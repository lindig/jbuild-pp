
(** [print io] reads sexpr from [io] and emits them
 * re-indented to [stdout].
 *)
val print : in_channel -> (unit, string) Result.result
