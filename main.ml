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

(** [print] emits a sexpr with indentation. Some lists are always printed
    in vertical mode to enhance readbility *)
let rec print fmt = function
  | `Atom s   -> Format.pp_print_string fmt s
  | `List []  -> Format.pp_print_string fmt "()"
  | `List [x] -> Format.fprintf fmt "@[<hov2>(%a)@]" print x
  | `List ([`Atom _; `List _] as l) ->
    Format.fprintf fmt "@[<v1>(";
    print' fmt l;
    Format.fprintf fmt ")@]"
  | `List ((`List _ :: _ :: _) as l) ->
    Format.fprintf fmt "@[<v1>(";
    print' fmt l;
    Format.fprintf fmt ")@]"
  | `List l ->
    Format.fprintf fmt "@[<hov1>(";
    print' fmt l;
    Format.fprintf fmt ")@]"

and print' fmt ts =
  List.iteri
    (fun i t' -> (if i > 0 then Format.fprintf fmt "@ "; print fmt t'))
    ts

(** [emit_to oc sexpr] emits a [sexpr] to channel [oc] with indentation *)
let emit_to oc sexp =
  let fmt = Format.formatter_of_out_channel oc in
  print fmt sexp;
  Format.pp_print_flush fmt ()

let pp sexps =
  sexps 
  |> List.iter (fun sexp -> emit_to stdout sexp; print_endline "\n")

let main () = 
  parse stdin
  |> function
  | CCResult.Ok sexps   -> pp sexps; exit 0
  | CCResult.Error msg  -> prerr_string msg; prerr_string "\n"; exit 1

let () = main ()
