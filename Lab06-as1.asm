.data 
A: .word 3,-2,3,-6,1 
 
.text 
main:       la  $a0,A 
            li  $a1,5 
            j     mspfx 
            nop 
continue: 
lock:       #j  lock  
	    addi $t0, $v0, 0
	    li $v0, 1
	    la $a0, ($t0)
	    
	    syscall
	    li $v0, 1
	    la $a0, ($v1)
	    syscall
	    j mspfx_end
            nop 
end_of_main: 
 
#----------------------------------------------------------------- 
#Procedure mspfx 
# @brief find the maximum-prefix sum in a list of integers 
# @param[in] a0: the base address of the list (A) need to be processed 
# @param[in] a1: the number of elements in list (A)  
# @param[out]v0: the length of sub-list of A that has the max sum. 
# @param[out]v1: the max prefix sum 
#----------------------------------------------------------------- 
#Procedure mspfx 
#function: find the maximum-prefix sum in a list of integers 
#the base address of the list (A) is stored in $a0  
#the number of elements is stored in a1 
mspfx:  addi  $v0,$zero,0 #initialize the length in $v0 to 0 
        addi  $v1,$zero,0 #initialize the max sum in $v1 to 0 
        addi  $t0,$zero,0 #initialize the index i in $t0 to 0 
        addi  $t1,$zero,0 #initialize the running sum in $t1 to 0 
loop: add   $t2,$t0,$t0       #put 2i in $t2 
      add  $t2,$t2,$t2       #put 4i in $t2 
  add  $t3,$t2,$a0       #put 4i+A (address of A[i]) in $t3 
  lw  $t4,0($t3)    #load A[i] from mem(t3) into $t4 
  add  $t1,$t1,$t4       #add A[i] to the running sum in $t1 
  slt  $t5,$v1,$t1       #set $t5 to 1 if max sum < new sum 
  bne  $t5,$zero,mdfy   #if the max sum is less, modify results 
  j  test          #done? 
mdfy: addi  $v0,$t0,1    #new max-sum prefix has length i+1 
  addi  $v1,$t1,0    #new max sum is the running sum 
test: addi  $t0,$t0,1    #increment the index i 
  slt  $t5,$t0,$a1       #set $t5 to 1 if i<n 
  bne  $t5,$zero,loop  #repeat if i<n 
done: j     continue 
mspfx_end: