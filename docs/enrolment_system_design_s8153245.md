# Student Name: George O'Hara
# Student ID: s8153245
# Assessment: VU Enrolment System

# VU Enrolment System Design & Reasoning

## Introduction

Victoria University's enrolment system experiences heavy demand at the beginning of each semester when large numbers of students attempt to enrol, swap classes and modify timetables simultaneously.

Each enrolment request behaves similarly to an operating system process because it requires CPU processing time, memory allocation and access to shared resources. The system must decide which requests can run immediately, which must wait, and which should be rejected.

## Enrolment Requests as Processes

An enrolment action performs several operations:

- prerequisite validation
- timetable clash checking
- class seat availability checking
- student record updates

These operations consume system resources in the same way that processes consume resources within an operating system.

| Process Attribute     | Enrolment Equivalent             |
|-----------------------|----------------------------------|
| Process Arrival Time  | Time enrolment request submitted |
| CPU Burst Time        | Processing time required         |
| Memory Requirement    | Memory needed for validation     |
| Resource Availability | Available system memory          |
| Shared Resource       | Class seats and database records |

---

## System Constraints

### CPU Time

Some requests require only simple capacity checks while others require complete timetable validation. Longer requests consume CPU resources for longer periods.

### Memory

Each request requires memory while being processed. If insufficient memory is available, the request cannot execute immediately.

### Class Capacity

Even when CPU and memory are available, enrolment must fail if no seats remain in the requested class.

---

## Reasoning Table

Assume:

- Total Memory = 100 MB
- Available Seats:
  - FIT1001 = 2 seats
  - NIT2002 = Full (0 seats)

| ID | Arrival | CPU | Memory | Subject | Seats Available | Decision | Reason                |
|----|---------|-----|--------|---------|----------------|-----------|-----------------------|
| E1 | 0       | 4   | 25     | FIT1001 | Yes            | Execute   | Meets all constraints |
| E2 | 1       | 2   | 15     | FIT1001 | Yes            | Execute   | Meets all constraints |
| E3 | 2       | 6   | 90     | FIT1001 | Yes            | Wait      | High memory usage     |
| E4 | 3       | 3   | 20     | NIT2002 | No             | Reject    | Class full            |
| EO | 4       | 5   | 30     | FIT1001 | Yes            | Execute   | Personalised request  |
| E5 | 5       | 8   | 120    | FIT1001 | Yes            | Reject    | Memory exceeds limit  |

---

## Scheduling Strategy

Round Robin scheduling with a time slice of 2 units is selected.

Advantages:

1. Prevents long requests monopolising the CPU.
2. Improves responsiveness during peak enrolment periods.
3. Ensures fairness by giving every eligible request CPU time.
4. Supports partial completion of longer validation tasks.

---

## Overload Handling

During overload conditions:

- Requests exceeding memory limits are rejected.
- Requests waiting for memory remain in the ready queue.
- Requests targeting full classes are rejected immediately.
- Round Robin scheduling prevents starvation.

## Conclusion

The proposed design balances fairness, responsiveness and correctness. CPU scheduling, memory availability and seat capacity are jointly considered before an enrolment action is permitted to execute.
