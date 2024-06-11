import sys
import time
total_time = 3
print(f"pytest.py start\n")
for second in range(total_time):
    print(f"pytest.py time slept: {second}\n")
    time.sleep(1)
print(f"pytest.py completed\n")
# sys.exit(0)