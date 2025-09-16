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
        DOS_INPUT_CHAR  = 01h
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
        ERROR_SUM_OF  = 8003h
        ERROR_SUB_UF  = 8004h
        ERROR_DUP_OF  = 8005h
    ;

    ; Misc
        PSP_INPUT_OFFSET = 80h
        STATIC_LIMIT     = 10 ; Individual gargantuan size limit due to single data-segment use
        ; TODO: Change static limit back to 20k. Changed temp for speed up linking
        ; TODO: Refactorizar wrappers de operadores relacionales y auxiliares. Separarlos en una funcion que realiza el checkeo con dos numeros independiente de pedir input, lo mismo
        ; aplica para Odd?
        ; TODO: Duplicar recorre del LSD al MSD. SHL el valor y su carry queda pendiente para la siguiente iter
        ; TODO: Half recorre del MSD al LSD. El cociente queda en la iter, el residuo pasa como carry a la siguiente iter
        ; nota, dividir impares entre 2 siempre da residuo 5. El cociente siempre queda en un rango de 1 a 4 a lo sumo
    ;
;

; String literals
    aboutMe db "ITCR: Escuela de Computacion - Arquitectura de Computadoras. 16/Set/2025", CHAR_CR, CHAR_LF
            db "Tarea Numero Gargantua | Autor: Gabriel Gomez Vega, 2021106483", CHAR_NULL
    helpMe  db "Ingrese junto al programa un unico comando valido para numeros gargantua:", CHAR_CR, CHAR_LF
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

    inputPrompt1 db "Digite el primer Gargantua: ", CHAR_NULL
    inputPrompt2 db "Digite el segundo Gargantua: ", CHAR_NULL
    inputPromptU db "Digite un Gargantua: ", CHAR_NULL
    outputPrompt db "El resultado es: ", CHAR_NULL
    outputTrue   db "Verdadero", CHAR_NULL
    outputFalse  db "Falso", CHAR_NULL

    errorLabel db "Error: ", CHAR_NULL
    errorNoState  db "El programa ha generado un error inesperado.", CHAR_NULL
    errorInvCmd   db "Se ha ingresado un comando invalido.", CHAR_NULL
    errorInvIn    db "La entrada solo acepta digitos en base decimal", CHAR_NULL
    errorSumOF    db "El resultado excede la memoria estatica permitida en el segmento", CHAR_NULL
    errorSubUF    db "La resta solicitada produce un numero negativo", CHAR_NULL
    errorDupOF    db "El valor excede la memoria estatica reservada para la variable", CHAR_NULL
;

; Look-up Tables
    stateTable  dw STATE_DEFAULT,   StartWrapper
    STATE_OFFSET = ($ - stateTable)
                dw STATE_HELP,      PrintHelp
                dw STATE_ADDITION,  AdditionWrapper
                dw STATE_COMPLEMENT,ComplementWrapper
                dw STATE_SUBTRACT,  SubtractionWrapper
                dw STATE_DUPLICATE, DuplicationWrapper
                dw STATE_HALF,      HalvingWrapper
                dw STATE_ABOVE,     GreaterThanWrapper
                dw STATE_BELOW,     LessThanWrapper
                dw STATE_EQUAL,     IsEqualWrapper
                dw STATE_PARITY,    ExampleRoutine
                dw STATE_MULTIPLY,  ExampleRoutine
                dw STATE_DIVISION,  ExampleRoutine
                dw STATE_POWER,     ExampleRoutine
                dw STATE_FIBONACCI, ExampleRoutine
                dw STATE_FACTORIAL, ExampleRoutine
    TABLE_SIZE = ($ - stateTable) / STATE_OFFSET
                dw ERROR_INV_CMD,   PrintError ; Fail safe state

    errorVector dw offset errorNoState, offset errorInvCmd, offset errorInvIn, offset errorSumOF, offset errorSubUF
                dw offset errorDupOF
;

    base dw 10
    programState dw STATE_DEFAULT

    gargantuanA dw 00
                db STATIC_LIMIT dup(0)

    gargantuanB dw 00
                db STATIC_LIMIT dup(0)
    
    gargantuanC dw 00
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

    ; Prints a gargantuan reference char by char until consumed
    ; Inputs: SI - Address to gargantuan variable
    ; Outputs: Sends each char to standard output via DOS' routine
    PrintLikeG proc
        Push ax
        Push dx
        Push si

        Mov cx, word ptr [si]   ; Retrieve pascal counter (word)
        Jcxz END_PrintLikeG
        
        Xor al, al
        Mov ah, DOS_PRINT_CHAR
        Inc si                  ; Point to upper byte in preparation for loop
    ITER_PrintLikeG:
        Inc si                  ; Point to next char
        Mov dl, byte ptr [si]   ; Read char
        Int 21h
        Loop ITER_PrintLikeG

    END_PrintLikeG:
        Pop si
        Pop dx
        Pop ax
        Ret
    PrintLikeG endP

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
    ; Inputs: Expects a single char input that serves as a command
    ; Outputs: Stores values in data variables, and flags errors if necessary
    ReadInput proc
        Push ax
        Push bx
        Push cx

        Mov bx, PSP_INPUT_OFFSET
        Cmp byte ptr es:[bx], 0    ; Is there an input?
        Je FLAG_NoInput            ; If not, set new state, and halt proc

        ; If there is, retrieve values only
        Inc bx ; Point to input-preceding whitespace
        Inc bx ; Point to first char
        
        Xor ah, ah
        Mov al, byte ptr es:[bx] ; Retrieve input, ignores any additional input if there's any
        And al, 0DFh              ; Assume valid char, but try enforcing upper case to allow either as valid

        Mov bx, STATE_OFFSET   ; Set offset within stateTable to address each entry, currently points to 2nd entry
        Shl bx, 1              ; Double offset to start at first command entry (ignore default and help states)
        Mov cx, (TABLE_SIZE-2) ; Set counter with offset in mind

    ITER_ReadInput:
        Cmp ax, stateTable[bx] ; Compare if input is a registered state value
        Je BREAK_ReadInput     ; If found, set next state
        Add bx, STATE_OFFSET   ; Point to next entry
        Loop ITER_ReadInput

        Mov ax, stateTable[bx]  ; If no state was found, bx is pointing to fail safe state
    BREAK_ReadInput:
        Mov programState, ax
        Jmp END_ReadInput

    FLAG_NoInput:
        Mov programState, STATE_HELP
    END_ReadInput:
        Pop cx
        Pop bx
        Pop ax
        Ret
    ReadInput endP

    ; Asks the user for a gargantuan number input, and validates it
    ; Inputs: [SI] - Address to input prompt, [DI] - Address to variable
    ; Outputs: [DI] - Stores a valid input in gargantuan format, CF - Set if an error ocurred
    GargantuanInput proc
        Push ax
        Push bx
        Push cx

        Call PrintLikeC        ; Print prompt to std output
        Mov ah, DOS_INPUT_CHAR ; Set DOS function
        Mov bx, word           ; Set pointer after pascal size counter
        Mov cx, STATIC_LIMIT   ; Enforce limit based on allocated size for variable
    ITER_GargantuanInput:
        Xor al, al  ; Clear previous input before invoking DOS function
        Int 21h

        Cmp cx, STATIC_LIMIT
        Jne CONTINUE_GargantuanInput ; If not first input, ignore special cases

        Cmp al, CHAR_CR
        Je AUX_IsFirstInput ; If user did not provide any digits, create default value

        Cmp al, '0'
        Jne CONTINUE_GargantuanInput ; Halt early if first input is 0
        Call PrintCRLF               ; Newline to avoid any future printing next to input

    AUX_IsFirstInput:
        Inc word ptr [di]           ; Default value: Size=1, Value='0'
        Mov byte ptr di[word], '0'
        Jmp FLAG_ValidInput

    CONTINUE_GargantuanInput:
        Cmp al, CHAR_CR
        Je FLAG_ValidInput ; Halt when user inputs <enter>

        Xor al, 30h  ; Assume input in range 30h-39h, mask upper nibble to obtain range 00h-09h
        Cmp al, 10
        Jae FLAG_InvalidInput ; Flag if input is not valid decimal digit

        Xor al, 30h             ; Restore original value
        Inc word ptr [di]       ; Update var's pascal counter
        Mov byte ptr di[bx], al ; Store input
        Inc bx                  ; Point at next available area
        Loop ITER_GargantuanInput
        Call PrintCRLF ; Newline to avoid printing next to last input
        Jmp FLAG_ValidInput     ; Truncate input, skip error flagging logic

    FLAG_InvalidInput:
        Mov programState, ERROR_INV_IN
        Call PrintCRLF ; Add newline to avoid printing next to last input
        Stc
        Jmp END_GargantuanInput

    FLAG_ValidInput:
        Clc
    END_GargantuanInput:
        Pop cx
        Pop bx
        Pop ax
        Ret
    GargantuanInput endP

    ; Shift once all digits of a Gargantuan number to make space for a new digit
    ; Inputs: [DI] - Address of gargantuan variable
    ; Outputs: [DI] - Updates gargantuan var's size value and digit positions, CF - set if shift exceeds limit
    ShiftGargantuanR proc
        Push es
        Push cx
        Push si
        Push di

        Mov cx, word ptr [di] ; Retrieve digit count
        Cmp cx, STATIC_LIMIT
        Jae FLAG_ShiftLimit   ; Flag if number can't be shifted due to static limit

        Push ds
        Pop es  ; Set DI to work in the same segment as SI
        Std     ; Dec addresses for upcoming rep

        Inc di
        Inc di      ; Set DI at first digit
        Add di, cx  ; Set DI at next to last digt
        Mov si, di  
        Dec si      ; Set SI at last digit

        Rep Movsb ; Shifts each digit once. When done, DI points to new byte
        Mov byte ptr [di], '0'
        Dec si
        Inc byte ptr [si] ; Increase digit count

        Clc ; Flag valid shift
        Jmp END_ShiftGargantuanR

    FLAG_ShiftLimit:
        Stc
    END_ShiftGargantuanR:
        Pop di
        Pop si
        Pop cx
        Pop es
        Ret
    ShiftGargantuanR endP

    ; Shift once all digits of a Gargantuan number to remove the leftmost digit
    ; Inputs: [DI] - Address of gargantuan variable
    ; Outputs: [DI] - Updates gargantuan var's size value and digit positions, CF - set if shift exceeds limit
    ShiftGargantuanL proc
        Push es
        Push cx
        Push si
        Push di

        Mov cx, word ptr [di] ; Retrieve digit count
        Cmp cx, 1
        Je FLAG_ShiftBound    ; Flag if number can't be shifted due to already being a single digit

        Dec cx                  ; Update count
        Mov word ptr [di], cx   ; and store it

        Push ds
        Pop es  ; Set DI to work in the same segment as SI
        Cld     ; Inc addresses for upcoming rep

        Inc di
        Inc di      ; Set DI at leftmost digit
        Mov si, di  
        Inc si      ; Set SI at its next digit

        Rep Movsb ; Shifts each digit once. When done, DI points to first digit out of bounds

        Clc ; Flag valid shift
        Jmp END_ShiftGargantuanL

    FLAG_ShiftBound:
        Stc
    END_ShiftGargantuanL:
        Pop di
        Pop si
        Pop cx
        Pop es
        Ret
    ShiftGargantuanL endP

    ; Shifts a gargantuan operand to remove any leftmost zeros in numbers different than only 0
    ; Inputs: [DI] - Destination operand
    TruncateOperand proc
    ITER_TruncateOperand:
        Cmp word ptr [di], 1
        Je END_TruncateOperand      ; If operand is a single digit long, it can't be compressed further

        Cmp byte ptr [di+word], '0' ; Check current leftmost digit
        Jne END_TruncateOperand     ; If no leftmost zero remains, halt

        Call ShiftGargantuanL       ; Otherwise, remove it and compress remaining digits
        Jmp ITER_TruncateOperand
    
    END_TruncateOperand:
        Ret
    TruncateOperand endP

    ; Shifts a gargantuan operand to match the size of a larger one
    ; Inputs: [DI] - Destination operand, [SI] - Source operand
    NormalizeOperands proc
        Push bx
        Push cx
        Push dx


        Mov cx, word ptr [si] ; Assume source is larger, set target to its size and
        Mov bx, di            ; use bx as placeholder for smaller operand's address

        Mov dx, word ptr [di] ; Check if destination op size is actually larger
        Cmp dx, cx
        Je END_NormalizeOperands ; Skip proc if sizes are equal
        Jb AUX_NormalizeOperands ; If assumption was correct, proceed directly to algorithm
        ; Otherwise, update target size and placeholder
        Xchg cx, dx
        Mov bx, si

    AUX_NormalizeOperands:
        Xchg di, bx ; Set placeholder as upcoming routine's DI argument
        Sub cx, dx  ; Shift up to the remaining range between sizes
    ITER_NormalizeOperands:
        Call ShiftGargantuanR
        Loop ITER_NormalizeOperands
        Xchg di, bx ; Restore addresses

    END_NormalizeOperands:
        Pop dx
        Pop cx
        Pop bx
        Ret
    NormalizeOperands endP

    ; Obtains the complement of a single gargantuan operand
    ; Inputs: [DI] - destination operand
    ; Outputs: [DI] - Result, CF - Set if carry/borrow is pending past the digit count
    GargantuanComplement proc
        Push ax
        Push bx
        Push di

        Mov bx, word ptr [di] ; Get operand size, indexes next-to-last digit
        Clc                   ; Assume no borrow for first sub operation
        Pushf                 ; Save borrow data
    ITER_GargantuanComplement:
        Cmp bx, 0
        Je END_GargantuanComplement    ; Halt if all digits were processed

        Xor ah, ah
        Mov al, 40h ; Analog to 10 for the digit range 30h to 40h

        Sub al, byte ptr di[byte+bx] ; Subtract to obtain single-digit complement
        
        Popf        ; Recover previous borrow
        Sbb al, 6   ; Subtract 6+carry to complement to account for prev borrows AND for hex and dec base arithmetic
        ; Example: 40h - 39h = 7h, but we need the nibble to be a decimal value of 1

        ; Possible range is 0-10. If 10 remains, no borrow is needed
        Cmp al, 10  ; If destination op < source op, set CF: AL is 0-9. Else, clear CF: AL is 10
        Pushf       ; Save CMP's implicit borrow flagging

        Jne CONTINUE_GargantuanComplement; If different than 10, no adjustment is necessary
        Xor al, al  ; Otherwise, clear to obtain '0's proper complement, itself :)...

    CONTINUE_GargantuanComplement:

        Or al, 30h                      ; Restore char from int data
        Mov byte ptr di[byte+bx], al    ; Store new digit in destination
        Dec bx                          ; Point to next greatest digit
        Jmp ITER_GargantuanComplement

    END_GargantuanComplement:
        Popf    ; Restore last borrow
        Pop di
        Pop bx
        Pop ax
        Ret
    GargantuanComplement endP

    ; Determines if a gargantuan number is equal to 0
    ; Inputs: [DI] - Compressed operand (no leftmost zeros for values above 0)
    ; Outputs: CF - Set if gargantuan is zero, cleared if not zero
    IsGargantuanZero proc
        Cmp word ptr [di], 1
        Ja FLAG_GargantuanNotZero

        Cmp byte ptr di[word], '0'
        Jne FLAG_GargantuanNotZero

        Stc
        Jmp END_GargantuanZero

    FLAG_GargantuanNotZero:
        Clc
    END_GargantuanZero:
        Ret
    IsGargantuanZero endP

    ; Adds two gargantuan operands and returns the result in the destination operand
    ; Inputs: [DI] - destination operand, [SI] - Source operand
    ; Outputs: [DI] - Result of the sum, CF - Set if carry is pending past their digit count
    GargantuanAddition proc
        Push ax
        Push bx
        Push si
        Push di        

        Mov bx, word ptr [di] ; Get operand size, indexes next-to-last digit
        Clc                   ; Assume no carry for first suboperation
        Pushf                 ; Save carry data
    ITER_GargantuanAddition:
        Cmp bx, 0
        Je END_GargantuanAddition    ; Halt if all digits were processed

        Xor ax, ax
        Popf        ; Recover previous carry
        Adc al, 0   ; Add to result

        Add al, byte ptr di[byte+bx] ; Add each sub operand (byte to access last digit
        Add al, byte ptr si[byte+bx] ; instead of next-to-last digit when using word)
        AAA                          ; ASCII adjust to obtain carry in ah, and new digit in al (Unpacked BCD)

        Or al, 30h                      ; Restore char from int data
        Mov byte ptr di[byte+bx], al    ; Store new digit in destination sub operand
        Shr ah, 1 ; Set carry flag with value in ah
        Pushf     ; Save for next iter
        Dec bx    ; Point to next greatest digit
        Jmp ITER_GargantuanAddition

    END_GargantuanAddition:
        Popf    ; Restore last carry
        Pop di
        Pop si
        Pop bx
        Pop ax
        Ret
    GargantuanAddition endP

    ; Duplicates one gargantuan operand
    ; Inputs: [DI] - destination operand
    ; Outputs: [DI] - Result of the operation, CF - Set if carry is pending past their digit count
    GargantuanDuplication proc
        Push ax
        Push bx
        Push di        

        Mov bx, word ptr [di] ; Get operand size, indexes next-to-last digit
        Clc                   ; Assume no carry for first suboperation
        Pushf                 ; Save carry data
    ITER_GargantuanDuplication:
        Cmp bx, 0
        Je END_GargantuanDuplication ; Halt if all digits were processed

        Xor ax, ax
        Mov al, byte ptr di[byte+bx] ; Copy rightmost digit
        Xor al, 30h                  ; Obtain int from char data
        Shl al, 1                    ; Duplicate value
        AAM                          ; Set carry value in AH, digit value in AL

        Popf        ; Recover previous carry
        Adc al, 0   ; Add to result

        Or al, 30h                      ; Restore char from int data
        Mov byte ptr di[byte+bx], al    ; Store new digit in destination sub operand

        Shr ah, 1 ; Set carry flag with value in ah
        Pushf     ; Save for next iter
        Dec bx    ; Point to next greatest digit
        Jmp ITER_GargantuanDuplication

    END_GargantuanDuplication:
        Popf    ; Restore last carry
        Pop di
        Pop bx
        Pop ax
        Ret
    GargantuanDuplication endP

    ; Halves one gargantuan operand
    ; Inputs: [DI] - destination operand
    ; Outputs: [DI] - Result of the operation, CF - Set if number has remainder
    GargantuanHalving proc
        Push ax
        Push bx
        Push cx
        Push di        

        Xor bx, bx            ; To index each digit from leftmost to rightmost
        Mov cx, word ptr [di] ; Get operand size for iter control
        Clc                   ; Assume no carry for first suboperation
        Pushf                 ; Save carry data
    ITER_GargantuanHalving:
        Xor ah, ah
        Popf                      ; Recover previous carry
        Jnc AUX_GargantuanHalving ; If no remainder, don't adjust for borrow
        Add ah, 5                 ; Otherwise, store half of borrow (10 / 2 = 5)

    AUX_GargantuanHalving:
        Mov al, byte ptr di[word+bx] ; Copy rightmost digit
        Xor al, 30h                  ; Obtain int from char data
        Shr al, 1                    ; Halve value, carry is set if there's a remainder
        Pushf                        ; Save borrow/remainder for next iter

        Add al, ah                      ; Apply pending borrow half if any
        Or al, 30h                      ; Restore char from int data
        Mov byte ptr di[word+bx], al    ; Store new digit in destination sub operand
        Inc bx                          ; Point to next least significant digit
        Loop ITER_GargantuanHalving

    END_GargantuanHalving:
        Popf    ; Restore last carry
        Pop di
        Pop cx
        Pop bx
        Pop ax
        Ret
    GargantuanHalving endP

    ; Prints AboutMe and validates user inputs
    ; Inputs: Expects a valid command line input
    ; Output: Sends AboutMe to standard output
    StartWrapper proc
        Call PrintAboutMe
        Call ReadInput
        Ret
    StartWrapper endP

    ; Prints a result prompt for a gargantuan value
    ; Inputs: [SI] - Address of number to print
    ; Output: Sends result to standard output, [programState] - sets state to halt
    ResultWrapper proc
        Push si
        Mov si, offset outputPrompt
        Call PrintLikeC ; Print prompt before showing result
        Pop si          ; Restore address of result value

        Call PrintLikeG ; Print number representation
        Call PrintCRLF
        Mov programState, STATE_HALT ; Halt entire program
        Ret
    ResultWrapper endP

    ; Requests operands for a sum, and provides their result
    ; Inputs: Expects valid decimal numbers
    ; Output: Sends the result's representation to the std output
    AdditionWrapper proc
        Push si
        Push di

        Mov si, offset inputPrompt1
        Mov di, offset gargantuanA
        Call GargantuanInput
        Jc END_AdditionWrapper      ; Halt if error found

        Mov si, offset inputPrompt2
        Mov di, offset gargantuanB
        Call GargantuanInput
        Jc END_AdditionWrapper      ; Halt if error found

        Mov si, offset gargantuanA
        Xchg di, si ; Set first op address in [DI], and second op's in [SI]
        Call NormalizeOperands ; Set operand sizes to match each others
        Call GargantuanAddition
        Jnc AUX_AdditionWrapper ; If no carry is pending, show result

        Call ShiftGargantuanR ; Try allocating space for carry digit
        Jc FLAG_SumOF         ; Catch shift exceeding static limit of variable

        Mov byte ptr di[word], '1' ; Store carry in new digit position 
        Jmp AUX_AdditionWrapper    ; Continue to result display

    FLAG_SumOF:
        Mov programState, ERROR_SUM_OF
        Jmp END_AdditionWrapper

    AUX_AdditionWrapper:
        Mov si, di          ; Set result in SI parameter to print it
        Call ResultWrapper  ; Show result and halt
    END_AdditionWrapper:
        Pop di
        Pop si
        Ret
    AdditionWrapper endP

    ; Requests a single operand for a complement, and provides its result
    ; Inputs: Expects valid decimal numbers
    ; Output: Sends the result's representation to the std output
    ComplementWrapper proc
        Push si
        Push di

        Mov si, offset inputPromptU
        Mov di, offset gargantuanA
        Call GargantuanInput
        Jc END_ComplementWrapper    ; Halt if error found

        Call GargantuanComplement   ; Obtain input's complement
        Call TruncateOperand

        Mov si, di          ; Set result in SI parameter to print it
        Call ResultWrapper  ; Show result and halt
    END_ComplementWrapper:
        Pop di
        Pop si
        Ret
    ComplementWrapper endP

    ; Requests operands for a sum, and provides their result
    ; Inputs: Expects valid decimal numbers
    ; Output: Sends the result's representation to the std output
    SubtractionWrapper proc
        Push ax
        Push si
        Push di

        Mov si, offset inputPrompt1
        Mov di, offset gargantuanA
        Call GargantuanInput
        Jc END_SubtractionWrapper      ; Halt if error found

        Mov si, offset inputPrompt2
        Mov di, offset gargantuanB
        Call GargantuanInput
        Jc END_SubtractionWrapper      ; Halt if error found

        Mov ax, gargantuanA
        Cmp ax, gargantuanB
        Jb FLAG_SubUF   ; If destination digit size < source's, result will be negative. Halt and flag error


        Mov si, offset gargantuanA
        Call NormalizeOperands      ; Set operand sizes to match the greatest, important before complementing
        Call GargantuanComplement   ; Obtain complement for subtrahend

        Xchg di, si                 ; Set first op address in [DI], and second op's in [SI]
        Call GargantuanAddition     ; Obtain subtraction with complement's arithmetic
        Jnc FLAG_SubUF              ; If no carry is pending, result is negative. Halt and flag error

        Call TruncateOperand    ; Otherwise, try removing any remaining zeros in leftmost position

        Mov si, di          ; Set result in SI parameter to print it
        Call ResultWrapper  ; Show result and halt
        Jmp END_SubtractionWrapper

    FLAG_SubUF:
        Mov programState, ERROR_SUB_UF

    END_SubtractionWrapper:
        Pop di
        Pop si
        Pop ax
        Ret
    SubtractionWrapper endP

    ; Requests an operand to duplicate, and provides its result
    ; Inputs: Expects valid decimal numbers
    ; Output: Sends the result's representation to the std output
    DuplicationWrapper proc
        Push si
        Push di

        Mov si, offset inputPromptU
        Mov di, offset gargantuanA
        Call GargantuanInput
        Jc END_DuplicationWrapper    ; Halt if error found

        Call GargantuanDuplication   ; Obtain input's duplicate value
        Jnc AUX_DuplicationWrapper   ; If no carry is pending, show result

        Call ShiftGargantuanR        ; Otherwise, try to allocate space fordigit
        Jc FLAG_DupOF                ; Catch shift exceeding static limit of variable

        Mov byte ptr di[word], '1' ; Store carry in new digit position 
        Jmp AUX_AdditionWrapper    ; Continue to result display

    FLAG_DupOF:
        Mov programState, ERROR_DUP_OF
        Jmp END_DuplicationWrapper

    AUX_DuplicationWrapper:
        Mov si, di          ; Set result in SI parameter to print it
        Call ResultWrapper  ; Show result and halt
    END_DuplicationWrapper:
        Pop di
        Pop si
        Ret
    DuplicationWrapper endP

    ; Requests an operand to halve, and provides its result
    ; Inputs: Expects valid decimal numbers
    ; Output: Sends the result's representation to the std output
    HalvingWrapper proc
        Push si
        Push di

        Mov si, offset inputPromptU
        Mov di, offset gargantuanA
        Call GargantuanInput
        Jc END_DuplicationWrapper    ; Halt if error found

        Call GargantuanHalving       ; Obtain input's halved value
        Call TruncateOperand         ; Truncate any remaining zeros in leftmost position

        Mov si, di          ; Set result in SI parameter to print it
        Call ResultWrapper  ; Show result and halt
    END_HalvingWrapper:
        Pop di
        Pop si
        Ret
    HalvingWrapper endP

    ; Requests operands for a comparison, and obtains their subtraction
    ; Inputs: Expects valid decimal numbers
    ; Output: Stores the result in destination op, CF - set if dest. op >= source op, else it clears CF
    ComparisonWrapper proc
        Push si
        Push di

        Mov si, offset inputPrompt1
        Mov di, offset gargantuanA
        Call GargantuanInput
        Jc END_ComparisonWrapper      ; Halt if error found

        Mov si, offset inputPrompt2
        Mov di, offset gargantuanB
        Call GargantuanInput
        Jc END_ComparisonWrapper      ; Halt if error found

        Mov si, offset gargantuanA
        Call NormalizeOperands      ; Set operand sizes to be same, especially before complement
        Call GargantuanComplement   ; Obtain complement for subtrahend

        Xchg di, si                 ; Set minuend in [DI], and subtrahend comp in [SI]
        Call GargantuanAddition     ; Subtract via complement's addition, may set CF
        ; If pending carry, minuend is above or equal
        ; If no carry, minued is below


        Pushf ; Create backup to avoid losing result
        Call TruncateOperand        ; Compress result if possible
        Mov si, offset outputPrompt ; Print result prompt
        Call PrintLikeC
        Popf
        
    END_ComparisonWrapper:
        Pop di
        Pop si
        Ret
    ComparisonWrapper endP

    ; Requests operands for a '>' comparison, and prints the result
    ; Inputs: Expects valid decimal numbers
    ; Output: Sends the boolean result to the std output
    GreaterThanWrapper proc
        Mov si, offset outputFalse  ; Assume false by default
        Call ComparisonWrapper      ; Compare two inputs
        Jnc END_GreaterThanWrapper  ; If below, skip to final print

        Mov di, offset gargantuanA
        Call IsGargantuanZero
        Jc END_GreaterThanWrapper   ; If equal, skip

        Mov si, offset outputTrue   ; Assumption false, change output string

    END_GreaterThanWrapper:
        Call PrintLikeC
        Call PrintCRLF

        Mov programState, STATE_HALT ; Halt entire program
        Ret
    GreaterThanWrapper endP

    ; Requests operands for a '>' comparison, and prints the result
    ; Inputs: Expects valid decimal numbers
    ; Output: Sends the boolean result to the std output
    LessThanWrapper proc
        Mov si, offset outputFalse  ; Assume false by default
        Call ComparisonWrapper      ; Compare two inputs
        Jc END_LessThanWrapper      ; If above or equal, skip to final print

        Mov si, offset outputTrue   ; Assumption false, change output string

    END_LessThanWrapper:
        Call PrintLikeC
        Call PrintCRLF

        Mov programState, STATE_HALT ; Halt entire program
        Ret
    LessThanWrapper endP

    ; Requests operands for a '=' comparison, and prints the result
    ; Inputs: Expects valid decimal numbers
    ; Output: Sends the boolean result to the std output
    IsEqualWrapper proc
        Mov si, offset outputFalse  ; Assume false by default
        Call ComparisonWrapper      ; Compare two inputs

        Mov di, offset gargantuanA
        Call IsGargantuanZero
        Jnc END_IsEqualWrapper      ; Subtraction was not zero, skip to printing

        Mov si, offset outputTrue
    
    END_IsEqualWrapper:
        Call PrintLikeC
        Call PrintCRLF

        Mov programState, STATE_HALT ; Halt entire program
        Ret
    IsEqualWrapper endP

    ; Routine for example state
    ; Inputs: ...
    ; Outputs: Sets programState to halt if no error occured
    ExampleRoutine proc
        Push ax
        Mov ax, programState

        Mov programState, STATE_HALT
    END_ExampleRoutine:
        Pop ax
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