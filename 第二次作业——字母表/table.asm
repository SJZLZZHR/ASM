STKSEG SEGMENT STACK
    DW 32 DUP(0)
STKSEG ENDS

DATASEG SEGMENT
    MSG DB "Hello World$"   ; 示例消息，当前没有使用
    MSG2 DB 'a'             ; 初始字母 'a'，用于开始打印字母表
    NEWLINE DB 0DH, 0AH     ; 回车符 (CR) 和换行符 (LF)
DATASEG ENDS

CODESEG SEGMENT
    ASSUME CS:CODESEG, DS:DATASEG
MAIN PROC FAR
    MOV AX, DATASEG         ; 设置数据段
    MOV DS, AX              ; 初始化 DS

    MOV CX, 26              ; 设置循环次数为 26 次，即 26 个字母
    MOV AH, 2               ; DOS 中断功能号 02H，用于显示字符
    MOV BX, 0               ; BX 作为计数器，跟踪每行打印的字符数

L:  MOV AL, [MSG2]          ; 从 MSG2 中加载当前字母到 AL（初始为 'a'）
    MOV DL, AL              ; 将 AL 中的字符加载到 DL 用于显示
    INT 21H                 ; 调用中断显示字符

    INC AL                  ; 递增字母 ('a' -> 'b' -> 'c'...)
    MOV [MSG2], AL          ; 将递增后的字符存回 MSG2

    INC BX                  ; 增加字符计数器

    CMP BX, 13              ; 检查是否已经打印了 13 个字符
    JNE CONTINUE            ; 如果不是 13 个字符，跳转到 CONTINUE

    ; 打印换行符
    MOV DL, 0DH             ; 回车符 CR 
    INT 21H
    MOV DL, 0AH             ; 换行符 LF 
    INT 21H
    MOV BX, 0               ; 重置计数器

CONTINUE:
    LOOP L                  ; 循环输出，直到 CX 减到 0

    ; 结束程序
    MOV AX, 4C00H
    INT 21H
MAIN ENDP
CODESEG ENDS
    END MAIN
