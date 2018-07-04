ip a | grep 'inet ' | grep -v -e docker -e 127.0.0.1 -e 'vir' | awk '{ print $2 }' | cut -f1 -d'/'
