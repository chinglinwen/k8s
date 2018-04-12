if ! ./check.py; then
  echo "numpy not found, exit"
  exit 1
fi
 ./run --params params/default.yaml --out-dir out
