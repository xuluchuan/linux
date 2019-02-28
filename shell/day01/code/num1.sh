#!/usr/bin/env bash
number1=20
number2=30
[[ ${number1} -ge ${number2} ]] && echo "${number1}较大" || echo "${number2}较大"