;DEBUG使用-P

STKSEG SEGMENT STACK
    DW 32 DUP(0)
STKSEG ENDS

DATASEG SEGMENT
    MSG DB "Hello World$"     ; 示例消息，当前没有使用
    MSG2 DB 'a'               ; 初始字母'A'，用于开始打印字母表
    NEWLINE DB 0DH, 0AH, '$'  ; 回车符 (CR) 和换行符 (LF)
DATASEG ENDS

CODESEG SEGMENT
    ASSUME CS:CODESEG, DS:DATASEG
MAIN PROC FAR
    MOV AX, DATASEG         ; 设置数据段
    MOV DS, AX              ; 初始化 DS

    MOV CX, 26              ; 设置计数器为26次，即26个字母
    MOV AH, 2               ; DOS中断功能号02H，用于显示字符
    MOV BX, 0               ; BX 作为字符计数器，初始化为 0

PRINT_LOOP:
    MOV AL, [MSG2]          ; 从MSG2中加载当前字母到AL（初始为 'A'）
    MOV DL, AL              ; 将AL中的字符加载到DL用于显示
    INT 21H                 ; 调用中断显示字符

    INC AL                  ; 递增字母 ('A' -> 'B' -> 'C'...)
    MOV [MSG2], AL          ; 将递增后的字符存回MSG2
    INC BX                  ; 增加字符计数器

    CMP BX, 13              ; 检查是否已经打印了 13 个字符
    JNE CONTINUE          ; 如果还没有打印 13 个字符，跳过换行

    ; 打印换行符
    MOV DL, 0DH             ; 回车符 CR 
    INT 21H
    MOV DL, 0AH             ; 换行符 LF 
    INT 21H
    MOV BX, 0               ; 重置计数器

CONTINUE:
    DEC CX                  ; 将循环计数器 CX 减 1
    JNZ PRINT_LOOP          ; 如果 CX 不为 0，跳转回 PRINT_LOOP 继续

    ; 结束程序
    MOV AX, 4C00H
    INT 21H
MAIN ENDP
CODESEG ENDS
    END MAIN
