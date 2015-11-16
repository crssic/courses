assume cs:code, ds:data
data segment
      s db `a`, `v`, `x`, `a`, `c`

;the following declaration has the same meaning:
;      s db `avxac`
;the effect of the two instructions is the allocation of one byte for each character of the string, in the same order in which they appear

      l EQU $-s

;$ represents the current value of the offset (the number of bytes that were generated by the assembler until this moment within the data segment; in this moment $=5 because there were 5 bytes generated until now, for the characters `a`,`v`,`x`,`a`,`c`)
;by substracting the offset of s from the current offset we obtain the number of bytes of the string s, which represents the number of characters
;we store the obtained number in the constant l
;the following declaration could have also been used: 
;      l db $-s 
;considering that the length of the string could be represented on a byte; the advantage of using EQU will be seen a bit later

      d db l dup (?)

;we allocate the space for the resulting string d, which will have the same length as s
;the operator DUP is used for reserving a memory block of length l
;the presence of the character `?` in this declaration has as effect only the reservation of the memory space, without initialization. 
;if we would have wanted to initialize the bytes in this memory space with the value 0, we would have used the following declaration:
;      d db l dup (0)
;the reason why we can use the value of l in this declaration is the fact that the assignment of the value to the constant l is done during the assembly phase, while if we would have used the following declaration for obtaining the length of the string:
;      l db $-s
;then l could not have appeared in the declaration:
;      d db l dup (?)
;because the value of l would not have been known during the assembly phase and the following error message would appear at assembly time: `Expecting scalar type` 
;another difference between the two variants is the fact that EQU directive does not generate bytes in memmory, therefore no space is allocated for l within the data segment; if we use the db directive for l, a byte is generated. 

data ends
code segment
start:
      mov ax, data
      mov ds, ax
      mov cx, l      ;we prepare in CX the length of string s, because we will use the loop instruction for repeatedly executing a set of instructions
      mov si, 0      ;the register SI will be used as index for the two strings
      jcxz Sfarsit   ;we will use loop instruction, which executes a set of instructions CX times. We first check if CX is not 0 before entering the loop, if CX is 0 then the loop would be executed 65535 times (because it first decrements 0-1 = -1 = 65535 and the test is done only after that)
      Repeta:
      mov al, byte ptr s[si]      ;we copy in AL the byte found in the data segment at offset s plus SI bytes; we thus obtain the byte of rank SI within the string, where the first byte has the rank 0
;in this moment in AL we have the ASCII code of a small cap letter from source string s

;because of the byte type of s, we couls also use:
;      mov al, s[si]
;if we would have had a string of words declared as follows:
;      sw dw `a`, `v`, `x`, `a`, `c`
;then the instruction:
;      mov al, s[si]
;would have represented a syntax error, generating the error message `Operand types do not match`, because AL is byte and s is word 
;in this case we should have used:
;      mov al, byte ptr s[si]
;which would have as effect loading AL with the low byte of the word starting at the offset s+SI

;we recall in this context the formula of computing the offset of an operand, which reflects 3 memory addressing modes: 
;      direct, when only the constant appears;
;      based, if BX or BP appears in the formula;
;      indexed, if SI or DI appears in the formula;
;offset = [ BX | BP ] + [ DI | SI ] + [ constant ]

      sub al, `a`-`A`      ;for obtaining the corresponding uppercase letter of the small cap letter whose ASCII code is in AL, we will substract from the ASCII code of the small cap letter the ASCII code of the uppercase letter `a`-`A`, this value represents the difference between any small cap letter and its corresponding uppercase letter

      mov byte ptr d[si], al      ;we put in d the uppercase letter thus obtained on the same position SI on which the small cap letter is found within the source string s
;we could have also used:
;      mov d[si], al
;for the same reason explained above

      inc si      ;we go to the next byte within the string
      loop Repeta
      Sfarsit:      ;end of program
mov ax, 4C00h
int 21h
code ends
end start
