let _ =
  Lwt_main.run @@
    Lwt_direct.indirect @@
      fun () ->
        Notafs_ortac.main ()

