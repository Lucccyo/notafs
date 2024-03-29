exception Error

type key = string list

type v = Dir of (string -> v option) | File of string

type t
(*@ mutable model contents: v *)

(*@ function inside (t_opt : v option) : v =
    match t_opt with
    | Some t -> t
    | None -> Dir (fun _ -> None) *)

(*@ function rec mset (t : v) (path : string list) (content : string) : v =
    match t, path with
    | _, [] -> File content
    | File _, _ -> mset (inside None) path content
    | Dir dir, s :: path ->
      Dir (fun k -> if k = s then Some (mset (inside (dir k)) path content) else dir k) *)

(*@ function rec mget (t : v) (path : string list) : string option =
    match t, path with
    | File c, [] -> Some c
    | Dir dir, s :: path ->
      (match dir s with
       | Some t -> mget t path
       | None -> None)
    | _, _ -> None *)

val make: unit -> t
(*@ t = make ()
    ensures t.contents = Dir (fun _ -> None) *)

val get: t -> key -> string option
(*@ s = get t p
    ensures s = mget t.contents p *)

val set: t -> key -> string -> unit option
(*@ set t p s
    requires p <> []
    modifies t.contents
    ensures t.contents = mset (old t.contents) p s
    raises Error -> false *)

val disconnect_reconnect: t -> unit
(*@ disconnect_reconnect t
    modifies t.contents
    ensures t.contents = old t.contents *)
