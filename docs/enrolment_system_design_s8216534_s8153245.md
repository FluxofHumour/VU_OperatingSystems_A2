# Student Name: Martin Yii George O'Hara
# Student ID: s8216534 s8153245
# Assessment: VU Enrolment System

# VU Enrolment System Design & Reasoning

---

# Table of Contents

1. Project Summary
2. Introduction
3. Enrolment Requests as Operating System Processes
4. System Constraints
5. Section A – Multi-Constraint Reasoning
6. Section B – Strategy Selection Under Conflict
7. Section C – Round Robin Simulation
8. Failure Analysis
9. Individual Contribution
10. Conclusion

--

# 1. Project Summary

This project simulates Victoria University's online enrolment system during peak enrolment periods. Students submit enrolment requests that compete for limited system resources, including CPU processing time, available memory, and class seats.

The system treats each enrolment request as a process and uses a Round Robin scheduling algorithm with a time quantum of two units. Requests are evaluated using admission control before entering the execution queue. Requests may be accepted, delayed, or rejected depending on resource availability.

The simulation demonstrates how operating system concepts can be applied to real-world enrolment management while ensuring fairness, responsiveness, and correctness.

---

# 2. Introduction

At the beginning of each semester, thousands of students attempt to enrol in classes within a short period of time. The enrolment platform must process requests efficiently while ensuring that invalid enrolments are prevented.

Each request requires:

- CPU processing time
- Memory allocation
- Class seat availability

Because these resources are limited, the system must make scheduling decisions that determine whether requests can execute immediately, must wait, or need to be rejected.

This simulation models those decisions using operating system principles.

---

# 3. Enrolment Requests as Operating System Processes

An enrolment request behaves similarly to an operating system process.

Examples of enrolment operations include:

- Validating subject prerequisites
- Checking timetable clashes
- Confirming class seat availability
- Updating the student database
- Generating enrolment confirmations

Each request contains:

| Process Attribute  | Enrolment Equivalent                |
|--------------------|-------------------------------------|
| Arrival Time       | Time request enters system          |
| CPU Time           | Processing time required            |
| Memory Requirement | Memory needed during processing     |
| Shared Resource    | Available class seats               |
| Process State      | Ready, Waiting, Completed, Rejected |

Since only one request executes at a time, all requests compete for CPU access.

---

# 4. System Constraints

## CPU Time

Different enrolment requests require different processing times.

| Request             | CPU Time |
|---------------------|----------|
| REQ_Prog_A          | 5        |
| REQ_Cyb_B           | 2        |
| REQ_NET_C           | 6        |
| REQ_Prog_A_s8216534 | 3        |
| REQ_NIT_D           | 6        |

Longer requests require more CPU time and therefore remain in the scheduling queue longer.

---

## Memory

The system contains:


Total Available Memory = 180 Units


Each request requires memory before it can execute.

| Request             | Memory Required |
|---------------------|-----------------|
| REQ_Prog_A          | 100             |
| REQ_Cyb_B           | 200             |
| REQ_NET_C           | 150             |
| REQ_Prog_A_s8216534 | 120             |
| REQ_NIT_D           | 180             |

If insufficient memory is available, the request enters the WAITING state.

If the memory requirement exceeds the total memory available in the entire system, the request is immediately rejected.

---

## Class Capacity

Each class has a limited number of seats.

| Class        | Capacity |
|--------------|----------|
| class_Prog_A | 1        |
| class_Cyb_B  | 2        |
| class_NET_C  | 1        |
| class_NIT_D  | 3        |

Once a seat has been assigned it remains occupied for the duration of the simulation.

---

# 5. Section A – Multi-Constraint Reasoning

## Request Classification Table

| Request             | Arrival | CPU | Memory | Class Seat  | Decision | Reason                                  |
|---------------------|---------|-----|---------|------------|----------|-----------------------------------------|
| REQ_Prog_A          | 0       | 5   | 100     | Available  | READY    | All constraints satisfied               |
| REQ_Cyb_B           | 0       | 2   | 200     | Available  | REJECTED | Memory requirement exceeds total memory |
| REQ_NET_C           | 4       | 6   | 150     | Available  | WAITING  | Insufficient available memory           |
| REQ_Prog_A_s8216534 | 4       | 3   | 120     | Available  | WAITING  | Memory unavailable at arrival           |
| REQ_NIT_D           | 8       | 6   | 180     | Available  | WAITING  | Must wait for memory release            |

---

## Personalised Request

The personalised request used in this simulation is:


REQ_Prog_A_s8216534


This request contains the student's ID:


s8216534


and satisfies the assessment individualisation requirement.

### Personalised Request Details

| Property     | Value               |
|--------------|---------------------|
| Request ID   | REQ_Prog_A_s8216534 |
| Arrival Time | 4                   |
| CPU Time     | 3                   |
| Memory       | 120                 |
| Class        | class_Prog_A        |

Initially, the request must wait because insufficient memory is available. Once memory is released by completed processes, it is admitted to the Round Robin queue.

---

# 6. Section B – Strategy Selection Under Conflict

## Selected Scheduling Algorithm

### Round Robin

Round Robin scheduling was selected because it balances:

- Fairness
- Responsiveness
- Correctness

### Time Quantum


2 CPU Units


---

## Fairness

Every process receives CPU access.

No process is allowed to monopolise system resources.

Long-running requests are periodically interrupted so that other requests can execute.

---

## Responsiveness

Short enrolment requests receive service quickly.

Students receive feedback sooner because they are not forced to wait for long requests to fully complete.

---

## Correctness

Before execution begins, the scheduler validates:

- Memory requirements
- Arrival times
- Class seat availability

Invalid requests are rejected before entering the queue.

---

## Why Round Robin Was Selected

Round Robin provides a balance between:

| Requirement           | Support  |
|-----------------------|----------|
| Fairness              | High     |
| Responsiveness        | High     |
| Starvation Prevention | High     |
| Simplicity            | High     |

For a high-demand enrolment platform, Round Robin provides predictable and equitable CPU access.

---

# 7. Section C – Round Robin Simulation

## Simulation Configuration


Scheduling Algorithm = Round Robin
Time Slice = 2 Units
Total Memory = 180 Units


---

## Initial Requests

| Request             | Arrival | CPU | Memory  |
|---------------------|---------|-----|---------|
| REQ_Prog_A          | 0       | 5   | 100     |
| REQ_Cyb_B           | 0       | 2   | 200     |
| REQ_NET_C           | 4       | 6   | 150     |
| REQ_Prog_A_s8216534 | 4       | 3   | 120     |
| REQ_NIT_D           | 8       | 6   | 180     |

---

## Admission Control Results

### Accepted


REQ_Prog_A


### Waiting


REQ_NET_C
REQ_Prog_A_s8216534
REQ_NIT_D


### Rejected


REQ_Cyb_B


Reason:


Memory Required = 200
System Memory = 180

## Memory State Changes

### Time 0


REQ_Prog_A admitted
Memory Allocated = 100
Available Memory = 80


### Time 4


REQ_NET_C arrives
Requires 150 Memory
WAITING



REQ_Prog_A_s8216534 arrives
Requires 120 Memory
WAITING


### Time 5


REQ_Prog_A completes
Memory Released = 100
Available Memory = 180


### Time 5


REQ_Prog_A_s8216534 admitted
Memory Allocated = 120
Available Memory = 60


### Time 8


REQ_Prog_A_s8216534 completes
Memory Released = 120


### Time 8


REQ_NET_C admitted
Memory Allocated = 150


### Time 14


REQ_NET_C completes
Memory Released = 150


### Time 14


REQ_NIT_D admitted
Memory Allocated = 180


### Time 20


REQ_NIT_D completes
Memory Released = 180


---

## Waiting Time and Turnaround Time

| Request             | Waiting Time                | Turnaround Time      |
|---------------------|-----------------------------|----------------------|
| REQ_Prog_A          | 0                           | 5                    |
| REQ_Cyb_B           | N/A                         | N/A                  |
| REQ_NET_C           | Depends on admission timing | Completion - Arrival |
| REQ_Prog_A_s8216534 | Depends on admission timing | Completion - Arrival |
| REQ_NIT_D           | Depends on admission timing | Completion - Arrival |

---

# 8. Failure Analysis

## Failed Request


REQ_Cyb_B


### Reason For Failure

The request requires:


200 Memory Units


The system only contains:


180 Memory Units


Since the request exceeds the total memory available within the system, it fails the admission check and is rejected before scheduling begins.

### Why This Matters

This demonstrates that:

- CPU availability alone is insufficient.
- Memory constraints must also be satisfied.
- The scheduler prevents unsafe execution.

---

# 9. Individual Contribution

| Task              | Contribution                                |
|-------------------|---------------------------------------------|
| System Design     | Created enrolment process model             |
| Scheduling Logic  | Implemented Round Robin scheduling          |
| Admission Control | Added memory and seat validation            |
| Simulation        | Tested process execution and waiting states |
| Documentation     | Produced system report and reasoning tables |
| Failure Analysis  | Analysed rejected enrolment request         |

# 10. Conclusion

This project successfully demonstrates how a university enrolment system can be modelled using operating system concepts.

Enrolment actions were treated as processes competing for CPU time, memory, and class seats. The Round Robin scheduling algorithm was selected because it provides fairness, good responsiveness, and prevents starvation.

The simulation demonstrated accepted requests, waiting requests, and rejected requests. The personalised request, REQ_Prog_A_s8216534, satisfied the individualisation requirement while demonstrating how resource constraints affect scheduling decisions.

Overall, the design provides a reliable and realistic representation of how large-scale enrolment systems manage competing requests during high-demand periods.
