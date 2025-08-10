; Documentacion
    ; ╔═════════════════════════════════════╦═══════════════════════════════════╗
    ; ║ Instituto Tecnologico de Costa Rica ║ Gabriel Gomez Vega                ║
    ; ║ Escuela de Computacion              ║ 2021106483                        ║
    ; ║ Arquitectura de Computadoras        ║ 13 de Agosto del 2025             ║
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
    ; ╚══════════════════════════════════════════════════════════╩══════════════╝
;

DataSegment segment
    progState   db 00h
    mrHeight    dw 80     
    mrWidth     dw 80

    errorMsg   db "Error: Se ha ingresado una base numerica desconocida ("
    mrFlatBase  db 00h ; Positioned here intentionally in case an invalid base is used (can be printed directly)
                db "). Debe usar H, B, u O", "$"
    aboutMeL1   db "ITCR: Escuela de Computacion - Arquitectura de Computadoras. 13/Agosto/2025", "$"
    aboutMeL2   db "Tarea Mr.Flat Tri Base | Autor: Gabriel Gomez Vega, 2021106483", "$"
    helpMe      db "Ingrese los datos para Mr.Flat: -Base (H, B, O) -Altura -Grosor", "$"
    base        dw 10
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
        mov ah, 02h
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

        Mov ax, 0200h ; Set DOS interruption for char outputs
        
        Mov dl, 0Dh ; Set carriage return
        Int 21h

        Mov dl, 0Ah ; Set line feed
        Int 21h

        Pop dx
        Pop ax
        Ret
    PrintCRLF endP

    ; Print details about the program's creation
    ; Inputs: Expects two string literals predefined in variables
    ; Outputs: Sends the two lines to standard output, separated by a newline
    PrintAboutMe proc
        Push ax
        Push dx

        Mov ax, 0900h ; Set DOS interruption for $-string output
        
        Mov dx, offset aboutMeL1 ; Set string's offset within DS
        Int 21h
        Call PrintCRLF

        Mov dx, offset aboutMeL2 ; Repeat for next line
        Int 21h
        Call PrintCRLF
        Call PrintCRLF

        Pop dx
        Pop ax
        Ret
    PrintAboutMe endP

    ; Print the program's help message
    ; Inputs: Expects predefined help string literal in memory
    ; Outputs: Sends the line to standard output, followed by a newline
    PrintHelp proc
        Push ax
        Push dx

        Mov ax, 0900h ; Set DOS interruption for $-string output

        Mov dx, offset helpMe ; Set string's offset within DS
        Int 21h
        Call PrintCRLF

        Pop dx
        Pop ax
        Ret
    PrintHelp endP

    ; Print the program's error message
    ; Inputs: Expects predefined error string literal in memory
    ; Outputs: Sends the line to standard output, followed by a newline
    PrintError proc
        Push ax
        Push dx

        Mov dx, offset errorMsg  ; Set $tring address
        Mov ax, 0900h            ; and DOS routine for printing it
        Int 21h
        Call PrintCRLF

        Pop dx
        Pop ax
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

        Mov bx, 80h                 ; Offset for input in PSP
        Mov cl, byte ptr es:[bx]    ; Obtain input size from offset ptr

        Cmp cl, 0
        Je END_ReadCL   ; Skip if empty
    
        Mov ax, 0200h ; Set DOS-int for char printing
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

    STATE_WrongBase: Mov progState, 02h ; Error - Unexpected char in base parameter
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
        Mov ch, 80h                 ; Copy base offset
        Add ch, byte ptr es:[80h]   ; Add input size to obtain iter limit
    ITER_ParseNumParameter:
        Inc bx                   ; Point to next value
        Cmp bl, ch
        Ja END_ParseNumParameter ; Input ran out, halt proc
        Mov cl, byte ptr es:[bx] ; Read current char
        Cmp cl, ' '
        Je END_ParseNumParameter ; If end of param, halt proc

        ; Otherwise, calculate int value
        Mul word ptr base     ; Update positional value of current sum
        call ParseDigit
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
        Push ax
        Push bx

        Mov bx, 80h                ; Offset for input in PSP
        Cmp byte ptr es:[bx], 0    ; Is there an input?
        Je STATE_NoInput           ; If not, set new prog state, and halt proc

        ; If there is, retrieve values only
        Inc bx ; Point to input-preceding whitespace
        Inc bx ; Point to Mr Flat's base
        Mov al, byte ptr es:[bx] ; Read base parameter
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

    STATE_NoInput: Mov progState, 01h ; Error - No Input
    END_ReadInput:
        Pop bx
        Pop ax
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
        Push ax
        Push cx
        Push dx

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
        Pop dx
        Pop cx
        Pop ax
        Ret
    PrintMrFlat endP

    main:
        Mov ax, ds
        Mov es, ax ; Save PSP's address

        Mov ax, StackSegment
        Mov ss, ax ; Set stack's address

        Mov ax, DataSegment
        Mov ds, ax ; Set data's address
        

        Call PrintAboutMe
        Call ReadInput

        Cmp progState, 01h
        Je AUX_HelpMe
        Cmp progState, 02h
        Je Aux_ErrorMsg

        ; Prints de prueba para la conversion de texto a int
        ; Mov ax, base  ; Guarda la base (parametro) en AX para su impresion
        ; Mov base, 10  ; Restaura base 10 por conveniencia :)
        ; Call PrintAX
        ; Call PrintCRLF
        ; Mov ax, mrHeight ; Para print del alto
        ; Call PrintAX
        ; Call PrintCRLF
        ; Mov ax, mrWidth ; Para print del ancho
        ; Call PrintAX
        ; Call PrintCRLF

        Call PrintMrFlat
        Jmp exit ; Skip error handling

    AUX_HelpMe:
        call PrintHelp
        Jmp exit ; Skip error printing
    Aux_ErrorMsg:
        call PrintError

    exit:
        Mov ax, 4C00h
        Int 21h


CodeSegment endS

end main