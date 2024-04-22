#!/usr/bin/env python3

nums = [int(input("num > "))]

while nums[-1] != 1:
    nums.append(nums[-1] // 2 if nums[-1] % 2 == 0 else nums[-1] * 3 + 1)

print(nums)
print(len(nums), max(nums), sum(nums) / len(nums)) 

