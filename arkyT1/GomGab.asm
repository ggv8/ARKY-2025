; Documentacion
    ; ╔═════════════════════════════════════╦═══════════════════════════════════╗
    ; ║ Instituto Tecnologico de Costa Rica ║ Gabriel Gomez Vega                ║
    ; ║ Escuela de Computacion              ║ 2021106483                        ║
    ; ║ Arquitectura de Computadoras        ║ 13 de Agosto del 2025             ║
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
    ; ║ Despliegue de la Ayuda                                   ║      -       ║
    ; ╠══════════════════════════════════════════════════════════╬══════════════╣
    ; ║ Lectura de la linea de comandos                          ║      A       ║
    ; ╠══════════════════════════════════════════════════════════╬══════════════╣
    ; ║ Conversión de texto a número                             ║      -       ║
    ; ╠══════════════════════════════════════════════════════════╬══════════════╣
    ; ║ Despliegue de Mr. Flat                                   ║      -       ║
    ; ╠══════════════════════════════════════════════════════════╬══════════════╣
    ; ║ Despliegue del Error (Base no esperada)                  ║      -       ║
    ; ╚══════════════════════════════════════════════════════════╩══════════════╝
;

DataSegment segment
    progState   db 00h
    mrFlatBase  db 00h
    mrHeight    dw 80     
    mrWidth     dw 80

    errorMsg    db "Error: Se ha ingresado una base numerica desconocida. Debe usar H, B, u O", "$"
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

        Pop dx
        Pop ax
        Ret
    PrintAboutMe endP

    ; Print the program's help message
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
    PrintError proc
        Push ax
        Push dx

        Mov dx, offset errorMsg ; Set $tring address
        Mov ax, 0900h           ; and DOS routine for printing it
        Int 21h
        Call PrintCRLF

        Pop dx
        Pop ax
        Ret
    PrintError endP

    ; Reads the command line's input back to the standard output
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
    ; Input: Assumes uppercase alphabetic value to be in AL
    ; Output: Changes Data's base accordingly to input if valid. Changes progState code if not valid.
    ValidateParameter proc
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
    
        Call ValidateParameter
        Cmp progState, 00h
        Jne END_ReadInput   ; Skip proc if param had an error
        Mov mrFlatBase, al  ; Otherwise, save value to display it

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
        Ret
    ReadInput endP

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


        Mov ax, base
        Mov base, 10
        Call PrintAX
        Call PrintCRLF

        Mov ax, mrHeight
        Call PrintAX
        Call PrintCRLF

        Mov ax, mrWidth
        Call PrintAX
        Call PrintCRLF

        ;Call Execute
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