.pos 0x100
                 ld $0x0, r0              # r0 = 0
                 ld $i, r1                # r1 = &i
                 st r0, (r1)              # i = 0, r0 = temp_i
                 ld $n, r1                # r1 = &n
                 ld (r1), r1              # r1 = temp_n
                 ld $a, r2                # r2 = &a
                 ld $b, r3                # r3 = &b
                 ld $c, r4                # r4 = &c
                 ld (r4), r4              # r4 = temp_c
loop:            beq r1, end_loop         # if r1 = temp_n == 0, goto end_loop
                 ld (r2, r0, 4), r5       # r5 = a[temp_i]
                 ld (r3, r0, 4), r6       # r6 = b[temp_i]
                 not r5                   # r5 = ~r5
                 inc r5                   # r5 ++ = -a[temp_i]
                 add r6, r5               # r5 = b[temp_i] - a[temp_i]
                 beq r5, then             # if b[temp_i] == a[temp_i] goto then
                 bgt r5, then             # if b[temp_i] > a[temp_i] goto then
                 inc r4                   # temp_c ++
then:            inc r0                   # temp_i ++
                 dec r1                   # temp_n --
                 br loop                  # goto loop
end_loop:        ld $c, r1                # r1 = &c
                 st r4, (r1)              # c = temp_c
                 ld $i, r1                # r1 = i
                 st r0, (r1)              # i = temp_i
                 halt 
.pos 0x1000
i:               .long -1                 # i
n:               .long 5                  # n
a:               .long 10                 # a[0]
                 .long 20                 # a[1]
                 .long 30                 # a[2]
                 .long 40                 # a[3]
                 .long 50                 # a[4]
b:               .long 11                 # b[0]
                 .long 20                 # b[1]
                 .long 28                 # b[2]
                 .long 44                 # b[3]
                 .long 48                 # b[4]
c:               .long 0                  # c
