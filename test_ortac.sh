ortac qcheck-stm tests/gospel/notafs_kv.mli "make ()" "t" > tests/gospel/notafs_ortac.ml
sed -ri 's/let\s\_/let main \(\)/g' tests/gospel/notafs_ortac.ml
sed -ri 's/\(string, v option\) \(->\)/(string -> v option)/g' tests/gospel/notafs_ortac.ml
dune exec -- tests/gospel/test_kv.exe --verbose
