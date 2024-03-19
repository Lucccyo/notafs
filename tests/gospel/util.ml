module Pp = struct
  let pp_string _ fmt str =
    let length = String.length str in
    if length < 10
      then Format.fprintf fmt "%S" str
      else Format.fprintf fmt "[%d]" length

  let pp_list pps b fmt l =
    List.iter (fun s -> Format.fprintf fmt "%a" (pps b) s) l

  let pp_key _ fmt s = pp_list pp_string true fmt s
end

module QCheck = struct
  include QCheck

  module Gen = struct
    include QCheck.Gen

    let key = list_size (oneofl [1; 2; 3]) (oneofl ["aaa"; "bbb"; "ccc"])
  end
end

open STM
type key = string list

type _ ty += Key : key ty

let key = Key, fun l -> Format.asprintf "Key %a" (Pp.pp_list Pp.pp_string true) l
