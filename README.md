# System Calls

The system call is the fundamental interface between an application and the
operating system kernel.

`syscall` module provides wrappers for system calls. Use `C.syscall()` if you
want to invoke system calls that has no wrappers.

## Status and Purpose

This project is currently a Work in Progress (WIP). Breaking changes may occur
prior to reaching version 1.0.0.

The objective of this module is to provide C wrappers that are currently
missing from V's standard `os` library. However, this does not preclude the
inclusion of wrappers for system calls that are *already* present in the
standard library. Consequently, the `syscall` module does not aim to provide
comprehensive coverage of all system calls; rather, the number of wrappers
will be expanded on an as-needed basis.

Microsoft Windows support is not planned.
