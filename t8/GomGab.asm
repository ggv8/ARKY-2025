; Documentacion
    ; ╔═════════════════════════════════════╦═══════════════════════════════════╗
    ; ║ Instituto Tecnologico de Costa Rica ║ Gabriel Gomez Vega                ║
    ; ║ Escuela de Computacion              ║ 2021106483                        ║
    ; ║ Arquitectura de Computadoras        ║ 07 de Noviembre del 2025          ║
    ; ╚═════════════════════════════════════╩═══════════════════════════════════╝
    ; ╔═════════════════════════════════════════════════════════════════════════╗
    ; ║                            Manual de Usuario                            ║
    ; ╠═════════════════════════════════════════════════════════════════════════╣
    ; ║ Este programa despliega a Mr.Flat en la salida estandar segun los para- ║
    ; ║ metros que se ingresen en la linea de comandos. Se esperan los siguien- ║
    ; ║ tes valores:                                                            ║
    ; ║     - Base                                                              ║
    ; ║         Indica la base numerica con la que opera el programa para  los  ║
    ; ║         parametros de altura y ancho. Es ademas el caracter que se uti- ║
    ; ║         za para representar a Mr.Flat al imprimirlo. Se esperan letras  ║
    ; ║         mayusculas o minusculas, pero deben ser para las bases binaria  ║
    ; ║         (B), octal (O), o hexadecimal (H)                               ║
    ; ║     - Altura                                                            ║
    ; ║         Espera un valor numerico expresado en la base solicitada. Este  ║
    ; ║         indica la altura que debe tomar Mr.Flat en pantalla. Si se exe- ║
    ; ║         de un valor de 80 decimal, el programa asume este mismo valor   ║
    ; ║         como la altura solicitada                                       ║
    ; ║     - Ancho                                                             ║
    ; ║         Espera un valor numerico en la base solicitada. Indica el ancho ║
    ; ║         que debe tomar Mr.Flat en pantalla al imprimirlo. De igual for- ║
    ; ║         ma, se establece un limite de 80 decimal en su valor y se asume ║
    ; ║         como tal en caso de que su entrada exceda esa cifra             ║
    ; ║                                                                         ║
    ; ║ Si no se ingresa ningun parametro, el programa mostrara en pantalla una ║
    ; ║ ayuda al usuario que resume la informacion anterior. Siempre que se co- ║
    ; ║ rre el archivo se mostrara una corta descripcion acerca del programa.   ║
    ; ║                                                                         ║
    ; ║ Si se ingresa una base no reconocida, el programa mostrara  un  mensaje ║
    ; ║ de error detallando las bases que se esperan. De acuerdo a la especifi- ║
    ; ║ caciones solicitadas, no se realiza ninguna validacion adicional.       ║
    ; ║                                                                         ║
    ; ║ Al ingresar los parametros solicitados, el ejecutable  leera su entrada ║
    ; ║ y hara la conversion numerica  que usted espera para asi  calcular las  ║
    ; ║ dimensiones que Mr.Flat tomara en pantalla. Seguido de ello, se mostra- ║
    ; ║ ra en pantalla compuesto del caracter de la base numerica elegida.      ║
    ; ║                                                                         ║
    ; ║ Esta versión de Mr Flat está optimizada con el formato ejecutable .COM  ║
    ; ║ y por lo tanto consume un menor espacio del almacenamiento en compara-  ║
    ; ║ ción a su versión anterior :)                                           ║
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
    ; ║ Lectura de la linea de comandos                          ║      A       ║
    ; ╠══════════════════════════════════════════════════════════╬══════════════╣
    ; ║ Conversión de texto a número                             ║      A       ║
    ; ╠══════════════════════════════════════════════════════════╬══════════════╣
    ; ║ Despliegue de Mr. Flat                                   ║      A       ║
    ; ╠══════════════════════════════════════════════════════════╬══════════════╣
    ; ║ Despliegue del Error (Base no esperada)                  ║      A       ║
    ; ╠══════════════════════════════════════════════════════════╬══════════════╣
    ; ║ Conversión al formato .COM (Monosegmento, ORG 100h)      ║      A       ║
    ; ╚══════════════════════════════════════════════════════════╩══════════════╝
;

; Macros
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
;


; Symbolic Constants

    ; State Machine
        STATE_DEFAULT = 00h
        ERROR_NO_INPUT = 01h
        ERROR_UNKNW_BASE = 02h
    ;

    ; Misc
        PSP_INPUT_OFFSET = 80h
    ;
;

COM segment
    Assume CS:COM, DS:COM, SS:COM
    ORG 100h    ; Allocate space for the PSP attachment

    start:
        Jmp main

    ; -----------
    ; Data area |
    ; -----------
    progState   db STATE_DEFAULT
    mrHeight    dw 80     
    mrWidth     dw 80

    errorMsg   db "Error: Se ha ingresado una base numerica desconocida ("
    mrFlatBase  db 00h ; Positioned here intentionally in case an invalid base is used (can be printed directly)
                db "). Debe usar H, B, u O", "$"
    aboutMeL1   db "ITCR: Escuela de Computacion - Arquitectura de Computadoras. 7/Noviembre/2025", "$"
    aboutMeL2   db "Tarea Mr.FlatCOM | Autor: Gabriel Gomez Vega, 2021106483", "$"
    helpMe      db "Ingrese los datos para Mr.Flat: -Base (H, B, O) -Altura -Grosor", "$"
    base        dw 10

    ; -----------
    ; Code area |
    ; -----------

    ; imprime a la salida est�ndar un n�mero que supone estar en el AX
    ; supone que es un n�mero positivo y natural en 16 bits.
    ; lo imprime en la base que indica la variable Base del Data Segment.  
    PrintAX proc near
        PUSHLIST ax, bx, cx, dx

        xor cx, cx
        mov bx, base
    ciclo1PAX: xor dx, dx
        div bx
        push dx
        inc cx
        cmp ax, 0
        jne ciclo1PAX
        mov ah, 02h
    ciclo2PAX: pop DX
        add dl, 30h
        cmp dl, 39h
        jbe prnPAX
        add dl, 7
    prnPAX: int 21h
        loop ciclo2PAX 

        POPLIST ax, bx, cx, dx
        ret
    PrintAX endP

    ; Prints a newline using CR and LF chars
    ; Inputs: N/A
    ; Outputs: Sends CRLF chars to standard output
    PrintCRLF proc
        PUSHLIST ax, dx

        Mov ax, 0200h ; Set DOS interruption for char outputs
        
        Mov dl, 0Dh ; Set carriage return
        Int 21h

        Mov dl, 0Ah ; Set line feed
        Int 21h

        POPLIST ax, dx
        Ret
    PrintCRLF endP

    ; Print details about the program's creation
    ; Inputs: Expects two string literals predefined in variables
    ; Outputs: Sends the two lines to standard output, separated by a newline
    PrintAboutMe proc
        PUSHLIST ax, dx

        Mov ax, 0900h ; Set DOS interruption for $-string output
        
        Mov dx, offset aboutMeL1 ; Set string's offset within DS
        Int 21h
        Call PrintCRLF

        Mov dx, offset aboutMeL2 ; Repeat for next line
        Int 21h
        Call PrintCRLF
        Call PrintCRLF

        POPLIST ax, dx
        Ret
    PrintAboutMe endP

    ; Print the program's help message
    ; Inputs: Expects predefined help string literal in memory
    ; Outputs: Sends the line to standard output, followed by a newline
    PrintHelp proc
        PUSHLIST ax, dx

        Mov ax, 0900h ; Set DOS interruption for $-string output

        Mov dx, offset helpMe ; Set string's offset within DS
        Int 21h
        Call PrintCRLF

        POPLIST ax, dx
        Ret
    PrintHelp endP

    ; Print the program's error message
    ; Inputs: Expects predefined error string literal in memory
    ; Outputs: Sends the line to standard output, followed by a newline
    PrintError proc
        PUSHLIST ax, dx

        Mov dx, offset errorMsg  ; Set $tring address
        Mov ax, 0900h            ; and DOS routine for printing it
        Int 21h
        Call PrintCRLF

        POPLIST ax, dx
        Ret
    PrintError endP

    ; Validates base-parameter and updates prog's working base. Halts and flags an error if necessary
    ; Input: Assumes an alphabetic value in AL
    ; Output: Changes Data's base accordingly to input if valid. Changes progState code if not valid.
    ValidateParameter proc
        And al, 0DFh ; Enforce uppercase with bitmask
        ; Uppercase: 4X,5Xh(0100-X,0101-X). Lowercase: 6X,7Xh(0110-X,0111-X). And 0DFh(1101-1111) discards 5th bit

        Cmp al, 'H'
        Jne CASE_B_ValidateParameter ; If not equal, check for B    
        Mov base, 10h ; Otherwise, set hex base
        Jmp END_ValidateParameter

    CASE_B_ValidateParameter:
        Cmp al, 'B'
        Jne CASE_O_ValidateParameter
        Mov base, 10b ; Otherwise, set bin base
        Jmp END_ValidateParameter

    CASE_O_ValidateParameter:
        Cmp al, 'O'
        Jne STATE_WrongBase
        Mov base, 10o ; Otherwise, set oct base
        Jmp END_ValidateParameter

    STATE_WrongBase: Mov progState, ERROR_UNKNW_BASE ; Error - Unexpected char in base parameter
    END_ValidateParameter:
        Ret
    ValidateParameter endP

    ; Obtains the int value of numerical digits or alphabetic digits (for Hex)
    ; Inputs: Expects a numerical char or an uppercase alpha (A to F) in CL
    ; Outputs: Returns the corresponding int value back in CL
    ParseDigit proc
        Cmp cl, 39h
        Ja AUX_ParseDigit ; Alpha values are retrieved using separate logic

        Xor cl, 30h         ; Clear high bits for any 3Xh numerical char to retrieve int
        Jmp END_ParseDigit

    AUX_ParseDigit:
        Xor cl, 40h ; Discard higher bits for 4Xh values
        Add cl, 09h ; Offset to alpha values (X1h) obtains int (A-> X1h + 9 = 10, F-> X6h + 9 = 15)

    END_ParseDigit:
        Ret
    ParseDigit endP

    ; Reads numerical parameter char-by-char to obtain int value
    ; Inputs: Assumes BX offset to whitespace preceeding param
    ; Outputs: Int value is kept in AX
    ParseNumParameter proc
        Push cx    ; To store int value retrieved per iter
        Push dx    ; Altered by Mul operations

        Xor ax, ax  ; Clear to accumulate sum in register
        Mov ch, PSP_INPUT_OFFSET                 ; Copy base offset
        Add ch, byte ptr ds:[PSP_INPUT_OFFSET]   ; Add input size to obtain iter limit
    ITER_ParseNumParameter:
        Inc bx                   ; Point to next value
        Cmp bl, ch
        Ja END_ParseNumParameter ; Input ran out, halt proc
        Mov cl, byte ptr [bx] ; Read current char
        Cmp cl, ' '
        Je END_ParseNumParameter ; If end of param, halt proc

        ; Otherwise, calculate int value
        Mul word ptr base     ; Update positional value of current sum
        Call ParseDigit
        Add al, cl   ; Add value to newest Least Significant Position

        Jmp ITER_ParseNumParameter ; Repeat until input is consumed

    END_ParseNumParameter:
        Pop dx
        Pop cx
        Ret
    ParseNumParameter endP

    ; Reads the command line's input and stores parameters if any
    ; Inputs: Expects 3 parameters (char, num, num) in command line
    ; Outputs: Stores values in data variables, and flags errors if necessary
    ReadInput proc
        PUSHLIST ax, bx

        Mov bx, PSP_INPUT_OFFSET
        Cmp byte ptr [bx], 0    ; Is there an input?
        Je STATE_NoInput        ; If not, set new prog state, and halt proc

        ; If there is, retrieve values only
        Inc bx ; Point to input-preceding whitespace
        Inc bx ; Point to Mr Flat's base
        Mov al, byte ptr [bx] ; Read base parameter
        Mov mrFlatBase, al  ; Save value for display

        Call ValidateParameter
        Cmp progState, 00h
        Jne END_ReadInput   ; Skip proc if param had an error

        Inc bx                  ; Point to whitespace preceeding height value (*)
        Call ParseNumParameter

        Cmp ax, mrHeight
        Jae AUX_ReadInput   ; If >= 80, keep default 80 height
        Mov mrHeight, ax    ; Assign read value otherwise

    AUX_ReadInput:
        Call ParseNumParameter ; Prev call halted at whitespace preceeding width value (*)

        Cmp ax, mrWidth
        Jae END_ReadInput  ; Keep default if >= 80
        Mov mrWidth, ax    ; Assign new value otherwise    
        Jmp END_ReadInput  ; Skip error flagging line

    STATE_NoInput: Mov progState, ERROR_NO_INPUT ; Error - No Input
    END_ReadInput:
        POPLIST ax, bx
        Ret
    ReadInput endP

    ; Prints a single row of MrFlat, col-by-col, and a newline if necessary
    ; Inputs: Expects valid parameters for base, and width in memory
    ; Outputs: Sends chars of MrFlatBase to standard output until the row width is met
    PrintMrRow proc
        Push cx
        Mov cx, mrWidth
    ITER_PrintMrRow:
        Cmp cx, 0
        Je END_PrintMrRow ; Halt if width 0 or row is finished
        Int 21h ; Trigger column printing
        Dec cx  ; Update count
        Jmp ITER_PrintMrRow
    END_PrintMrRow:
        Cmp mrWidth, 80
        Je AUX_PrintMrRow ; Skip newline printing if width already covers a full line        
        Call PrintCRLF

    AUX_PrintMrRow:
        Pop cx
        Ret
    PrintMrRow endP

    ; Prints MrFlat, row-by-row
    ; Inputs: Expects valid parameters for base, and height in memory
    ; Outputs: Sends rows of MrFlatBase to standard output until the column height is met
    PrintMrFlat proc
        PUSHLIST ax, cx, dx

        Mov ax, 0200h       ; Set DOS routine for char printing
        Mov dl, mrFlatBase  ; Prep char value to print
        Mov cx, mrHeight
    ITER_PrintMrFlat:
        Cmp cx, 0
        Je END_PrintMrFlat ; Halt if height 0 or MrFlat is finished
        Call PrintMrRow
        Dec cx               ; Update count
        Jmp ITER_PrintMrFlat

    END_PrintMrFlat:
        POPLIST ax, cx, dx
        Ret
    PrintMrFlat endP

    main:
        Call PrintAboutMe
        Call ReadInput

        Cmp progState, ERROR_NO_INPUT
        Je AUX_HelpMe
        Cmp progState, ERROR_UNKNW_BASE
        Je Aux_ErrorMsg

        Call PrintMrFlat
        Jmp exit ; Skip error handling

    AUX_HelpMe:
        Call PrintHelp
        Jmp exit ; Skip error printing
    Aux_ErrorMsg:
        Call PrintError

    exit:
        Mov ax, 4C00h
        Int 21h
COM endS

end start