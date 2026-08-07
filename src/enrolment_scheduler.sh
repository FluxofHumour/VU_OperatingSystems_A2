#!/bin/bash

# Student Name: George O'Hara
# Student ID: s8153245
# Assessment: VU Enrolment System Scheduler

TIME_SLICE=2
TOTAL_MEMORY=100

# Enrolment requests (processes)
request_ids=("George" "Martin" "Bill" "Frank" "Harry" "Simon")

# CPU burst times
cpu_times=(4 2 6 3 5 8)

# Memory required (MB)
memory_required=(25 15 90 20 30 120)

# Available class seats
seat_available=(1 1 4 0 6 3) # 0 = no seats available

# Copy CPU times into remaining CPU array
remaining_cpu=("${cpu_times[@]}")

# Waiting times
waiting_time=(0 0 0 0 0 0)

echo "=================================================="
echo "VU ENROLMENT ROUND ROBIN SCHEDULER"
echo "Student: George O'Hara"
echo "Student ID: s8153245"
echo "Time Slice: $TIME_SLICE"
echo "Total Memory: ${TOTAL_MEMORY}MB"
echo "=================================================="

echo ""
echo "--------------- Admission Control ---------------"

# Check requests before entering scheduler
for ((i=0; i<${#request_ids[@]}; i++))
do
    if [ ${seat_available[$i]} -eq 0 ]; then

        echo "${request_ids[$i]} REJECTED - Class Full"
        remaining_cpu[$i]=-1

    elif [ ${memory_required[$i]} -gt $TOTAL_MEMORY ]; then

        echo "${request_ids[$i]} REJECTED - Memory Limit Exceeded"
        remaining_cpu[$i]=-1

    elif [ ${memory_required[$i]} -gt 80 ]; then

        echo "${request_ids[$i]} WAITING - High Memory Request"

    else

        echo "${request_ids[$i]} ACCEPTED"

    fi
done

echo ""
echo "------------- Round Robin Execution -------------"

current_time=0

while true
do
    active_process_found=0

    for ((i=0; i<${#request_ids[@]}; i++))
    do

        # Skip rejected or completed processes
        if [ ${remaining_cpu[$i]} -le 0 ]; then
            continue
        fi

        active_process_found=1
        process=${request_ids[$i]}

        # Determine runtime for this time slice
        if [ ${remaining_cpu[$i]} -gt $TIME_SLICE ]; then
            run_time=$TIME_SLICE
        else
            run_time=${remaining_cpu[$i]}
        fi

        echo ""
        echo "Time $current_time -> $((current_time + run_time))"
        echo "Running: $process"
        echo "CPU Before: ${remaining_cpu[$i]}"

        # Execute process
        remaining_cpu[$i]=$(( ${remaining_cpu[$i]} - run_time ))

        # Update waiting times of all other active processes
        for ((j=0; j<${#request_ids[@]}; j++))
        do
            if [ $j -ne $i ] && [ ${remaining_cpu[$j]} -gt 0 ]; then
                waiting_time[$j]=$(( ${waiting_time[$j]} + run_time ))
            fi
        done

        current_time=$((current_time + run_time))

        echo "CPU Remaining: ${remaining_cpu[$i]}"

        if [ ${remaining_cpu[$i]} -eq 0 ]; then
            echo "$process COMPLETED"
        fi

        echo "--------------------------------------"
    done

    if [ $active_process_found -eq 0 ]; then
        break
    fi
done

echo ""
echo "---------------- Final Status ----------------"

for ((i=0; i<${#request_ids[@]}; i++))
do

    if [ ${seat_available[$i]} -eq 0 ]; then

        echo "${request_ids[$i]} -> REJECTED (Class Full)"

    elif [ ${memory_required[$i]} -gt $TOTAL_MEMORY ]; then

        echo "${request_ids[$i]} -> REJECTED (Memory Limit)"

    else

        echo "${request_ids[$i]} -> COMPLETED"
        echo "   Waiting Time: ${waiting_time[$i]} units"

    fi

done

echo ""
echo "============== Scheduler Finished =============="

