#!/usr/bin/env bash
number1=$1
number2=$2
[[ $# -ne 2 ]] && {
    echo "传入的参数不是2个，需要传入2个数字"
    exit 1
}
echo ${number1} | grep -q "[^0-9]"
n1=$?
echo ${number2} | grep -q "[^0-9]"
n2=$?
[[ ${n1} -eq 0 || ${n2} -eq 0 ]] && {
    echo "传入的不是数字，需要传入2个数字"
    exit 2
}
[[ ${number1} -ge ${number2} ]] && echo "${number1}较大" || echo "${number2}较大"
