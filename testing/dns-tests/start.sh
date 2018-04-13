if ! ./check.py 2>/dev/null; then
  echo "numpy not found, exit"
  exit 1
fi
 ./run --params params/default.yaml --out-dir out &> run.log &
echo "start tail -f run.log"
tail -f run.log

