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
    mrHeight    db 80h      
    mrWidth     db 80h

    errorMsg    db "Error: Se ha ingresado una base númerica no esperada. Debe usar H, B, u O", "$"
    aboutMeL1   db "ITCR: Escuela de Computacion - Arquitectura de Computadoras. DD/MM/2025", "$"
    aboutMeL2   db "Tarea --- | Autor: Gabriel Gomez Vega, 2021106483", "$"
    helpMe      db "Ingrese los datos solicitados", "$"
    numberChar  db "25"
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

    ; Obtains the integer value of a number expressed in a char
    ; Inputs:  Expects numerical char in DL
    ; Outputs: Returns int value back in DL
    CharToInt proc
        Xor dl, 30h ; Clears high bits for any 3Xh value
        Ret
    CharToInt endP

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

    ; Reads numerical parameter char-by-char to obtain int value
    ParseNumParameter proc

        Ret
    ParseNumParameter endP

    ; Reads the command line's input and stores parameters if any
    ReadInput proc
        Push ax
        Push bx
        Push cx

        Cmp byte ptr es:[bx], 0    ; Is there an input?
        Je STATE_NoInput           ; Set new prog state, and halt proc if no input

        ; If there is input, retrieve values only
        Inc bx ; Point to input-preceding whitespace
        Inc bx ; Point to Mr Flat's base

        Mov al, byte ptr es:[bx]
        Mov mrFlatBase, al          ; Save char as base to display

        ; Logic that sets base accordingly to input (or halts and displays error)

        ; Logic that casts numerical str to int values according to base inputted


    STATE_NoInput: Mov 
    END_ReadInput:
        Pop cx
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
        Call PrintHelp

        Call ReadCL
    exit:
        Mov ax, 4C00h
        Int 21h


CodeSegment endS

end main