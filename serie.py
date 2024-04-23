#!/usr/bin/env python3
from sys import argv

if len(argv) > 1:
    nums = [int(argv[1])]
else:
    nums = [int(input("num > "))]

while nums[-1] != 1:
    nums.append(nums[-1] // 2 if nums[-1] % 2 == 0 else nums[-1] * 3 + 1)

# Lista 
vIni = nums[0]
vT = len(nums)
vMax = max(nums)
vMed = sum(nums) / vT

lista = [x * vT for x in [vIni, vMax, vMed, vIni / vMax, vIni / vMed, vMax/vIni, vMax/vMed, vMed/vIni, vMed/vMax]]

print("vIni:", vIni)
print("vT:", vT)
print("vMed:", vMed)
print("vMax:", vMax)
print("vT/vMax:", vT/vMax)
print("vT/vIni:", vT/vIni)
print("vT/vMed:", vT/vMed)

print(lista)

