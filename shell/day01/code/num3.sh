#!/usr/bin/env bash
read -p "请输入第一个数字：" number1
read -p "请输入第二个数字：" number2
[[ -z ${number1} || -z ${number2} ]] && {
    echo "不能输入空，需要输入2个数字"
    exit 1
}
echo ${number1} | grep -q "[^0-9]"
n1=$?
echo ${number2} | grep -q "[^0-9]"
n2=$?
[[ ${n1} -eq 0 || ${n2} -eq 0 ]] && {
    echo "输入的不是数字，需要输入2个数字"
    exit 2
}
[[ ${number1} -ge ${number2} ]] && echo "${number1}较大" || echo "${number2}较大"
