; Documentacion
    ; ╔═════════════════════════════════════╦═══════════════════════════════════╗
    ; ║ Instituto Tecnologico de Costa Rica ║ Gabriel Gomez Vega                ║
    ; ║ Escuela de Computacion              ║ 2021106483                        ║
    ; ║ Arquitectura de Computadoras        ║ 29 de Setiembre del 2025          ║
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
        STATE_HALT      = 0000h
        STATE_DEFAULT   = 0001h
        STATE_HELP      = 'A'
        STATE_CREATE    = 'C'
        STATE_INSERT    = 'I'
        STATE_OVERWRITE = 'S'
        STATE_ENCRYPT   = 'E'
        STATE_DECRYPT   = 'D'
        STATE_CAPLINE   = 'V'
        STATE_UPPERLINE = 'M'
        STATE_LOWERLINE = 'm'
        STATE_ERASELINE = 'B'
        STATE_COPYCLIP  = 'c'
        STATE_CUTCLIP   = 'x'
        STATE_PASTECLIP = 'v'
        STATE_REPLACEC  = 'F'

        ; 8000h to FFFFh are reserved for errors
        STATE_ERROR   = 8000h ; Reference for comparisons
        ERROR_INV_CMD = 8001h ; Fail safe state
    ;

    ; Misc
        PSP_INPUT_OFFSET = 80h
        MAX_LINE_SIZE    = 256
        CL_INPUT_SIZE    = 128
    ;
;

; String literals
    aboutMe db "ITCR: Escuela de Computacion - Arquitectura de Computadoras. 29/Set/2025", CHAR_CR, CHAR_LF
            db "Tarea Centurion | Autor: Gabriel Gomez Vega, 2021106483", CHAR_NULL
    helpMe  db "Ingrese comandos validos y sus parametros:", CHAR_CR, CHAR_LF, CHAR_CR, CHAR_LF
            db CHAR_HTAB, "Crear archivo (",STATE_CREATE, "):", CHAR_HTAB,"   -nombre", CHAR_CR, CHAR_LF
            db CHAR_HTAB, "Insertar linea (",STATE_INSERT, "):", CHAR_HTAB,"   -nombre -linea -columna -texto", CHAR_CR, CHAR_LF
            db CHAR_HTAB, "Sobreescribir linea (",STATE_OVERWRITE, "):   -nombre -linea -columna -texto", CHAR_CR, CHAR_LF
            db CHAR_HTAB, "Encriptar linea (",STATE_ENCRYPT, "):", CHAR_HTAB,"   -nombre -linea -caracter de encriptacion ", CHAR_CR, CHAR_LF
            db CHAR_HTAB, "Desencriptar linea (",STATE_DECRYPT, "):", CHAR_HTAB,"   -nombre -linea -caracter de encriptacion ", CHAR_CR, CHAR_LF
            db CHAR_HTAB, "Linea en versalles (",STATE_CAPLINE, "):", CHAR_HTAB,"   -nombre -linea", CHAR_CR, CHAR_LF
            db CHAR_HTAB, "Linea en mayusculas (",STATE_UPPERLINE, "):   -nombre -linea", CHAR_CR, CHAR_LF
            db CHAR_HTAB, "Linea en minusculas (",STATE_LOWERLINE, "):   -nombre -linea", CHAR_CR, CHAR_LF
            db CHAR_HTAB, "Borrar linea (",STATE_ERASELINE, "):", CHAR_HTAB,"   -nombre -linea", CHAR_CR, CHAR_LF
            db CHAR_HTAB, "Copiar rect. de texto (",STATE_COPYCLIP, "): -nombre -linea1 -columna1 -linea2 -columna2", CHAR_CR, CHAR_LF
            db CHAR_HTAB, "Cortar rect. de texto (",STATE_CUTCLIP, "): -nombre -linea1 -columna1 -linea2 -columna2", CHAR_CR, CHAR_LF
            db CHAR_HTAB, "Pegar rect. de texto (",STATE_PASTECLIP, "):  -nombre -linea -columna", CHAR_CR, CHAR_LF
            db CHAR_HTAB, "Buscar y reemplazar (",STATE_REPLACEC, "):   -nombre -caracter a reemplazar -texto", CHAR_NULL

    outputPromptA   db "El texto se", CHAR_NULL
    outputPromptB   db "correctamente:", CHAR_NULL
    outputCreate    db "creo", CHAR_NULL
    outputInsert    db "inserto", CHAR_NULL
    outputOverwrite db "sobreescribio", CHAR_NULL
    outputEncrypt   db "encripto", CHAR_NULL
    outputDecrypt   db "desencripto", CHAR_NULL
    outputCapLine   db "paso a versalles", CHAR_NULL
    outputUpperLine db "paso a mayusculas", CHAR_NULL
    outputLowerLine db "paso a minusculas", CHAR_NULL
    outputEraseLine db "elimino", CHAR_NULL
    outputCopyClip  db "copio al portapapeles", CHAR_NULL
    outputCutClip   db "corto al portapapeles", CHAR_NULL
    outputPasteClip db "pego del portapapeles", CHAR_NULL
    outputReplaceC  db "coloco como reemplazo", CHAR_NULL

    errorLabel db "Error: ", CHAR_NULL
    errorNoState  db "El programa ha generado un error inesperado.", CHAR_NULL
    errorTestMsg  db "Este es un error de prueba para el vector de errores.", CHAR_NULL
;

; Look-up Tables

    stateTable  dw STATE_DEFAULT,   StartWrapper,       0,  0
    STATE_OFFSET = ($ - stateTable) ; Each entry contains the Code, Exec Routine*, Input Validation Routine*, Exec Str Output*
                dw STATE_HELP,      PrintHelp,          0,  0
                dw STATE_CREATE,    CreateFileWrapper,  ReadFileName,       offset outputCreate
                dw STATE_INSERT,    InsertWrapper,      WriteLineWrapper,   offset outputInsert
                dw STATE_OVERWRITE, OverwriteWrapper,   WriteLineWrapper,   offset outputOverwrite
                dw STATE_ENCRYPT,   EncryptWrapper,     CaesarLineWrapper,  offset outputEncrypt
                dw STATE_DECRYPT,   DecryptWrapper,     CaesarLineWrapper,  offset outputDecrypt
                dw STATE_CAPLINE,   CapLineWrapper,     SelectLineWrapper,  offset outputCapLine
                dw STATE_UPPERLINE, UpperLineWrapper,   SelectLineWrapper,  offset outputUpperLine
                dw STATE_LOWERLINE, LowerLineWrapper,   SelectLineWrapper,  offset outputLowerLine
                dw STATE_ERASELINE, EraseLineWrapper,   SelectLineWrapper,  offset outputEraseLine
                dw STATE_COPYCLIP,  CopyClipWrapper,    ClipInputWrapper,   offset outputCopyClip
                dw STATE_CUTCLIP,   CutClipWrapper,     ClipInputWrapper,   offset outputCutClip
                dw STATE_PASTECLIP, PasteClipWrapper,   ClipOutputWrapper,  offset outputPasteClip
                dw STATE_REPLACEC,  ReplaceCWrapper,    SearchWrapper,      offset outputReplaceC

    TABLE_SIZE = ($ - stateTable) / STATE_OFFSET
                dw ERROR_INV_CMD,   PrintError ; Fail safe state
    
    invalidChars db '/', '|', ':', ';', '?', '<', '>', '"', '*', '[', ']', ',', '.'
    INV_VECTOR_SIZE = ($ - invalidChars)

    errorVector dw offset errorNoState, offset errorTestMsg
;

    programState       dw STATE_DEFAULT
    stateEntryOffset   dw 0
    
    clipPath db ".\clipB.txt",    CHAR_NULL
    tempFile db ".\tempEdit.txt", CHAR_NULL
    filePath db CL_INPUT_SIZE dup(0)

    newlineBuffer db CHAR_CR, CHAR_LF
    coordinateA dw 0, 0 ; Line and column
    coordinateA dw 0, 0

    ; likePascalW format: first word stores line's byte count, followed by a buffer capable of fitting a full line of text + newline (CRLF)
    sourceBuffer dw 0   ; To read from target file
                 db (MAX_LINE_SIZE + 2) dup(0)
    sourceFilePtr dw 0
    
    auxiliarBuffer dw 0 ; Stores line input or to read from clipboard
                   db (MAX_LINE_SIZE + 2) dup(0)
    auxiliarFilePtr dw 0
    
    searchBuffer db 0 ; Stores single char or string to find
                 db CL_INPUT_SIZE dup(0)

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
        Mov programState, STATE_HALT ; Placeholder

        Jmp END_ReadInput  ; Skip error flagging line
    FLAG_NoInput:
        Mov programState, STATE_HELP
    END_ReadInput:
        Pop bx
        Pop ax
        Ret
    ReadInput endP

    ReadFileName proc
        Ret
    ReadFileName endP

    ReadInt proc
        Ret
    ReadInt endP

    ReadString proc
        Ret
    ReadString endP

    WriteLineWrapper proc
        ; ReadFileName > path
        ; ReadInt > Line1
        ; ReadInt > Column1
        ; ReadString > TextBuffer
        Ret
    WriteLineWrapper endP

    CaesarLineWrapper proc
        ; ReadFileName > path
        ; ReadInt > Line1
        ; Read char to byte buffer
        Ret
    CaesarLineWrapper endP

    SelectLineWrapper proc
        ; ReadFileName > path
        ; ReadInt > Line1
        Ret
    SelectLineWrapper endP

    ClipInputWrapper proc
        ; ReadFileName > path
        ; ReadInt > Line1
        ; ReadInt > Column1
        ; ReadInt > Line2
        ; ReadInt > Column2
        Ret
    ClipInputWrapper endP

    ClipOutputWrapper proc
        ; ReadFileName > path
        ; ReadInt > Line1
        ; ReadInt > Column1
        Ret
    ClipOutputWrapper endP

    SearchWrapper proc
        ; ReadFileName > path
        ; Read char to byte buffer
        ; ReadString > TextBuffer
        Ret
    SearchWrapper endP

    ; Prints AboutMe and validates user inputs
    ; Inputs: Expects a valid command line input
    ; Output: Sends AboutMe to standard output
    StartWrapper proc
        Call PrintAboutMe
        Call ReadInput
        Ret
    StartWrapper endP

    CreateFileWrapper proc
        Ret
    CreateFileWrapper endP

    InsertWrapper proc
        Ret
    InsertWrapper endP

    OverwriteWrapper proc
        Ret
    OverwriteWrapper endP

    EncryptWrapper proc
        Ret
    EncryptWrapper endP

    DecryptWrapper proc
        Ret
    DecryptWrapper endP

    CapLineWrapper proc
        Ret
    CapLineWrapper endP

    UpperLineWrapper proc
        Ret
    UpperLineWrapper endP

    LowerLineWrapper proc
        Ret
    LowerLineWrapper endP

    EraseLineWrapper proc
        Ret
    EraseLineWrapper endP

    CopyClipWrapper proc
        Ret
    CopyClipWrapper endP

    CutClipWrapper proc
        Ret
    CutClipWrapper endP

    PasteClipWrapper proc
        Ret
    PasteClipWrapper endP

    ReplaceCWrapper proc
        Ret
    ReplaceCWrapper endP


    ; Routine for example state
    ; Inputs: ...
    ; Outputs: Sets programState to halt if no error occured
    ExampleRoutine proc
        Call PrintAX
        Call PrintCRLF
        Mov programState, STATE_HALT
        Ret
    ExampleRoutine endP

    ; Finds the data row's offset for the current state of the program
    ; Inputs: programState - Expects a valid state code in variable
    ; Outputs: [stateEntryOffset] Index to row address in stateTable.
    ;                             If state invalid, index to fail safe row
    FindStateEntry proc
        Push cx
        Push dx

        Xor bx, bx           ; Base to address stateTable contents
        Mov cx, TABLE_SIZE
        Mov dx, programState ; Copy to reg for mem to mem comparison

    ITER_FindStateRoutine:
        Cmp dx, word ptr stateTable[bx]
        Je END_FindStateRoutine         ; Routine address found, halt
        Add bx, STATE_OFFSET            ; Otherwise, point to next row
        Loop ITER_FindStateRoutine

        ; If out of range, BX points to failsafe state address
        Mov dx, word ptr stateTable[bx]
        Mov programState, dx ; Update invalid program state with error state

    END_FindStateRoutine:
        Mov stateEntryOffset, bx
        Pop dx
        Pop cx
        Ret
    FindStateEntry endP

    ; Calls the routine associated with the state of the program
    ; Inputs: Expects a valid base address in [stateEntryOffset]
    ; Outputs: Executes a routine through its address
    RunState proc
        Push si

        Mov si, stateEntryOffset
        Call word ptr stateTable[si + word] ; Offset by 2 to point at routine address

        Pop si
        Ret
    RunState endP
    

    main:
        Mov ax, ds
        Mov es, ax ; Save PSP's address

        Mov ax, StackSegment
        Mov ss, ax ; Set stack's address

        Mov ax, DataSegment
        Mov ds, ax ; Set data's address

        

        Mov ax, 3C00h
        Mov dx, offset path
        Xor cx, cx
        Int 21h

        Jnc aux
        Call PrintAX
        Call PrintCRLF
        Jmp exit

    aux:
        Mov bx, ax
        Mov ax, 3E00h
        Int 21h

        Jmp exit

    
    ITER_main:
        Call FindStateEntry
        Call RunState
        Cmp programState, STATE_HALT
        Jne ITER_main

    exit:
        Mov al, 00h
        Mov ah, 4Ch
        Int 21h


CodeSegment endS

end main