; rowe_4-1.asm
; Finds the largest number in a sequential list of N 32-bit
; signed numbers and stores it after the list
count1: .equ 5           ; Initialize constants
count2: .equ 4
count3: .equ 6

        .org 0xF0        ; Indicate location of data
data1:  .dc  2
        .dc  5
        .dc  5
        .dc  7
        .dc  1
res1:   .dc  1

data2:  .dc  100
        .dc  50
        .dc  1
        .dc  -10
res2:   .dc  1

data3:  .dc  -5
        .dc  -10
        .dc  -1000
        .dc  1
        .dc  -500
        .dc  -1
res3:   .dc  1

        .org 0xA000      ; Indicate location of code
main:   la   r3, data1   ; Begin main and start loading first round
        la   r1, count1  ; N of first round
        la   r10, res1   ; Result space for first round
        lar  r11, big    ; Store the "big" address in r11
        brl  r9, r11     ; Store the return address and call the big subroutine
        
        la   r3, data2   ; Start loading second round
        la   r1, count2  ; N of second round
        la   r10, res2   ; Result space for second round
        brl  r9, r11     ; Store the return address and call the big subroutine
        
        la   r3, data3   ; Start loading third round
        la   r1, count3  ; N of second round
        la   r10, res3   ; Result space for third round
        brl  r9,  r11    ; Store the return address and call the big subroutine

                         ; Begin the subroutine:
big:    lar  r2, loop    ; Put the loop address into r2
        lar  r6, update  ; Put the update address into r6
        lar  r7, finish  ; Put the finish address into r7
        
        stop
        
update: ld   r4, 0(r3)   ; Place the number at the current address      
                         ; in the current largest.
        brzr r7, r1      ; If N is 0, jump ahead to finish.
                         
loop:   addi r3, r3, 4   ; Move the current address ahead by 4.
        addi r1, r1, -1  ; Subtract 1 from N.
        ld   r8, 0(r3)   ; Load the value at the current address into r8
        sub  r5, r8, r4  ; Subtract the largest number from the current number
                         ; and let r5 hold the result.
        brpl r6, r5      ; If current - largest >= 0, update largest to current.
        brzr r7, r1      ; If N is 0, jump ahead to finish.
        br   r2          ; Otherwise, just jump back to the top of the loop.
        
finish: st   r4, 0(r10)  ; Store the largest to the result address,
                         ; i.e., after all the numbers in the sequence.
        br   r9          ; Branch back to the return address.
        
