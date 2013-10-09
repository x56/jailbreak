/*
 * Copyright 2013, winocm. <winocm@icloud.com>
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 * 
 *   Redistributions of source code must retain the above copyright notice, this
 *   list of conditions and the following disclaimer.
 * 
 *   Redistributions in binary form must reproduce the above copyright notice, this
 *   list of conditions and the following disclaimer in the documentation and/or
 *   other materials provided with the distribution.
 * 
 *   If you are going to use this software in any form that does not involve
 *   releasing the source to this project or improving it, let me know beforehand.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
 * ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
/*
 * Kernel shellcode entrypoint.
 */

#include "asm_help.h"
#include "arch.h"

/* Force alignment for this to be in the right place... */
.align 15

/* This must be at 0x10000 | (CPSR_T). */

/*
 * CPSR bit definitions.
 */
#define BIT_IRQ     (1 << 7)
#define BIT_FIQ     (1 << 6)

/**
 * hfs_payload_entry
 *
 * Calls the real kernel payload and restores the stack.
 */
EnterThumb(hfs_payload_entry)
    /* Leet hax. */
    bl      _Leet_hax

    /* Restore kernel state. */
    movs    r0, #0x1000
    add     sp, sp, #0xE4
    pop     {r2-r4}
    mov     r8, r2
    mov     r10, r3
    mov     r11, r4
    pop     {r4-r7,pc}

/**
 * Leet_hax
 *
 * The entrypoint for the kernel mode part of the exploit.
 */
EnterARM(Leet_hax)
    /* Prologue for the kernel code. */
    stmfd   sp!, {r4-r7,pc}

    /* Establish a frame pointer. */
    add     r7, sp, #4

    /* Mask off all interrupts to prevent interferences. */
    mrs     r7, cpsr
    orr     r6, r7, #(BIT_IRQ | BIT_FIQ)
    msr     cpsr_cf, r6

    /* xxx write your kernel shellcode routines here */
    /* xxx right now, I'll leave an Undefined instruction here so you can see a cool panic! */

    .long   0xfefefefe
    
    /* Exit the kernel shellcode. Return to the previous processor state. */
    msr     cpsr_cf, r7

    /* Bye. */
    ldmfd   sp!, {r4-r7, pc}
