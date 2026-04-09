# Convert minutes to human readable format

minutes = int(input())

hours = minutes // 60
remaining = minutes % 60

if hours == 1:
    print(f"{hours} hr {remaining} minutes")
else:
    print(f"{hours} hrs {remaining} minutes")
