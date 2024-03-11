module Check = Notafs.No_checksum
module Clock = Pclock
module KV = Notafs.KV (Clock) (Check) (Block)
open Lwt.Syntax

type t = KV.t
exception Error
type v = Dir of v | File of string

let make () =
  Lwt_direct.direct (fun () ->
    let* block = Block.connect "/tmp/notafs_test" in
    let+ res = KV.format block in
    match res with
    | Ok t -> t
    | Error _ -> assert(false))

let get t k =
  Lwt_direct.direct (fun () ->
    let+ res = KV.get t (Mirage_kv.Key.v k) in
    match res with
    | Ok t -> Some t
    | Error _ -> None)

let set t k s =
  Lwt_direct.direct (fun () ->
    let+ res = KV.set t (Mirage_kv.Key.v k) s in
    match res with
    | Ok t -> Some t
    | Error _ -> None)
