[org 0x0100]
jmp start
Dcount: dd 0
message: db 'Game Over'
message1: db 'score:'
length: dw 9
foodposition: dw 0
row: dw 0
col: dw 0
score: dw 0
paddle: db '********************'
gameName: db 'Apple Catcher'
Madeby1: db 'F219273 (Noor Afaqi)'
Madeby2: db 'F219304 (Sheharyar Ajmal)'
made: db 'Made by:'
control1: db 'Use "A" & "D" to play'
flag: db 0
paddlepos: dw 33


startGame:
call clrscr
	mov ax, 34
	push ax
	mov ax, 12
	push ax
	mov ax, 0x0E
	push ax
	mov ax, gameName
	push ax
	mov ax,13
	push ax
	call printstr
	mov ax, 0
	push ax
	mov ax, 22
	push ax
	mov ax, 0x0E
	push ax
	mov ax, made
	push ax
	mov ax,8
	push ax
	call printstr
	mov ax, 0
	push ax
	mov ax, 23
	push ax
	mov ax, 0x0C
	push ax
	mov ax, Madeby1
	push ax
	mov ax,20
	push ax
	call printstr
	mov ax, 0
	push ax
	mov ax, 24
	push ax
	mov ax, 0x0C
	push ax
	mov ax, Madeby2
	push ax
	mov ax,25
	push ax
	call printstr
	mov ax, 30
	push ax
	mov ax, 13
	push ax
	mov ax, 0x0A
	push ax
	mov ax, control1
	push ax
	mov ax,21
	push ax
	call printstr
	ret


setApplePosition:
	push ax
	push cx
	push dx
l1:
	MOV AH, 00h
	INT 1AH     
	mov  ax, dx
	xor  dx, dx
	mov  cx, 80    
	div  cx 
	mov word[col],dx
	mov ax,0
	mov bx,80
	mul bx
	add ax,[col]
	shl ax,1
	cmp ax,4000
	jg l1
	mov [foodposition],ax
	pop dx
	pop cx
	pop ax
	ret


clrscr: 
	push es
	push ax
	push di
	mov ax, 0xb800
	mov es, ax
	mov di, 0
nextloc: 
	mov word [es:di], 0x0720
	add di, 2
	cmp di, 4000
	jne nextloc
	pop di
	pop ax
	pop es
	ret


printstr: 
	push bp
	mov bp, sp
	push es
	push ax
	push cx
	push si
	push di
	mov ax, 0xb800
	mov es, ax
	mov al, 80 
	mul byte [bp+10]
	add ax, [bp+12] 
	shl ax, 1
	mov di,ax
	mov si, [bp+6]
	mov cx, [bp+4] 
	mov ah, [bp+8]
nextchar: 
	mov al, [si] 
	mov [es:di], ax 
	add di, 2 
	add si, 1
	loop nextchar
	pop di
	pop si
	pop cx
	pop ax
	pop es
	pop bp
	ret 10


printfood: 
	push bp
	mov bp, sp
	push es
	push ax
	push cx
	push si
	push di
	push bx
	push dx
	mov ax, 0xb800
	mov es, ax 
	mov ax,[bp+6]
	mov di,ax
	mov dx,3840
	cmp ax,dx
	jl normalprint
	mov bx,word[es:di]
	cmp bx,0x0E2A
	jne continue
	inc word[score]
	jmp ending
continue:
	call endgame
	mov byte[flag],1
	jmp ending
normalprint:
	mov ah, [bp+4] 
	mov al, 0x03 
	mov [es:di], ax
ending:
	pop dx
	pop bx
	pop di
	pop si
	pop cx
	pop ax
	pop es
	pop bp
	ret 4


DelayS:
	push bp
	mov bp,sp
	push cx
	mov cx,[bp+4]
DDlay:
	mov dword[Dcount],250000
	mov ah,0x01
	int 0x16
	jz delSec
	mov ah,0x00
	int 0x16
	cmp al,0x01
	je leftkey1
	cmp al,0x64
	je rightkey1
leftkey1:
	mov ax, 0xb800
	mov es, ax 
	mov ax,[paddlepos]
	cmp ax,0
	je delSec
	add ax,20
	shl ax,1
	add ax,3840
	mov di,ax
	mov ax,0X0720
	mov [es:di], ax
	dec word[paddlepos]
	mov ax, 0xb800
	mov es, ax 
	mov ax,[paddlepos]
	shl ax,1
	add ax,3840
	mov di,ax
	mov ax,0X0E2A
	mov [es:di], ax
	jmp delSec
rightkey1:
	mov ax, 0xb800
	mov es, ax 
	mov ax,[paddlepos]
	cmp ax,60
	je delSec
	shl ax,1
	add ax,3840
	mov di,ax
	mov ax,0X0720
	mov [es:di], ax
	inc word[paddlepos]
	mov ax, 0xb800
	mov es, ax 
	mov ax,[paddlepos]
	add ax,20
	shl ax,1
	add ax,3840
	mov di,ax
	mov ax,0X0E2A
	mov [es:di], ax
delSec:
	dec dword[Dcount]
	cmp dword[Dcount],0
	jne delSec
	dec cx
	jnz DDlay
	pop cx
	pop bp
	ret 2


fallingfood:
	push ax
	push bx
	push cx
	mov cx,25
	call setApplePosition
	mov bx,0
lll:
	call clrscr
	call printpaddle
	mov ax, 0
	push ax
	mov ax, 0
	push ax
	mov ax, 0x0A
	push ax
	mov ax, message1
	push ax
	mov ax,6
	push ax
	call printstr
	mov ax,16
	push ax
	mov ax,[score]
	push ax
	call printnum
	mov ah,0x01
	int 0x16
	jz continue2
	mov ah,0x00
	int 0x16
	cmp al,0x01
	je leftkey
	cmp al,0x64
	je rightkey
leftkey:
	mov ax, 0xb800
	mov es, ax 
	mov ax,[paddlepos]
	cmp ax,0
	je continue2
	add ax,20
	shl ax,1
	add ax,3840
	mov di,ax
	mov ax,0X0720
	mov [es:di], ax
	dec word[paddlepos]
	mov ax, 0xb800
	mov es, ax 
	mov ax,[paddlepos]
	shl ax,1
	add ax,3840
	mov di,ax
	mov ax,0X0E2A
	mov [es:di], ax
	jmp continue2
rightkey:
	mov ax, 0xb800
	mov es, ax 
	mov ax,[paddlepos]
	cmp ax,60
	je continue2
	shl ax,1
	add ax,3840
	mov di,ax
	mov ax,0X0720
	mov [es:di], ax
	inc word[paddlepos]
	mov ax, 0xb800
	mov es, ax 
	mov ax,[paddlepos]
	add ax,20
	shl ax,1
	add ax,3840
	mov di,ax
	mov ax,0X0E2A
	mov [es:di], ax
continue2:
	mov ax,[foodposition]
	add ax,bx
	push ax
	cmp cx,8
	jle colour2
	cmp cx,18
	jle colour1
	mov ax,0x0A
	push ax
	jmp skipcolour
colour1:	
	mov ax,0x0B
	push ax
	jmp skipcolour
colour2:
	mov ax,0x0C
	push ax
skipcolour:
	call printfood
	mov ax,1
	push ax
	call DelayS
	add bx,160
	dec cx
	jnz lll
	pop cx
	pop bx
	pop ax
	ret


endgame: 
	call clrscr
	mov ax, 34
	push ax
	mov ax, 12
	push ax
	mov ax, 0x0E
	push ax
	mov ax, message
	push ax 
	push word [length]
	call printstr
	mov ax, 34
	push ax
	mov ax, 13
	push ax
	mov ax, 0x0A
	push ax
	mov ax, message1
	push ax
	mov ax,6
	push ax
	call printstr
	mov ax,2162
	push ax
	mov ax,[score]
	push ax
	call printnum
	ret


printpaddle:
	mov ax, [paddlepos]
	push ax
	mov ax, 24
	push ax
	mov ax, 0x0E
	push ax
	mov ax, paddle
	push ax
	mov ax,20
	push ax
	call printstr
	ret


printnum: 
	push bp
	mov bp, sp
	push es
	push ax
	push bx
	push cx
	push dx
	push di
	mov ax, 0xb800
	mov es, ax 
	mov ax, [bp+4] 
	mov bx, 10 
	mov cx, 0 
nextdigit: 
	mov dx, 0 
	div bx
	add dl, 0x30 
	push dx 
	inc cx 
	cmp ax, 0 
	jnz nextdigit 
	mov di, [bp+6]
nextpos:
	pop dx 
	mov dh, 0x0A 
	mov [es:di], dx 
	add di, 2 
	loop nextpos 
	pop di
	pop dx
	pop cx
	pop bx
	pop ax
	pop es
	pop bp
	ret 4





start:
	call startGame
	mov ax,15
	push ax
	call DelayS
begin:
	call fallingfood
	cmp byte[flag],0
	je begin
	
	mov ax, 0x4c00
	int 0x21