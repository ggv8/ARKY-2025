; Documentacion
    ; ╔═════════════════════════════════════╦═══════════════════════════════════╗
    ; ║ Instituto Tecnologico de Costa Rica ║ Gabriel Gomez Vega                ║
    ; ║ Escuela de Computacion              ║ 2021106483                        ║
    ; ║ Arquitectura de Computadoras        ║ 01 de Setiembre del 2025          ║
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
    ; ║ Despliegue del Acerca De                                 ║      A       ║
    ; ╠══════════════════════════════════════════════════════════╬══════════════╣
    ; ║ Despliegue de la Ayuda                                   ║      A       ║
    ; ╠══════════════════════════════════════════════════════════╬══════════════╣
    ; ║ Lectura de la entrada                                    ║      -       ║
    ; ╠══════════════════════════════════════════════════════════╬══════════════╣
    ; ║ Restricciones de la entrada                              ║      -       ║
    ; ╠══════════════════════════════════════════════════════════╬══════════════╣
    ; ║ Implementacion de las operaciones aritmeticas            ║      -       ║
    ; ╠══════════════════════════════════════════════════════════╬══════════════╣
    ; ║ Simplificacion y despliegue del resultado                ║      -       ║
    ; ╠══════════════════════════════════════════════════════════╬══════════════╣
    ; ║ Despliegue del resultado alfabeticamente                 ║      -       ║
    ; ╠══════════════════════════════════════════════════════════╬══════════════╣
    ; ║ Despliegue de mensajes de error                          ║      -       ║
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
        STATE_DEFAULT  = 00h
        STATE_HELP     = 01h
        STATE_MUL      = 78h ; = 'x'
        STATE_DIV      = 25h ; = '%'
        STATE_ADD      = 2Bh ; = '+'
        STATE_SUB      = 2Dh ; = '-'
        ; 8000h to FFFFh are reserved for errors
        STATE_ERROR     = 8000h ; Used as reference for comparisons
        ERROR_NUM_OF    = 8001h
        ERROR_DEN_OF    = 8002h
        ERROR_ZERODIV   = 8003h
        ERROR_CALC_OF   = 8004h
        ERROR_CALC_ZD   = 8005h
        ERROR_OPCODE    = 8006h
    ;

    ; Misc
        PSP_INPUT_OFFSET = 80h
    ;
;

; String literals
    aboutMe db "ITCR: Escuela de Computacion - Arquitectura de Computadoras. 01/09/2025", CHAR_CR, CHAR_LF
            db "Tarea El Fracturador | Autor: Gabriel Gomez Vega, 2021106483", CHAR_NULL

    helpMe  db "Debe ingresar los siguientes datos: {fraccion1} {operador} {fraccion2}", CHAR_CR, CHAR_LF, CHAR_LF
            db CHAR_HTAB, "Cada fraccion se expresa como '{numerador}/{denominador}'", CHAR_CR, CHAR_LF
            db CHAR_HTAB, "Sus rangos son de 0 a 255 y 1 a 255 respectivamente.", CHAR_CR, CHAR_LF
            db CHAR_HTAB, "Los operadores permitidos son +, -, x, %", CHAR_NULL

    errorLabel    db "Error: ", CHAR_NULL

    errorNoState  db "El programa ha generado un error inesperado.", CHAR_NULL
    errorNumOF    db "El numerador esta fuera del rango permitido (0 a 255).", CHAR_NULL
    errorDenOF    db "El denominador esta fuera del rango permitido (1 a 255)", CHAR_NULL
    errorZeroDiv  db "El denominador de una fraccion no puede ser 0.", CHAR_NULL
    errorCalcOF   db "El calculo de esta operacion excede el rango permitido.", CHAR_NULL
    errorCalcZD   db "La operacion no es permitida ya que provoca una division por 0", CHAR_NULL
    errorOpCode   db "No se permite el operador ingresado.", CHAR_NULL
;

; Look-up Tables
    stateTable dw STATE_DEFAULT, PrintAboutMe
    stateOffset = ($ - stateTable)
               dw STATE_HELP, PrintHelp
               dw STATE_MUL, PrintAX
               dw STATE_DIV, PrintAX
               dw STATE_ADD, PrintAX
               dw STATE_SUB, PrintAX
    tableSize = ($ - stateTable) / stateOffset
               dw ERROR_OPCODE, PrintError ; Fail safe state

    errorVector dw offset errorNoState, offset errorNumOF, offset errorDenOF, offset errorZeroDiv
                dw offset errorCalcOF, offset errorCalcZD, offset errorOpCode
;

    programState dw STATE_DEFAULT
    base dw 10

    fraction1 dw 0001h ; Defaults to 0/1
    fraction2 dw 0001h
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
    ; Outputs: Reads helpMe str to standard output, followed by a newline
    PrintHelp proc
        Push si

        Mov si, offset helpMe
        Call PrintLikeC
        Call PrintCRLF

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
    ; Inputs: Expects two fractional numbers and an operator, inorder
    ; Outputs: BX - Index to routine address in lookup table.
    ;          Stores fraction params in variables
    ;          programState - Updates to match operation requested, flags errors if necessary
    ReadInput proc
        Push ax
        Push si
        Push di

        Xor ax, ax
        Mov si, PSP_INPUT_OFFSET
        Cmp byte ptr es:[si], 0    ; Is there an input?
        Je FLAG_NoInput            ; If not, set new state, and halt proc

        ; If there is, retrieve values only
        Inc si ; Point to input-preceding whitespace
        Inc si ; Point to first char in param
        
        Mov di, offset fraction1 ; Set variable address for param storage
        Call ReadFraction        ; Read first fraction input
        Cmp programState, STATE_ERROR
        Jae END_ReadInput        ; Halt if input had an error (states >= 8000h are reserved for errors)
        
        Inc si                   ; Point to operator parameter
        Mov al, byte ptr es:[si] ; Retrieve its value
        Mov programState, ax     ; Set opcode as state
        Call FindStateRoutine    ; Attempt to find stateTable row, index placed in BX

        Cmp word ptr stateTable[bx], ERROR_OPCODE
        Je END_ReadInput         ; Opcode is invalid, halt

        Inc si
        Inc si ; Skip whitespace, point to first char in second fraction

        Mov di, offset fraction2
        Call ReadFraction
        ; No error checking. Above was necessary to avoid opcode potentially overriding an error state flagged by ReadFraction
        Jmp END_ReadInput  ; Skip error flagging line
    FLAG_NoInput:
        Mov programState, STATE_HELP
    END_ReadInput:
        Pop di
        Pop si
        Pop ax
        Ret
    ReadInput endP

    ; Obtains integer value of a number input, within word-capacity. Halts when non-digit chars are read
    ; Inputs: SI - Assumes ptr to first digit char
    ; Outputs: Returns the positional sum of values in AX, and SI with last address read
    ReadNumberAX proc
        Push bx
        Push dx

        Xor dx, dx
        Xor ax, ax ; Sum of positional values
        Mov bl, 10 ; For decimal shifts
    
    ITER_ReadNumber:
        Mov dl, byte ptr es:[si] ; Retrieve char
        Xor dl, 30h
        Cmp dl, 09h         ; Check if value is within digit range after discarding hi-nibble
        Ja END_ReadNumber   ; Halt if number was fully read

        Mul bl      ; Shift current dec value
        Add ax, dx  ; Add current int

        Inc si      ; Otherwise, continue to next char
        Jmp ITER_ReadNumber

    END_ReadNumber:
        Pop dx
        Pop bx
        Ret
    ReadNumberAX endP

    ; Reads from CL input and stores a fraction parameter read
    ; Inputs: SI - Expects ptr to cli parameter, DI - Expects address of fraction variable to store
    ; Outputs: May flag a programState with an error. Saves a fraction's value in a word variable
    ReadFraction proc
        Push ax
        Push dx

        Call ReadNumberAX ; Read numerator input
        Cmp ah, 0       ; Check if value exceeds byte capacity
        Jne FLAG_NumOF  ; Flag as error if out of range

        Mov byte ptr [di + byte], al ; Otherwise, store numerator as fraction's upper value
        Inc si ; Point to char next-to '/'

        Call ReadNumberAX ; Read denominator input
        Cmp ah, 0
        Jne FLAG_DenOF  ; Restrict overflow
        Cmp al, 0
        Je FLAG_ZeroDiv ; Restrict zero division in input

        Mov byte ptr [di], al ; If valid, store denominator as fraction's lower value
        Jmp END_ReadFraction  ; Fraction was fully read, halt. SI should be pointing prev to operator or after CL input

    FLAG_NumOF:
        Mov programState, ERROR_NUM_OF
        Jmp END_ReadFraction
    FLAG_DenOF:
        Mov programState, ERROR_DEN_OF
        Jmp END_ReadFraction
    FLAG_ZeroDiv:
        Mov programState, ERROR_ZERODIV

    END_ReadFraction:
        Pop dx
        Pop ax
        Ret
    ReadFraction endP

    ; Finds row with state code and routine address corresponding to current program state
    ; Inputs: programState - Expects a valid state code in variable
    ; Outputs: BX with row address in stateTable. If invalid, BX points to failsafe row
    FindStateRoutine proc
        Push cx
        Push dx

        Xor bx, bx           ; Base to address stateTable contents
        Mov cx, tableSize
        Mov dx, programState ; Copy to reg for mem to mem comparison

    ITER_FindStateRoutine:
        Cmp dx, word ptr stateTable[bx]
        Je END_FindStateRoutine     ; Routine address found, halt
        Add bx, stateOffset         ; Otherwise, point to next row
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
        Mov cx, tableSize
        Mov dx, programState ; Copy to reg for mem to mem comparison

    ITER_RunState:
        Cmp dx, stateTable[si]
        Je EXEC_State               ; Routine found
        Add si, stateOffset         ; Otherwise, point to next row
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


        ;Mov programState, ERROR_OPCODE
        ;Xor ax, ax
        ;Mov al, programState
        ;Call RunState
        Call ReadInput

        Mov base, 10h
        Mov ax, fraction1
        Call PrintAX
        Call PrintCRLF

        Mov ax, programState
        Call PrintAX
        Call PrintCRLF

        Mov ax, fraction2
        Call PrintAX
        Call PrintCRLF

        Call RunState
    exit:
        Mov al, 00h
        Mov ah, 4Ch
        Int 21h


CodeSegment endS

end main