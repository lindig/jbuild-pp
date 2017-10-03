(** Command line evaluation *)

module C = Cmdliner

let pretty = function
  | Some path -> CCIO.with_in path Pretty.print
  | None      -> Pretty.print stdin

module Command = struct
  let filename =
    C.Arg.(value
           & pos 0 (some file) None
           & info []
             ~docv:"FILE"
             ~doc:"Path of file to be pretty printed. Defaults to stdin."
          )

  let pretty =
    let doc = "re-format jbuild file" in
    C.Term.
      ( const pretty $ filename
      , info "jbuild-pp" ~doc
      )

end

let main () =
  try match C.Term.eval Command.pretty ~catch:false with
    | `Error _  -> exit 1
    | _         -> exit 0
  with exn ->
    Printf.eprintf "error: %s\n" (Printexc.to_string exn);
    exit 1

let () = if !Sys.interactive then () else main ()
