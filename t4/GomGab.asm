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
        DOS_INPUT_CHAR  = 01h
        DOS_PRINT_CHAR  = 02h
        DOS_PRINT_STR   = 09h
        DOS_CREATE_FILE = 3Ch
        DOS_OPEN_FILE   = 3Dh
        DOS_CLOSE_FILE  = 3Eh
        DOS_READ_FILE   = 3Fh
        DOS_WRITE_FILE  = 40h
        DOS_SET_FILEPTR = 42h
        DOS_EXIT        = 4Ch
    ;

    ; File Functions
        FILE_ACCESS_READ  = 00h
        FILE_ACCESS_WRITE = 01h
        FILE_ACCESS_RW    = 02h
        FILEPTR_SOF_POS   = 00h
        FILEPTR_CUR_POS   = 01h
        FILEPTR_EOF_POS   = 02h
    ;

    ; ASCII
        CHAR_NULL   = 00h
        CHAR_CR     = 0Dh
        CHAR_LF     = 0Ah
        CHAR_SPACE  = 20h
        CHAR_HTAB   = 09h
        CHAR_BSLASH = 5Ch
        CHAR_DOT    = 2Eh
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
        ERROR_ILLEGAL_PATH   = 8002h
        ERROR_EXTENSION      = 8003h
        ERROR_NON_INTEGER    = 8004h
        ERROR_OVERFLOW       = 8005h
        ERROR_MISSING_INPUT  = 8006h
        ERROR_COLUMN_LIMIT   = 8007h
        ERROR_PATH_NOT_FOUND = 8008h
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
            db CHAR_HTAB, "Crear archivo (",STATE_CREATE, "):", CHAR_HTAB,"   -ruta", CHAR_CR, CHAR_LF
            db CHAR_HTAB, "Insertar linea (",STATE_INSERT, "):", CHAR_HTAB,"   -ruta -linea -columna -texto", CHAR_CR, CHAR_LF
            db CHAR_HTAB, "Sobreescribir linea (",STATE_OVERWRITE, "):   -ruta -linea -columna -texto", CHAR_CR, CHAR_LF
            db CHAR_HTAB, "Encriptar linea (",STATE_ENCRYPT, "):", CHAR_HTAB,"   -ruta -linea -caracter de encriptacion ", CHAR_CR, CHAR_LF
            db CHAR_HTAB, "Desencriptar linea (",STATE_DECRYPT, "):", CHAR_HTAB,"   -ruta -linea -caracter de encriptacion ", CHAR_CR, CHAR_LF
            db CHAR_HTAB, "Linea en versalles (",STATE_CAPLINE, "):", CHAR_HTAB,"   -ruta -linea", CHAR_CR, CHAR_LF
            db CHAR_HTAB, "Linea en mayusculas (",STATE_UPPERLINE, "):   -ruta -linea", CHAR_CR, CHAR_LF
            db CHAR_HTAB, "Linea en minusculas (",STATE_LOWERLINE, "):   -ruta -linea", CHAR_CR, CHAR_LF
            db CHAR_HTAB, "Borrar linea (",STATE_ERASELINE, "):", CHAR_HTAB,"   -ruta -linea", CHAR_CR, CHAR_LF
            db CHAR_HTAB, "Copiar rect. de texto (",STATE_COPYCLIP, "): -ruta -linea1 -columna1 -linea2 -columna2", CHAR_CR, CHAR_LF
            db CHAR_HTAB, "Cortar rect. de texto (",STATE_CUTCLIP, "): -ruta -linea1 -columna1 -linea2 -columna2", CHAR_CR, CHAR_LF
            db CHAR_HTAB, "Pegar rect. de texto (",STATE_PASTECLIP, "):  -ruta -linea -columna", CHAR_CR, CHAR_LF
            db CHAR_HTAB, "Buscar y reemplazar (",STATE_REPLACEC, "):   -ruta -caracter a reemplazar -texto", CHAR_CR, CHAR_LF, CHAR_CR, CHAR_LF
            db "Ruta: nombre de archivo sin extension. Separador es \, se permite .\ al inicio", CHAR_NULL
    
    fileRewritePrompt db "El archivo ya existe. Desea sobreescribirlo? (s/n): ", CHAR_NULL
    fileRewriteHalt   db "Se ha cancelado la creacion del archivo.", CHAR_NULL

    outputPromptA   db "El texto se ", CHAR_NULL
    outputPromptB   db " correctamente:", CHAR_NULL
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
    errorInvCommand  db "El comando solicitado no es valido. Vea la ayuda con A", CHAR_NULL
    errorIllegalPath db "La ruta del archivo no permite los simbolos "
    invalidChars db ',','/', '|', ':', ';', '?', '<', '>', '"', '*', '[', ']'
    INV_VECTOR_SIZE = ($ - invalidChars)
                 db CHAR_NULL
    errorExtension  db "No se permite indicar una extension de archivo .*", CHAR_NULL
    errorNonInteger db "Debe ingresar un digito decimal para parametros de linea y columna", CHAR_NULL
    errorOverflow   db "El numero de linea excede el rango maximo de 0 a 65535", CHAR_NULL
    errorMissingInput db "Debe completar los parametros del comando. Ingrese A para ver la ayuda", CHAR_NULL
    errorColumnLimit db "El numero de columna excede el rango permitido de 0 a 255", CHAR_NULL
    errorPathNotFound db "No se pudo localizar el archivo con la ruta ingresada", CHAR_NULL

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
                dw ERROR_INV_CMD,   PrintError, 0, 0 ; Fail safe state

    errorVector dw offset errorNoState, offset errorInvCommand, offset errorIllegalPath, offset errorExtension, offset errorNonInteger
                dw offset errorOverflow, offset errorMissingInput, offset errorColumnLimit, offset errorPathNotFound
;

    programState       dw STATE_DEFAULT
    stateEntryOffset   dw 0
    
    clipHandle dw 0
    clipPath db ".\clipB.txt",    CHAR_NULL

    tempHandle dw 0
    tempPath db ".\~temp~.txt", CHAR_NULL

    targetHandle dw 0
    filePath db CL_INPUT_SIZE dup(0)

    newlineBuffer db CHAR_CR, CHAR_LF
    coordinateA dw 0, 0 ; Line and column
    coordinateB dw 0, 0

    ; likePascalW format: first word stores line's byte count, followed by a buffer capable of fitting a full line of text + newline (CRLF)
    sourceBuffer dw 0   ; To read from target file
                 db (MAX_LINE_SIZE + 2) dup(0)
    
    auxiliarBuffer dw 0 ; Stores line input or to read from clipboard
                   db (MAX_LINE_SIZE + 2) dup(0)

    mergeBuffer dw 0    ; To insert text, to overwrite in a line or to clip a line
                db MAX_LINE_SIZE dup(0)
    
    charBuffer db 0

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

    ; Prints a like Pascal string reference char by char until its size count is over
    ; Inputs: SI - Address to string variable
    ; Outputs: Sends each char to standard output via DOS' routine
    PrintLikePW proc
        Push ax
        Push dx
        Push si

        Mov cx, word ptr [si]   ; Retrieve pascal counter (word)
        Jcxz END_PrintLikePW
        
        Xor al, al
        Mov ah, DOS_PRINT_CHAR
        Inc si                  ; Point to upper byte in preparation for loop
    ITER_PrintLikePW:
        Inc si                  ; Point to next char
        Mov dl, byte ptr [si]   ; Read char
        Int 21h
        Loop ITER_PrintLikePW

    END_PrintLikePW:
        Pop si
        Pop dx
        Pop ax
        Ret
    PrintLikePW endP

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
    ; Inputs: Expects parameters corresponding to the command input
    ; Outputs: Stores values in data variables, and flags errors if necessary
    ReadInput proc
        Push ax
        Push bx
        Push cx
        Push si

        Mov si, PSP_INPUT_OFFSET
        Xor ch, ch
        Mov cl, byte ptr es:[si]
        Cmp cx, 0                  ; Is there an input?
        Je FLAG_NoInput            ; If not, set new state, and halt proc

        ; If there is, retrieve values only
        Add cx, PSP_INPUT_OFFSET+1 ; Apply offset+1 to serve as bound for si
        Inc si                     ; Point to input-preceding whitespace
        Inc si                     ; Point to first char
        
        ; Insert detailed logic here
        Xor ah, ah
        Mov al, byte ptr es:[si] ; Retrieve command input
        Mov programState, ax     ; Assume command is valid
        Call FindStateEntry

        Cmp programState, ERROR_INV_CMD ; Halt if command is not valid
        Je END_ReadInput
        Cmp programState, STATE_HELP ; Skip reading parameters for help
        Je END_ReadInput

        Inc si
        Inc si      ; Try pointing to next parameter

        Cmp si, cx  ; Halt if input only included command with no parameters
        Jae FLAG_InputIncomplete
        
        Mov bx, stateEntryOffset ; Obtain state routine data for valid command
        Call word ptr stateTable[bx + 2*word] ; Call cmd specific input validation
        Jmp END_ReadInput                     ; Skip error flagging line

    FLAG_InputIncomplete:
        Mov programState, ERROR_MISSING_INPUT
        Jmp END_ReadInput

    FLAG_NoInput:
        Mov programState, STATE_HELP
    END_ReadInput:
        Pop si
        Pop cx
        Pop bx
        Pop ax
        Ret
    ReadInput endP

    ; Tests if a char value is valid in a path
    ; Inputs: AL - Char value to test
    ; Outputs: Sets CF if valid, clears CF if not valid
    IsPathValid proc
        Push cx
        Push si

        Xor si, si
        Mov cx, INV_VECTOR_SIZE ;
    ITER_IsPathValid:
        Cmp al, byte ptr invalidChars[si]
        Je FLAG_PathInvalid ; If found, char is invalid
        Inc si
        Loop ITER_IsPathValid

        Stc ; If not found in blacklist, char is valid
        Jmp END_IsPathValid

    FLAG_PathInvalid:
        Clc
    END_IsPathValid:
        Pop si
        Pop cx
        Ret
    IsPathValid endP

    ; Aux routine that validates a parameter as a complete file path or just a name
    ; Inputs: ES:[SI] - Expects pointer to first char in parameter
    ;         CX - Expects pointer to last char in entire CL input
    ; Outputs: ES:[SI] - Sets pointer after last char of param if no error ocurred
    ;          DS:[filepath] - Saves path as ASCIIZ, concatenates .txt extension
    ;          CF            - Set if CL input is over, cleared in any other case
    ReadFileName proc
        Push di

        Xor di, di          ; Base address for filepath variable

        Mov ah, CHAR_BSLASH
        Mov al, CHAR_DOT    ; Set ax = '\.', little-endian = .\

        Cmp word ptr es:[si], ax ; If input is not a relative path
        Jne ITER_ReadFileName    ; skip to general validation algorithm

        Mov word ptr filepath[di], ax ; Save relative path prefix
        Inc di
        Inc di
        Inc si
        Inc si ; Adjust both pointers to offset from prefix
    
    ITER_ReadFileName:
        Cmp si, cx               ; If CL input is over, halt
        Jae AUX_ReadFileName

        Mov al, byte ptr es:[si] ; Retrieve char
        Cmp al, CHAR_SPACE       ; If parameter was fully read, halt
        Je END_ReadFileName      ; CF = 0 if Equal

        Call IsPathValid         ; If char is not permitted in path, flag error
        Jnc FLAG_IllegalPath

        Cmp al, CHAR_DOT    ; Flag error if user attempted to specify an extension
        Je FLAG_Extension   ; CF = 0 if Equal

        Mov byte ptr filepath[di], al ; Save valid char in path buffer
        Inc di                        ; Point to next byte in buffer
        Inc si                        ; Point to next byte in input
        Jmp ITER_ReadFileName         ; Continue until parameter or input is consumed

    AUX_ReadFileName: ; Necessary to set CF for end of input, other halting cases clear implicitly 
        Stc
        Jmp END_ReadFileName

    FLAG_IllegalPath:
        Mov programState, ERROR_ILLEGAL_PATH
        Jmp END_ReadFileName
    FLAG_Extension:
        Mov programState, ERROR_EXTENSION
    
    END_ReadFileName:
        Mov byte ptr filepath[di],   '.'
        Mov byte ptr filePath[di+1], 't'
        Mov byte ptr filepath[di+2], 'x'
        Mov byte ptr filepath[di+3], 't'
        Pop di
        Ret
    ReadFileName endP

    ; Aux routine that validates a parameter as a number for a line or column
    ; Inputs: ES:[SI] - Expects pointer to first char in parameter
    ;         DS:[DI] - Word sized variable to store value
    ;         CX - Expects pointer to last char in entire CL input
    ; Outputs: ES:[SI] - Sets pointer after last char of param if no error ocurred
    ;          DS:[DI] - Int value from parameter
    ;          CF      - Set if CL input is over, cleared in any other case
    ReadInt proc
        Push ax
        Push bx
        Push dx

        Xor ax, ax
        Xor bh, bh
    ITER_ReadInt:
        Cmp si, cx               ; If CL input is over, halt
        Jae AUX_ReadInt

        Mov bl, byte ptr es:[si] ; Retrieve char value
        Cmp bl, CHAR_SPACE       ; Halt if end of parameter was reached
        Je END_ReadInt           ; CF = 0

        Xor bl, 30h     ; Obtain int from char data
        Cmp bl, 10      ; Halt and flag error if digit is not decimal
        Jae FLAG_NonInt ; CF = 0 when bl = 10 or bl > 10

        Mul base
        Jc FLAG_Overflow ; Set error if input overflows into dx
        Add ax, bx
        Jc FLAG_Overflow ; Set error state if input exceeds word capacity

        Inc si           ; Point to next byte
        Jmp ITER_ReadInt

    AUX_ReadInt:
        Stc
        Jmp END_ReadInt
    
    FLAG_Overflow:
        Clc
        Mov programState, ERROR_OVERFLOW
        Jmp END_ReadInt

    FLAG_NonInt:
        Mov programState, ERROR_NON_INTEGER

    END_ReadInt:
        Mov word ptr ds:[di], ax
        Pop dx
        Pop bx
        Pop ax
        Ret
    ReadInt endP

    ; Aux routine that stores remaining CL input as a string parameter in a likePascalW buffer
    ; Inputs: ES:[SI] - Expects pointer to first char in parameter
    ;         DS:[DI] - LikePascalW buffer variable
    ;         CX - Expects pointer to last char in entire CL input
    ; Outputs: ES:[SI] - Sets pointer after last char of input
    ;          DS:[DI] - Saves parameter in likePascalW format
    ReadString proc
        Push ax
        Push ds
        Push es
        Push cx
        Push di

        Sub cx, si          ; Obtain remaining byte count
        Jbe END_ReadString  ; Halt if input was already consumed previously

        Mov word ptr ds:[di], cx ; Otherwise, store byte count in Pascal variable's first field
        Inc di
        Inc di                   ; Set pointer at buffer field
        Cld                      ; Prep for sequential transfer

        Mov ax, ds               ; Save DATASG
        Push es
        Pop ds                   ; Set DS = PSP
        Mov es, ax               ; and ES = DATASG
        Rep Movsb                ; Transfer from PSP:SI (input) to DATASG:DI (variable)

    END_ReadString:
        Pop di
        Pop cx
        Pop es
        Pop ds
        Pop ax
        Ret
    ReadString endP

    ; Aux routine, reads two int parameters corresponding to a line and column
    ; Inputs: ES:[SI] - Pointer to first parameter in PSP input
    ;         DS:[DI] - Pointer to coordinate variable
    ; Outputs: ES:[SI]        - Sets pointer after last char of column param if no error ocurred
    ;          DS:[DI]        - Int values for line and column numbers
    ;          CF             - Set if input is over after reading column param
    ;          [programState] - An error may be set for missing input if column is missing,
    ;                           overflow if line num exceeds word capacity, if column exceeds
    ;                           line limit of 256
    ReadCoordinate proc
        Push di

        Call ReadInt                    ; Save int param at coordinate.line field
        Jc FLAG_IncompletePair          ; Halt and set error state if input is over after line param
        Cmp programState, STATE_ERROR   ; Halt if line num param had an error
        Jae END_ReadCoordinate          ; CF = 0 for x >= y, won't lead to confusions for CF="input is over after col"

        Inc si ; Set offset to first char of next param
        Inc di
        Inc di ; Set offset to coordinate.column field

        Call ReadInt ; Save int param for column. Sets CF if input is over, may flag error states

        Pushf                                ; Backup CF to avoid loss in adjustment logic
        Cmp programState, ERROR_OVERFLOW
        Jne AUX_ReadCoordinate1
        Mov programState, ERROR_COLUMN_LIMIT ; Set correct error handling if overflow in column
    
    AUX_ReadCoordinate1:
        Cmp programState, STATE_ERROR   ; Skip range validation if another error occured
        Jae AUX_ReadCoordinate2

        Cmp word ptr ds:[di], MAX_LINE_SIZE ; Skip error flagging if value is inside range
        Jb AUX_ReadCoordinate2

        Mov programState, ERROR_COLUMN_LIMIT ; Flag state error for column out of range

    AUX_ReadCoordinate2: ; Restore CF result and halt
        Popf
        Jmp END_ReadCoordinate

    FLAG_IncompletePair:
        Clc                 ; Clear to avoid confusion with input is over after column param
        Mov programState, ERROR_MISSING_INPUT
    END_ReadCoordinate:

        Pop di
        Ret
    ReadCoordinate endP

    ; Wrapper for comprehensive input parsing and validation for Insertion and Overwrite commands
    ; Inputs: ES:[SI] - Expects all requested parameters with valid values
    ; Outputs: [programState] - May set an error state if there are missing parameters or invalid values
    WriteLineWrapper proc
        Push di

        Call ReadFileName
        Jc FLAG_WriteLineIncomplete     ; If input is over after reading a single param, halt & set error state
        Cmp programState, STATE_ERROR
        Jae END_WriteLineWrapper        ; Halt if filename param had an error

        Inc si                          ; Ajust offset, prev routine halted at whitespace preceeding next param
        Mov di, offset coordinateA      ; Set coord param

        Call ReadCoordinate             ; Attempt to read line and column from input
        Jc FLAG_WriteLineIncomplete     ; Halt if input's is over after reading column
        Cmp programState, STATE_ERROR   ; Halt if either input had an error
        Jae END_WriteLineWrapper

        Inc si ; Point to last parameter
        Mov di, offset auxiliarBuffer
        Call ReadString

        Jmp END_WriteLineWrapper

    FLAG_WriteLineIncomplete:
        Mov programState, ERROR_MISSING_INPUT
    END_WriteLineWrapper:
        Pop di
        Ret
    WriteLineWrapper endP

    ; Wrapper for comprehensive input parsing and validation for line cmds: Capitalization, UpperCase, LowerCase, & Erase
    ; Inputs: ES:[SI] - Expects all requested parameters with valid values
    ; Outputs: [programState] - May set an error state if there are missing parameters or invalid values
    SelectLineWrapper proc
        Push di
        Call ReadFileName
        Jc FLAG_SelectLineIncomplete     ; If input is over after reading a single param, halt & set error state
        Cmp programState, STATE_ERROR
        Jae END_SelectLineWrapper        ; Halt if filename param had an error

        Inc si                          ; Set offset at beginning of next param
        Mov di, offset coordinateA
        Call ReadInt                    ; Save int param at coordinateA.line field, may flag an error state
        Jmp END_SelectLineWrapper       ; Skip error flagging for incomplete params

    FLAG_SelectLineIncomplete:
        Mov programState, ERROR_MISSING_INPUT
    END_SelectLineWrapper:
        Pop di
        Ret
    SelectLineWrapper endP

    ; Wrapper for comprehensive input parsing and validation for Encryption and Decryption commands
    ; Inputs: ES:[SI] - Expects all requested parameters with valid values
    ; Outputs: [programState] - May set an error state if there are missing parameters or invalid values
    CaesarLineWrapper proc
        Push ax
        Call SelectLineWrapper       ; Attempt to read filename and line from input
        Jc FLAG_CaesarLineIncomplete ; Halt if input is missing encryption char param
        Cmp programState, STATE_ERROR
        Jae END_CaesarLineWrapper    ; Halt if an error ocurred in either param

        Inc si                       ; Set offset at beginning of next param
        Mov al, byte ptr es:[si] 
        Mov charBuffer, al           ; Store encryption key in char buffer
        Jmp END_CaesarLineWrapper
        
    FLAG_CaesarLineIncomplete:
        Mov programState, ERROR_MISSING_INPUT
    END_CaesarLineWrapper:
        Pop ax
        Ret
    CaesarLineWrapper endP

    ; Wrapper for comprehensive input parsing and validation for Copy and Cut commands
    ; Inputs: ES:[SI] - Expects all requested parameters with valid values
    ; Outputs: [programState] - May set an error state if there are missing parameters or invalid values
    ClipInputWrapper proc
        Push di

        Call ReadFileName
        Jc FLAG_ClipInputIncomplete     ; If input is over after reading a single param, halt & set error state
        Cmp programState, STATE_ERROR
        Jae END_WriteLineWrapper        ; Halt if filename param had an error

        Inc si                          ; Ajust offset, prev routine halted at whitespace preceeding next param
        Mov di, offset coordinateA      ; Set coord param

        Call ReadCoordinate             ; Attempt to read first upper left coordinate from input
        Jc FLAG_ClipInputIncomplete     ; Halt if input's is over after reading column
        Cmp programState, STATE_ERROR   ; Halt if either input had an error
        Jae END_WriteLineWrapper

        Inc si ; Point to last parameter
        Mov di, offset coordinateB
        Call ReadCoordinate ; Attempt to read first upper left coordinate from input, may flag state errors
        Jmp END_WriteLineWrapper

    FLAG_ClipInputIncomplete:
        Mov programState, ERROR_MISSING_INPUT
    END_ClipInputWrapper:
        Pop di
        Ret
    ClipInputWrapper endP

    ; Wrapper for comprehensive input parsing and validation for Clipboard Paste command
    ; Inputs: ES:[SI] - Expects all requested parameters with valid values
    ; Outputs: [programState] - May set an error state if there are missing parameters or invalid values
    ClipOutputWrapper proc
        Call SelectLineWrapper       ; Attempt to read filename and line from input
        Jc FLAG_ClipOutputIncomplete ; Halt if input over before column param
        Cmp programState, STATE_ERROR
        Jae END_ClipOutputWrapper    ; Halt if an error ocurred in either param

        Inc si                          ; Set offset at beginning of next param
        Mov di, offset [coordinateA+word]
        Call ReadInt                    ; Save int param in column field, may flag an error state
        Jmp END_ClipOutputWrapper       ; Skip error flagging for incomplete params

    FLAG_ClipOutputIncomplete:
        Mov programState, ERROR_MISSING_INPUT
    END_ClipOutputWrapper:
        Ret
    ClipOutputWrapper endP

    ; Wrapper for comprehensive input parsing and validation for Find and Replace command
    ; Inputs: ES:[SI] - Expects all requested parameters with valid values
    ; Outputs: [programState] - May set an error state if there are missing parameters or invalid values
    SearchWrapper proc
        Push ax
        Push di

        Call ReadFileName
        Jc FLAG_SearchIncomplete      ; If input is over after reading a single param, halt & set error state
        Cmp programState, STATE_ERROR
        Jae END_SearchWrapper         ; Halt if filename param had an error

        Inc si                        ; Set offset at beginning of next param
        Mov al, byte ptr es:[si]
        Mov charBuffer, al            ; Store char target

        Inc si
        Inc si      ; Try pointing to next parameter

        Cmp si, cx  ; Halt if input only included command and char with no replacement text param
        Jae FLAG_SearchIncomplete

        Mov di, offset auxiliarBuffer
        Call ReadString
        Jmp END_SearchWrapper

    FLAG_SearchIncomplete:
        Mov programState, ERROR_MISSING_INPUT
    END_SearchWrapper:
        Pop di
        Pop ax
        Ret
    SearchWrapper endP

    ; Execution wrappers

    ; Prints AboutMe and validates user inputs
    ; Inputs: Expects a valid command line input
    ; Output: Sends AboutMe to standard output
    StartWrapper proc
        Call PrintAboutMe
        Call ReadInput
        Ret
    StartWrapper endP

    ; Prints the corresponding result prompt of a command
    ; Inputs: n/a
    ; Outputs: Sends individual sentences to the standard output in order
    PrintResultPrompt proc
        Push si
        Push bx

        Mov si, offset outputPromptA
        Call PrintLikeC

        Mov bx, stateEntryOffset
        Mov si, stateTable[bx + 3*word] ; Retrieve ptr from output str field in state data
        Call PrintLikeC

        Mov si, offset outputPromptB
        Call PrintLikeC
        Call PrintCRLF

        Pop bx
        Pop si
        Ret
    PrintResultPrompt endP

    ; Attempts to locate the desired file by opening it
    ; Inputs: [filePath] - Valid path of requested file to create
    ; Outputs: CF - Sets CF if file is already present, clears if file is not present
    IsFilePresent proc
        Mov ah, DOS_OPEN_FILE
        Xor al, al              ; Mode: Read only
        Int 21h                 ; Attempt to locate file
        Jc AUX_IsFilePresent    ; Skip closing file if an error ocurred
        
        
        Mov bx, ax              ; Set opened file handle
        Mov ah, DOS_CLOSE_FILE
        Xor al, al
        Int 21h                 ; Request file closure, CF = 0 (file present)
        
    AUX_IsFilePresent: ; CF = 1 (file not present)
        Cmc            ; Complement to align value with boolean statement
        Ret
    IsFilePresent endP

    ; Processes a request for a file creation command. It performs error checking
    ; for existing files and missing paths
    ; Inputs: [filePath] - Valid file name read from CL
    ; Outputs: Result of the operation
    CreateFileWrapper proc
        Push ax
        Push bx
        Push cx
        Push dx
        Push si
        
        Mov dx, offset filePath   ; Set ASCIIZ for file op

        Call IsFilePresent
        Jnc CREATE_CreateFileWrapper ; If file can't be opened, try creating it

        Mov si, offset fileRewritePrompt
        Call PrintLikeC
        Mov ah, DOS_INPUT_CHAR
    ITER_CreateFileWrapper:
        Int 21h                    ; Request confirmation
        Cmp al, 's'
        Je AUX_CreateFileWrapper   ; Continue if yes
        Cmp al, 'n'
        Jne ITER_CreateFileWrapper ; Iter until valid input
        Jmp CANCEL_CreateFileWrapper ; Halt if no
    
    AUX_CreateFileWrapper:
        Call PrintCRLF
    CREATE_CreateFileWrapper:
        Xor al, al
        Mov ah, DOS_CREATE_FILE ; Attempt to create file
        Mov cx, 00h             ; Set file attributes
        Int 21h
        Jnc CLOSE_CreateFileWrapper ; If successful, close file and print result

        Mov programState, ERROR_PATH_NOT_FOUND ; Otherwise, flag error state
        Jmp END_CreateFileWrapper
    
    CLOSE_CreateFileWrapper:
        Mov bx, ax              ; Set file handle
        Mov ah, DOS_CLOSE_FILE  ; Request file closure
        Xor al, al
        Int 21h

        Call PrintResultPrompt
        Mov si, dx              ; Set filepath for printing
        Call PrintLikeC
        Jmp HALT_CreateFileWrapper
    
    CANCEL_CreateFileWrapper:
        Call PrintCRLF          ; Print result of command cancellation
        Mov si, offset fileRewriteHalt
        Call PrintLikeC
        Call PrintCRLF

    HALT_CreateFileWrapper:
        Mov programState, STATE_HALT
    END_CreateFileWrapper:
        Pop si
        Pop dx
        Pop cx
        Pop bx
        Pop ax
        Ret
    CreateFileWrapper endP

    ; Adjusts the position of a file handle to point at the beginning of a line
    ; Inputs: BX - File handle
    ;         CX - Offset to apply from current position
    ; Outputs: n/a
    AlignFilePosition proc
        Push ax
        Push cx
        Push dx

        Mov ah, DOS_SET_FILEPTR
        Mov al, FILEPTR_CUR_POS
        Mov dx, cx              ; Parameter is CX:DX, set offset in lower value
        Mov cx, 0FFFFh          ; Sign extend upper value
        Neg dx                  ; Complement to move position backwards
        Int 21h

        Pop dx
        Pop cx
        Pop ax
        Ret
    AlignFilePosition endP

    ; Counts the size of a line until a CR char is found
    ; Inputs: DX - Offset to pascal buffer field
    ;         CX - Total byte count in buffer
    ; Outputs: [DX-word] - Stores line size in pascal size field
    ;           CX       - Byte count excluding current line size + CRLF
    CountLine proc
        Push es
        Push ax
        Push si
        Push di

        Mov di, dx              ; To index likePascal buffer
        Mov si, di
        Dec si
        Dec si                  ; To index pascal size field
        Mov word ptr ds:[si], 0 ; Reset prev line count

        Jcxz END_CountLine; If nothing was read, keep empty count
        ; Otherwise, buffer is at least size 2 due to CRLF

        Mov al, CHAR_CR ; To identify end of line
    ITER_CountLine:
        Cmp al, byte ptr ds:[di]    ; Halt if line is over
        Je AUX_CountLine
        Inc word ptr ds:[si]        ; Count column
        Inc di                      ; Point to next char
        Loop ITER_CountLine
    
    AUX_CountLine:  ; Cx has remaining byte count after iteration
        Dec cx
        Dec cx      ; Adjust for CRLF from current line

    END_CountLine:
        Pop di
        Pop si
        Pop ax
        Pop es
        Ret
    CountLine endP

    ; Reads an expected full line from a file and obtains its size
    ; Inputs: BX - Open file handle
    ;         DX - Offset to likePascalW buffer field
    ; Outputs: [DX] - Line size (excluding CRLF) and contents in pascal buffer
    ;           AX  - Total byte count read from file
    ReadLine proc
        Push cx
        Push di

        Xor al, al
        Mov ah, DOS_READ_FILE
        Mov cx, MAX_LINE_SIZE+2 ; Attempt to read a full line + CRLF chars
        Int 21h                 ; Request at DX's buffer
        Jnc AUX_ReadLine

        Call PrintCRLF
        Call PrintAX        ; TODO: Error handling for read operation
        Call PrintCRLF
        Jmp END_ReadLine

    AUX_ReadLine:
        Mov cx, ax             ; Set total byte count as param for upcoming routine
        Call CountLine         ; Update size field with line size, set CX with remaining size
        Call AlignFilePosition ; Set file position at the end of current line using CX as offset

    END_ReadLine:
        Pop di
        Pop cx
        Ret
    ReadLine endP

    ; Writes the current line of a buffer in a specified file
    ; Inputs:    Bx  - File handle
    ;           [Dx] - Address of likePascalW buffer
    ; Outputs: CF - Set if an error ocurred ; TODO implement error flag
    WriteLineToFile proc
        Push ax
        Push cx
        Push dx
        Push si

        Xor al, al
        Mov ah, DOS_WRITE_FILE
        Mov si, dx              ; Obtain buffer address
        Mov cx, [si-word]       ; Write buffer up to its preceeding count variable
        Int 21h
        Jc FLAG_WriteLineToFile  ; Flag error state if necessary

        Cmp ax, cx
        Jb FLAG_WriteLineToFile  ; Flag error if requested write count wasn't completed

        Xor al, al
        Mov ah, DOS_WRITE_FILE
        Mov cx, 2
        Mov dx, offset newlineBuffer ; Set newline delimiter
        Int 21h
        Jc FLAG_WriteLineToFile  ; Flag write error

        Cmp ax, cx
        Jb FLAG_WriteLineToFile  ; Flag write count error
        Jmp END_WriteLineToFile  ; Skip error flagging if operation was succesful

    FLAG_WriteLineToFile:
        Call PrintCRLF
        Call PrintAX        ; TODO: Error handling for read operation
        Call PrintCRLF

    END_WriteLineToFile:
        Pop si
        Pop dx
        Pop cx
        Pop ax
        Ret
    WriteLineToFile endP

    ; Writes the current line of a buffer in the clipboard file
    ; Inputs: [Dx] - Address of likePascalW buffer
    ; Outputs: CF - Set if an error ocurred ; TODO implement error flag
    WriteLineToClip proc
        Push bx
        Mov bx, clipHandle
        Call WriteLineToFile
        Pop bx
        Ret
    WriteLineToClip endP

    ; Writes the current line of a buffer in the temporary work file
    ; Inputs: [Dx] - Address of likePascalW buffer
    ; Outputs: CF - Set if an error ocurred ; TODO implement error flag
    WriteLineToTemp proc
        Push bx
        Mov bx, tempHandle
        Call WriteLineToFile
        Pop bx
        Ret
    WriteLineToTemp endP

    ; Copies the remaining contents of a file to the temp file and closes both
    ; Inputs: BX - File handle to copy
    ;         [Dx] - Address of likePascalW buffer
    ; Outputs: Closes files and replaces the original one with the temp contents
    FinishTempFile proc
        Push ax
        Push bx

    ITER_FinishTempFile:
        Call ReadLine
        Cmp ax, 0
        Je CLOSE_FinishTempFile
        Call WriteLineToTemp
        Jmp ITER_FinishTempFile

    CLOSE_FinishTempFile:
        Mov ah, DOS_CLOSE_FILE
        Xor al, al
        Int 21h                 ; Close original file

        Mov ah, DOS_CLOSE_FILE
        Xor al, al
        Mov bx, tempHandle
        Int 21h                 ; Close temp file
        
        ; TODO:
        ; Reemplazar por logica que cierra y elimina archivo original
        ; para reemplazarlo por tempfile

        Pop bx
        Pop ax
        Ret
    FinishTempFile endP

    ; Transfers a subtring to a buffer given a byte count
    ; Inputs:  CX  - Amount of bytes to copy
    ;         [SI] - String to copy from
    ;         [DI] - Address of storage buffer
    ; Outputs: [DI] - Copy of substring
    MoveSubstringCX proc
        Push ax
        Push cx
        Push si
        Push di

        Jcxz END_MoveSubstringCX    ; Skip algorithm if request is zero transfer
    ITER_MoveSubstringCX:
        Mov al, byte ptr ds:[si]    ; Retrieve char from substring
        Mov byte ptr ds:[di], al    ; Store in destination area
        Inc si
        Inc di                      ; Advance pointers
        Loop ITER_MoveSubstringCX

    END_MoveSubstringCX:
        Pop di
        Pop si
        Pop cx
        Pop ax
        Ret
    MoveSubstringCX endP

    ; Writes space chars to a buffer area up to an specified amount
    ; Inputs:  CX - Amount of spaces to write
    ;         [DI] - Address of storage buffer
    ; Outputs: [DI] - Buffer with N space characters
    WriteSpacesCX proc
        Push cx
        Push di

        Jcxz END_WriteSpacesCX  ; Skip zero request
    ITER_WriteSpacesCX:
        Mov byte ptr ds:[di], CHAR_SPACE ; Transfer immed to memory
        Inc di                           ; Point to next area
        Loop ITER_WriteSpacesCX

    END_WriteSpacesCX:
        Pop di
        Pop cx
        Ret
    WriteSpacesCX endP

    ; Compares Cx with [Si] and returns the min value between them
    ; Inputs: Cx, [Si] - unsigned int values to compare
    ; Outputs: Cx - Contains the smallest value
    GetMinCxSi proc
        Cmp cx, word ptr ds:[si]    ; Skip value swap if cx is already min
        Jbe END_GetMinCxSi
        Mov cx, word ptr ds:[si]    ; Update cx with SI's lower value
    END_GetMinCxSi:
        Ret
    GetMinCxSi endP

    ; Aux to InsertLine: Gets byte count for a feasible insertion
    ; taking into account insertion size and available space
    ; Inputs:  [Cx]          - Expects column value requested for insertion
    ;          [mergeBuffer] - Assumes updated byte count for buffer within 0 to MAX_LINE_SIZE
    ; Outputs: Cx - Amount of times to loop a byte transfer from insertion line 
    AvailableInsertionCX proc
        Mov cx, MAX_LINE_SIZE
        Sub cx, mergeBuffer     ; Obtain remaining line capacity
        Call GetMinCxSi         ; min(both). capacity < insert size: get substring. cap >= insert: only copy up to insert size
        Ret
    AvailableInsertionCX endP

    ; Aux to InsertLine: Attempts to include right substring after text insertion
    ; Inputs:  [mergeBuffer] - Assumes updated byte count for buffer within 0 to MAX_LINE_SIZE
    ; Outputs: [mergeBuffer+word] - Updates buffer with right substring contents if possible
    BestFitInsertSubstr proc
        Push bx
        Cmp mergeBuffer, MAX_LINE_SIZE
        Je END_BestFitRightSubstring   ; If right substring can't fit, halt. Otherwise, include as many chars as possible

        Mov si, dx  ; Point to current line's size
        Mov bx, dx
        Inc bx
        Inc bx      ; To point at buffer offset
       
        Sub word ptr ds:[si], cx  ; Original size - col = right substring size
        Add bx, cx                ; Base address  + col = start of substring
        Call AvailableInsertionCX ; Get counter for byte insertion

        Xchg si, bx          ; Prep SI as substring param
        Call MoveSubstringCX
        Add mergeBuffer, cx  ; Update complete line's size field

    END_BestFitRightSubstring:
        Pop bx
        Ret
    BestFitInsertSubstr endP

    ; Aux to OverwriteLine: Attempts to include right substring after text insertion accounting for its lost chars
    ; Inputs:   AX - Count of bytes overwritten
    ;          [mergeBuffer] - Assumes updated byte count for buffer within 0 to MAX_LINE_SIZE
    ; Outputs: [mergeBuffer+word] - Updates buffer with right substring contents if possible
    BestFitOverwriteSubstr proc
        Push bx
        Cmp mergeBuffer, MAX_LINE_SIZE
        Je END_BestFitOverwriteSubstr   ; If right substring can't fit, halt. Otherwise, include as many chars as possible

        Mov si, dx  ; Point to current line's size
        Mov bx, dx
        Inc bx
        Inc bx      ; To point at buffer offset
       
        Sub word ptr ds:[si], cx  ; Original size - col = right substring size
        Cmp ax, word ptr ds:[si]  ; If overwritten count consumed entire substring, halt
        Jae END_BestFitOverwriteSubstr

        Sub word ptr ds:[si], ax ; Otherwise, only account for non overwritten substr bytes

        Add bx, cx                ; Base address  + col = start of substring
        Add bx, ax                ; Substr address + overwritten count = start of non overwritten substr
        Call AvailableInsertionCX ; Get counter for byte insertion

        Xchg si, bx          ; Prep SI as substring param
        Call MoveSubstringCX
        Add mergeBuffer, cx  ; Update complete line's size field

    END_BestFitOverwriteSubstr:
        Pop bx
        Ret
    BestFitOverwriteSubstr endP

    ; Inserts a text line to the current line of a file
    ; Inputs: [Dx] - likePascalW variable with current line size and buffer
    ;         [Ax] - likePascalW variable with line to insert in buffer
    ;          Cx  - Column value to insert at
    ; Outputs: [mergeBuffer] - Insertion result in likePascalW format
    InsertLine proc
        Push cx
        Push si
        Push di

        Mov di, offset mergeBuffer[word] ; Work area to combine lines
        Mov si, dx                 ; To access current line's buffer
        Inc si
        Inc si                     ; Point to buffer field
        Cmp cx, word ptr ds:[si-word] ; If requested column is greater than available in line, extend line size
        Ja AUX_InsertLine             ; Note: Col is restricted from 0 to 255, case 256=256 is impossible, requires no validation

        Call MoveSubstringCX    ; Obtain current line's left substring in DI
        Mov mergeBuffer, cx     ; Track remaining space for line insertion
        Add di, cx              ; Offset area to write after left substring

        Push cx ; Save column value to later use
        Mov si, ax                  ; Point to insertion line's size
        Call AvailableInsertionCX   ; Obtain count for MoveSubstring accounting for best fit insertion

        Inc si
        Inc si                  ; Point to insertion's buffer, CX and DI are already set
        Call MoveSubstringCX    ; Insertion partially complete: Line + Insertion + right substr??
        Add mergeBuffer, cx     ; Update size field to match buffer contents
        Add di, cx              ; Offset area for potential last write
        Pop cx
        
        Call BestFitInsertSubstr ; Try to include right subtring if capacity allows it
        Jmp END_InsertLine

    AUX_InsertLine:
        Mov mergeBuffer, cx      ; Update size ahead of time with column as target
        Push cx
        Mov cx, word ptr ds:[si-word] ; Prep to copy entire line to buffer, work area (DI) already set
        Call MoveSubstringCX          ; Obtain line copy
        Add di, cx                    ; Offset area to continue writing after line copy
        Pop cx

        Sub cx, word ptr ds:[si-word] ; Obtain count of spaces required to extend up to desired column
        Call WriteSpacesCX       ; Write required spaces, work area's size = column = line size + whitespace count
        Add di, cx               ; Offset in prep for next write operation

        Mov si, ax                  ; Point to insertion line's size
        Call AvailableInsertionCX   ; Obtain count for MoveSubstring accounting for best fit insertion

        Inc si
        Inc si                  ; Point to insertion's buffer, CX and DI are already set
        Call MoveSubstringCX    ; Insertion complete: Line + Whitespaces + Insertion best fit
        Add mergeBuffer, cx     ; Update size field to match buffer contents

    END_InsertLine:
        Pop di
        Pop si
        Pop cx
        Ret
    InsertLine endP

    ; Inserts a text line to the current line of a file
    ; Inputs: [Dx] - likePascalW variable with current line size and buffer
    ;         [Ax] - likePascalW variable with line to insert in buffer
    ;          Cx  - Column value to insert at
    ; Outputs: [mergeBuffer] - Overwrite result in likePascalW format
    OverwriteLine proc
        Push ax
        Push cx
        Push si
        Push di

        Mov di, offset mergeBuffer[word] ; Work area to combine lines
        Mov si, dx                       ; To access current line's buffer
        Inc si
        Inc si                        ; Point to buffer field
        Cmp cx, word ptr ds:[si-word] ; If requested column is greater than available in line, extend line size
        Ja AUX_OverwriteLine          ; Note: Col is restricted from 0 to 255, case 256=256 is impossible, requires no validation

        Call MoveSubstringCX    ; Obtain current line's left substring in DI
        Mov mergeBuffer, cx     ; Track remaining space for line overwrite
        Add di, cx              ; Offset area to write after left substring

        Push cx ; Save column value to later use
        Mov si, ax                  ; Point to overwrite line's size
        Call AvailableInsertionCX   ; Obtain count for MoveSubstring accounting for best fit insertion

        Inc si
        Inc si                        ; Point to overwrite's buffer, CX and DI are already set
        Call MoveSubstringCX          ; Overwrite partially complete: Line + Insertion + right substr??
        Add mergeBuffer, cx           ; Update size field to match buffer contents
        Add di, cx                    ; Offset area for potential last write
        Mov ax, cx                    ; Save overwrite count for upcoming best fit
        Pop cx
        
        Call BestFitOverwriteSubstr ; Try to include right subtring if capacity allows it
        Jmp END_OverwriteLine

    AUX_OverwriteLine:
        Mov mergeBuffer, cx      ; Update size ahead of time with column as target
        Push cx
        Mov cx, word ptr ds:[si-word] ; Prep to copy entire line to buffer, work area (DI) already set
        Call MoveSubstringCX          ; Obtain line copy
        Add di, cx                    ; Offset area to continue writing after line copy
        Pop cx

        Sub cx, word ptr ds:[si-word] ; Obtain count of spaces required to extend up to desired column
        Call WriteSpacesCX       ; Write required spaces, work area's size = column = line size + whitespace count
        Add di, cx               ; Offset in prep for next write operation

        Mov si, ax                  ; Point to insertion line's size
        Call AvailableInsertionCX   ; Obtain count for MoveSubstring accounting for best fit insertion

        Inc si
        Inc si                  ; Point to insertion's buffer, CX and DI are already set
        Call MoveSubstringCX    ; Insertion complete: Line + Whitespaces + Insertion best fit
        Add mergeBuffer, cx     ; Update size field to match buffer contents

    END_OverwriteLine:
        Pop di
        Pop si
        Pop cx
        Pop ax
        Ret
    OverwriteLine endP

    ; Copies a file in the temp file until a line bound is found
    ; Inserts newlines if there aren't enough lines in the original
    ; Inputs:  BX  - File handle to copy
    ;         [Dx] - Address of likePascalW buffer
    ;          Cx  - Line number bound
    ; Outputs: [Dx] - Contents of line number that bounded copy
    BoundedTempCopy proc
        Push ax

        Jcxz END_BoundedTempCopy    ; Skip algorithm if line bound is immediate
    ITER_BoundedTempCopy:
        Call ReadLine           ; Set buffer with line-size and contents, adjust file position at start of next line
        Cmp ax, 0
        Je AUX_BoundedTempCopy  ; If EoF is reached before line is found, proceed to direct line insertion

        Call WriteLineToTemp        ; Copy line to temp file + CRLF
        Loop ITER_BoundedTempCopy   ; Recreate original file in temp file until requested line is found
        Jmp END_BoundedTempCopy

    AUX_BoundedTempCopy:         ; Avoids redundant ReadLines when an EoF is already know
        Call WriteLineToTemp     ; Write empty line + CRLF
        Loop AUX_BoundedTempCopy ; Until line num is met
    
    END_BoundedTempCopy:
        Call ReadLine       ; Save line bound contents and prep file pointer at start of next line

        Pop ax
        Ret
    BoundedTempCopy endP

    ; Reads a text file until it finds the requested line bound
    ; Inputs:  BX  - File handle to copy
    ;         [Dx] - Address of likePascalW buffer
    ;          Cx  - Line number bound
    ; Outputs: [Dx] - Contents of line number that bounded copy
    ;           CF  - Set if line exists, cleared if line is out of file's range
    FindLineBound proc
        Push ax
        Push cx

        Inc cx              ; Adjust bound to obtain line inside iter (reminder: BoundedTempCopy doesnt to exclude bound from copy logic)
    ITER_FindLineBound:
        Call ReadLine               ; Set buffer with line-size and contents, adjust file position at start of next line
        Cmp ax, 0
        Je FLAG_NoLineBound         ; If EoF is reached before line is found, clear flag
        Loop ITER_FindLineBound   ; Request lines until requested line is found
        Stc                         ; Set flag for found line
        Jmp END_FindLineBound

    FLAG_NoLineBound:
        Clc
    END_FindLineBound:
        Pop cx
        Pop ax
        Ret
    FindLineBound endP

    ; Processes a request for a line insertion command. It performs error checking
    ; for existing files
    ; Inputs: [filePath] - Valid file name read from CL
    ;         [coordinateA] - Line and column numbers
    ;         [auxiliarBuffer] - Text to insert
    ; Outputs: Result of the operation
    InsertWrapper proc
        Push ax
        Push bx
        Push cx
        Push dx
        Push si

        ; Attempt to open requested file
        Mov ah, DOS_OPEN_FILE
        Mov al, FILE_ACCESS_READ
        Mov dx, offset filePath
        Int 21h
        Jc FLAG_InsertNotFound  ; Flag error state if file can't be found
        Mov targetHandle, ax    ; Save file handle for later use

        Xor al, al
        Mov ah, DOS_CREATE_FILE ; Create temporary work file
        Mov cx, 00h             ; Set file attribute, and path
        Mov dx, offset tempPath
        Int 21h
        Mov tempHandle, ax      ; Save handle for later use

        Mov dx, offset sourceBuffer[word]  ; Set read buffer
        Mov bx, targetHandle

        Mov cx, coordinateA[0]  ; To iter until line is found
        Call BoundedTempCopy    ; Find line contents and copy file up to its predecessors
        
        Mov cx, coordinateA[word]   ; To locate column in current line
        Sub dx, word                ; Point buffer back to size field for upcoming routine
        Mov ax, offset auxiliarBuffer ; Set likePW line to insert
        Call InsertLine               ; Obtain result in mergeBuffer

        Mov dx, offset mergeBuffer[word] ; Set result for write operation
        Call WriteLineToTemp

        Call PrintResultPrompt
        Mov si, dx              ; Set filepath for printing
        Call PrintLikeC

        Call FinishTempFile

        Jmp HALT_InsertWrapper

    FLAG_InsertNotFound:
        Mov programState, ERROR_PATH_NOT_FOUND
        Jmp END_InsertWrapper
    HALT_InsertWrapper:
        Mov programState, STATE_HALT
    END_InsertWrapper:
        Pop si
        Pop dx
        Pop cx
        Pop bx
        Pop ax
        Ret
    InsertWrapper endP

    ; Processes a request for an overwrite line command. It performs error checking
    ; for existing files
    ; Inputs: [filePath] - Valid file name read from CL
    ;         [coordinateA] - Line and column numbers
    ;         [auxiliarBuffer] - Text to overwrite from
    ; Outputs: Result of the operation
    OverwriteWrapper proc
        Push ax
        Push bx
        Push cx
        Push dx
        Push si

        ; Attempt to open requested file
        Mov ah, DOS_OPEN_FILE
        Mov al, FILE_ACCESS_READ
        Mov dx, offset filePath
        Int 21h
        Jc FLAG_OverwriteNotFound  ; Flag error state if file can't be found
        Mov targetHandle, ax    ; Save file handle for later use

        Xor al, al
        Mov ah, DOS_CREATE_FILE ; Create temporary work file
        Mov cx, 00h             ; Set file attribute, and path
        Mov dx, offset tempPath
        Int 21h
        Mov tempHandle, ax      ; Save handle for later use

        Mov dx, offset sourceBuffer[word]  ; Set read buffer
        Mov bx, targetHandle

        Mov cx, coordinateA[0]  ; To iter until line is found
        Call BoundedTempCopy    ; Find line contents and copy file up to its predecessors
        
        Mov cx, coordinateA[word]   ; To locate column in current line
        Sub dx, word                ; Point buffer back to size field for upcoming routine
        Mov ax, offset auxiliarBuffer ; Set likePW line to overwrite
        Call OverwriteLine            ; Obtain result in mergeBuffer

        Mov dx, offset mergeBuffer[word] ; Set result for write operation
        Call WriteLineToTemp

        Call PrintResultPrompt
        Mov si, dx              ; Set filepath for printing
        Call PrintLikeC

        Call FinishTempFile

        Jmp HALT_OverwriteWrapper

    FLAG_OverwriteNotFound:
        Mov programState, ERROR_PATH_NOT_FOUND
        Jmp END_OverwriteWrapper
    HALT_OverwriteWrapper:
        Mov programState, STATE_HALT
    END_OverwriteWrapper:
        Pop si
        Pop dx
        Pop cx
        Pop bx
        Pop ax
        Ret
    OverwriteWrapper endP

    ; Applies a format from a function to each char in a line
    ; Inputs:   [SI] - Address to line in likePascalW format
    ;           [BX] - Address of function applied to each char
    ; Outputs: [SI] - Updates line with function's format
    FormatLine proc
        Push cx
        Push si
    
        Mov cx, word ptr ds:[si] ; Retrieve line size
        Inc si                   ; Adjust prior to buffer contents
    ITER_FormatLine:
        Inc si              ; Point to next char
        Call word ptr bx    ; Call function that expects [SI] = char as param

        Loop ITER_FormatLine

    END_FormatLine:
        Pop si
        Pop cx
        Ret
    FormatLine endP

    EncryptWrapper proc
        Mov programState, STATE_HALT
        Ret
    EncryptWrapper endP

    DecryptWrapper proc
        Mov programState, STATE_HALT
        Ret
    DecryptWrapper endP

    CapLineWrapper proc
        Mov programState, STATE_HALT
        Ret
    CapLineWrapper endP

    ; Sets a char reference to uppercase if possible
    ; Inputs: [SI] - Pointer to char
    ; Outputs: [SI] - Alphabetic char in uppercase
    SetUpperCase proc
        Push ax
        Mov al, byte ptr ds:[si]
        Cmp al, 'a'
        Jb END_SetUpperCase
        Cmp al, 'z'
        Ja END_SetUpperCase
        Sub al, 20h ; Offset for upper to lower
        Mov byte ptr ds:[si], al
    END_SetUpperCase:
        Pop ax
        Ret
    SetUpperCase endP

    ; Processes a request for a uppercase line command. It performs error checking
    ; for existing files
    ; Inputs: [filePath] - Valid file name read from CL
    ;         [coordinateA] - Line number
    ; Outputs: Result of the operation
    UpperLineWrapper proc
        Push ax
        Push bx
        Push cx
        Push dx
        Push si

        ; Attempt to open requested file
        Mov ah, DOS_OPEN_FILE
        Mov al, FILE_ACCESS_READ
        Mov dx, offset filePath
        Int 21h
        Jc FLAG_UpperLineWrapper  ; Flag error state if file can't be found
        Mov targetHandle, ax    ; Save file handle for later use

        Xor al, al
        Mov ah, DOS_CREATE_FILE ; Create temporary work file
        Mov cx, 00h             ; Set file attribute, and path
        Mov dx, offset tempPath
        Int 21h
        Mov tempHandle, ax      ; Save handle for later use

        Mov dx, offset sourceBuffer[word]  ; Set read buffer
        Mov bx, targetHandle

        Mov cx, coordinateA[0]  ; To iter until line is found
        Call BoundedTempCopy    ; Find line contents and copy file up to its predecessors

        Mov si, offset sourceBuffer ; Set line param to modify
        Mov bx, offset SetUpperCase ; Set function to apply at each char
        Call FormatLine             ; Obtain lowercase line

        Mov bx, targetHandle ; Restore file handle before operating files
        Call WriteLineToTemp

        Call PrintResultPrompt
        Call PrintLikePW ; SI already points to result buffer

        Call FinishTempFile

        Jmp HALT_UpperLineWrapper

    FLAG_UpperLineWrapper:
        Mov programState, ERROR_PATH_NOT_FOUND
        Jmp END_UpperLineWrapper
    HALT_UpperLineWrapper:
        Mov programState, STATE_HALT
    END_UpperLineWrapper:
        Pop si
        Pop dx
        Pop cx
        Pop bx
        Pop ax
        Ret
    UpperLineWrapper endP

    ; Sets a char reference to lowercase if possible
    ; Inputs: [SI] - Pointer to char
    ; Outputs: [SI] - Alphabetic char in lowercase
    SetLowerCase proc near
        Push ax
        Mov al, byte ptr ds:[si]
        Cmp al, 'A'
        Jb END_SetLowerCase
        Cmp al, 'Z'
        Ja END_SetLowerCase
        Add al, 20h ; Offset for upper to lower
        Mov byte ptr ds:[si], al
    END_SetLowerCase:
        Pop ax
        Ret
    SetLowerCase endP

    ; Processes a request for a lowercase line command. It performs error checking
    ; for existing files
    ; Inputs: [filePath] - Valid file name read from CL
    ;         [coordinateA] - Line number
    ; Outputs: Result of the operation
    LowerLineWrapper proc
        Push ax
        Push bx
        Push cx
        Push dx
        Push si

        ; Attempt to open requested file
        Mov ah, DOS_OPEN_FILE
        Mov al, FILE_ACCESS_READ
        Mov dx, offset filePath
        Int 21h
        Jc FLAG_LowerLineWrapper  ; Flag error state if file can't be found
        Mov targetHandle, ax    ; Save file handle for later use

        Xor al, al
        Mov ah, DOS_CREATE_FILE ; Create temporary work file
        Mov cx, 00h             ; Set file attribute, and path
        Mov dx, offset tempPath
        Int 21h
        Mov tempHandle, ax      ; Save handle for later use

        Mov dx, offset sourceBuffer[word]  ; Set read buffer
        Mov bx, targetHandle

        Mov cx, coordinateA[0]  ; To iter until line is found
        Call BoundedTempCopy    ; Find line contents and copy file up to its predecessors

        Mov si, offset sourceBuffer   ; Set line param to modify
        Mov bx, offset SetLowerCase ; Set function to apply at each char
        Call FormatLine             ; Obtain lowercase line

        Mov bx, targetHandle ; Restore file handle before operating files
        Call WriteLineToTemp

        Call PrintResultPrompt
        Call PrintLikePW ; SI already points to result buffer

        Call FinishTempFile

        Jmp HALT_LowerLineWrapper

    FLAG_LowerLineWrapper:
        Mov programState, ERROR_PATH_NOT_FOUND
        Jmp END_LowerLineWrapper
    HALT_LowerLineWrapper:
        Mov programState, STATE_HALT
    END_LowerLineWrapper:
        Pop si
        Pop dx
        Pop cx
        Pop bx
        Pop ax
        Ret
    LowerLineWrapper endP

    ; Processes a request for an erase line command. It performs error checking
    ; for existing files
    ; Inputs: [filePath] - Valid file name read from CL
    ;         [coordinateA] - Line number
    ; Outputs: Result of the operation
    EraseLineWrapper proc
        Push ax
        Push bx
        Push cx
        Push dx
        Push si

        ; Attempt to open requested file
        Mov ah, DOS_OPEN_FILE
        Mov al, FILE_ACCESS_READ
        Mov dx, offset filePath
        Int 21h
        Jc FLAG_EraseNotFound  ; Flag error state if file can't be found
        Mov targetHandle, ax    ; Save file handle for later use

        Xor al, al
        Mov ah, DOS_CREATE_FILE ; Create temporary work file
        Mov cx, 00h             ; Set file attribute, and path
        Mov dx, offset tempPath
        Int 21h
        Mov tempHandle, ax      ; Save handle for later use

        Mov dx, offset sourceBuffer[word]  ; Set read buffer
        Mov bx, targetHandle

        Mov cx, coordinateA[0]  ; To iter until line is found
        Call BoundedTempCopy    ; Find line contents and copy file up to its predecessors
        ; Does not copy the found line in the file to delete it
        Call PrintResultPrompt
        Mov si, offset sourceBuffer ; Set filepath for printing
        Call PrintLikePW

        Call FinishTempFile
        Jmp HALT_EraseLineWrapper

    FLAG_EraseNotFound:
        Mov programState, ERROR_PATH_NOT_FOUND
        Jmp END_EraseLineWrapper
    HALT_EraseLineWrapper:
        Mov programState, STATE_HALT
    END_EraseLineWrapper:
        Pop si
        Pop dx
        Pop cx
        Pop bx
        Pop ax
        Ret
    EraseLineWrapper endP

    CopyClipWrapper proc
        Mov programState, STATE_HALT
        Ret
    CopyClipWrapper endP

    CutClipWrapper proc
        Mov programState, STATE_HALT
        Ret
    CutClipWrapper endP

    PasteClipWrapper proc
        Mov programState, STATE_HALT
        Ret
    PasteClipWrapper endP

    ReplaceCWrapper proc
        Mov programState, STATE_HALT
        Ret
    ReplaceCWrapper endP

    ; Finds the data row's offset for the current state of the program
    ; Inputs: [programState] - Expects a valid state code in variable
    ; Outputs: [stateEntryOffset] Index to row address in stateTable.
    ;                             If state invalid, index to fail safe row
    ;          [programState] - Changed to fail safe state if value is invalid
    FindStateEntry proc
        Push bx
        Push cx
        Push dx

        Xor bx, bx           ; Base to address stateTable contents
        Mov cx, TABLE_SIZE
        Mov dx, programState ; Copy to reg for mem to mem comparison

        Cmp dx, STATE_ERROR ; If state is not a know error, continue to search
        Jb ITER_FindStateEntry

        Mov bx, TABLE_SIZE*STATE_OFFSET ; Otherwise, point to failsafe
        Jmp END_FindStateEntry          ; but skip programState update
        

    ITER_FindStateEntry:
        Cmp dx, word ptr stateTable[bx]
        Je END_FindStateEntry           ; Routine address found, halt
        Add bx, STATE_OFFSET            ; Otherwise, point to next row
        Loop ITER_FindStateEntry

        ; If out of range, BX points to failsafe state address
        Mov dx, word ptr stateTable[bx]
        Mov programState, dx ; Update invalid program state with error state

    END_FindStateEntry:
        Mov stateEntryOffset, bx
        Pop dx
        Pop cx
        Pop bx
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