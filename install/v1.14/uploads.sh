#!/bin/sh

while read f; do
  echo "uploading $f"
  curl http://fs.devops.haodai.net/k8s/v1.14/uploadapi -F file=@$f -F truncate=yes
done<<eof
$( ls -1 *.sh )
eof