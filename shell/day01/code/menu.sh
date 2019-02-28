#!/usr/bin/env bash
menu() {
cat << EOF
1) start num1.sh
2) start num2.sh
3) start num3.sh
EOF
}

menu
read -p "pls input your choice [1-3]: " choice
[[ -z ${choice} ]] && {
    ehco "输入为空，pls input [1-3]"
    exit1
}
echo ${choice} | grep -q "[^0-9]"
n1=$?
[[ ${n1} -eq 0 ]] && {
    echo "输入的不是数字，pls input [1-3]"
    exit 2
}
[[ ${choice} -lt 1 || ${choice} -gt 3 ]] && {
    echo "输入的不是1-3， pls input [1-3]"
    exit 3
}
[[ ${choice} -eq 1 ]] && {
    [[ -f /srv/scripts/day01/num1.sh ]] || {
        echo "/srv/scripts/day01/num1.sh 脚本不存在"
        exit 4
    }
    /bin/bash /srv/scripts/day01/num1.sh
    exit 0
}
[[ ${choice} -eq 2 ]] && {
    [[ -f /srv/scripts/day01/num2.sh ]] || {
        echo "/srv/scripts/day01/num2.sh 脚本不存在"
        exit 5
    }
    /bin/bash /srv/scripts/day01/num2.sh
    exit 0
}
[[ ${choice} -eq 3 ]] && {
    [[ -f /srv/scripts/day01/num3.sh ]] || {
        echo "/srv/scripts/day01/num3.sh 脚本不存在"
        exit 6
    }
    /bin/bash /srv/scripts/day01/num3.sh
    exit 0
}