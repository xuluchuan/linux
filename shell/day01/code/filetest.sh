#!/usr/bin/env bash
file1="/etc/service"
file2="/etc/rc.local"
[[ -f "${file1}" ]] && echo 1 || echo 0
[[ -f "${file2}" ]] && echo 1 || echo 0
[[ -z "" ]] && echo 1 || echo 0
[[ -n "hello" ]] && echo 1 || echo 0
n1="hello"
n2=""
[[ "${n1}" = "${n2}" ]] && echo 1 || echo 0
n3="hello"
n4=""
[[ "${n1}" = "${n2}" ]] && echo 1 || echo 0
[[ "${n1}" != "${n2}" ]] && echo 1 || echo 0
n5=32
n6=12
[[ ${n5} -gt ${n6} ]] && echo 1 || echo 0
[[ ${n6} -eq 32 ]] && echo 1 || echo 0
[[ -f "${file1}" && -f "${file2}" ]] || {
    echo "文件${file1}或${file2}不存在"
    exit 1
}
[[ ! -f "${file1}" ]] && echo 1 || echo 0
