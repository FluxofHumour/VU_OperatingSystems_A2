# Student Name: George O'Hara
# Student ID: <StudentID>
# Assessment: VU Enrolment System Scheduler

TIME_SLICE = 2
TOTAL_MEMORY = 100

# Request data
request_ids = ["George", "John", "Bill", "Frank", "Harry", "Simon"]  # EO = personalised request

cpu_times = [4, 2, 6, 3, 5, 8]
memory_required = [25, 15, 90, 20, 30, 120]
seat_available = [1, 1, 4, 2, 6, 3, 5,25, 15, 90, 20, 30]

# Copy CPU times so we can reduce them during execution
remaining_cpu = cpu_times.copy()

print("========================================")
print("VU ENROLMENT ROUND ROBIN SCHEDULER")
print("Student: George O'Hara")
print("Student ID: <StudentID>")
print("========================================")

print("\n--- Admission Control ---")

# Reject invalid requests before scheduling
for i in range(len(request_ids)):

    if seat_available[i] == 0:
        print(f"{request_ids[i]} REJECTED - Class Full")
        remaining_cpu[i] = -1

    elif memory_required[i] > TOTAL_MEMORY:
        print(f"{request_ids[i]} REJECTED - Memory Limit Exceeded")
        remaining_cpu[i] = -1

    elif memory_required[i] > 80:
        print(f"{request_ids[i]} WAITING - High Memory Request")

    else:
        print(f"{request_ids[i]} ACCEPTED")

print("\n--- Round Robin Execution ---")

while True:

    active_process_found = False

    for i in range(len(request_ids)):

        # Skip rejected or completed requests
        if remaining_cpu[i] <= 0:
            continue

        active_process_found = True

        process = request_ids[i]

        if remaining_cpu[i] > TIME_SLICE:

            print(f"Running {process} for {TIME_SLICE} units")

            remaining_cpu[i] -= TIME_SLICE

            print(f"Remaining CPU: {remaining_cpu[i]}")

        else:

            print(f"Running {process} for {remaining_cpu[i]} units")

            remaining_cpu[i] = 0

            print(f"{process} COMPLETED")

        print("--------------------------")

    if not active_process_found:
        break

print("\n--- Final Status ---")

for i in range(len(request_ids)):

    if seat_available[i] == 0:
        print(f"{request_ids[i]} -> REJECTED (Class Full)")

    elif memory_required[i] > TOTAL_MEMORY:
        print(f"{request_ids[i]} -> REJECTED (Memory Limit)")

    else:
        print(f"{request_ids[i]} -> COMPLETED")

print("\nScheduler Finished")
