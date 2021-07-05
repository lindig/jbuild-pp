(** This is a small filter to format jbuild files. It reads froms stdin
 * and emits to stdout. It is meant to be used from within an editor.
*)

(** [parse io] parses input from [io] and returns a list of sexpr values
 * on success *)
let parse io =
  let decoder = Lexing.from_channel io |> CCSexp.Decoder.of_lexbuf in
  let rec loop acc = match CCSexp.Decoder.next decoder with
    | CCSexp.Yield sexp -> loop (sexp::acc) 
    | CCSexp.End        -> CCResult.return (List.rev acc)
    | CCSexp.Fail msg   -> CCResult.fail msg
  in
  loop []

(** [pp] emits a sexpr with indentation. Some lists are always printed
    in vertical mode to enhance readbility *)
let rec pp fmt = function
  | `Atom s   -> Format.pp_print_string fmt s
  | `List []  -> Format.pp_print_string fmt "()"
  | `List [x] -> Format.fprintf fmt "@[<hov2>(%a)@]" pp x
  | `List (`Atom ("libraries") :: _ as l)
  | `List (`Atom _ :: `List _ :: _ as l) ->
    Format.fprintf fmt "@[<v2>(";
    pp' fmt l;
    Format.fprintf fmt "@]@,)"
  | `List ((`List _ :: _ :: _) as l) ->
    Format.fprintf fmt "@[<v2>(";
    pp' fmt l;
    Format.fprintf fmt ")@]"
  | `List l ->
    Format.fprintf fmt "@[<hov2>(";
    pp' fmt l;
    Format.fprintf fmt ")@]"

and pp' fmt ts =
  List.iteri
    (fun i t' -> (if i > 0 then Format.fprintf fmt "@ "; pp fmt t'))
    ts

(** [emit_to oc sexpr] emits a [sexpr] to channel [oc] with indentation *)
let emit_to oc sexp =
  let fmt = Format.formatter_of_out_channel oc in
  pp fmt sexp;
  Format.pp_print_flush fmt ()

(** [print io] reads sexpr from [io] and emits them to stdout *)
let print io =
  parse io
  |> function
  | CCResult.Ok sexps -> 
    sexps 
    |> List.iter (fun sexp -> emit_to stdout sexp; print_endline "\n")
    |> fun () -> Result.Ok ()
  | CCResult.Error(msg) -> Result.Error(msg)


