.syntax unified
    .thumb
    .section .text
    .global xmodem_receive

/* r0 = Destination Buffer Address */
xmodem_receive:
    push    {r4, r5, r6, r7, r8, lr}
    mov     r4, r0              @ r4 = current buffer pointer
    mov     r5, #1              @ r5 = expected block number

    @ 1. Start the transfer by sending NAK
start_retry:
    mov     r0, #0x15           @ NAK
    bl      putchar

receive_loop:
    bl      getchar             @ Wait for SOH or EOT
    
    cmp     r0, #0x04           @ Check for EOT (End of Transmission)
    beq     finished_success
    
    cmp     r0, #0x01           @ Check for SOH (Start of Header)
    bne     start_retry         @ If not SOH, something is wrong; NAK again

    @ 2. Read Block Number
    bl      getchar             
    mov     r6, r0              @ r6 = Block Number
    bl      getchar             
    mvn     r0, r0              @ Bitwise NOT of the inverse block number
    and     r0, r0, #0xFF       @ Keep only lower byte
    cmp     r0, r6              @ Must match r6
    bne     error_nak

    @ 3. Read 128 Bytes of Data
    mov     r7, #0              @ Index counter
data_loop:
    push    {r0-r3}             @ Save registers for getchar
    bl      getchar
    mov     r8, r0              @ Store byte in r8
    pop     {r0-r3}
    
    strb    r8, [r4, r7]        @ Store in buffer
    add     r7, #1
    cmp     r7, #128
    blt     data_loop

    @ 4. Read Checksum (simplified 8-bit sum)
    bl      getchar             @ For standard XMODEM, this is the checksum byte
    @ (In a production version, you would verify the sum here)

    @ 5. Success! ACK and move to next block
    mov     r0, #0x06           @ ACK
    bl      putchar
    
    add     r4, #128            @ Advance buffer pointer
    add     r5, #1              @ Increment expected block
    b       receive_loop

finished_success:
    mov     r0, #0x06           @ Final ACK for the EOT
    bl      putchar
    mov     r0, #0              @ Return 0 (Success)
    pop     {r4, r5, r6, r7, r8, pc}

error_nak:
    mov     r0, #0x15           @ NAK (Request re-send of block)
    bl      putchar
    b       receive_loop
