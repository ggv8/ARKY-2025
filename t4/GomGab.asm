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
        DOS_EXIT        = 4Ch
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
    errorPathNotFound db "La ruta solicitada para crear el archivo no se pudo encontrar", CHAR_NULL

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
    
    clipPath db ".\clipB.txt",    CHAR_NULL
    tempFile db ".\tempEdit.txt", CHAR_NULL
    filePath db CL_INPUT_SIZE dup(0)

    newlineBuffer db CHAR_CR, CHAR_LF
    coordinateA dw 0, 0 ; Line and column
    coordinateB dw 0, 0

    ; likePascalW format: first word stores line's byte count, followed by a buffer capable of fitting a full line of text + newline (CRLF)
    sourceBuffer dw 0   ; To read from target file
                 db (MAX_LINE_SIZE + 2) dup(0)
    sourceFilePtr dw 0
    
    auxiliarBuffer dw 0 ; Stores line input or to read from clipboard
                   db (MAX_LINE_SIZE + 2) dup(0)
    auxiliarFilePtr dw 0
    
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
    ;          DS:[DI] - Saves paramaeter in likePascalW format
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
        Mov cx, 00h
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
        Call PrintCRLF
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

    InsertWrapper proc
        Mov programState, STATE_HALT
        Ret
    InsertWrapper endP

    OverwriteWrapper proc
        Mov programState, STATE_HALT
        Ret
    OverwriteWrapper endP

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

    UpperLineWrapper proc
        Mov programState, STATE_HALT
        Ret
    UpperLineWrapper endP

    LowerLineWrapper proc
        Mov programState, STATE_HALT
        Ret
    LowerLineWrapper endP

    EraseLineWrapper proc
        Mov programState, STATE_HALT
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