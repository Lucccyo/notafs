module Check = Notafs.No_checksum
module Clock = Pclock
module KV = Notafs.KV (Clock) (Check) (Block)
open Lwt.Syntax

type t = KV.t ref
exception Error
type v = Dir of (string -> v option) | File of string
type key = string list

let rec to_key t l =
  match l with
  | [] -> t
  | hd :: tl -> to_key (Mirage_kv.Key.add t hd) tl

let make () =
  Lwt_direct.direct (fun () ->
  let* block = Block.connect "/tmp/notafs_test" in
  let+ res = KV.format block in
  match res with
  | Ok t -> ref t
  | Error _ -> assert(false))

let get t p =
  let key = to_key Mirage_kv.Key.empty p in
  Lwt_direct.direct (fun () ->
    let+ res = KV.get !t key in
    match res with
    | Ok t -> Some t
    | Error _ -> None)

let set t p s =
  let key = to_key Mirage_kv.Key.empty p in
  Lwt_direct.direct (fun () ->
    let+ res = KV.set !t key s in
    match res with
    | Ok t -> Some t
    | Error _ -> None)

let disconnect_reconnect t =
  Lwt_direct.direct (fun () ->
    let* _ = KV.disconnect !t in
    let* block = Block.connect "/tmp/notafs_test" in
    let+ res = KV.connect block in
    match res with
    | Ok nt -> t := nt
    | Error _ -> assert(false))
