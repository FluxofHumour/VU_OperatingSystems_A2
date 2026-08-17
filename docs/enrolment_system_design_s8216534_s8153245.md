# Student Name: Martin Yii George O'Hara
# Student ID: s8216534 s8153245
# Assessment: VU Enrolment System

# VU Enrolment System Design & Reasoning

---

# Table of Contents

1. Project Summary
2. Enrolment Requests as Operating System Processes
3. System Constraints
4. Section A – Multi-Constraint Reasoning
5. Section B – Strategy Selection Under Conflict
6. Section C – Round Robin Simulation
7. Failure Analysis
8. Trade Offs
9. Individual Contribution
10. Conclusion

---

# 1. Project Summary

This project models the Victoria University enrolment platform using Operating System scheduling concepts. Each student enrolment request is treated as a process competing for CPU time, memory resources, and class seat availability.

The system uses a Round Robin scheduling algorithm with a time slice of 2 CPU units. Requests are admitted only when sufficient memory and class seats are available. Requests may be accepted, delayed in a waiting state, or rejected if system constraints cannot be satisfied.

This project will focus on 3 major constraints. (1) CPU capacity. Each enrolment request requires a certain amount of processing time.  In this assignment, the given time slice is 2-unit time slice. The enrolment system will demonstrate how it can employ a fair scheduling policy while ensuring correctness and responsiveness. (2) Memory capacity. The main constraint of the system is that there is only 180 units of total memory. Each requests require different amounts of memory, with some requests requiring more memory than the entire system can provide. For example, REQ_Cyb_B requires 200 units and is therefore rejected. (3) Class capacity. The system also has limited class capacity. When a request is admitted, a class seat is allocated and remains unavailable even after the enrolment process finishes. In contrast, memory is released when a process completes and can then be reused.

The simulation demonstrates CPU scheduling, resource allocation, waiting, rejection, completion, waiting time and turnaround time. It also demonstrates operating-system must employ a scheduling policy that balances competing goals such as fairness, responsiveness, resource utilisation and correctness.

---

# 2. Enrolment Requests as Operating System Processes

An enrolment request behaves similarly to a process within an operating system.

Refer to the following comparison:
Enrolment System	- Operating System Concept
Enrolment request	- Process
CPU time required	- CPU burst
Memory required	- Memory/resource requirement
Arrival time	- Process arrival time
Waiting request	- Waiting process
Ready request	- Ready process
Round Robin queue	- Ready queue
Time slice	- CPU time quantum
Completion	- Process termination
Waiting time	- Process waiting time
Turnaround time	- Process turnaround time
Class seat	- Shared resource
Available memory	- Available system resource

Each request requires:

- Arrival time
- CPU processing time
- Memory allocation
- Access to shared resources

Examples of enrolment processing include:

- Prerequisite checking
- Timetable validation
- Class capacity validation
- Student record updates

Only one enrolment request may execute at a time. All other requests wait in a scheduling queue.

---

# 3. System Constraints

## CPU Processing Time

Each request requires a different amount of CPU processing.

| Request             | CPU Time |
|---------------------|----------|
| REQ_Prog_A          | 5        |
| REQ_Cyb_B           | 2        |
| REQ_NET_C           | 6        |
| REQ_Prog_A_s8216534 | 3        |
| REQ_NIT_D           | 6        |

The given time slice is 2-unit. Therefore, a process requiring six units cannot execute for all six units continuously. 
It must receive the CPU in multiple turns. 
Long-running processes require multiple time slices before completion, which increases scheduling overhead and potentially increases turnaround time.

---

## Memory Availability

The system contains:

Total System Memory = 180 Units

Memory requirements for each enrolment request are:

| Request             | Memory Required |
|---------------------|-----------------|
| REQ_Prog_A          | 100             |
| REQ_Cyb_B           | 200             |
| REQ_NET_C           | 80              |
| REQ_Prog_A_s8216534 | 120             |
| REQ_NIT_D           | 180             |

A request may only execute when enough memory is available.

If the request exceeds total memory capacity, it is rejected.

The system uses memory dynamically. When a process is admitted, memory is allocated. When the process completes, the memory is released and becomes available for another process. 

---

## Class Capacity

Each class contains a limited number of seats.

| Class        | Initial Capacity |
|--------------|------------------|
| class_Prog_A | 1                |
| class_Cyb_B  | 2                |
| class_NET_C  | 1                |
| class_NIT_D  | 3                |

When a seat is allocated it remains occupied for the remainder of the simulation.

---

# 4. Section A – Multi-Constraint Reasoning

## Request Classification

| Request             | Arrival | CPU | Memory  | Decision | Reason                             |
|---------------------|---------|-----|---------|----------|------------------------------------|
| REQ_Prog_A          | 0       | 5   | 100     | READY    | Memory and seat available          |
| REQ_Cyb_B           | 0       | 2   | 200     | REJECTED | Memory exceeds total system memory |
| REQ_NET_C           | 0       | 6   | 80      | READY    | Memory and seat available          |
| REQ_Prog_A_s8216534 | 4       | 3   | 120     | WAITING  | Insufficient available memory      |
| REQ_NIT_D           | 8       | 6   | 180     | WAITING  | Insufficient available memory      |

---

## Personalised Request

The personalised request used in this simulation is:

REQ_Prog_A_s8216534

This request contains the Student ID:

s8216534


### Personalised Request Details

| Property        | Value               |
|-----------------|---------------------|
| Request ID      | REQ_Prog_A_s8216534 |
| Arrival Time    | 4                   |
| CPU Time        | 3                   |
| Memory Required | 120                 |
| Class           | class_Prog_A        |

The request initially enters the WAITING state because memory resources are unavailable. Once memory has been released by completed requests, it can be admitted into the Round Robin scheduling queue.

---

# 5. Section B – Strategy Selection Under Conflict

## Selected Scheduling Algorithm

### Round Robin

Time Quantum:

2 CPU Units

Round Robin scheduling was chosen because it balances:

- Fairness
- Responsiveness
- Correctness

---

## Fairness

Every admitted request receives processing time.

No process can monopolise the CPU.

Long-running requests are periodically interrupted, allowing other requests to execute.

---

## Responsiveness

Short requests can complete quickly.

Students receive enrolment results faster because shorter requests are not blocked behind larger requests.

---

## Correctness

Before entering the scheduling queue each request undergoes:

- Memory validation
- Arrival-time validation
- Class-capacity validation

Only valid requests enter the system.

---

# 6. Section C – Round Robin Simulation

## Simulation Settings

Scheduling Algorithm: Round Robin
Time Slice: 2 Units
Total Memory: 180 Units

---

## Request Data

| Request             | Arrival | CPU | Memory  |
|---------------------|---------|-----|---------|
| REQ_Prog_A          | 0       | 5   | 100     |
| REQ_Cyb_B           | 0       | 2   | 200     |
| REQ_NET_C           | 0       | 6   | 80      |
| REQ_Prog_A_s8216534 | 4       | 3   | 120     |
| REQ_NIT_D           | 8       | 6   | 180     |

---

## Admission Results

### Accepted Immediately

REQ_Prog_A
REQ_NET_C

### Waiting

REQ_Prog_A_s8216534
REQ_NIT_D

### Rejected

REQ_Cyb_B
Reason: Memory Required = 200 System Memory = 180

---

## System State Changes

### Time 0

REQ_Prog_A admitted 
Memory Allocated = 100

REQ_NET_C admitted 
Memory Allocated = 80

Available Memory = 0

### Time 0

REQ_Cyb_B rejected 
Reason = Memory exceeds system capacity

### Time 4

REQ_Prog_A_s8216534 arrives

REQ_Prog_A_s8216534 rejected 
Reason = No class seat available / request not admitted

### Time 8

REQ_NIT_D arrives 
Status = WAITING

Reason = No available memory

### Time 9

REQ_Prog_A completes 
Memory Released = 100

Available Memory = 100

### Time 11

REQ_NET_C completes 
Memory Released = 80

Available Memory = 180

REQ_NIT_D admitted 
Memory Allocated = 180

Available Memory = 0

### Time 17

REQ_NIT_D completes 
Memory Released = 180

Available Memory = 180

---

## Waiting Time and Turnaround Analysis

Waiting time is calculated as:
Waiting Time = Turnaround Time − CPU Time

Turnaround time is calculated as:
Turnaround Time = Completion Time − Arrival Time

The scheduler automatically calculates these values during execution and displays them in the final execution table.

---

# 7. Failure Analysis

## Failed Request

REQ_Cyb_B

### Reason For Failure

REQ_Cyb_B requires:
200 Memory Units

The system contains:
180 Memory Units

Because the request exceeds the maximum available memory, the scheduler rejects it during admission control.

The request never enters the Round Robin queue.

### Impact

This demonstrates that available CPU time alone is insufficient. Requests must satisfy all resource constraints before they can execute.

---

# 8. Trade-offs

8.1 Fairness vs Correctness
One of the main trade-offs is between fairness and correctness. Round Robin is designed to provide fairness by giving each ready process a limited amount of CPU time. A long-running process cannot continuously use the CPU while shorter processes wait indefinitely. However, fairness alone does not guarantee that an enrolment is correct.
For example, suppose two students request the last available seat in the same class. Giving both requests equal opportunities to execute would appear fair from a scheduling perspective. However, allowing both enrolments to complete would be incorrect because only one seat exists.
Therefore, fair scheduling must operate together with resource validation. The scheduler should be fair when deciding which valid process gets CPU time, but correctness must take priority when deciding whether the process is actually allowed to enrol. The assignment demonstrates this trade-off because CPU scheduling is handled using Round Robin, while class-seat allocation is handled separately.
8.2 Responsiveness vs Validation Accuracy
Another trade-off is between responsiveness and validation accuracy. A system that performs many checks before allowing a request to execute may be more accurate, but those checks can delay the response.
For example, the simulation performs several admissions checks before a request becomes ready. This improves reliability because invalid requests can be rejected instead of being processed incorrectly. However, if the system performed extremely detailed validation repeatedly, it could increase processing time and reduce responsiveness.


---
# 9. Individual Contribution
Both of us contributed in equal amounts on each aspect of the project. We ran through a number of itirations of AI generated bash code and then tweaked the setting in the code such as memory usage, seat availability and arrival time to show how the round robin scheduling worked.

| Task              | Contribution                           |
|-------------------|----------------------------------------|
| System Design     | Designed enrolment process model       |
| Scheduling Logic  | Implemented Round Robin Scheduler      |
| Admission Control | Implemented memory and seat validation |
| Queue Management  | Implemented ready and waiting queues   |
| Simulation        | Tested process execution and failures  |
| Reporting         | Prepared technical documentation       |


---

# 10. Conclusion

This project successfully demonstrates how a university enrolment platform can be modelled using Operating System concepts.

Enrolment requests were treated as processes competing for CPU time, memory, and class seats. Round Robin scheduling provided fair CPU allocation while admission control ensured that only valid requests entered the system.

The simulation demonstrated accepted, waiting, and rejected requests. The personalised request REQ_Prog_A_s8216534 satisfied the individualisation requirement while showing how resource limitations affect system behaviour.

This assignment demonstrates several important trade-offs. Fairness is important because processes should receive reasonable opportunities to execute, but fairness cannot override correctness. Similarly, a system needs to be responsive, it must perform enough validation to prevent invalid enrolments.

Overall, the design provides a realistic representation of how large-scale enrolment systems manage competing requests during peak periods while maintaining responsiveness, fairness, and reliability.
