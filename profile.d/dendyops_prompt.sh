innerip=$(ip a  |egrep 'eth0|ens32|ens33|eno1|eno2|enp5s0' |grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' |awk '{print $2}')
export PROMPT_COMMAND='echo -ne "\033]0;$innerip\007"'
export PS1="\[\e[1;36m\][\H]\[\e[31;1m\]\u\[\e[0m\]@\[\e[32;1m\]$innerip\[\e[0m\]:\[\e[35;1m\]\w\[\e[0m\]\\$ "
