.pos 0x100                    # CALCULATE AVERAGES
      ld $n, r0               # r0 = &n
      ld (r0), r0             # r0 = temp_n
      ld $s, r1               # r1 = &s
      ld (r1), r1             # r1 = s
loop: beq r0, endl            # if temp_n == 0 goto end_loop
      ld 4(r1), r2            # r2  = s->grade[0]
      ld 8(r1), r3            # r3  = s->grade[1]
      add r3, r2              # r2 += s->grade[1]
      ld 12(r1), r3           # r3  = s->grade[2]
      add r3, r2              # r2 += s->grade[2]
      ld 16(r1), r3           # r3  = s->grade[3]
      add r3, r2              # r2 += s->grade[3]
      shr $2, r2              # r2  = r2/4
      st r2, 20(r1)           # s->average = r2
      ld $24, r3              # r3 = 24
      add r3, r1              # r1 = next_student = 24 + curr_student
      dec r0                  # temp_n --
      br loop                 # goto loop
                              # AVERAGES CALCULATED
                              # BEGIN SORTING -- ONLY r4, r5 available long term
endl: ld $n, r4               # r4 = &n
      ld (r4), r4             # r4 = n
      dec r4                  # r4 = n - 1
l2:   beq r4, enl2            # goto enl2 if r4 == 0
      mov r4, r5              # r5 = i (outer loop index)
                              # INNER LOOP STARTS
il2:  beq r5, eil2            # goto end of inner loop if r5 == 0
      mov r5, r1              # r1 = r5
      not r1                  # r1 = ~ r5
      inc r1                  # r1 = - r5
      add r4, r1              # r1 = r4 - r5
      mov r1, r0              # r0 = r4 - r5
      inc r1                  # r1 = r4 - r5 + 1

      mov r0, r3              # r3 = r0
      ld $s, r0               # r0 = s
      ld (r0), r0             # r0 = base
      ld $24, r1              # r1 = 24
rol:  beq r3, erol            # if r3 == 0 goto erol
      add r1, r0              # r0 = r0 + r1
      dec r3                  # r3 --
      br rol                  # goto rol
erol: add r0, r1              # r1 = r0 + 24
      gpc $6, r6              # r6 => decrement step
      j swap                  # goto swap
      dec r5                  # r5 --
      br il2                  # goto il2
                              # INNER LOOP ENDS
eil2: dec r4                  # r4 --
      br l2                   # goto l2
                              # SORTING COMPLETE
                              # BEGIN MEDIAN SEARCH
enl2: ld $n, r0               # r0 = &n
      ld (r0), r0             # r0 = n
      shr $1, r0              # r0 = floor[r0/2]
      ld $s, r1               # r1 = &s
      ld (r1), r1             # r1 = base
      ld $24, r3              # r3 = 24
l3:   beq r0, el3             # if r0 == 0 goto el3
      add r3, r1              # r1 = r1 + 24
      dec r0                  # r0 --
      br l3                   # goto l3
el3:  ld $m, r4               # r4 = &m
      ld 20(r1), r1           # r1 = r1_avg
      st r1, (r4)             # m = r1_avg
      halt


                              # SWAP FUNCTION; assumes r0, r1 contains addresses
                              #                uses only r0, r1, r3, t0, t1
                              #                assumes r6 gives RA
                              #                swaps iff r0_avg > r1_avg
swap: ld $t0, r3              # r3 = &t0
      st r0, (r3)             # t0 = r0
      ld 20(r0), r0           # r0 = r0_avg
      ld $t1, r3              # r3 = &t1
      st r1, (r3)             # t1 = r1
      ld 20(r1), r1           # r1 = r1_avg
      mov r1 ,r3              # r3 = r1_avg
      not r3                  # r3 = ~r3
      inc r3                  # r3 = -r1_avg
      add r0, r3              # r3 = r0_avg - r1_avg
      bgt r3, grt             # goto grt if r0_avg - r1_avg
      br endf                 # goto endf
                              # SWAP AVERAGES
grt:  ld $t0, r3              # r3 = &t0
      ld (r3), r3             # r3 = t0
      st r1, 20(r3)           # s0_avg = s1_avg
      ld $t1, r3              # r3 = &t1
      ld (r3), r3             # r3 = t1
      st r0, 20(r3)           # s1_avg = s0_avg
                              # SWAP G3
      ld 16(r3), r1           # r1 = s1_g3
      ld $t0, r3              # r3 = &t0
      ld (r3), r3             # r3 = t0
      ld 16(r3), r0           # r0 = s2_g3
      st r1, 16(r3)           # s0_g3 = s1_g3
      ld $t1, r3              # r3 = &t1
      ld (r3), r3             # r3 = t1
      st r0, 16(r3)           # s1_g3 = s0_g3
                              # SWAP G2
      ld 12(r3), r1           # r1 = s1_g2
      ld $t0, r3              # r3 = &t0
      ld (r3), r3             # r3 = t0
      ld 12(r3), r0           # r0 = s0_g2
      st r1, 12(r3)           # s0_g2 = s1_g2
      ld $t1, r3              # r3 = &t1
      ld (r3), r3             # r3 = t1
      st r0, 12(r3)           # s1_g2 = s0_g2
                              # SWAP G1
      ld 8(r3), r1            # r1 = s1_g2
      ld $t0, r3              # r3 = &t0
      ld (r3), r3             # r3 = t0
      ld 8(r3), r0            # r0 = s0_g2
      st r1, 8(r3)            # s0_g2 = s1_g2
      ld $t1, r3              # r3 = &t1
      ld (r3), r3             # r3 = t1
      st r0, 8(r3)            # s1_g2 = s0_g2
                              # SWAP G0
      ld 4(r3), r1            # r1 = s1_g2
      ld $t0, r3              # r3 = &t0
      ld (r3), r3             # r3 = t0
      ld 4(r3), r0            # r0 = s0_g2
      st r1, 4(r3)            # s0_g2 = s1_g2
      ld $t1, r3              # r3 = &t1
      ld (r3), r3             # r3 = t1
      st r0, 4(r3)            # s1_g2 = s0_g2
                              # SWAP ID
      ld (r3), r1             # r1 = s1_g2
      ld $t0, r3              # r3 = &t0
      ld (r3), r3             # r3 = t0
      ld (r3), r0             # r0 = s0_g2
      st r1, (r3)             # s0_g2 = s1_g2
      ld $t1, r3              # r3 = &t1
      ld (r3), r3             # r3 = t1
      st r0, (r3)             # s1_g2 = s0_g2
endf: j (r6)                  # goto r6 = RA


.pos 0x1000
n:    .long 5                 # two students
m:    .long 0                 # put the answer here
s:    .long base              # address of the array
base: .long 0003              # student ID
      .long 25                # grade 0
      .long 50                # grade 1
      .long 25                # grade 2
      .long 0                 # grade 3
      .long 0                 # computed average
      .long 0005              # student ID
      .long 10                # grade 0
      .long 10                # grade 1
      .long 5                 # grade 2
      .long 5                 # grade 3
      .long 0                 # computed average
      .long 0002              # student ID
      .long 50                # grade 0
      .long 100               # grade 1
      .long 50                # grade 2
      .long 100               # grade 3
      .long 0                 # computed average
      .long 0004              # student ID
      .long 0                 # grade 0
      .long 0                 # grade 1
      .long 0                 # grade 2
      .long 0                 # grade 3
      .long 0                 # computed average
      .long 0001              # student ID
      .long 75                # grade 0
      .long 75                # grade 1
      .long 50                # grade 2
      .long 50                # grade 3
      .long 0                 # computed average
t0:   .long 0                 # temp local variable
t1:   .long 0                 # temp local variable
j:    .long 0                 # temp local variable
