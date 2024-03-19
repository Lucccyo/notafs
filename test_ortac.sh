set -eu

ortac qcheck-stm tests/gospel/notafs_kv.mli "make ()" "t" > tests/gospel/notafs_ortac.ml --include Util
sed -ri 's/let\s\_/let main \(\)/g' tests/gospel/notafs_ortac.ml
dune exec -- tests/gospel/test_kv.exe --verbose
