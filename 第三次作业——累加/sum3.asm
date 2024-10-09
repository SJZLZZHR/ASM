;存放在栈中
.model small
.stack 100h
.data
    newline db 13, 10, '$'          ; 回车符和换行符
    result_msg db 'Sum from 1 to 100 is  : $'
    result db 6 dup ('$')           ; 用于存储结果的字符串

.code
main proc
    ; 初始化数据段
    mov ax, @data
    mov ds, ax

    ; 计算从 1 加到 100 的和
    mov cx, 100                     ; 循环计数器
    xor ax, ax                      ; 清零 AX
    mov bx, 1                       ; 从 1 开始

sum_loop:
    add ax, bx                      ; 将 BX 加到 AX 中
    inc bx                          ; BX 自增
    cmp bx, 101                     ; 如果 BX 超过 100 则跳出循环
    jne sum_loop                    ; 如果 BX <= 100 继续循环

    ; 将结果压入栈中
    push ax                         ; 将和压入栈

    ; 输出换行符
    mov dx, offset newline
    mov ah, 09h
    int 21h

    ; 取出栈中结果，并转换为字符串形式
    pop ax                          ; 从栈中弹出和
    call convert_to_ascii            ; 将结果转换为 ASCII

    ; 输出结果信息
    mov dx, offset result_msg
    mov ah, 09h
    int 21h

    ; 输出计算结果
    mov dx, offset result
    mov ah, 09h
    int 21h

    ; 输出换行符
    mov dx, offset newline
    mov ah, 09h
    int 21h

    ; 程序结束
    mov ax, 4C00h
    int 21h

main endp

; 将 AX 中的值转换为 ASCII 字符串
convert_to_ascii proc
    mov si, offset result            ; SI 指向 result
    mov cx, 5                        ; 最多处理 5 位数
    mov di, si                       ; DI 也指向 result 的开头

convert_loop:
    xor dx, dx                       ; 清除 DX
    mov bx, 10                       ; 除以 10
    div bx                           ; AX ÷ 10，商在 AX，余数在 DX
    add dl, '0'                      ; 将余数转换为 ASCII
    dec di                           ; DI 向前移动一位
    mov [di], dl                     ; 存储结果字符
    dec cx                           ; 处理下一个字符
    test ax, ax                      ; AX 是否为 0
    jnz convert_loop                 ; 如果 AX 不为 0，继续循环

    ret
convert_to_ascii endp

end main
