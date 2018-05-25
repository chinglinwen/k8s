ip="$( kubectl get svc -n kong postgres | grep post | awk '{ print $3 }' )"
pgweb  --bind=0.0.0.0 --url=postgresql://kong:kong@$ip/kong?sslmode=disable &> pgweb.log &
