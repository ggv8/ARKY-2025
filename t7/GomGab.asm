; Documentacion
    ; ╔═════════════════════════════════════╦═══════════════════════════════════╗
    ; ║ Instituto Tecnologico de Costa Rica ║ Gabriel Gomez Vega                ║
    ; ║ Escuela de Computacion              ║ 2021106483                        ║
    ; ║ Arquitectura de Computadoras        ║ 31 de Octubre del 2025            ║
    ; ╚═════════════════════════════════════╩═══════════════════════════════════╝
    ; ╔═════════════════════════════════════════════════════════════════════════╗
    ; ║                            Manual de Usuario                            ║
    ; ╠═════════════════════════════════════════════════════════════════════════╣
    ; ║ Este programa es una implementación sencilla de un algoritmo recursivo  ║
    ; ║ que resuelve el problema de las Torres de Hanoi. Despliega a la salida  ║
    ; ║ estandar los movimientos individuales que toma el algoritmo para poner  ║
    ; ║ los discos de la torre A en la torre C, utilizando la torre B como un   ║
    ; ║ buffer intermedio.                                                      ║
    ; ║                                                                         ║
    ; ║ Para invocar el algoritmo, se debe ingresar un dato numérico entre 1 y  ║
    ; ║ 99 que representa la cantidad de discos con los que inicia la torre A.  ║
    ; ║ El programa valida que la entrada este en el rango permitido y que los  ║
    ; ║ digitos sean en formato decimal. Debido a la implementacion de la con-  ║
    ; ║ versión de texto a entero que realiza la rutina de validación, es posi- ║
    ; ║ ingresar ceros a la izquierda del número siempre y cuando el número sea ║
    ; ║ valor valido :)                                                         ║
    ; ║                                                                         ║
    ; ║ Si el programa no recibe ninguna entrada por linea de comandos, se in-  ║
    ; ║ forma al usuario una pequeña ayuda de los datos que debe ingresar y sus ║
    ; ║ restricciones.                                                          ║
    ; ║                                                                         ║
    ; ║ En cualquier instancia que se invoca al programa, se mostrará primero   ║
    ; ║ un corto encabezado acerca del programa. Este identifica el autor, fe-  ║
    ; ║ cha de creación y propósito. Conforme el programa calcula la secuencia  ║
    ; ║ de movimientos, este despliega una representación de texto que indica   ║
    ; ║ la torre de origen y la torre que recibe su disco. Cada movimiento vie- ║
    ; ║ ne separado por un salto de línea. Cuando el programa finaliza, este de-║
    ; ║ ja de imprimir a la salida estándar y retorna al sistema operativo.     ║
    ; ╚═════════════════════════════════════════════════════════════════════════╝
    ;
    ; ╔═════════════════════════════════════════════════════════════════════════╗
    ; ║                        Analisis de Resultados                           ║
    ; ╠══════════════════════════════════════════════════════════╦══════════════╣
    ; ║                          Aspectos                        ║ Calificacion ║
    ; ╠══════════════════════════════════════════════════════════╬══════════════╣
    ; ║ Documentacion                                            ║      A       ║
    ; ╠══════════════════════════════════════════════════════════╬══════════════╣
    ; ║ Despliegue de la ayuda                                   ║      A       ║
    ; ╠══════════════════════════════════════════════════════════╬══════════════╣
    ; ║ Despliegue del acerca de                                 ║      A       ║
    ; ╠══════════════════════════════════════════════════════════╬══════════════╣
    ; ║ Lectura del numero de discos por linea de comandos       ║      A       ║
    ; ╠══════════════════════════════════════════════════════════╬══════════════╣
    ; ║ Rutina recursiva que obtiene los movimientos de Hanoi    ║      A       ║
    ; ╠══════════════════════════════════════════════════════════╬══════════════╣
    ; ║ Despliegue de los movimientos a la salida estandar       ║      A       ║
    ; ╠══════════════════════════════════════════════════════════╬══════════════╣
    ; ║ Validacion de la entrada                                 ║      A       ║
    ; ╚══════════════════════════════════════════════════════════╩══════════════╝
;

; Macros

    ; Creates a BP backup before setting it as a pointer to the SP
    ; Optionally, it allocates space below the stack for local variables
    ; Inputs: pAllocSize - Byte count that is subtracted to SP for local variables
    SET_STACKFRAME Macro pAllocSize
        Push bp
        Mov bp, sp
        IFNB <pAllocSize>
            Sub sp, pAllocSize
        EndIF
    endM

    ; Releases stack space for local variables before restoring BP
    ; Optionally releases stack space for arguments
    ; Inputs: pArgSize - Byte count to release in Ret N instruction
    END_STACKFRAME Macro pArgSize
        Mov sp, bp
        Pop bp
        Ret pArgSize
    endM

    ; Pushes a list of registers to the CPU stack in order
    ; Inputs: R1~R12 : List of comma-separated registers
    PUSHLIST Macro R1:REQ,R2,R3,R4,R5,R6,R7,R8,R9,R10,R11,R12
        IRP item, <R1,R2,R3,R4,R5,R6,R7,R8,R9,R10,R11,R12>
            IFB <item>
                exitM ; Halt early if list is shorter than 12 regs
            endIF
            Push item
        endM
    endM

    ; Pops a list of registers from the CPU stack in reverse order
    ; Inputs: R1~R12 : List of comma-separated registers
    POPLIST Macro R1:REQ,R2,R3,R4,R5,R6,R7,R8,R9,R10,R11,R12
        IFNB <R2> ; General case: Recursive for lists larger than 1
            POPLIST R2,R3,R4,R5,R6,R7,R8,R9,R10,R11,R12
        EndIF
        Pop R1
    endM

    ; Increases a register with a word-sized step
    ; Inputs: R - Register to increase
    INCW Macro R:REQ
        Inc R
        Inc R
    endM
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
        STATE_HALT  = 0000h
        STATE_BEGIN = 0001h
        STATE_HELP  = 0002h
        STATE_RUN   = 0003h
        ; 8000h to FFFFh are reserved for errors, 8000h is a failsafe state
        STATE_ERROR   = 8000h ; Used as reference for comparisons
        ERROR_NON_INTEGER    = 8001h 
        ERROR_INPUT_RANGE    = 8002h
    ;

    ; Misc
        PSP_INPUT_OFFSET = 80h
        LOWER_BOUND = 1
        UPPER_BOUND = 99
    ;
;

; String literals
    aboutMe db "ITCR: Escuela de Computacion - Arquitectura de Computadoras. 29/Oct/2025", CHAR_CR, CHAR_LF
            db "Tarea Hanoi | Autor: Gabriel Gomez Vega, 2021106483", CHAR_NULL
    helpMe  db "Debe ingresar los siguientes datos:", CHAR_CR, CHAR_LF, CHAR_CR, CHAR_LF
            db CHAR_HTAB, "<Discos> Numero entre 1 y 99, inclusive", CHAR_NULL

    errorLabel db "Error: ", CHAR_NULL
    errorNoState  db "El programa ha generado un error inesperado.", CHAR_NULL
    errorNonInteger   db "Debe ingresar digitos decimales para indicar los discos del problema", CHAR_NULL
    errorInputRange   db "El numero de discos debe ser entre 1 a 99, inclusive", CHAR_NULL

    resultString db "Pase de la torre "
    sourceTower  db (?)
                 db " a la "
    targetTower  db (?)
                 db CHAR_NULL
;

; Look-up Tables
    stateTable  dw STATE_BEGIN,     StartWrapper
    STATE_OFFSET = ($ - stateTable)
                dw STATE_HELP,      PrintHelp
                dw STATE_RUN,       HanoiWrapper
    TABLE_SIZE = ($ - stateTable) / STATE_OFFSET
                dw STATE_ERROR,     PrintError ; Fail safe state

    errorVector dw offset errorNoState, offset errorNonInteger, offset errorInputRange
;

    programState dw STATE_BEGIN
    discs db 01
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

    ; Reads the command line's input and stores parameters if present
    ; Inputs: Expects an integer input in the command tail
    ; Outputs: Stores values in data variables, and flags errors if necessary
    ReadInput proc
        PUSHLIST ax, bx, cx, dx

        Mov bx, PSP_INPUT_OFFSET

        Xor ch, ch
        Mov cl, byte ptr es:[bx] ; Check command tail size
        Jcxz FLAG_NoInput        ; Set new state and halt if there is no input

        Dec cl     ; Ignore whitespace from count
        Inc bx     ; Point to input-preceding whitespace
        Xor ax, ax ; To save input's integer value
        Mov dh, 10 ; To shift decimal values
    ITER_ReadInput:
        Inc bx ; Point to next char

        Mov dl, byte ptr es:[bx]
        Xor dl, 30h ; Bit mask to obtain int value if char is a digit
        Cmp dl, 10
        Jae FLAG_NonInteger ; Flag data type error if char was not a digit

        Mul dh     ; Shift prev decimal to the left
        Add al, dl ; Insert digit in new position

        Cmp al, UPPER_BOUND
        Ja FLAG_InputRange  ; If input exceeds range, flag value error
        Loop ITER_ReadInput ; Continue until input is consumed

        Cmp al, LOWER_BOUND ; If input is below range, flag value error
        Jb FLAG_InputRange

        Mov discs, al
        Mov programState, STATE_RUN ; Otherwise, prepare to run routine
        Jmp END_ReadInput           ; Skip error flagging line

    FLAG_NonInteger:
        Mov programState, ERROR_NON_INTEGER
        Jmp END_ReadInput
    FLAG_InputRange:
        Mov programState, ERROR_INPUT_RANGE
        Jmp END_ReadInput
    FLAG_NoInput:
        Mov programState, STATE_HELP
    END_ReadInput:
        POPLIST ax, bx, cx, dx
        Ret
    ReadInput endP

    ; Prints AboutMe and validates user inputs
    ; Inputs: Expects a valid command line input
    ; Output: Sends AboutMe to standard output
    StartWrapper proc
        Call PrintAboutMe
        Call ReadInput
        Ret
    StartWrapper endP

    ; Moves N discs from a tower source to another tower, with the help of an auxiliar buffer tower
    ; Inputs: pDiscs  (Int)                  - Number of discs to move from a tower to another
    ;         pSource, pTemp, pTarget (Char) - Letter that identifies the each tower
    ; Outputs: Sends a string representation of the moves to standard output
    Hanoi proc near
        pDiscs   EQU word ptr [bp + 10]
        pSource  EQU word ptr [bp + 8]
        pTemp    EQU word ptr [bp + 6]
        pTarget  EQU word ptr [bp + 4]
        argsSize EQU 4*word
        SET_STACKFRAME
        PUSHLIST ax, bx, cx, dx

        Mov dx, pDiscs
        Mov ax, pSource
        Mov bx, pTemp
        Mov cx, pTarget

        Cmp dx, 1
        Jbe BASE_Hanoi ; Base case : Single disc movement
        
        ; General/Recursive case
        Dec dx
        Push dx
        Push ax
        Push cx
        Push bx
        Call Hanoi ; Move first n-1 discs to temp tower, Hanoi(pDiscs-1, A, C, B)

        Push 0001h
        Push ax
        Push bx
        Push cx
        Call Hanoi ; Move bottom disc to target, Hanoi(1, A, B, C)

        Push dx
        Push bx
        Push ax
        Push cx
        Call Hanoi ; Move remaining n-1 discs to target, Hanoi(pDiscs-1, B, A, C)

        Jmp END_Hanoi

    BASE_Hanoi:
        Mov sourceTower, al ; Set Tower identifiers to print
        Mov targetTower, cl
        Push si
        Mov si, offset resultString
        Call PrintLikeC     ; Display the movement's string representation
        Call PrintCRLF
        Pop si

    END_Hanoi:
        POPLIST ax, bx, cx, dx
        END_STACKFRAME argsSize
    Hanoi endP

    ; Invokes the algorithm that solves the Hanoi problem with the parameter input
    ; Inputs: discs - Number of discs that the first tower starts with
    ; Outputs: Prints all movements of the algorithm
    HanoiWrapper proc
        PUSHLIST ax

        Xor ah, ah
        Mov al, discs
        Push ax
        Push 'A'
        Push 'B'
        Push 'C'
        Call Hanoi

        Mov programState, STATE_HALT
        POPLIST ax
        Ret
    HanoiWrapper endP

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

; Algorithm example runs

; Hanoi (Discos = 2, Source = A, Temp = B, Destination = C)
;   S   T   D   ;
;               ;
;   1           ;
;   2           ;
;   A   B   C   ;

        ; S(1) > T
        ;   S   T   D   ;
        ;               ;
        ;               ;
        ;   2   1       ;
        ;   A   B   C   ;

        ; S(2) > D
        ;   S   T   D   ;
        ;               ;
        ;               ;
        ;       1   2   ;
        ;   A   B   C   ;

        ; T(1) > D
        ;   S   T   D   ;
        ;               ;
        ;           1   ;
        ;           2   ;
        ;   A   B   C   ;

;

; Hanoi (Discos = 3, Source = A, Temp = B, Destination = C)
;   S   T   D   ;
;               ;
;   1           ;
;   2           ;
;   3           ;
;   A   B   C   ;

        ; Hanoi (Discos = discos-1, Source = A, Temp = C, Destination = B)
        ; 2 discos > B

                ; S(1) > T
                ;   S   D   T   ;
                ;               ;
                ;               ;
                ;   2           ;
                ;   3       1   ;
                ;   A   B   C   ;

                ; S(2) > D
                ;   S   D   T   ;
                ;               ;
                ;               ;
                ;               ;
                ;   3   2   1   ;
                ;   A   B   C   ;

                ; T(1) > D
                ;   S   D   T   ;
                ;               ;
                ;               ;
                ;       1       ;
                ;   3   2       ;
                ;   A   B   C   ;
        
        ;

        ; Hanoi (Discos = 1, Source = A, Temp = B, Destination = C)
        ; 1 disco > C

                ; S(3) > D
                ;   S   T   D   ;
                ;               ;
                ;               ;
                ;       1       ;
                ;       2   3   ;
                ;   A   B   C   ;
        
        ;

        ; Hanoi (Discos = discos-1, Source = B, Temp = A, Destination = C)
        ; 2 discos > D
                ; S(1) > T
                ;   T   S   D   ;
                ;               ;
                ;               ;
                ;               ;
                ;   1   2   3   ;
                ;   A   B   C   ;

                ; S(2) > D
                ;   T   S   D   ;
                ;               ;
                ;               ;
                ;           2   ;
                ;   1       3   ;
                ;   A   B   C   ;

                ; T(1) > D
                ;   T   S   D   ;
                ;               ;
                ;           1   ;
                ;           2   ;
                ;           3   ;
                ;   A   B   C   ;
        
        ;

;

; Hanoi (Discos = 4, Source = A, Temp = B, Destination = C)
;   S   T   D   ;
;               ;
;   1           ;
;   2           ;
;   3           ;
;   4           ;
;   A   B   C   ;

        ; Hanoi (Discos = 3, Source = A, Temp = C, Destination = B)

                ; Hanoi (Discos = 2, Source = A, Temp = B, Destination = C )

                        ; S(1) > T
                        ;   S   T   D   ;
                        ;               ;
                        ;               ;
                        ;   2           ;
                        ;   3           ;
                        ;   4   1       ;
                        ;   A   B   C   ;

                        ; S(2) > D
                        ;   S   T   D   ;
                        ;               ;
                        ;               ;
                        ;               ;
                        ;   3           ;
                        ;   4   1   2   ;
                        ;   A   B   C   ;

                        ; T(1) > D
                        ;   S   T   D   ;
                        ;               ;
                        ;               ;
                        ;               ;
                        ;   3       1   ;
                        ;   4       2   ;
                        ;   A   B   C   ;
                ;

                ; Hanoi (Discos = 1, Source = A, Temp = C, Destination = B)

                        ; S(3) > D
                        ;   S   D   T   ;
                        ;               ;
                        ;               ;
                        ;               ;
                        ;           1   ;
                        ;   4   3   2   ;
                        ;   A   B   C   ;
                ;

                ; Hanoi (Discos = 2, Source = C, Temp = A, Destination = B)

                        ; S(1) > T
                        ;   T   D   S   ;
                        ;               ;
                        ;               ;
                        ;               ;
                        ;   1           ;
                        ;   4   3   2   ;
                        ;   A   B   C   ;

                        ; S(2) > D
                        ;   T   D   S   ;
                        ;               ;
                        ;               ;
                        ;               ;
                        ;   1   2       ;
                        ;   4   3       ;
                        ;   A   B   C   ;

                        ; T(1) > D
                        ;   T   D   S   ;
                        ;               ;
                        ;               ;
                        ;       1       ;
                        ;       2       ;
                        ;   4   3       ;
                        ;   A   B   C   ;
                ;
        ;

        ; Hanoi (Discos = 1, Source = A, Temp = B, Destination = C)

                ; S(4) > D
                ;   S   T   D   ;
                ;               ;
                ;               ;
                ;       1       ;
                ;       2       ;
                ;       3   4   ;
                ;   A   B   C   ;
        ;

        ; Hanoi (Discos = 3, Source = B, Temp = A, Destination = C)

                ; Hanoi (Discos = 2, Source = B, Temp = C, Destination = A)

                        ; S(1) > T
                        ;   D   S   T   ;
                        ;               ;
                        ;               ;
                        ;               ;
                        ;       2   1   ;
                        ;       3   4   ;
                        ;   A   B   C   ;

                        ; S(2) > D
                        ;   D   S   T   ;
                        ;               ;
                        ;               ;
                        ;               ;
                        ;           1   ;
                        ;   2   3   4   ;
                        ;   A   B   C   ;

                        ; T(1) > D
                        ;   D   S   T   ;
                        ;               ;
                        ;               ;
                        ;               ;
                        ;   1           ;
                        ;   2   3   4   ;
                        ;   A   B   C   ;
                ;

                ; Hanoi (Discos = 1,  Source = B, Temp = A, Destination = C)

                        ; T(1) > D
                        ;   T   S   D   ;
                        ;               ;
                        ;               ;
                        ;               ;
                        ;   1       3   ;
                        ;   2       4   ;
                        ;   A   B   C   ;
                ;

                ; Hanoi (Discos = 2, Source = A, Temp = B, Destination = C)

                        ; S(1) > T
                        ;   S   T   D   ;
                        ;               ;
                        ;               ;
                        ;               ;
                        ;           3   ;
                        ;   2   1   4   ;
                        ;   A   B   C   ;

                        ; S(2) > D
                        ;   S   T   D   ;
                        ;               ;
                        ;               ;
                        ;           2   ;
                        ;           3   ;
                        ;       1   4   ;
                        ;   A   B   C   ;

                        ; T(1) > D
                        ;   S   T   D   ;
                        ;               ;
                        ;           1   ;
                        ;           2   ;
                        ;           3   ;
                        ;           4   ;
                        ;   A   B   C   ;
                ;
        ;

;