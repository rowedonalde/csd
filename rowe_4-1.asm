; rowe_4-1.asm
; Finds the largest number in a sequential list of N 32-bit
; signed numbers and stores it after the list
count:  .equ 5           ; Initialize constant

        .org 0xF0        ; Indicate location of data
data:   .dc  2
        .dc  5
        .dc  5
        .dc  7
        .dc  1
result: .dc  1

        .org 0xA000      ; Indicate location of code
        la   r1, count   ; Put N in r1 and just say it's 5 for right now
        lar  r2, loop    ; Put the loop address into r2
        la   r3, data    ; Current address
        lar  r6, update  ; Put the update address into r6
        lar  r7, finish  ; Put the finish address into r7
        
        stop
        
update: ld   r4, 0(r3)      ; Place the number at the current address      
                         ; in the current largest.
        brzr r7, r1      ; If N is 0, jump ahead to finish.
                         
loop:   addi r3, r3, 4       ; Move the current address ahead by 4.
        addi r1, r1, -1      ; Subtract 1 from N.
        ld   r8, 0(r3)   ; Load the value at the current address into r8
        sub  r5, r8, r4  ; Subtract the largest number from the current number
                         ; and let r5 hold the result.
        brpl r6, r5      ; If current - largest >= 0, update largest to current.
        brzr r7, r1      ; If N is 0, jump ahead to finish.
        br   r2          ; Otherwise, just jump back to the top of the loop.
        
finish: st   r4, result  ; Store the largest to the result address,
                         ; i.e., after all the numbers in the sequence
        
