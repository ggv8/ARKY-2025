; Documentacion
    ; ╔═════════════════════════════════════╦═══════════════════════════════════╗
    ; ║ Instituto Tecnologico de Costa Rica ║ Gabriel Gomez Vega                ║
    ; ║ Escuela de Computacion              ║ 2021106483                        ║
    ; ║ Arquitectura de Computadoras        ║ 14 de Noviembre del 2025          ║
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

    ; Snippet that tests if the keyboard has buffered an input
    ; Outputs: ZF - Set if there is no input, cleared if there is an input
    CHECK_KEY_INPUT Macro
        Xor al, al
        Mov ah, BIOS_CHECK_KEY
        Int 16h
    endM

    READ_KEY_INPUT Macro
        Xor al, al
        Mov ah, BIOS_GET_KEY
        Int 16h
    endM

    SET_CURSOR Macro pRow:REQ, pCol:REQ, pPage
        IFB <pPage>
            Xor bh, bh ; Assume page 0 for cursor
        Else
            Mov bh, pPage
        EndIf
        Mov dh, pRow
        Mov dl, pCol
        Mov ah, BIOS_SET_CURSOR
        Int 10h
    endM
;

DataSegment segment
; Symbolic Constants

    ; Interruptions
        BIOS_GET_KEY    = 00h
        BIOS_CHECK_KEY  = 01h

        DOS_INPUT_CHAR  = 01h
        DOS_PRINT_CHAR  = 02h
        DOS_PRINT_STR   = 09h
        DOS_EXIT        = 4Ch

        BIOS_SET_VIDEO_MODE = 00h
        VGA_640x480_16C     = 12h
        TEXT_MODE_80x25     = 03h
        VIDEO_WIDTH         = 640
        VIDEO_HEIGHT        = 480

        BIOS_SET_CURSOR = 02h

        BIOS_SET_PIXEL_COLOR = 0Ch
        BIOS_GET_PIXEL_COLOR = 0Dh
        
    ;

    ; ASCII
        CHAR_WIDTH  = 8
        CHAR_HEIGHT = 16
        CHAR_NULL  = 00h
        CHAR_CR    = 0Dh
        CHAR_LF    = 0Ah
        CHAR_SPACE = 20h
        CHAR_HTAB  = 09h
        CHAR_ENNE  = 0A4h
    ;

    ; State Machine
        STATE_HALT          = 0000h
        STATE_DEFAULT       = 0001h
        STATE_HELP          = 0002h
        STATE_COSTA_RICA    = 0003h
        STATE_GERMANY       = 0004h
        STATE_CHAD          = 0005h
        STATE_NORWAY        = 0006h
        STATE_PALESTINE     = 0007h
        STATE_GREAT_BRITAIN = 0008h
        STATE_CHILE         = 0009h
        STATE_URUGUAY       = 000Ah
        STATE_CANADA        = 000Bh
        ; 8000h to FFFFh are reserved for errors, 8000h is a failsafe state
        STATE_ERROR   = 8000h ; Used as reference for comparisons
        ERROR_UNKNOWN = 8001h
    ;

    ; Misc
        PSP_INPUT_OFFSET = 80h
        KEY_C = 2Eh

        ; Stack frames
        NEAR_BOUND = 2*word
        FAR_BOUND  = 3*word

        ; VGA colors        ----ARGB
        COLOR_BLACK       = 00000000b
        COLOR_DARK_BLUE   = 00000001b
        COLOR_DARK_GREEN  = 00000010b
        COLOR_DARK_CYAN   = 00000011b
        COLOR_DARK_RED    = 00000100b
        COLOR_PURPLE      = 00000101b
        COLOR_BROWN       = 00000110b
        COLOR_LIGHT_GREY  = 00000111b
        COLOR_DARK_GREY   = 00001000b
        COLOR_LIGHT_BLUE  = 00001001b
        COLOR_LIGHT_GREEN = 00001010b
        COLOR_LIGHT_CYAN  = 00001011b
        COLOR_LIGHT_RED   = 00001100b
        COLOR_MAGENTA     = 00001101b
        COLOR_YELLOW      = 00001110b
        COLOR_WHITE       = 00001111b

        ; Simple line vectors
        VECTOR_UP         EQU -1,  0
        VECTOR_DOWN       EQU  1,  0
        VECTOR_LEFT       EQU  0, -1
        VECTOR_RIGHT      EQU  0,  1
        VECTOR_UP_LEFT    EQU -1,  0
        VECTOR_UP_RIGHT   EQU -1,  1
        VECTOR_DOWN_LEFT  EQU  1, -1
        VECTOR_DOWN_RIGHT EQU  1,  1
        VECTOR_COUNT = 8

        ; Line Directions
        GO_UP         = 0
        GO_UP_RIGHT   = 1
        GO_RIGHT      = 2
        GO_DOWN_RIGHT = 3
        GO_DOWN       = 4
        GO_DOWN_LEFT  = 5
        GO_LEFT       = 6
        GO_UP_LEFT    = 7

    ;
;

; String literals
    aboutLine1 db "ITCR - Escuela de Computacion - Arquitectura de Computadoras", CHAR_NULL
    aboutLine2 db "Fecha: 14/Noviembre/2025", CHAR_NULL
    aboutLine3 db "Tarea de Flags", CHAR_NULL
    aboutLine4 db "Autor: Gabriel Gomez Vega - 2021106483", CHAR_NULL
    aboutLine5 db "Muestra bandera de uno de los siguientes paises al ingresar su nombre:", CHAR_NULL
    aboutLine6 db "Costa Rica,Alemania,Chad,Noruega,Palestina,Chile,Uruguay,Canada,Gran Breta", CHAR_ENNE,"a", CHAR_NULL
    aboutLine7 db "<C> Cerrar el programa", CHAR_NULL

    errorLabel db "Error: ", CHAR_NULL
    errorNoState  db "El programa ha generado un error inesperado.", CHAR_NULL
    errorUnknown  db "La bandera solicitada no es una entrada valida.", CHAR_NULL
;

; Look-up Tables
    stateTable  dw STATE_DEFAULT,       StartWrapper
    STATE_OFFSET = ($ - stateTable)
                dw STATE_HELP,          AboutMe
                dw STATE_COSTA_RICA,    CostaRica
                dw STATE_GERMANY,       Germany
                dw STATE_CHAD,          Chad
                dw STATE_NORWAY,        Norway
                dw STATE_PALESTINE,     Palestine
                dw STATE_GREAT_BRITAIN, GreatBritain
                dw STATE_CHILE,         Chile
                dw STATE_URUGUAY,       Uruguay
                dw STATE_CANADA,        Canada
    TABLE_SIZE = ($ - stateTable) / STATE_OFFSET
                dw STATE_ERROR,     PrintError ; Fail safe state

    errorVector dw offset errorNoState, offset errorUnknown

    inputTable  db STATE_COSTA_RICA,     10, "costa rica"
                db STATE_GERMANY,         8, "alemania"
                db STATE_CHAD,            4, "chad"
                db STATE_NORWAY,          7, "noruega"
                db STATE_PALESTINE,       9, "palestina"
                db STATE_GREAT_BRITAIN,  12, "gran breta", CHAR_ENNE,"a"
                db STATE_CHILE,           5, "chile" 
                db STATE_URUGUAY,         7, "uruguay" 
                db STATE_CANADA,          6, "canada" 
    INPUT_ENTRIES = 9

    lineDirections dw VECTOR_UP, VECTOR_UP_RIGHT, VECTOR_RIGHT, VECTOR_DOWN_RIGHT ; Double Word array
                   dw VECTOR_DOWN, VECTOR_DOWN_LEFT, VECTOR_LEFT, VECTOR_UP_LEFT
;

    programState dw STATE_DEFAULT
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

    ; Determines if an input string is equal to a valid input entry
    ; Inputs: ES:BX - Offset to the first input char
    ;            CL - Length of the input
    ;         DS:SI - Offset to likePascal str within inputTable
    ; Outputs: CF   - Set if inputs is equal, clear otherwise
    CompareInput proc
        PUSHLIST si, ax, bx, cx

        Cmp cl, byte ptr inputTable[si] ; Inputs differ in length, flag not equal
        Jne FLAG_Different

        Xor ch, ch
        Inc si
    ITER_CompareInput:
        Mov al, byte ptr es:[bx]

        Cmp al, CHAR_SPACE
        Je AUX_CompareInput ; Skip lowercase mask if char is ' '
        Cmp al, CHAR_ENNE
        Je AUX_CompareInput ; or if it is 'ñ'

        Cmp al, CHAR_ENNE+1
        Jne AUX_CompareLowercase
        Dec al ; If it is 'Ñ', manually set to lowercase and compare directly
        Jmp CompareInput

    AUX_CompareLowercase:
        Or al, 60h ; Assume alpha char, enforce lowercase prior to be case insensitive
    
    AUX_CompareInput:
        Cmp al, byte ptr inputTable[si]
        Jne FLAG_Different ; If a single character is off, flag not equal
        Inc bx
        Inc si ; Point to next byte of both strings
        Loop ITER_CompareInput

        Stc
        Jmp END_CompareInput

    FLAG_Different:
        Clc
    END_CompareInput:
        POPLIST si, ax, bx, cx
        Ret
    CompareInput endP

    ; Gets the state associated to the command tail's input
    ; Inputs: ES:BX - Offset to the first input char
    ;            CX - Length of the input
    ; Outputs: AX - State code corresponding to an input or an error for invalid entries
    FindInputState proc
        PUSHLIST si, cx

        Xor ah, ah
        Xor si, si
        Mov ch, INPUT_ENTRIES
    ITER_FindInputState:
        Inc si ; Point at entry's likePascal str field
        Call CompareInput
        Jc AUX_FindInputState ; Save state code if there's a match

        Mov al, byte ptr inputTable[si] ; Obtain offset to next entry
        Inc si                          ; Point to first char of string field
        Add si, ax                      ; Point to next entry's first field
        Dec ch
        Jnz ITER_FindInputState
        
        Mov programState, ERROR_UNKNOWN ; Flag input as unknown
        Jmp END_FindInputState

    AUX_FindInputState:
        Mov al, byte ptr inputTable[si-byte] ; Retrieve entry's state code field
        Mov programState, ax
        
    END_FindInputState:
        POPLIST si, cx
        Ret
    FindInputState endP

    ; Reads the command line's input and stores parameters if present
    ; Inputs: Expects ...
    ; Outputs: Stores values in data variables, and flags errors if necessary
    ReadInput proc
        PUSHLIST ax, bx

        Mov bx, PSP_INPUT_OFFSET
        Xor ch, ch
        Mov cl, byte ptr es:[bx]
        Jcxz FLAG_NoInput         ; If there is no input, set new state and halt

        Dec cx ; Ignore whitespace
        Inc bx ; Point to input-preceding whitespace
    ITER_ReadInput:
        Inc bx  ; Point to next char
        Mov al, byte ptr es:[bx]
        Cmp al, CHAR_SPACE
        Jne AUX_ReadInput   ; Parse beginning from first non-space char
        Loop ITER_ReadInput
        Jmp END_ReadInput  ; Skip error flagging line

    AUX_ReadInput:
        Call FindInputState
        Jmp END_ReadInput

    FLAG_NoInput:
        Mov programState, STATE_HELP
    END_ReadInput:
        POPLIST ax, bx
        Ret
    ReadInput endP

    ; Prints AboutMe and validates user inputs
    ; Inputs: Expects a valid command line input
    ; Output: Sends AboutMe to standard output
    StartWrapper proc
        Call ReadInput
        
        Mov ah, BIOS_SET_VIDEO_MODE
        Mov al, VGA_640x480_16C
        Int 10h
        Ret
    StartWrapper endP

    ; Suspends program execution by doing nothing in quadratic time
    ; Inputs: n/a
    ; Outputs: Time :)
    Pause proc
        PUSHLIST cx
        Mov ch, 50
    ITER_Pause_L1:
        Mov cl, 50
    ITER_Pause_L2:
        Nop
        Dec cl
        Jnz ITER_Pause_L2
        Dec ch
        Jnz ITER_Pause_L1
        POPLIST cx
        Ret
    Pause endP

    ; Auxiliar routine to DrawLine
    ; Prepares the next line position to draw a pixel at
    ; Inputs: pDirection (int) - Enum of direction the line is taking
    ;         DX - Row index
    ;         CX - Column index    
    ; Outputs: Sends colored pixels to the graphic memory display
    NextLinePosition proc near
        Local pDirection, ArgSize
            pDirection = [bp + NEAR_BOUND]
            ArgSize = word
        SET_STACKFRAME
        PUSHLIST ax, bx

        Mov ax, word ptr pDirection
        Shl ax, 2   ; x4 to obtain word-based offset

        Mov bl, VECTOR_COUNT*dword ; Simple range restriction via modulo
        Div bl

        Xor bh, bh
        Mov bl, ah ; Obtain remainder

        Mov ax, word ptr lineDirections[bx]     ; Get row vector value
        Add dx, ax                              ; Apply offset

        Mov ax, word ptr lineDirections[bx+word] ; Get col vector value
        Add cx, ax                               ; Apply offset

        POPLIST ax, bx
        END_STACKFRAME ArgSize
        Ret
    NextLinePosition endP

    ; Displays a line at a coordinate with a specified length
    ; Inputs:   pColor     (RGB) - Color coded byte
    ;           pRow       (int) - Index to VRAM row
    ;           pCol       (int) - Index to VRAM column
    ;           pLength    (int) - Length of line from top corner to bottom corner
    ;           pDirection (int) - Direction the line is taking
    ; Outputs: Sends colored pixels to the graphic memory display
    DrawLine proc near
        Local pColor, pRow, pCol, pLength, pDirection, ArgSize
            pColor     = [bp + 4*word + NEAR_BOUND]
            pRow       = [bp + 3*word + NEAR_BOUND]
            pCol       = [bp + 2*word + NEAR_BOUND]
            pLength    = [bp + 1*word + NEAR_BOUND]
            pDirection = [bp + 0*word + NEAR_BOUND]
            ArgSize = 5*word
        SET_STACKFRAME
        PUSHLIST ax, bx, cx, dx

        Mov ax, word ptr pColor
        Mov ah, BIOS_SET_PIXEL_COLOR
        Mov dx, word ptr pRow
        Mov cx, word ptr pCol
        Xor bx, bx ; Set page=0 NOTE: Even though documentation claims that mode 12h has no pages,
                   ; BH still affects BIOS 10H routine that sets pixels on screen for some reason >:c
    ITER_DrawLine:
        Int 10h ; Set pixel on screen
        Push word ptr pDirection
        Call NextLinePosition
        Dec word ptr pLength  ; Decrease length counter
        Jnz ITER_DrawLine

        POPLIST ax, bx, cx, dx
        END_STACKFRAME ArgSize
    DrawLine endP

    ; Displays a solid rectangle between a pair of coordinates
    ; Inputs:   pColor  (RGB) - Color of the rectangle
    ;           pRow    (int) - Index to VRAM row
    ;           pCol    (int) - Index to VRAM column
    ;           pLength (int) - Length from column position
    ;           pHeight (int) - Height from row position
    ; Outputs: Sends colored pixels to the graphic memory display
    DrawRect proc
        Local pColor, pRow, pCol, pLength, pHeight, ArgSize
            pColor  = [bp + 4*word + NEAR_BOUND]
            pRow    = [bp + 3*word + NEAR_BOUND]
            pCol    = [bp + 2*word + NEAR_BOUND]
            pLength = [bp + 1*word + NEAR_BOUND]
            pHeight = [bp + 0*word + NEAR_BOUND]
            ArgSize = 5*word
        SET_STACKFRAME
        PUSHLIST ax, bx, cx, dx

        Mov ax, word ptr pRow
        Mov bx, word ptr pCol
        Mov cx, word ptr pHeight
        Mov dx, word ptr pLength
    ITER_DrawRect:
        Push word ptr pColor
        PUSHLIST ax, bx, dx, GO_RIGHT
        Call DrawLine
        Inc ax
        Loop ITER_DrawRect

        POPLIST ax, bx, cx, dx
        END_STACKFRAME ArgSize
    DrawRect endP

    ;
    SetPixel proc
        Local pColor, pRow, pCol, ArgSize
            pColor  = [bp + 2*word +  NEAR_BOUND]
            pRow    = [bp + 1*word + NEAR_BOUND]
            pCol    = [bp + 0*word + NEAR_BOUND]
            ArgSize = 3*word
        SET_STACKFRAME
        PUSHLIST ax, bx, cx, dx

        Mov ax, word ptr pColor
        Mov ah, BIOS_SET_PIXEL_COLOR
        Mov dx, word ptr pRow
        Mov cx, word ptr pCol
        Xor bx, bx
        Int 10h

        POPLIST ax, bx, cx, dx
        END_STACKFRAME ArgSize
    SetPixel endP

    INIT_DIFF_STEP Macro pDifference:REQ, pVal1:REQ, pVal2:REQ, pStep:REQ
        Local END_Abs
        Mov pStep, 1 ; Assume step is forward
        Mov pDifference, word ptr pVal2
        Sub pDifference, word ptr pVal1 ; Dif = Val2 - Val1
        Jns END_Abs
        Neg pDifference ; If difference is negative, get its abs(value)
        Neg pStep       ; and set step to be backwards
        END_Abs:
    endM

    INIT_BRESENHAM Macro
        ; Assume row is driving axis
        ; SI = Ptr to driving axis coordinate, DX = Driving Offset/Difference, AX = Driving Step Direction
        ; DI = Ptr to passive axis coordinate, BX = Passive Offset/Difference, CX = Passive Step Direction
        Lea si, word ptr pRow1
        Lea di, word ptr pCol1
        INIT_DIFF_STEP dx, pRow1, pRow2, ax ; Get each coordinate's abs(difference)
        INIT_DIFF_STEP bx, pCol1, pCol2, cx ; and their step direction

        Cmp dx, bx           ; Determine if assumptions are correct or not
        Jge END_InitBresenham ; Correct if row increases at same or greater pace than col

        Xchg si, di ; Otherwise, set col as driving axis and row as passive
        Xchg dx, bx ; Swap their difference as well
        Xchg ax, cx ; as their steps
    
    END_InitBresenham: ; Store calculated steps in respective local variable and init constant values
        Mov word ptr drivingStep, ax ; Store driving and passive
        Mov word ptr passiveStep, cx ; steps in respective vars

        Mov cx, dx ; Use driving offset to control upcoming iter
        
        Shl bx, 1 ; BX: incE = 2(Passive)
        Mov ax, bx
        Sub ax, dx ; 2(Passive) - (Driving)
        Mov word ptr pixelBound, ax

        Shl dx, 1
        Neg dx
        Add dx, bx ; 2(Passive - Driving) = 2(Passive) - 2(Driving)
    endM

    ;
    Bresenham proc near
        Local pColor, pRow1, pCol1, pRow2, pCol2, ArgSize
        Local difRow, difCol, pixelBound, stepRow, stepCol
            pColor = [bp + 4*word + NEAR_BOUND]
            pRow1  = [bp + 3*word + NEAR_BOUND]
            pCol1  = [bp + 2*word + NEAR_BOUND]
            pRow2  = [bp + 1*word + NEAR_BOUND]
            pCol2  = [bp + 0*word + NEAR_BOUND]
            ArgSize = 5*word
            pixelBound  = [bp - 1*word]
            drivingStep = [bp - 2*word]
            passiveStep = [bp - 3*word]
            VarSize = 3*word
        SET_STACKFRAME VarSize
        PUSHLIST si, ax, bx, cx, dx

        INIT_BRESENHAM ; Initializes local variables and set registers to        
    
        Push word ptr pColor
        Push word ptr pRow1
        Push word ptr pCol1
        Call SetPixel
    ITER_Bresenham:
        Mov ax, word ptr drivingStep
        Add word ptr ss:[si], ax    ; drivingAxis += step (+1 or -1 depending on slope)

        Cmp word ptr pixelBound, 0
        Jl AUX_Bresenham            ; Skip if passive movement pixelBound < 0

        Mov ax, word ptr passiveStep
        Add word ptr ss:[di], ax    ; passiveAxis += step (+1 or -1 depending on slope)
        Add word ptr pixelBound, dx ; pixelBound += INCNE
        Jmp NEXT_Bresenham

    AUX_Bresenham:
        Add word ptr pixelBound, bx ; pixelBound += INCE
    NEXT_Bresenham:
        Push word ptr pColor
        Push word ptr pRow1
        Push word ptr pCol1
        Call SetPixel
        Loop ITER_Bresenham

    END_Bresenham:
        POPLIST si, ax, bx, cx, dx
        END_STACKFRAME ArgSize
    Bresenham endP

    StandBy proc
        CHECK_KEY_INPUT
        Jz StandBy  ; If no input, keep checking

        READ_KEY_INPUT
        Cmp ah, KEY_C
        Jne StandBy ; Keep checking until input is for closing window
        Ret
    StandBy endP

    CostaRica proc
        PUSHLIST ax

        PUSHLIST COLOR_DARK_BLUE, 0, 0, VIDEO_WIDTH, 80
        Call DrawRect

        PUSHLIST COLOR_WHITE, 80, 0, VIDEO_WIDTH, 80
        Call DrawRect
        
        PUSHLIST COLOR_LIGHT_RED, 2*80, 0, VIDEO_WIDTH, 2*80
        Call DrawRect

        PUSHLIST COLOR_WHITE, 4*80, 0, VIDEO_WIDTH, 80
        Call DrawRect

        PUSHLIST COLOR_DARK_BLUE, 5*80, 0, VIDEO_WIDTH, 80
        Call DrawRect

        ;PUSHLIST COLOR_BLACK, 100, 100, 240, 320 
        ;Call Bresenham
;
        ;Call StandBy
;
        ;PUSHLIST COLOR_DARK_GREEN, 240, 320, 100, 100
        ;Call Bresenham
;
        ;Call StandBy
;
        ;PUSHLIST COLOR_BLACK, 100, 100
        ;Call SetPixel
;
        ;PUSHLIST COLOR_BLACK, 240, 320
        ;Call SetPixel
        ;
        Call StandBy
        
        Mov programState, STATE_HALT
        POPLIST ax, cx
        Ret
    CostaRica endP

    Germany proc
        PUSHLIST ax

        PUSHLIST COLOR_LIGHT_RED, 160, 0, VIDEO_WIDTH, 160
        Call DrawRect

        PUSHLIST COLOR_YELLOW, 2*160, 0, VIDEO_WIDTH, 160
        Call DrawRect

        PUSHLIST COLOR_BLACK, 0, 0, VIDEO_WIDTH, 160
        Call DrawRect

        Call StandBy
        Mov programState, STATE_HALT
        POPLIST ax
        Ret
    Germany endP

    Chad proc
        PUSHLIST ax, cx

        PUSHLIST COLOR_DARK_BLUE, 0, 0, 213, VIDEO_HEIGHT
        Call DrawRect

        PUSHLIST COLOR_YELLOW, 0, 213, 214, VIDEO_HEIGHT
        Call DrawRect

        PUSHLIST COLOR_LIGHT_RED, 0, 213+214, 213, VIDEO_HEIGHT
        Call DrawRect

        Call StandBy
        Mov programState, STATE_HALT
        POPLIST ax, cx
        Ret
    Chad endP

    Norway proc
        PUSHLIST ax, cx

        PUSHLIST COLOR_DARK_RED, 0, 0, 128+32, 128+32+8
        Call DrawRect

        PUSHLIST COLOR_DARK_RED, 0, 128+32+128, VIDEO_WIDTH-(128+32+128), 128+32+8
        Call DrawRect

        PUSHLIST COLOR_DARK_RED, 128+32+8+144, 0, 128+32, 128+32+8
        Call DrawRect

        PUSHLIST COLOR_DARK_RED, 128+32+8+144, 128+32+128, VIDEO_WIDTH-(128+32+8), 128+32+8
        Call DrawRect

        PUSHLIST COLOR_WHITE, 0, 128+32, 128, VIDEO_HEIGHT
        Call DrawRect

        PUSHLIST COLOR_WHITE, 128+32+8, 0, VIDEO_WIDTH, 144
        Call DrawRect

        PUSHLIST COLOR_DARK_BLUE, 0, 128+32+32, 64, VIDEO_HEIGHT
        Call DrawRect

        PUSHLIST COLOR_DARK_BLUE, 128+32+8+36, 0, VIDEO_WIDTH, 72
        Call DrawRect

        Call StandBy
        Mov programState, STATE_HALT
        POPLIST ax, bx, cx
        Ret
    Norway endP

    Palestine proc
        PUSHLIST ax, bx, cx


        PUSHLIST COLOR_WHITE, 160, 0, VIDEO_WIDTH, 160
        Call DrawRect

        PUSHLIST COLOR_DARK_GREEN, 2*160, 0, VIDEO_WIDTH, 160
        Call DrawRect

        PUSHLIST COLOR_BLACK, 0, 0, VIDEO_WIDTH, 160
        Call DrawRect

        Xor ax, ax
        Mov bx, VIDEO_HEIGHT-1
        Mov cx, VIDEO_HEIGHT/2
    ITER_PalestineFG:
        PUSHLIST COLOR_LIGHT_RED, ax, 0, cx, GO_DOWN_RIGHT
        Call DrawLine

        PUSHLIST COLOR_LIGHT_RED, bx, 0, cx, GO_UP_RIGHT
        Call DrawLine
        Inc ax
        Dec bx
        Loop ITER_PalestineFG
    END_Palestine:
        Call StandBy
        Mov programState, STATE_HALT
        POPLIST ax, bx, cx
        Ret
    Palestine endP

    GreatBritain proc
        PUSHLIST ax, cx

        Xor ax, ax
        Mov cx, VIDEO_HEIGHT
    ITER_GreatBritainBG:
        PUSHLIST COLOR_DARK_BLUE, ax, 0, VIDEO_WIDTH, GO_RIGHT
        Call DrawLine
        Inc ax
        Loop ITER_GreatBritainBG

        Xor ax, ax
        Mov cx, VIDEO_HEIGHT
    ITER_GreatBritainFG1:
        PUSHLIST COLOR_WHITE, ax, 128*2, 128, GO_RIGHT
        Call DrawLine
        PUSHLIST COLOR_DARK_RED, ax, 128*2+32, 64, GO_RIGHT
        Call DrawLine
        Inc ax
        Loop ITER_GreatBritainFG1
    
        Xor ax, ax
        Mov cx, 128*2+32
    ITER_GreatBritainFG2:
        Push ax
        PUSHLIST COLOR_WHITE, 96*2, ax, 96, GO_DOWN
        Call DrawLine

        PUSHLIST COLOR_DARK_RED, 96*2+24, ax, 48, GO_DOWN
        Call DrawLine

        Add ax, 128*2+32+64
        PUSHLIST COLOR_WHITE, 96*2, ax, 96, GO_DOWN
        Call DrawLine

        PUSHLIST COLOR_DARK_RED, 96*2+24, ax, 48, GO_DOWN
        Call DrawLine
        Pop ax
        Inc ax
        Dec cx
        Jcxz END_GreatBritain
        Jmp ITER_GreatBritainFG2
    
    END_GreatBritain:
        Call StandBy
        Mov programState, STATE_HALT
        POPLIST ax, cx
        Ret
    GreatBritain endP

    Chile proc
        PUSHLIST ax, cx

        PUSHLIST COLOR_DARK_BLUE, 0, 0, VIDEO_HEIGHT/2, VIDEO_HEIGHT/2
        Call DrawRect

        PUSHLIST COLOR_WHITE, 0, VIDEO_HEIGHT/2, VIDEO_WIDTH-(VIDEO_HEIGHT/2), VIDEO_HEIGHT/2
        Call DrawRect

        PUSHLIST COLOR_DARK_RED, VIDEO_HEIGHT/2, 0, VIDEO_WIDTH, VIDEO_HEIGHT/2
        Call DrawRect

        Call StandBy
        Mov programState, STATE_HALT
        POPLIST ax, cx
        Ret
    Chile endP

    Uruguay proc
        PUSHLIST ax, bx, cx, dx

        Xor ax, ax
        Mov cx, 9
        Mov bx, COLOR_WHITE
        Mov dx, COLOR_DARK_BLUE
    ITER_UruguayBG:
        PUSHLIST bx, ax, 0, VIDEO_WIDTH, 53
        Call DrawRect
        Add ax, 53
        Xchg bx, dx
        Loop ITER_UruguayBG

        PUSHLIST dx, 53, 0, VIDEO_HEIGHT/2, 53*3
        Call DrawRect

        Call StandBy
        Mov programState, STATE_HALT
        POPLIST ax, bx, cx, dx
        Ret
    Uruguay endP

    Canada proc
        PUSHLIST ax, cx

        PUSHLIST COLOR_DARK_RED, 0, 0, 160, VIDEO_HEIGHT
        Call DrawRect

        PUSHLIST COLOR_WHITE, 0, 160, 160*2, VIDEO_HEIGHT
        Call DrawRect

        PUSHLIST COLOR_DARK_RED, 0, 160*3, 160, VIDEO_HEIGHT
        Call DrawRect

        Call StandBy
        Mov programState, STATE_HALT
        POPLIST ax, cx
        Ret
    Canada endP

    AboutMe proc
        PUSHLIST si, ax, bx, cx, dx

        Xor ax, ax
        Mov cx, CHAR_HEIGHT*18
    ITER_AboutMe1:
        Mov dx, COLOR_WHITE
        Xor bx, bx
        PUSHLIST ax, cx
        Mov cx, 7
    ITER_AboutMe2:
        PUSHLIST dx, ax, bx, 94, GO_RIGHT
        Call DrawLine
        Dec dx
        Add bx, 91
        Loop ITER_AboutMe2
        POPLIST ax, cx
        Inc ax
        Loop ITER_AboutMe1

        Xor ax, ax
        Mov bx, COLOR_WHITE
        Mov cx, 7

        PUSHLIST COLOR_LIGHT_GREY, CHAR_HEIGHT*18, 0, CHAR_WIDTH*80, CHAR_HEIGHT*12
        Call DrawRect

        PUSHLIST COLOR_DARK_GREY, (CHAR_HEIGHT*18)+10, 4, (CHAR_WIDTH*78)+(4*2), (CHAR_HEIGHT*10)+(6*2)
        Call DrawRect

        PUSHLIST COLOR_BLACK, (CHAR_HEIGHT*18)+16, CHAR_WIDTH, CHAR_WIDTH*78, CHAR_HEIGHT*10
        Call DrawRect

        ; Display each line in the designated area with centered text
        SET_CURSOR 20, 10
        Mov si, offset aboutLine1
        Call PrintLikeC
        
        SET_CURSOR 21, 28
        Mov si, offset aboutLine2
        Call PrintLikeC
        
        SET_CURSOR 22, 33
        Mov si, offset aboutLine3
        Call PrintLikeC
        
        SET_CURSOR 23, 21
        Mov si, offset aboutLine4
        Call PrintLikeC
        
        SET_CURSOR 25, 5
        Mov si, offset aboutLine5
        Call PrintLikeC

        SET_CURSOR 26, 2
        Mov si, offset aboutLine6
        Call PrintLikeC

        SET_CURSOR 28, 29
        Mov si, offset aboutLine7
        Call PrintLikeC

        Call StandBy
        Mov programState, STATE_HALT
        POPLIST si, ax, bx, cx, dx
        Ret
    AboutMe endP

    ; Routine for example state
    ; Inputs: ...
    ; Outputs: Sets programState to halt if no error occured
    ExampleRoutine proc
        PUSHLIST ax, bx, cx, dx

        Mov ax, COLOR_YELLOW     ; Base color
        Mov bx, 0   ; Starting row
        Mov cx, 20 ; Color reps

    ITER_L1:
        Mov dx, 10    ; Height

    ITER_L2:
        Push ax
        Push bx
        Push 240
        Push 10
        Push GO_RIGHT
        Call DrawLine
        ;Call Pause
        Inc bx
        Dec dx
        Jnz ITER_L2

        Loop ITER_L1
        


        Mov programState, STATE_HALT

        POPLIST ax, bx, cx, dx
        Ret
    ExampleRoutine endP

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
        Mov ah, BIOS_SET_VIDEO_MODE
        Mov al, TEXT_MODE_80x25
        Int 10h

        Mov al, 00h
        Mov ah, 4Ch
        Int 21h


CodeSegment endS

end main