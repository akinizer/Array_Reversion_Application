.data
array:  .space 88
prompt: .asciiz "Enter input (0 to quit) :"
text:   .asciiz "List:"
space: .asciiz " "
next: .asciiz "\n"
  
.text
.globl main
main:
	la $a1, array   # empty list
	li $t1, 0 # counter for item amount
	
read_numbers:
	# message to read item
	li $v0, 4 
   	la $a0, prompt
    	syscall
	
	# read item
    	li $v0, 5
    	syscall
	
	# insert item to list and update size
    	sw $v0, 0($a1)
    	addiu $a1, $a1, 4
	
	# update current size counter
	addi $t1, $t1, 1
	
	# condition to check whether current size is max
	beq $t1, 20, gotolist
	
	# condition to check whether 0 as stop command is read
	beqz $v0, gotolist
	
	# loop to read
	j read_numbers		
    	
gotolist:
	# go to list represntation
   	jal list

while:
	# get current item from list
    	lw $t0, 0($a1)
   	addiu $a1, $a1, 4

	# condition to check to reach the end of list
	beqz $t0, list_rev
	
	# list current item
    	li $v0, 1
    	move $a0, $t0
    	syscall
    	
    	# space delimiter between items
    	li $v0, 4 #string
	la $a0, space 
	syscall	 
	
	# loop to list items
    	j while
    
rev:
	# get current item from list in a reversed way
    	lw $t0, -8($a1) 
    	
    	# next index 	
    	addiu $a1, $a1, -4

    	# check end of list    	
    	bnez $t0, rev_cont
    	
    	# reversed list is done
    	j done

rev_cont:   
	# print items for reversed list	
    	li $v0, 1
    	move $a0, $t0
    	syscall
	
	# space delimiter
 	li $v0, 4 #string
	la $a0, space 
	syscall	 
	
	# loop for reversed list
    	j rev

done:	
	# end of program
	li $v0, 10
	syscall	 

list:
	# get the list
    	la $a1, array
	
	# nextline character
	li $v0, 4
    	la $a0, next
    	syscall
	
	# "list: "
    	li $v0, 4
    	la $a0, text
    	syscall
    	
    	# back to caller
    	jr $ra
    	
list_rev:
	# next line
	li $v0, 4
    	la $a0, next
    	syscall
	
	# "list: "
    	li $v0, 4
    	la $a0, text
    	syscall
    	
    	# go to reversed list function
    	j rev

max_cap:
	# 0 as null value for next item of full list aka stop command
	li $v0, 0
	
	# set value and update list
    	sw $v0, 0($a1)
    	addiu $a1, $a1, 4
	
	#go to back to operations
	j gotolist
