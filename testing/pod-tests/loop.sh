
i=0
while true; do
  echo
  echo "==================try $i times===================="
  ((i++))
  FORMAL=true ./run.sh 3
  #./run.sh 3
done
