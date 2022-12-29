; Link with kernel32.lib

extern GetTickCount
extern QueryPerformanceCounter
extern QueryPerformanceFrequency
extern GetCurrentProcess
extern OpenProcess
extern GetCurrentProcessId
extern GetModuleHandleA
extern GetProcAddress
extern ExitProcess

section .data

temp_format db "Current temperature: %d degrees Celsius", 10, 0

section .bss

temp resd 1

section .text

global main

main:

; Query the system tick count
push 0
call GetTickCount
add esp, 4

; Query the performance counter and frequency
push 0
push 0
call QueryPerformanceCounter
add esp, 8

; Get the current process handle
push 0
call GetCurrentProcess
add esp, 4

; Open the current process
push 0
push eax
call OpenProcess
add esp, 8

; Get the current process ID
push eax
call GetCurrentProcessId
add esp, 4

; Get the handle to kernel32.dll
push 0
call GetModuleHandleA
add esp, 4

; Get the address of the GetSystemTimes function
push eax
push offset "GetSystemTimes"
call GetProcAddress
add esp, 8

; Call the GetSystemTimes function
push 0
push 0
push 0
push eax
call eax
add esp, 16

; Get the current tick count
push 0
call GetTickCount
add esp, 4

; Calculate the elapsed time
sub eax, [esp+12]

; Calculate the CPU usage
fild qword [esp]
fild qword [esp+8]
fdiv
fstp qword [temp]

; Print the CPU usage
push dword [temp+4]
push dword [temp]
push offset temp_format
call printf
add esp, 12

; Exit the process
push 0
call ExitProcess
