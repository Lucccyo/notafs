module Check = Notafs.No_checksum
module Clock = Pclock
module KV = Notafs.KV (Clock) (Check) (Block)
open Lwt.Syntax

type t = KV.t
exception Error
type v = Dir of (string -> v option) | File of string

let rec to_key t l =
  match l with
  | [] -> t
  | hd :: tl ->
    let hd = String.map (fun c -> if c = '/' then '_' else c) hd in
    to_key (Mirage_kv.Key.add t hd) tl

let make () =
  Lwt_direct.direct (fun () ->
    let* block = Block.connect "/tmp/notafs_test" in
    let+ res = KV.format block in
    match res with
    | Ok t -> t
    | Error _ -> assert(false))

let get t p =
  Lwt_direct.direct (fun () ->
    let+ res = KV.get t (to_key Mirage_kv.Key.empty p) in
    match res with
    | Ok t -> Some t
    | Error _ -> None)

let set t p s =
  Lwt_direct.direct (fun () ->
    let+ res = KV.set t (to_key Mirage_kv.Key.empty p) s in
    match res with
    | Ok t -> Some t
    | Error _ -> None)
