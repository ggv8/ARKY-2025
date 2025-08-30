; Documentacion
    ; ╔═════════════════════════════════════╦═══════════════════════════════════╗
    ; ║ Instituto Tecnologico de Costa Rica ║ Gabriel Gomez Vega                ║
    ; ║ Escuela de Computacion              ║ 2021106483                        ║
    ; ║ Arquitectura de Computadoras        ║ DD de MM del 2025                 ║
    ; ╚═════════════════════════════════════╩═══════════════════════════════════╝
    ; ╔═════════════════════════════════════════════════════════════════════════╗
    ; ║                            Manual de Usuario                            ║
    ; ╠═════════════════════════════════════════════════════════════════════════╣
    ; ║                                                                         ║
    ; ╚═════════════════════════════════════════════════════════════════════════╝
    ; ╔═════════════════════════════════════════════════════════════════════════╗
    ; ║                        Analisis de Resultados                           ║
    ; ╠══════════════════════════════════════════════════════════╦══════════════╣
    ; ║                          Aspectos                        ║ Calificacion ║
    ; ╠══════════════════════════════════════════════════════════╬══════════════╣
    ; ║ Documentacion                                            ║      A       ║
    ; ╠══════════════════════════════════════════════════════════╬══════════════╣
    ; ║ Documentacion                                            ║      A       ║
    ; ╠══════════════════════════════════════════════════════════╬══════════════╣
    ; ║ Documentacion                                            ║      A       ║
    ; ╚══════════════════════════════════════════════════════════╩══════════════╝
;

DataSegment segment
; Symbolic Constants

    ; Interruptions
        DOS_PRINT_CHAR  = 02h
        DOS_PRINT_STR   = 09h
        DOS_EXIT        = 4Ch
    ;

    ; ASCII
        CHAR_NULL  = 00h
        CHAR_CR    = 0Dh
        CHAR_LF    = 0Ah
        CHAR_SPACE = 20h
    ;

    ; State Machine
        STATE_DEFAULT = 00h
        STATE_HELP    = 01h
        STATE_ERROR   = 80h
    ;

    ; Misc
        PSP_INPUT_OFFSET = 80h
    ;
;

; String literals
    aboutMe db "ITCR: Escuela de Computacion - Arquitectura de Computadoras. DD/MM/2025", CHAR_CR, CHAR_LF
            db "Tarea --- | Autor: Gabriel Gomez Vega, 2021106483", CHAR_NULL
    helpMe  db "Debe ingresar los siguientes datos:", CHAR_CR, CHAR_LF
            db CHAR_NULL
    errorLabel db "Error: ", CHAR_NULL
    errorMsg1  db "Ha ocurrido un error inesperado", CHAR_NULL
;

; Look-up Tables
    stateTable db STATE_DEFAULT
               dw PrintAboutMe
    stateOffset = ($ - stateTable)
               db STATE_HELP
               dw PrintHelp
    tableSize = ($ - stateTable) / stateOffset
               db STATE_ERROR   ; Fail safe state
               dw PrintAX

    errorTable dw offset errorMsg1
;

    programState db STATE_DEFAULT
    base dw 10
DataSegment endS

StackSegment segment stack 'stack'
   dw 256 dup(?)
StackSegment endS

CodeSegment segment
    Assume CS:CodeSegment, DS:DataSegment, SS:StackSegment

    ; imprime a la salida est�ndar un n�mero que supone estar en el AX
    ; supone que es un n�mero positivo y natural en 16 bits.
    ; lo imprime en la base que indica la variable Base del Data Segment.  
    PrintAX proc near    
        push AX
        push BX
        push CX                           
        push DX

        xor cx, cx
        mov bx, base
    ciclo1PAX: xor dx, dx
        div bx
        push dx
        inc cx
        cmp ax, 0
        jne ciclo1PAX
        mov ah, DOS_PRINT_CHAR
    ciclo2PAX: pop DX
        add dl, 30h
        cmp dl, 39h
        jbe prnPAX
        add dl, 7
    prnPAX: int 21h
        loop ciclo2PAX 

        pop DX
        pop CX
        pop BX
        pop AX
        ret
    PrintAX endP

    ; Prints a newline using CR and LF chars
    ; Inputs: N/A
    ; Outputs: Sends CRLF chars to standard output
    PrintCRLF proc
        Push ax
        Push dx

        Xor al, al
        Mov ah, DOS_PRINT_CHAR
        
        Mov dl, CHAR_CR ; Carriage return
        Int 21h

        Mov dl, CHAR_LF ; Line feed
        Int 21h

        Pop dx
        Pop ax
        Ret
    PrintCRLF endP

    ; Prints a string reference char by char until a null termination is found
    ; Inputs: SI - Address to string literal
    ; Outputs: Sends each char to standard output via DOS' routine
    PrintLikeC proc
        Push ax
        Push dx

        Xor al, al
        Mov ah, DOS_PRINT_CHAR
    ITER_PrintLikeC:
        Mov dl, byte ptr [si] ; Read char
        Cmp dl, CHAR_NULL     ; Halt if EoStr
        Je END_PrintLikeC
        Int 21h
        Inc si              ; Point to next char
        jmp ITER_PrintLikeC

    END_PrintLikeC:

        Pop dx
        Pop ax
        Ret
    PrintLikeC endP

    ; Print details about the program's creation
    ; Inputs: N/A
    ; Outputs: Reads aboutMe str to standard output, followed by a newline
    PrintAboutMe proc
        Push si

        Mov si, offset aboutMe
        Call PrintLikeC
        Call PrintCRLF

        Pop si
        Ret
    PrintAboutMe endP

    ; Print the program's help message
    ; Inputs: N/A
    ; Outputs: Reads aboutMe str to standard output, followed by a newline
    PrintHelp proc
        Push si

        Mov si, offset helpMe
        Call PrintLikeC
        Call PrintCRLF

        Pop si
        Ret
    PrintHelp endP

    ; Reads the command line's input back to the standard output
    ; Inputs: Expects any input in command line
    ; Outputs: Sends input back to standard output
    ReadCL proc
        Push ax
        Push bx
        Push cx
        Push dx

        Mov bx, PSP_INPUT_OFFSET
        Mov cl, byte ptr es:[bx]    ; Obtain input size from offset ptr

        Cmp cl, 0
        Je END_ReadCL   ; Skip if empty

        Xor al, al
        Mov ah, DOS_PRINT_CHAR
        Xor dh, dh    ; Clear in prep for int

        Dec cl ; Ignore extra whitespace count
        Inc bx ; Point to input-preceding whitespace
    ITER_ReadCL:
        Inc bx      ; Point to next byte
        Mov dl, byte ptr es:[bx]
        Int 21h     ; Print current char
        Loop ITER_ReadCL

    END_ReadCL:
        Pop dx
        Pop cx
        Pop bx
        Pop ax
        Ret
    ReadCL endP

    ; Calls the routine associated with the state of the program
    ; Inputs: Expects a valid state in programState variable
    ; Outputs: Executes a routine through its address
    RunStateMachine proc
        Push cx
        Push dx
        Push si

        Xor si, si           ; Base to address stateTable contents
        Mov cx, tableSize
        Mov dl, programState ; Copy to reg for mem to mem comparison

    ITER_RunStateMachine:
        Cmp dl, stateTable[si]
        Je EXEC_State               ; Routine found
        Add si, stateOffset         ; Otherwise, point to next row
        Loop ITER_RunStateMachine
        ; If out of range, SI points to failsafe, and executes it
    EXEC_State:
        Call word ptr stateTable[si+1] ; Offset SI by 1 to address the routine address, not the state code

        Pop si
        Pop dx
        Pop cx
        ret
    RunStateMachine endP
    

    main:
        Mov ax, ds
        Mov es, ax ; Save PSP's address

        Mov ax, StackSegment
        Mov ss, ax ; Set stack's address

        Mov ax, DataSegment
        Mov ds, ax ; Set data's address


        Mov programState, STATE_HELP
        Xor ax, ax
        Mov al, programState
        Call RunStateMachine
    exit:
        Mov al, 00h
        Mov ah, 4Ch
        Int 21h


CodeSegment endS

end main