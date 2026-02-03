[org 0x0100]
jmp start
opened: db 'file opened successfully$'
failed_2: db 'failed to read the file$'
message_1:	db 'file read successful$'
failed_1: db 'file does not exist$'
failed_3: db 'file has incomplete data$'
message_2: db 'press any key to begin$'

message: db 'Enter filename: $'
rock_position: dw 0
name:  db 30
            db 0
            times 30 db 0 
data: times 2000 db 0

start:
mov ax, 0
mov bx, 0
mov cx, 0
mov dx, 0
mov di, 0
mov si, 0
jmp main


clear_screen   ; Standard clear screen subroutine
push ax
push es
push di
push cx

mov ax, 0xb800
mov es, ax
mov ax, 0x0720
mov cx, 2000

rep stosw

pop cx
pop di
pop es
pop ax
ret


cursor_point:   ; Standard point cursor routine
push bp
push ax
push bx
push dx

mov bp, sp
mov dh, [bp + 10]
mov dl, 00h
mov bh, 0
mov ah, 2
int 10h

pop dx
pop bx
pop ax
pop bp
ret 2



display:
push si
push di
push ax
push cx
push es

mov ax, 0xb800
mov es, ax
mov ax, 0
mov cx, 1600
mov di, 0
mov si, data

set_display:
cmp byte[si], 20h
je show_blank
cmp byte[si], 57h
je show_wall
cmp byte[si], 44h
je show_diamond
cmp byte[si], 42h
je show_boulder
cmp byte[si], 52h
je show_rock
cmp byte[si], 54h
je show_target
cmp byte[si], 78h
je show_dirt
jmp show_blank


show_wall:
mov ax, 0xe020
jmp show_block

show_boulder:
mov ax, 0x06e8
jmp show_block

show_diamond:
mov ax, 0x0b04
jmp show_block

show_target:
mov ax, 0x6f7f
jmp show_block

show_rock:
mov ax, 0x059a
jmp show_block

show_dirt:
mov ax, 0x9020
jmp show_block

show_blank:
mov ax, 0x8020
jmp show_block
  
show_block:
stosw
add si, 1
loop set_display

pop es
pop cx
pop ax
pop di
pop si
ret



first_phase:
push ax
push bx
push cx		;storing register values
push dx
push si
push di
push es
push ds

file_open:
call clear_screen

push 1h		;setting cursor
call cursor_point

mov ah, 09h
mov dx, message		; displaying message to enter file name
int 21h

mov ah, 0ah
mov dx, name		;calling interrupt to open file
int 21h

mov bl, [name + 1]
mov si, name + 2
add si, bx
mov bx, 0			;replacing 0D by 00
mov byte[si], 0
mov ah, 3dh
mov al, 0			;opemning in read mode
mov dx, name + 2		;pointing dx towards the start of file name
int 21h
jnc opening_successful
jmp unable_to_open


unable_to_open:
push 2
call cursor_point		;setting cursor

mov ah, 09h
mov dx, failed_1
int 21h			;displaying message to show file failed to open
mov ah, 0
int 0x16
jmp file_open		;jump back

opening_successful:
push 2
call cursor_point		;setting cursor

mov bx, ax
mov ah, 09h
mov dx, opened		; displaying message to show file successfully opened
int 21h
jmp read_file

read_file:
mov ah, 3fh
mov cx, 2000		;Total bytes to read from file
mov dx, data		;points to start of data
int 21h
jc unable_read_file
jmp successfully_read_file


unable_read_file:
push 3
call cursor_point		;setting cursor
mov ah, 09
mov dx, failed_2		;displaying message to show file failed to open
int 21h

mov ah, 0
int 0x16
jmp file_open		;jump back


file_incomplete:
push 3			;setting cursor
call cursor_point
mov ah, 09
mov dx, failed_3
int 21h			;displaying message to show incomplete data

mov ah, 0
int 0x16			
jmp file_open		;Again asks to enter filename


successfully_read_file:
cmp ax, 1600		;checking if 1600 bytes were read
jb file_incomplete	;if not then jump to incomplete data subroutine

push 3			;setting cursor
call cursor_point
mov ah, 09			;displaying message to show file read successfully
mov dx, message_1
int 21h

push 4
call cursor_point
mov ah, 09
mov dx, message_2		;displaying message to prompt user to enter any key
int 21h
mov ah, 0
int 0x16

pop ds
pop es
pop di
pop si
pop dx
pop cx			;popping stored values from stack
pop bx
pop ax
ret



main:
call first_phase		; main 
call display

jmp finish


finish:
mov ax, 0x4c00		;ending program
int 0x21