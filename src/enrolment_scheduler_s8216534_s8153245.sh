#!/bin/bash

# ============================================================
# VU ENROLMENT SYSTEM SCHEDULER
# ============================================================
# Student Name: Martin Yii George O'Hara
# Student ID: s8216534 s8153245
# Scheduling Algorithm: Round Robin
# Time Slice: 2 units
# Total Memory: 180 units
# ============================================================

echo "=========================================================="
echo "             VU Enrolment System Scheduler"
echo "             Student Name: Martin Yii"
echo "             Student ID: s8216534"
echo "=========================================================="
echo

# ============================================================
# SYSTEM SETTINGS
# ============================================================

TIME_SLICE=2
TOTAL_MEMORY=180
available_memory=$TOTAL_MEMORY

# ============================================================
# REQUEST ARRAYS
# ============================================================

Request=("REQ_Prog_A" "REQ_Cyb_B" "REQ_NET_C" "REQ_Prog_A_s8216534" "REQ_NIT_D")

memory=(100 200 80 120 180)
cpu_time=(5 2 6 3 6)
arrival_time=(0 0 0 4 8)

# ============================================================
# CLASS ARRAYS
# ============================================================

Class=("class_Prog_A" "class_Cyb_B" "class_NET_C" "class_NIT_D")

# Original class seat capacity
class_seat_capacity=(1 2 1 3)

# ============================================================
# SCHEDULING RESULT ARRAYS
# ============================================================

remaining_cpu=(5 2 6 3 6)

start_time=(-1 -1 -1 -1 -1)
completion_time=(-1 -1 -1 -1 -1)

waiting_time=(-1 -1 -1 -1 -1)
turnaround_time=(-1 -1 -1 -1 -1)

status=("PENDING" "PENDING" "PENDING" "PENDING" "PENDING")

subject_enrolled=("NONE" "NONE" "NONE" "NONE" "NONE")

# ============================================================
# CHECKPOINT 1
# ============================================================

echo "CHECKPOINT 1 - First Request"
echo "Request:      ${Request[0]}"
echo "Arrival Time: ${arrival_time[0]}"
echo "CPU Time:     ${cpu_time[0]}"
echo "Memory:       ${memory[0]}"
echo

# ============================================================
# HELPER FUNCTION: GET CLASS INDEX
# ============================================================

get_class_index()
{
    local request_name="$1"

    case "$request_name" in

        "REQ_Prog_A")
            echo 0
            ;;

        "REQ_Cyb_B")
            echo 1
            ;;

        "REQ_NET_C")
            echo 2
            ;;

        "REQ_Prog_A_s8216534")
            echo 0
            ;;

        "REQ_NIT_D")
            echo 3
            ;;

        *)
            echo -1
            ;;

    esac
}

# ============================================================
# HELPER FUNCTION: GET AVAILABLE MEMORY
# ============================================================

get_available_memory()
{
    echo "$available_memory"
}

# ============================================================
# HELPER FUNCTION: ALLOCATE MEMORY
# ============================================================

allocate_memory()
{
    local amount=$1

    available_memory=$((available_memory - amount))

    echo "      Memory allocated: $amount"
    echo "      Available memory: $(get_available_memory)"
}

# ============================================================
# HELPER FUNCTION: RELEASE MEMORY
# ============================================================

release_memory()
{
    local amount=$1

    available_memory=$((available_memory + amount))

    echo "      Memory released:  $amount"
    echo "      Available memory: $(get_available_memory)"
}

# ============================================================
# HELPER FUNCTION: CHECK CLASS SEATS
# ============================================================

get_seats()
{
    local request_name="$1"
    local class_index

    class_index=$(get_class_index "$request_name")

    if [ "$class_index" -ge 0 ]; then
        echo "${class_seat_capacity[$class_index]}"
    else
        echo 0
    fi
}

# ============================================================
# HELPER FUNCTION: REDUCE CLASS SEAT
#
# A class seat is permanently taken once allocated.
# It is NOT restored when the process completes.
# ============================================================

reduce_class_seat()
{
    local request_name="$1"
    local class_index

    class_index=$(get_class_index "$request_name")

    if [ "$class_index" -ge 0 ]; then

        class_seat_capacity[$class_index]=$((class_seat_capacity[$class_index] - 1))

        echo "      Seat allocated for $request_name"
        echo "      Remaining seats: ${class_seat_capacity[$class_index]}"

    fi
}

# ============================================================
# HELPER FUNCTION: CHECK ARRIVAL TIME
# ============================================================

has_arrived()
{
    local index=$1

    if [ "${arrival_time[$index]}" -le "$current_time" ]; then
        return 0
    else
        return 1
    fi
}

# ============================================================
# HELPER FUNCTION: CALCULATE WAITING AND TURNAROUND TIME
# ============================================================

calculate_times()
{
    local index=$1

    turnaround_time[$index]=$((completion_time[$index] - arrival_time[$index]))

    waiting_time[$index]=$((turnaround_time[$index] - cpu_time[$index]))
}

# ============================================================
# INITIALISE QUEUE AND COUNTERS
# ============================================================

queue=()
queue_count=0

completed_count=0
rejected_count=0

current_time=0

# ============================================================
# ADMISSION CHECK
# ============================================================

echo "=========================================================="
echo "ADMISSION CHECK"
echo "=========================================================="
echo

# ============================================================
# ADMISSION PHASE
# ============================================================

for ((i=0; i<${#Request[@]}; i++))
do

    echo "Checking request: ${Request[$i]}"
    echo "  Arrival time: ${arrival_time[$i]}"
    echo "  CPU time:     ${cpu_time[$i]}"
    echo "  Memory:       ${memory[$i]}"

    # --------------------------------------------------------
    # CHECK ARRIVAL TIME
    # --------------------------------------------------------

    if [ "${arrival_time[$i]}" -gt "$current_time" ]; then
        current_time=${arrival_time[$i]}
    fi

    # --------------------------------------------------------
    # CHECK IF MEMORY EXCEEDS TOTAL MEMORY
    # --------------------------------------------------------

    if [ "${memory[$i]}" -gt "$TOTAL_MEMORY" ]; then

        status[$i]="REJECTED"
        rejected_count=$((rejected_count + 1))

        echo "  Status: REJECTED"
        echo "  Reason: Memory requirement exceeds total memory."
        echo

        continue
    fi

    # --------------------------------------------------------
    # CHECK CLASS SEAT
    # --------------------------------------------------------

    seats=$(get_seats "${Request[$i]}")

    if [ "$seats" -le 0 ]; then

        status[$i]="REJECTED"
        rejected_count=$((rejected_count + 1))

        echo "  Status: REJECTED"
        echo "  Reason: No class seat available."
        echo

        continue
    fi

    # --------------------------------------------------------
    # CHECK AVAILABLE MEMORY
    # --------------------------------------------------------

    if [ "${memory[$i]}" -gt "$available_memory" ]; then

        status[$i]="WAITING"

        echo "  Status: WAITING"
        echo "  Reason: Not enough available memory."
        echo "  Required memory: ${memory[$i]}"
        echo "  Available memory: $available_memory"
        echo

    else

        status[$i]="READY"

        echo "  Status: READY"
        echo "  Class seat available: YES"
        echo "  Memory available: YES"

        # Add request to Round Robin queue
        queue[$queue_count]=$i
        queue_count=$((queue_count + 1))

        # Permanently allocate class seat
        reduce_class_seat "${Request[$i]}"

        # Allocate memory
        allocate_memory "${memory[$i]}"

        echo

    fi

done

# ============================================================
# ROUND ROBIN EXECUTION
# ============================================================

echo "=========================================================="
echo "ROUND ROBIN EXECUTION"
echo "Time Slice = $TIME_SLICE units"
echo "=========================================================="
echo

# ============================================================
# RESET TIME FOR SCHEDULING
# ============================================================

current_time=0

# ============================================================
# INITIALISE ROUND ROBIN QUEUE
# ============================================================

queue=()
queue_count=0

for ((i=0; i<${#Request[@]}; i++))
do

    if [ "${status[$i]}" == "READY" ] &&
       [ "${arrival_time[$i]}" -le "$current_time" ]; then

        queue[$queue_count]=$i
        queue_count=$((queue_count + 1))

    fi

done

# ============================================================
# MAIN ROUND ROBIN LOOP
#
# Continue while at least one request is READY or WAITING.
#
# Stop when every request is either:
# COMPLETED
# or
# REJECTED
# ============================================================

while true
do

    # --------------------------------------------------------
    # COUNT ACTIVE REQUESTS
    # --------------------------------------------------------

    active_requests=0

    for ((i=0; i<${#Request[@]}; i++))
    do

        if [ "${status[$i]}" == "READY" ] ||
           [ "${status[$i]}" == "WAITING" ]; then

            active_requests=$((active_requests + 1))

        fi

    done

    # --------------------------------------------------------
    # STOP CONDITION
    # --------------------------------------------------------

    if [ "$active_requests" -eq 0 ]; then

        echo "=========================================================="
        echo "NO MORE ACTIVE REQUESTS"
        echo "All requests are either COMPLETED or REJECTED."
        echo "Scheduler stopping."
        echo "=========================================================="
        echo

        break

    fi

    # --------------------------------------------------------
    # IF QUEUE IS EMPTY
    # --------------------------------------------------------

    if [ "$queue_count" -eq 0 ]; then

        current_time=$((current_time + 1))

        # ----------------------------------------------------
        # CHECK WAITING REQUESTS
        # ----------------------------------------------------

        for ((i=0; i<${#Request[@]}; i++))
        do

            if [ "${status[$i]}" == "WAITING" ] &&
               [ "${arrival_time[$i]}" -le "$current_time" ] &&
               [ "${memory[$i]}" -le "$available_memory" ]; then

                echo "[$current_time] Waiting request admitted: ${Request[$i]}"

                status[$i]="READY"

                # Permanently allocate class seat
                reduce_class_seat "${Request[$i]}"

                # Allocate memory
                allocate_memory "${memory[$i]}"

                # Add request to queue
                queue[$queue_count]=$i
                queue_count=$((queue_count + 1))

                echo

            fi

        done

        continue

    fi

    # --------------------------------------------------------
    # TAKE FIRST REQUEST FROM QUEUE
    # --------------------------------------------------------

    index=${queue[0]}

    # --------------------------------------------------------
    # SHIFT QUEUE
    # --------------------------------------------------------

    for ((j=0; j<queue_count-1; j++))
    do
        queue[$j]=${queue[$j+1]}
    done

    unset 'queue[$((queue_count-1))]'

    queue_count=$((queue_count - 1))

    # --------------------------------------------------------
    # SET PROCESS START TIME
    # --------------------------------------------------------

    if [ "${start_time[$index]}" -eq -1 ]; then
        start_time[$index]=$current_time
    fi

    # --------------------------------------------------------
    # CALCULATE EXECUTION TIME
    # --------------------------------------------------------

    if [ "${remaining_cpu[$index]}" -le "$TIME_SLICE" ]; then

        run_time=${remaining_cpu[$index]}

    else

        run_time=$TIME_SLICE

    fi

    old_time=$current_time

    current_time=$((current_time + run_time))

    # --------------------------------------------------------
    # REDUCE REMAINING CPU TIME
    # --------------------------------------------------------

    remaining_cpu[$index]=$((remaining_cpu[$index] - run_time))

    echo "Executing ${Request[$index]}"
    echo "  Time: $old_time -> $current_time"
    echo "  Time slice used: $run_time"
    echo "  Remaining CPU time: ${remaining_cpu[$index]}"

    # ========================================================
    # CHECK PROCESS COMPLETION
    # ========================================================

    if [ "${remaining_cpu[$index]}" -eq 0 ]; then

        completion_time[$index]=$current_time

        status[$index]="COMPLETED"

        class_index=$(get_class_index "${Request[$index]}")

        subject_enrolled[$index]="${Class[$class_index]}"

        calculate_times "$index"

        # ----------------------------------------------------
        # RELEASE MEMORY
        #
        # Memory can be reused after completion.
        # The class seat remains occupied.
        # ----------------------------------------------------

        release_memory "${memory[$index]}"

        completed_count=$((completed_count + 1))

        echo "  Status: COMPLETED"
        echo "  Completion time: ${completion_time[$index]}"
        echo "  Waiting time: ${waiting_time[$index]}"
        echo "  Turnaround time: ${turnaround_time[$index]}"
        echo "  Class seat remains UNAVAILABLE."
        echo

    else

        echo "  Status: WAITING - more CPU time required"

        # Return process to end of Round Robin queue
        queue[$queue_count]=$index
        queue_count=$((queue_count + 1))

        echo

    fi

    # ========================================================
    # CHECK WAITING REQUESTS AFTER EACH TIME SLICE
    # ========================================================

    for ((i=0; i<${#Request[@]}; i++))
    do

        if [ "${status[$i]}" == "WAITING" ] &&
           [ "${arrival_time[$i]}" -le "$current_time" ] &&
           [ "${memory[$i]}" -le "$available_memory" ]; then

            echo "[$current_time] Memory is now available."
            echo "[$current_time] ${Request[$i]} can enter the queue."

            status[$i]="READY"

            # Permanently allocate class seat
            reduce_class_seat "${Request[$i]}"

            # Allocate memory
            allocate_memory "${memory[$i]}"

            # Add process to queue
            queue[$queue_count]=$i
            queue_count=$((queue_count + 1))

            echo

        fi

    done

done

# ============================================================
# FINAL EXECUTION TABLE
# ============================================================

echo
echo "=========================================================="
echo "FINAL EXECUTION TABLE"
echo "=========================================================="

printf "%-22s %-10s %-10s %-10s %-12s %-12s %-18s\n" \
"Request" "Arrival" "CPU" "Start" "Completion" "Status" "Subject"

echo "------------------------------------------------------------------------------------------------------"

for ((i=0; i<${#Request[@]}; i++))
do

    printf "%-22s %-10s %-10s %-10s %-12s %-12s %-18s\n" \
    "${Request[$i]}" \
    "${arrival_time[$i]}" \
    "${cpu_time[$i]}" \
    "${start_time[$i]}" \
    "${completion_time[$i]}" \
    "${status[$i]}" \
    "${subject_enrolled[$i]}"

done

# ============================================================
# WAITING TIME AND TURNAROUND TIME
# ============================================================

echo
echo "=========================================================="
echo "WAITING TIME AND TURNAROUND TIME"
echo "=========================================================="

printf "%-22s %-15s %-20s\n" \
"Request" "Waiting Time" "Turnaround Time"

echo "----------------------------------------------------------"

total_waiting=0
total_turnaround=0
executed_processes=0

for ((i=0; i<${#Request[@]}; i++))
do

    if [ "${status[$i]}" == "COMPLETED" ]; then

        printf "%-22s %-15s %-20s\n" \
        "${Request[$i]}" \
        "${waiting_time[$i]}" \
        "${turnaround_time[$i]}"

        total_waiting=$((total_waiting + waiting_time[$i]))

        total_turnaround=$((total_turnaround + turnaround_time[$i]))

        executed_processes=$((executed_processes + 1))

    else

        printf "%-22s %-15s %-20s\n" \
        "${Request[$i]}" \
        "N/A" \
        "N/A"

    fi

done

# ============================================================
# CALCULATE AVERAGES
# ============================================================

if [ "$executed_processes" -gt 0 ]; then

    average_waiting=$(
        awk "BEGIN {printf \"%.2f\", $total_waiting / $executed_processes}"
    )

    average_turnaround=$(
        awk "BEGIN {printf \"%.2f\", $total_turnaround / $executed_processes}"
    )

else

    average_waiting=0
    average_turnaround=0

fi

# ============================================================
# PERFORMANCE SUMMARY
# ============================================================

echo
echo "=========================================================="
echo "PERFORMANCE SUMMARY"
echo "=========================================================="

echo "Completed processes:       $completed_count"
echo "Rejected requests:         $rejected_count"
echo "Total waiting time:        $total_waiting"
echo "Total turnaround time:     $total_turnaround"
echo "Average waiting time:      $average_waiting"
echo "Average turnaround time:   $average_turnaround"

# ============================================================
# FINAL CLASS SEAT STATUS
#
# Seats are permanently consumed when allocated.
# They are NOT restored when a process completes.
# ============================================================

echo
echo "=========================================================="
echo "FINAL CLASS SEAT STATUS"
echo "=========================================================="

for ((i=0; i<${#Class[@]}; i++))
do

    echo "${Class[$i]} : ${class_seat_capacity[$i]} seat(s) available"

done

# ============================================================
# FINAL MEMORY STATUS
# ============================================================

echo
echo "=========================================================="
echo "FINAL AVAILABLE MEMORY: $available_memory"
echo "=========================================================="
