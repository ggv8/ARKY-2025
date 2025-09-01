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
        NULL_FRACTION  = 0000h ; For simplification tests
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
    errorCalcOF   db "El calculo de esta operacion require exceder el rango permitido.", CHAR_NULL
    errorCalcZD   db "La operacion no es permitida ya que provoca una division por 0", CHAR_NULL
    errorOpCode   db "No se permite el operador ingresado.", CHAR_NULL
;

; Look-up Tables
    stateTable dw STATE_DEFAULT, PrintAboutMe
    stateOffset = ($ - stateTable)
               dw STATE_HELP, PrintHelp
               dw STATE_MUL, LinearProduct
               dw STATE_DIV, CrossedProduct
               dw STATE_ADD, AddFractions
               dw STATE_SUB, SubtractFractions
    tableSize = ($ - stateTable) / stateOffset
               dw ERROR_OPCODE, PrintError ; Fail safe state

    errorVector dw offset errorNoState, offset errorNumOF, offset errorDenOF, offset errorZeroDiv
                dw offset errorCalcOF, offset errorCalcZD, offset errorOpCode
;

    programState dw STATE_DEFAULT
    base dw 10

    fraction1 dw 0001h ; Defaults to 0/1
    fraction2 dw 0001h
    result dw 0101h
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
        Push ax
        Push bx
        Push cx                           
        Push dx

        Xor cx, cx
        Mov bx, base
    ciclo1PAX: Xor dx, dx
        Div bx
        Push dx
        Inc cx
        Cmp ax, 0
        Jne ciclo1PAX
        Mov ah, DOS_PRINT_CHAR
    ciclo2PAX: Pop dx
        Add dl, 30h
        Cmp dl, 39h
        Jbe prnPAX
        Add dl, 7
    prnPAX: Int 21h
        Loop ciclo2PAX 

        Pop dx
        Pop cx
        Pop bx
        Pop ax
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

    ; Auxiliary to SimplifyFraction, Finds first common divisor in a range
    ; Inputs: CL - (n) range limit, min(numerator, denominator) of result fraction
    ; Outputs: DX - Simplified fraction if possible. Empty if fraction can't be simplified
    FindFactor proc
        Xor ch, ch
        Inc ch      ; (i): Use CH as control var for iteration

    ITER_FindFactor:  ; From i=2 to n, inclusive
        Xor dx, dx              ; To store partial simplifications
        Inc ch                  ; Try next number (begin with i=2)
        Cmp ch, cl              
        Ja END_FindFactor ; If not within range halt (jA to be inclusive, e.g (i=2)(n=2)[2/4 => 1/2])

        ; Test numerator / n
        Xor ax, ax
        Mov al, byte ptr [result+byte]
        Div ch
        Cmp ah, 0           ; No remainder implies even division
        Jne ITER_FindFactor ; If not even, discard and try another

        Mov dh, al ; Store quotient as new potential numerator

        ; Test denominator / n
        Xor ax, ax
        Mov al, byte ptr [result]
        Div ch
        Cmp ah, 0
        Jne ITER_FindFactor ; Discard if not a factor of both, try another

        Mov dl, al ; Store quotient as new denominator, DX contains new partial simplification of result
    END_FindFactor:
        Ret
    FindFactor endP

    ; Attempts to fully simplify the fraction result
    ; Inputs: result - Expects a valid fraction in the variable
    ; Outputs: result - Sets most simplified fraction possible in variable
    SimplifyFraction proc
        Push ax
        Push cx
        Push dx

    ITER_SimplifyFraction:
        ; Find min(numerator, denominator) for current simplified fraction
        Mov cx, result
        Cmp ch, cl                ; Which is greater between numerator and denominator?
        Jae AUX_SimplifyFraction  ; If CL already has smaller number, proceed to algorithm
        Xchg ch, cl               ; Otherwise, set greater number in ch

    AUX_SimplifyFraction:
        Call FindFactor         ; Attempt to find factor and simplify fraction
        Cmp dx, NULL_FRACTION
        Je END_SimplifyFraction ; If no factor can be found, fraction is fully simplified
        
        Mov result, dx ; Update stored result with partial simplification
        Jmp ITER_SimplifyFraction ; Repeat until fully simplified

    END_SimplifyFraction:
        Pop dx
        Pop cx
        Pop ax
        Ret
    SimplifyFraction endP

    ; Multiplies a fraction with another fraction
    ; Inputs: BX - First fraction operand, CX - Second fraction operand
    ; Outputs: Places the result in DX:AX
    MultiplyFractions proc
        Xor ax, ax
        Mov al, bh
        Mul ch
        Mov dx, ax  ; DX = bh x ch numerator

        Xor ax, ax
        Mov al, bl
        Mul cl      ; AX = bl x cl
        Ret
    MultiplyFractions endP

    ; Multiplies fraction1 with fraction2, performs error checking
    ; Inputs: Expects valid fractional values in the fraction1 and fraction2 variables
    ; Outputs: Obtains the product and places it in result variable
    LinearProduct proc
        Push ax
        Push bx
        Push cx
        Push dx
        ; Prep fractions in registers
        Mov bx, fraction1
        Mov cx, fraction2
        Call MultiplyFractions

        ; Restrict overflow after multiplication
        Cmp dh, 0
        Jne FLAG_ProductOF ; If numerator product exceeds byte range, flag of error
        Cmp ah, 0
        Jne FLAG_ProductOF ; Same goes for denominator product

        Mov ah, dl        ; Move valid numerator in same reg as valid denominator
        Mov result, ax    ; Store fraction result
        Jmp END_LinearProduct

    FLAG_ProductOF:
        Mov programState, ERROR_CALC_OF
    END_LinearProduct:
        Pop dx
        Pop cx
        Pop bx
        Pop ax
        Ret
    LinearProduct endP

    ; Divides fraction1 with fraction2, performs error checking
    ; Inputs: Expects valid fractional values in the fraction1 and fraction2 variables
    ; Outputs: Obtains the product and places it in result variable
    CrossedProduct proc
        Push ax
        Push bx
        Push cx
        Push dx

        Mov cx, fraction2
        Cmp ch, 0
        Je FLAG_CalcZeroDiv ; 2nd operand's numerator can't be zero for division

        Mov bx, fraction1 ; Set 1st operand
        Xchg ch, cl       ; Set 2nd operand with swapped values
        Call MultiplyFractions
        
        ; Restrict overflow after division
        Cmp dh, 0
        Jne FLAG_DivisionOF ; If numerator product exceeds byte range, flag of error
        Cmp ah, 0
        Jne FLAG_DivisionOF ; Same goes for denominator product

        Mov ah, dl        ; Move valid numerator in same reg as valid denominator
        Mov result, ax    ; Store fraction result
        Jmp END_CrossedProduct

    FLAG_CalcZeroDiv:
        Mov programState, ERROR_CALC_ZD
        Jmp END_CrossedProduct
    FLAG_DivisionOF:
        Mov programState, ERROR_CALC_OF
    END_CrossedProduct:
        Pop dx
        Pop cx
        Pop bx
        Pop ax
        Ret
    CrossedProduct endP

    ; Homogenizes fractions if they are not already homogenous
    ; Inputs: Expects valid fraction values in operand variables
    ; Outputs: Places the new operands in BX and CX respectively
    HomogenizeFractions proc
        Push dx
        Push result ; Used for intermediate results

        Mov dx, fraction2            ; Obtain copy for mem to mem comparison
        Cmp dl, byte ptr [fraction1]
        Je CASE_Homogenized          ; Skip algorithm if already homogenous

        ; Homogenizes (a/b) + (c/d) like this: (a/b)(d/d) + (b/b)(c/d)

        Mov dh, dl          ; Obtain (d/d)
        Xchg dx, fraction2  ; Backup (c/d) and prep multiplication in one go
        Call LinearProduct  ; Obtain (a/b)(d/d) in result
        Mov bx, result

        Mov fraction2, dx   ; Restore (c/d) operand
        Mov dx, fraction1   ; Backup (a/b)
        Mov byte ptr [fraction1+byte], dl ; Move b to hi-byte, obtain (b/b)
        Call LinearProduct  ; Obtain (b/b)(c/d) in result
        Mov cx, result

        Mov fraction1, dx ; Restore (a/b) operand
        Jmp END_HomogenizeFractions ; Skip already-homogenized logic

    CASE_Homogenized:
        Mov bx, fraction1
        Mov cx, dx ; Copy 2nd operand from dx

    END_HomogenizeFractions:
        Pop result
        Pop dx
        Ret
    HomogenizeFractions endP

    ; Adds two fractions and saves the result
    ; Inputs: Expects valid fraction values in operand variables
    ; Outputs: Obtains the sum and places it in result variable
    AddFractions proc
        Push bx
        Push cx

        Call HomogenizeFractions        ; Prep bx and cx with homogenized operands
        Cmp programState, ERROR_CALC_OF
        Je END_AddFractions         ; Halt if homogenization caused overflow
        
        Add bh, ch      ; Sum numerators
        Jc FLAG_AddOF   ; Halt if sum exceeds byte capacity
        
        Mov result, bx ; Save result
        Jmp END_AddFractions

    FLAG_AddOF:
        Mov programState, ERROR_CALC_OF
    END_AddFractions:
        Pop cx
        Pop bx
        Ret
    AddFractions endP

    ; Subtracts two fractions and saves the result
    ; Inputs: Expects valid fraction values in operand variables
    ; Outputs: Obtains the sum and places it in result variable
    SubtractFractions proc
        Push bx
        Push cx

        Call HomogenizeFractions        ; Prep bx and cx with homogenized operands
        Cmp programState, ERROR_CALC_OF
        Je END_SubtractFractions      ; Halt if homogenization caused overflow
        
        
        Sub bh, ch      ; Subtract 2nd numerator from 1st
        Jc FLAG_SubOF   ; Halt if source > destination
        
        Mov result, bx ; Save result
        Jmp END_SubtractFractions

    FLAG_SubOF:
        Mov programState, ERROR_CALC_OF
    END_SubtractFractions:
        Pop cx
        Pop bx
        Ret
    SubtractFractions endP

    ; Displays the simplified result of a fraction operation and its alphabetic equivalent
    ; Inputs: Expects valid fraction values in result variable
    ; Outputs: Sends the fraction and its alphabetic result to the standard output
    PrintResult proc
        Push ax
        Push dx

        Call SimplifyFraction

        Xor ax, ax
        Mov al, byte ptr [result+byte] ; Access numerator first
        Call PrintAX

        ; Print fraction line
        Xor al, al
        Mov ah, DOS_PRINT_CHAR
        Xor dh, dh
        Mov dl, '/'
        Int 21h

        Xor ax, ax
        Mov al, byte ptr [result] ; Print denominator
        Call PrintAX
        Call PrintCRLF

        ; Routine that prints result alphabetically

        Pop dx
        Pop ax
        Ret
    PrintResult endP

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
        ;Call ReadInput

        ;Mov base, 10h
        ;Mov ax, fraction1
        ;Call PrintAX
        ;Call PrintCRLF

        ;Mov ax, programState
        ;Call PrintAX
        ;Call PrintCRLF

        ;Mov ax, fraction2
        ;Call PrintAX
        ;Call PrintCRLF

        ;Call RunState

        Mov fraction1, 0203h
        Mov fraction2, 0506h
        Call AddFractions

        Mov base, 16
        Mov ax, programState
        Call PrintAX
        Call PrintCRLF
        Call PrintCRLF
        
        Call PrintResult

    exit:
        Mov al, 00h
        Mov ah, 4Ch
        Int 21h


CodeSegment endS

end main