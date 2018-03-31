#!/bin/sh
ip="$1"
if [ "x$ip" = "x" ]; then
  echo "Please, provide cluster apiserver ip"
  echo "Usage: ./fixconfig.sh ip"
  exit 1
fi

sed -i "s/172.28.46.123/$ip/" prometheus.yml

token="$( ./gettoken.sh )"
if [ "x$token" = "x" ]; then
  echo "get token error, check ./gettoken.sh is correct"
  exit 1
fi
sed -i "s/eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJtb25pdG9yaW5nIiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZWNyZXQubmFtZSI6InByb21ldGhldXMtazhzLXRva2VuLTV6cW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZXJ2aWNlLWFjY291bnQubmFtZSI6InByb21ldGhldXMtazhzIiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZXJ2aWNlLWFjY291bnQudWlkIjoiOTJmYThiOWItMzBiYi0xMWU4LWFlZTItZjQwMzQzNDM3NjU0Iiwic3ViIjoic3lzdGVtOnNlcnZpY2VhY2NvdW50Om1vbml0b3Jpbmc6cHJvbWV0aGV1cy1rOHMifQ.seXXt0PLAlNzclSq28zks7rVlgkhQzn6ZqPLP9CmgAPOAD5XeE19t2MmpMKXWZAe14sBILT4hZTFeG_yiepYB4q8x5frpoKU7ml_z7eKbPgHAPV_sHskyd9WIzUuC3yHaqQa-3E_SDaXTna_FAHCoCkSKZtsVPou5qHHPwhQvez2YNB4hM67OZv2uQCcZAO4kLVL5_0af68cuxkIkrRw7MI9C2WyxMK6NUIoa_YsR7eXsGYuGN2aDy-M_UDY7vNngqPiAQQ4BgwjUHzam0Kx-spBU0XxFbGVk6Na2iew1yFYPnGtC7ebEAfsDL9A_YV2DLzol4YX4QPAqMcbphKmWw/$token/" prometheus.yml

echo "done"
