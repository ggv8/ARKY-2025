; Documentacion
    ; ╔═════════════════════════════════════╦═══════════════════════════════════╗
    ; ║ Instituto Tecnologico de Costa Rica ║ Gabriel Gomez Vega                ║
    ; ║ Escuela de Computacion              ║ 2021106483                        ║
    ; ║ Arquitectura de Computadoras        ║ 16 de Setiembre del 2025          ║
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
        CHAR_HTAB  = 09h
    ;

    ; State Machine
        STATE_HALT    = 0000h
        STATE_DEFAULT = 0001h
        STATE_HELP    = 0002h
        STATE_ADDITION   = 'S'
        STATE_COMPLEMENT = 'C'
        STATE_SUBTRACT   = 'R'
        STATE_DUPLICATE  = 'D'
        STATE_HALF       = 'P'
        STATE_ABOVE      = 'A'
        STATE_BELOW      = 'B'
        STATE_EQUAL      = 'E'
        STATE_PARITY     = 'O'
        STATE_MULTIPLY   = 'M'
        STATE_DIVISION   = 'K'
        STATE_POWER      = 'X'
        STATE_FIBONACCI  = 'I'
        STATE_FACTORIAL  = 'F'
        ; 8000h to FFFFh are reserved for errors
        STATE_ERROR   = 8000h ; Used as reference for comparisons
        ERROR_INV_CMD = 8001h
        ERROR_INV_IN  = 8002h
    ;

    ; Misc
        PSP_INPUT_OFFSET = 80h
        STATIC_LIMIT     = 20000 ; Individual gargantuan size limit due to single data-segment use
    ;
;

; String literals
    aboutMe db "ITCR: Escuela de Computacion - Arquitectura de Computadoras. 16/Set/2025", CHAR_CR, CHAR_LF
            db "Tarea Numero Gargantua | Autor: Gabriel Gomez Vega, 2021106483", CHAR_NULL
    helpMe  db "Ingrese junto al programa uno comando validos para numeros gargantua:", CHAR_CR, CHAR_LF
            db CHAR_HTAB, STATE_ADDITION,": Sumar dos valores gargantua", CHAR_CR, CHAR_LF
            db CHAR_HTAB, STATE_COMPLEMENT,": Complementar un valor", CHAR_CR, CHAR_LF
            db CHAR_HTAB, STATE_SUBTRACT,": Restar un valor gargantua a otro", CHAR_CR, CHAR_LF
            db CHAR_HTAB, STATE_DUPLICATE,": Duplicar el valor", CHAR_CR, CHAR_LF
            db CHAR_HTAB, STATE_HALF,": Obtener mitad entera del numero ", CHAR_CR, CHAR_LF
            db CHAR_HTAB, STATE_ABOVE,": Compara si un valor es mayor a otro", CHAR_CR, CHAR_LF
            db CHAR_HTAB, STATE_BELOW,": Compara si un valor es menor a otro", CHAR_CR, CHAR_LF
            db CHAR_HTAB, STATE_EQUAL,": Compara si un valor es igual a otro", CHAR_CR, CHAR_LF
            db CHAR_HTAB, STATE_PARITY,": Determinar si un valor es impar", CHAR_CR, CHAR_LF
            db CHAR_HTAB, STATE_MULTIPLY,": Multiplicar dos valores", CHAR_CR, CHAR_LF
            db CHAR_HTAB, STATE_DIVISION,": Dividir dos valores", CHAR_CR, CHAR_LF
            db CHAR_HTAB, STATE_POWER,": Calcular potencia de un numero", CHAR_CR, CHAR_LF
            db CHAR_HTAB, STATE_FIBONACCI,": Calcular un valor de fibonacci", CHAR_CR, CHAR_LF
            db CHAR_HTAB, STATE_FACTORIAL,": Calcular factorial de un numero", CHAR_NULL

    errorLabel db "Error: ", CHAR_NULL
    errorNoState  db "El programa ha generado un error inesperado.", CHAR_NULL
    errorInvCmd   db "Se ha ingresado un comando invalido.", CHAR_NULL
    errorInvIn    db "La entrada solo acepta digitos en base decimal", CHAR_NULL
;

; Look-up Tables
    stateTable  dw STATE_DEFAULT,   StartProgram
    STATE_OFFSET = ($ - stateTable)
                dw STATE_HELP,      PrintHelp
                dw STATE_ADDITION,  ExampleRoutine
                dw STATE_COMPLEMENT,ExampleRoutine
                dw STATE_SUBTRACT,  ExampleRoutine
                dw STATE_DUPLICATE, ExampleRoutine
                dw STATE_HALF,      ExampleRoutine
                dw STATE_ABOVE,     ExampleRoutine
                dw STATE_BELOW,     ExampleRoutine
                dw STATE_EQUAL,     ExampleRoutine
                dw STATE_PARITY,    ExampleRoutine
                dw STATE_MULTIPLY,  ExampleRoutine
                dw STATE_DIVISION,  ExampleRoutine
                dw STATE_POWER,     ExampleRoutine
                dw STATE_FIBONACCI, ExampleRoutine
                dw STATE_FACTORIAL, ExampleRoutine
    TABLE_SIZE = ($ - stateTable) / STATE_OFFSET
                dw ERROR_INV_CMD,   PrintError ; Fail safe state

    errorVector dw offset errorNoState, offset errorInvCmd, offset errorInvIn
;

    base dw 10
    programState dw STATE_DEFAULT

    gargantuaA dw 00
               db STATIC_LIMIT dup(0)

    gargantuaB dw 00
               db STATIC_LIMIT dup(0)

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
        Call PrintCRLF

        Pop si
        Ret
    PrintAboutMe endP

    ; Print the program's help message
    ; Inputs: N/A
    ; Outputs: Reads helpMe str to standard output, followed by a newline
    PrintHelp proc
        Push si

        Mov si, offset helpMe
        Call PrintLikeC
        Call PrintCRLF

        Mov programState, STATE_HALT ; Set program to halt afterward
        Pop si
        Ret
    PrintHelp endP

    ; Prints an error message based on the program's current state
    ; Inputs: Expects an error state in programState variable
    ; Outputs> Reads the error message to standard output, followed by a newline
    PrintError proc
        Push bx
        Push si

        Mov si, offset errorLabel
        Call PrintLikeC

        Mov bx, programState ; Copy to use as index
        Sub bx, STATE_ERROR  ; Adjust offset for an error state
        Shl bx, 1   ; x2 to adjust for word-sized elements

        Mov si, errorVector[bx] ; Find errorStr address
        Call PrintLikeC
        Call PrintCRLF

        Mov programState, STATE_HALT ; Set program to halt afterward
        Pop si
        Pop bx
        Ret
    PrintError endP

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

    ; Reads the command line's input and stores parameters if present
    ; Inputs: Expects ...
    ; Outputs: Stores values in data variables, and flags errors if necessary
    ReadInput proc
        Push ax
        Push bx

        Mov bx, PSP_INPUT_OFFSET
        Cmp byte ptr es:[bx], 0    ; Is there an input?
        Je FLAG_NoInput            ; If not, set new state, and halt proc

        ; If there is, retrieve values only
        Inc bx ; Point to input-preceding whitespace
        Inc bx ; Point to first char
        
        ; Insert detailed logic here

        Jmp END_ReadInput  ; Skip error flagging line
    FLAG_NoInput:
        Mov programState, STATE_HELP
    END_ReadInput:
        Pop bx
        Pop ax
        Ret
    ReadInput endP

    ; Prints AboutMe and validates user inputs
    ; Inputs: Expects a valid command line input
    ; Output: Sends AboutMe to standard output
    StartProgram proc
        Call PrintAboutMe
        Call ReadInput
        Mov programState, STATE_HALT ; Temporary placement to avoid endless loop if no input
        Ret
    StartProgram endP

    ; Routine for example state
    ; Inputs: ...
    ; Outputs: Sets programState to halt if no error occured
    ExampleRoutine proc
        Call PrintAX
        Call PrintCRLF
        Mov programState, STATE_HALT
        Ret
    ExampleRoutine endP

    ; Finds row with state code and routine address corresponding to current program state
    ; Inputs: programState - Expects a valid state code in variable
    ; Outputs: BX with row address in stateTable. If invalid, BX points to failsafe row
    FindStateRoutine proc
        Push cx
        Push dx

        Xor bx, bx           ; Base to address stateTable contents
        Mov cx, TABLE_SIZE
        Mov dx, programState ; Copy to reg for mem to mem comparison

    ITER_FindStateRoutine:
        Cmp dx, word ptr stateTable[bx]
        Je END_FindStateRoutine     ; Routine address found, halt
        Add bx, STATE_OFFSET         ; Otherwise, point to next row
        Loop ITER_FindStateRoutine
        ; If out of range, BX points to failsafe state address
        Mov dx, word ptr stateTable[bx]
        Mov programState, dx ; Update invalid program state with error state

    END_FindStateRoutine:
        Inc bx
        Inc bx ; Adjust offset to point directly at state routine within table row
        Pop dx
        Pop cx
        Ret
    FindStateRoutine endP

    ; Calls the routine associated with the state of the program
    ; Inputs: Expects a valid state in programState variable
    ; Outputs: Executes a routine through its address
    RunState proc
        Push cx
        Push dx
        Push si

        Xor si, si           ; Base to address stateTable contents
        Mov cx, TABLE_SIZE
        Mov dx, programState ; Copy to reg for mem to mem comparison

    ITER_RunState:
        Cmp dx, stateTable[si]
        Je EXEC_State               ; Routine found
        Add si, STATE_OFFSET         ; Otherwise, point to next row
        Loop ITER_RunState
        ; If out of range, SI points to failsafe, and executes it
    EXEC_State:
        Call word ptr stateTable[si+word] ; Offset SI by 2 to address the routine address, not the state code

        Pop si
        Pop dx
        Pop cx
        Ret
    RunState endP
    

    main:
        Mov ax, ds
        Mov es, ax ; Save PSP's address

        Mov ax, StackSegment
        Mov ss, ax ; Set stack's address

        Mov ax, DataSegment
        Mov ds, ax ; Set data's address

        
    ITER_main:
        Cmp programState, STATE_HALT
        Je exit
        Call RunState
        Jmp ITER_main

    exit:
        Mov al, 00h
        Mov ah, 4Ch
        Int 21h


CodeSegment endS

end main