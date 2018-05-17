#!/bin/sh
# run at target path which includes yaml files.
#../../helper/images/convert.sh

convert () {
  line="$1"
  img="$( echo $line| awk '{ print $2 }' FS="image: " )"
  imgname="$( echo $line| awk '{ print $2 }' FS="image: " | awk '{ print $NF }' FS='/' )"
  newtag="reg.qianbao-inc.com/k8s/$imgname"
  echo "$img -> $newtag"
  docker pull $img
  docker tag $img $newtag
  docker push $newtag
  echo "$newtag done"
}

:>images.sed
while read l; do
  convert "$l"
cat <<eof >> images.sed
s_${img}_${newtag}_
eof
done <<eof
$( grep image: * | sort -n |uniq )
eof

echo "try sed -i -f images.sed  some.yaml.file"
