exception Error

type v = Dir of v | File of string

(*@ type path = string *)

type t
(*@ mutable model contents: (path -> v option) *)

(*@ function is_dir (v_opt: v option) : bool =
    match v_opt with
    | Some v -> (
      match v with
      | Dir  _ -> true
      | File _ -> false )
    | None -> false *)

(*@ function str_of_v (v_opt: v option) : string option =
    match v_opt with
    | Some v -> (
      match v with
      | Dir  _ -> None
      | File s -> Some s )
    | None -> None *)

(*@ function mem (res: v option) : bool =
    match res with
    | Some _ -> true
    | None   -> false *)

val make: unit -> t
(*@ t = make ()
   ensures t.contents = (fun _ -> None) *)

val get: t -> string -> string option
(*@ s = get t p
    ensures s = str_of_v (t.contents p)
    raises Error -> is_dir (t.contents p)
*)

val set: t -> string -> string -> unit option
(*@ r = set t k s
    requires k <> ""
    requires k <> "/"     (* A voir -> Mirage_kv décompose le key -> et "/" devient vide -> "//" meme soucis*)
    modifies t.contents
    ensures t.contents = (fun kt -> if kt = k then Some (File s) else None)
    raises Error -> false *)
