module Pp = struct
  let pp_key _ fmt _ = Format.fprintf fmt "i"
  let pp_string _ fmt str =
    let length = String.length str in
    if length < 10 then
      Format.fprintf fmt "%S" str
      else Format.fprintf fmt "[%d]" length
  let pp_list pps b fmt l =
    List.iter (fun s ->
      Format.fprintf fmt "%a" (pps b) s
    ) l
end
