; Documentacion
    ; ╔═════════════════════════════════════╦═══════════════════════════════════╗
    ; ║ Instituto Tecnologico de Costa Rica ║ Gabriel Gomez Vega                ║
    ; ║ Escuela de Computacion              ║ 2021106483                        ║
    ; ║ Arquitectura de Computadoras        ║ 9 de Octubre del 2025             ║
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
        DOS_ERASE_FILE  = 41h
        DOS_SET_FILEPTR = 42h
        DOS_EXIT        = 4Ch
        DOS_RENAME_FILE = 56h
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
        STATE_RESTART = 0003h
        STATE_FIRST_PANEL = 0004h
        STATE_PLACE_PANEL = 0005h
        STATE_FIRST_TURN  = 0006h
        STATE_PLAY_TURN   = 0007h
        STATE_GAME_OVER   = 0008h
        ; 8000h to FFFFh are reserved for errors, 8000h is a failsafe state
        STATE_ERROR   = 8000h ; Used as reference for comparisons
        ERROR_UNKNOWN_CMD    = 8001h
        ERROR_MISSING_INPUT  = 8002h
        ERROR_UNKNOWN_PANEL  = 8003h ; Panel ID different from 2,3,4,6
        ERROR_INVALID_PANEL  = 8004h ; Chosen panel ran out
        ERROR_ORIENTATION    = 8005h ; Invalid orientation code
        ERROR_NON_INTEGER    = 8006h ; Non-int input for row/col
        ERROR_INPUT_RANGE    = 8007h ; Row/Col exceeds range 0 to 9
        ERROR_INVALID_PLAY   = 8008h ; Attempt to play during board creation stage
        ERROR_INVALID_ADD    = 8009h ; Attempt to add panel during match
        ERROR_PANEL_OVERFLOW = 800Ah ; Panel placement from pivot extends outside 10x10 grid
        ERROR_PANEL_ALONE    = 800Bh ; Panel is not adjacent to other panels
        ERROR_PANEL_OVERLAP  = 800Ch ; Panel is colliding with other panels
        ERROR_INVALID_TURN   = 800Dh ; Play position is not aligned with prev turn's position
        ERROR_HOLE_OCCUPIED  = 800Eh ; Play position is not empty
        ERROR_PANEL_BLOCKED  = 800Fh ; Play position is the same panel as prev turn
        ERROR_VOID_POSITION  = 8010h ; Play position is outside play area
        ERROR_FILE_CORRUPT   = 8011h ; Attempt to load file shows signs of external manipulation (byte count mismatch)
    ;

    ; Game Symbols
        MATRIX_SIZE = 10

        ; Input Commands
        CMD_NEW_GAME     = 'N'
        CMD_ADD_PANEL    = 'A'
        CMD_PLAY_TURN    = 'J'
        CMD_DISPLAY_GAME = 'K'

        ; Token Representations
        GAME_RED_TOKEN      = 'B'
        GAME_RED_SENTINEL   = 'b'
        GAME_BLACK_TOKEN    = 'X'
        GAME_BLACK_SENTINEL = 'x'

        ; Turn and panel shapes
        PLAYER_RED_TURN     = 0
        PLAYER_BLACK_TURN   = 1
        TOTAL_TOKENS        = 28

        PANEL_LINE_2_ID     = '2'
        PANEL_LINE_3_ID     = '3'
        PANEL_SQUARE_ID     = '4'
        PANEL_RECT_6_ID     = '6'
        PANEL_SHAPE_LIMIT   = 4
        PANEL_SQUARE_LIMIT  = 5
        TOTAL_PANELS        = 17
    ;

    ; Misc
        PSP_INPUT_OFFSET = 80h  
    ;
;

; String literals
    aboutMe db "ITCR: Escuela de Computacion - Arquitectura de Computadoras. 09/Oct/2025", CHAR_CR, CHAR_LF
            db "Tarea Kulami | Autor: Gabriel Gomez Vega, 2021106483", CHAR_NULL
    helpMe  db "Debe ingresar los siguientes datos:", CHAR_CR, CHAR_LF
            db CHAR_HTAB, "Crear partida   (",CMD_NEW_GAME, ")", CHAR_CR, CHAR_LF
            db CHAR_HTAB, "Agregar panel   (",CMD_ADD_PANEL, "): -tipo (2,3,4,6) -direccion (H,V) -fila -columna", CHAR_CR, CHAR_LF
            db CHAR_HTAB, "Colocar esfera  (",CMD_PLAY_TURN, "): -fila -columna", CHAR_CR, CHAR_LF
            db CHAR_HTAB, "Mostrar tablero (",CMD_DISPLAY_GAME, ")", CHAR_NULL

    errorLabel db "Error: ", CHAR_NULL
    errorNoState      db "El programa ha generado un error inesperado.", CHAR_NULL
    errorUnknownCmd   db "Solo se permiten los comandos N, A, J y K", CHAR_NULL
    errorMissingInput db "No completo los parametros del comando", CHAR_NULL
    errorUnknownPanel db "Debe dar un digito de panel valido (2,3,4 o 6)", CHAR_NULL
    errorInvalidPanel db "Ya no quedan mas paneles del tipo solicitado", CHAR_NULL
    errorOrientation  db "Debe ingresar la orientacion de la pieza con H o V", CHAR_NULL
    errorNonInteger   db "Debe ingresar un digito decimal para parametros de posicion", CHAR_NULL
    errorInputRange   db "El parametro de coordenada excede el rango permitido de 0 a 9", CHAR_NULL
    errorInvalidPlay  db "No se puede jugar hasta que se complete el tablero.", CHAR_NULL
    errorInvalidAdd   db "No se puede modificar el tablero en media partida.", CHAR_NULL
    errorPanelOverflow db "El panel se extiende fuera del tablero en la posicion dada", CHAR_NULL
    errorPanelAlone    db "El panel debe colocarse adyacente a otros paneles", CHAR_NULL
    errorPanelOverlap  db "El panel se extiende encima de otro panel en la posicion dada", CHAR_NULL
    errorInvalidTurn   db "La posicion dada no esta alineada con la ultima esfera del oponente", CHAR_NULL
    errorHoleOccupied  db "La posicion dada ya esta ocupada por una esfera", CHAR_NULL
    errorPanelBlocked  db "La posicion comparte panel con la ultima esfera del oponente", CHAR_NULL
    errorVoidPosition  db "La posicion dada se sale del tablero de juego creado", CHAR_NULL
    errorFileCorrupt   db "El archivo de la partida esta corrupto o fue renombrado", CHAR_NULL

    fileRestartPrompt db "Esta seguro de que quiere reiniciar la partida? (s/n): ", CHAR_NULL
    fileRestartHalt   db "Se ha cancelado la operacion de reinicio", CHAR_NULL
    fileRestartDone   db "Se ha reiniciado el archivo de la partida", CHAR_NULL
;

; Look-up Tables
    stateTable  dw STATE_DEFAULT,       StartWrapper
    STATE_OFFSET = ($ - stateTable)
                dw STATE_HELP,          PrintHelp
                dw STATE_RESTART,       FileRestartWrapper
                dw STATE_FIRST_PANEL,   ExampleRoutine
                dw STATE_PLACE_PANEL,   ExampleRoutine
                dw STATE_FIRST_TURN,    ExampleRoutine
                dw STATE_PLAY_TURN,     ExampleRoutine
                dw STATE_GAME_OVER,     ExampleRoutine
    TABLE_SIZE = ($ - stateTable) / STATE_OFFSET
                dw STATE_ERROR,     PrintError ; Fail safe state

    commandVector db CMD_NEW_GAME, CMD_ADD_PANEL, CMD_PLAY_TURN, CMD_DISPLAY_GAME
    errorVector dw offset errorNoState, offset errorUnknownCmd, offset errorMissingInput, offset errorUnknownPanel
                dw offset errorInvalidPanel, offset errorOrientation, offset errorNonInteger, offset errorInputRange
                dw offset errorInvalidPlay, offset errorInvalidAdd, offset errorPanelOverflow, offset errorPanelAlone
                dw offset errorPanelOverlap, offset errorInvalidTurn, offset errorHoleOccupied, offset errorPanelBlocked
                dw offset errorVoidPosition, offset errorFileCorrupt
;
    base dw 10

    gamefilePath    db ".\kulami.raw", CHAR_NULL
    gamefileHandle  dw (?)

    tokenData   db GAME_RED_TOKEN, GAME_RED_SENTINEL        ; Word array[2]
                db GAME_BLACK_TOKEN, GAME_BLACK_SENTINEL

    ; Upcoming data variables are stored and recovered from disk
    programState   dw STATE_DEFAULT
    turnCounter    dw PLAYER_RED_TURN
    tokenCounters  db 2 dup(TOTAL_TOKENS)
    panelCounters  db 4 dup(0)
    panelArrayList dw TOTAL_PANELS dup(0)
    arrayListSize  db 0
    previousTurn   dw 2 dup(0)
    boardGrid      dd MATRIX_SIZE dup(MATRIX_SIZE dup(0))
    DISK_BUFFER_SIZE = ($ - programState)

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

        Jmp END_ReadInput  ; Skip error flagging line
    FLAG_NoInput:
        Mov programState, STATE_HELP
    END_ReadInput:
        Pop bx
        Pop ax
        Ret
    ReadInput endP

    ; Writes a new game file using the current game data
    ; Inputs: n/a
    ; Outpus: Writes relevant game variables in a single binary file
    WriteGameFile proc
        PUSHLIST ax, bx, cx, dx
        
        Mov dx, offset gamefilePath ; Set ASCIIZ for file op
        Xor al, al
        Mov ah, DOS_CREATE_FILE ; Attempt to create file
        Mov cx, 00h             ; Set file attributes
        Int 21h
        Jnc WRITE_WriteGameFile   ; If successful, write default contents

        Call PrintAX ; Otherwise, print error code
        Jmp END_WriteGameFile
    
    WRITE_WriteGameFile:
        Mov bx, ax                  ; Set file handle
        Mov cx, DISK_BUFFER_SIZE    ; To write byte count from
        Mov dx, offset programState ; programState up to boardGrid
        Xor al, al
        Mov ah, DOS_WRITE_FILE
        Int 21h                     ; Request file operation
        Jnc CLOSE_WriteGameFile     ; Close file if succesful

        Call PrintAX    ; Otherwise, print error code before closing file
        ; Note to self: Ideally there should be error checking for AX < CX
        ; for succesful writes to inform insufficient disk space (TODO???)

    CLOSE_WriteGameFile:
        Xor al, al
        Mov ah, DOS_CLOSE_FILE
        Int 21h                 ; Request file closure
    END_WriteGameFile:
        POPLIST ax, bx, cx, dx
        Ret
    WriteGameFile endP

    ; Retrieves game data from its file and stores it in memory
    ; Inputs: Assumes file has been confirmed to be present in directory
    ; Outputs: Stores contents from file in programState, turnCounter
    ;          tokenCounters, panelCounters, panelArrayList, arrayListSize,
    ;          previousTurn, and boardGrid
    ;          Otherwise, it creates a new file with their default variables
    LoadGameFile proc
        PUSHLIST ax, bx, cx, dx

        Mov dx, offset gamefilePath
        Mov ah, DOS_OPEN_FILE
        Mov al, FILE_ACCESS_READ ; Set access mode
        Int 21h                  ; Attempt to locate file
        Jnc READ_LoadGameFile    ; If successful, read contents

        ; Otherwise, create a new default game file
        Mov programState, STATE_FIRST_PANEL ; Restart game state
        Call WriteGameFile                  ; Write defaults to file
        Jmp END_LoadGameFile                ; Skip redundant loading
        
    READ_LoadGameFile:
        Mov bx, ax                  ; Set opened file handle
        Mov cx, DISK_BUFFER_SIZE    ; Read byte count from
        Mov dx, offset programState ; programState up to boardGrid
        Xor al, al
        Mov ah, DOS_READ_FILE
        Int 21h                     ; Request file operation
        Jnc AUX_LoadGameFile        ; Check read byte count if successful

        Call PrintAX ; Otherwise, print error code before closing file
        Call PrintCRLF
        Jmp CLOSE_LoadGameFile
    
    AUX_LoadGameFile:
        ; TODO: Check if read byte count < requested count in CX, potential corrupt file indicator
    CLOSE_LoadGameFile:
        Mov ah, DOS_CLOSE_FILE
        Xor al, al
        Int 21h                 ; Request file closure, CF = 0 (file present)
    END_LoadGameFile:
        POPLIST ax, bx, cx, dx
        Ret
    LoadGameFile endP

    ; Prints AboutMe and validates user inputs
    ; Inputs: Expects a valid command line input
    ; Output: Sends AboutMe to standard output
    StartWrapper proc
        Call LoadGameFile ; Initializes game data
        Call PrintAboutMe
        Call ReadInput
        Ret
    StartWrapper endP

    ; Restores all game variables to their default values
    ; Inputs: n/a
    ; Outputs: n/a
    ClearData proc
        PUSHLIST bx, cx
        Mov programState, STATE_FIRST_PANEL
        Mov turnCounter, PLAYER_RED_TURN
        Mov tokenCounters[0],    TOTAL_TOKENS
        Mov tokenCounters[byte], TOTAL_TOKENS
        Mov word ptr panelCounters[0],    0
        Mov word ptr panelCounters[word], 0
        Mov word ptr previousTurn[0],     0
        Mov word ptr previousTurn[word],  0
    
        Xor ch, ch
        Mov cl, arrayListSize
        Jcxz AUX_ClearData ; Skip if list was already empty (e.g Restart request after a restart request)
        
        Xor bx, bx
        Mov arrayListSize, 0
    ITER_ClearPanelList:
        Mov word ptr panelArrayList[bx], 0
        Inc bx
        Inc bx
        Loop ITER_ClearPanelList
    
    AUX_ClearData:
        Xor bx, bx
        Mov cx, (MATRIX_SIZE*MATRIX_SIZE)
    ITER_ClearBoard:
        Mov word ptr boardGrid[bx], 0
        Mov word ptr boardGrid[bx+word], 0
        Add bx, dword
        Loop ITER_ClearBoard

        POPLIST bx, cx
        Ret
    ClearData endP

    ; Asks for user input to confirm a file restart operation
    ; Inputs: Expects key entry from the standard input
    ; Outputs: Describes the result of the operation to the standard output
    FileRestartWrapper proc
        PUSHLIST ax, si

        Mov si, offset fileRestartPrompt
        Call PrintLikeC
        Mov ah, DOS_INPUT_CHAR
    ITER_FileRestartWrapper:
        Int 21h                    ; Request confirmation
        Cmp al, 's'
        Je AUX_FileRestartWrapper   ; Continue if yes
        Cmp al, 'n'
        Jne ITER_FileRestartWrapper  ; Iter until valid input
        Jmp CANCEL_FileRestartWrapper ; Halt if no
    
    AUX_FileRestartWrapper:
        Call PrintCRLF
        Call ClearData
        Call WriteGameFile
        Mov si, offset fileRestartDone
        Call PrintLikeC
        Jmp END_FileRestartWrapper
        
    CANCEL_FileRestartWrapper:
        Call PrintCRLF
        Mov si, offset fileRestartHalt
        Call PrintLikeC

    END_FileRestartWrapper:
        POPLIST ax, si
        Ret
    FileRestartWrapper endP

    ; Routine for example state
    ; Inputs: ...
    ; Outputs: Sets programState to halt if no error occured
    ExampleRoutine proc
        Call PrintAX
        Call PrintCRLF
        Mov programState, STATE_HALT
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
    
    ; Ideas preliminares de como lograr juego

    ; 1) Usar memoria en disco como memoria pseudo dinámica y una matriz sencilla
    ;   PROS: Conveniente para la revisión de puntajes por áreas
    ;   CONS: Requiere mucho planificamiento en disco y un estándar sólido la lectura del archivo

    ; 2) Usar una matriz con estructuras por celdas
    ;   PROS: No requiere mucha administración del disco más alla de guardar el estado del juego
    ;   CONS: La revisión de puntajes requiere que se almacene los rangos de las piezas y algun
    ;         listado auxiliar para determinar que piezas ya se revisaron

    ; Como la cantidad de piezas son fijas, el manejado de un listado de piezas se puede hacer con
    ; memoria estática. Hay que determinar que tamaño debería tener la estructura de cada celda
    ; para que sea conveniente de procesar

    ; En cada celda sería necesario guardar lo siguiente
    ;   Cuadrado del panel: Forma implicita, deben ser coordenadas de la esquina superior izq. a la inferior derecha
    ;                       Si es una linea horizontal, seria (r,c) y (r  ,c+k)
    ;                       Si es una linea vertical          (r,c) y (r+k,c)
    ;                       Si es un cuadrado                 (r,c) y (r+k,c+k)
    ;                       Si es un rectangulo horizontal    (r,c) y (r+i,c+j)
    ;                       Si es un rectangulo vertical      (r,c) y (r+j,c+i)
    ;   En resumen, sería posible hacer el recorrido de indices a partir de esos valores [for range (r1, r2): for range (c1, c2)]
    ;   El problema es que por si solo, esto solo sirve para analizar un panel individual. No permite distinguir unos de otros.
    ;   En la misma asignación del panel en matriz se puede insertar la información. Asumiendo SI = Row, BX = Col, CH = Row offset, CL = Col offset
    ;   Se puede crear por adelantado un valor DH:DL = (row, col):(row+i, col+j). Note que una coordenada puede caber en un byte, pues la matriz se espera
    ;   indexar de 0 a 9 y un nibble se presta para 16 valores distintos. La gran ventaja de estos datos es que indican
    ;   su orientación de forma tácita. Ya con esto se ocupa un mínimo de un word para la estructura.
    ;
    ;   Identificador del panel: De las 17 piezas, a lo sumo hay 5 de un mismo tipo (panel cuadrado). El resto son 4 c/u. En total son 4 tipos
    ;   de figuras. Ambos datos caben en un byte a cambio de complicar la lectura:
    ;       a) Usar los 2 most significant bits para indicar tipo de pieza (00xx-xxxx, 01xx-xxxx, 10xx-xxxx, 11xx-xxxx)
    ;          y el resto para indicar su ID (1,2,3,4,5*)
    ;       b) Usar el high nibble para el tipo de pieza y el nibble bajo para el ID
    ;   Aunque evidentemente es más cómoda la b, podría ser necesario guardar datos de forma compresa. Una idea sería no usar un
    ;   identificador en sí, sino un vector. Habría que retomar la idea de la orientación, y revisar su permutación para identificar el tipo
    ;   de pieza. Como el vector ocupa mínimo un nibble para los offsets (0-9 de 16 valores), se ocuparia igual un word + byte de todos modos.
    ;   Por lo tanto, sería mejor seguir la opción b de momento ya que no puede optimizarse más el consumo de bytes para identificar el pivote
    ;   del panel y su desplazamiento. Además, no vale la pena usar vectores para identificar el tipo de figura si de todos modos se requiere un
    ;   byte adicional, que sería mejor que mantenga ese dato a mano
    ;
    ;   Contenido del panel: Posiblemente el más sencillo, pues su revisión es directa a diferencia de los otros que deben procesarse
    ;                        sus bit strings. Para este se podría almacenar directamente un 'O' para indicar posición vacía. Un '2'
    ;                        para ficha negra sentinela, un '1' para ficha roja sentinela, un 'X' para ficha negra y un 'B' para ficha roja
    ;
    ; Además del tablero, sería prudente manejar entonces el listado de piezas en orden con un array de words {Little-endian: coordPivote, identificador}
    ; Este siempre inicia vacío, pero conforme se crea el tablero (y por ende, se cargará del disco a memoria como tal), se agregará el registro de su
    ; creación siempre que fuera un posicionamiento válido
    ;
    ; Encima de ello, se necesita manejar un contador o bandera de turno. Una forma sería mediante el estado del programa, pero esto duplicaría
    ; los estados funcionales del mismo. Lo mejor sería una variable aparte. Pienso que la alternativa sería otro arreglo de dos elementos.
    ; Cada elemento indica la última jugada del contrincante mediante un indice de turno. En la etapa/fase del tablero, el arreglo se mantendra vacío
    ; y sólo se revisara el indice de partida. Cuando se esté en fase de juego, además de revisar el turno, se puede comparar los datos de la jugada anterior.
    ; La idea entonces es:
    ;       a) Se distingue el primer turno por un estado del programa, se permite cualquier jugada con entradas numericamente validas. Además de actualizar
    ;          el contador de turno, se utiliza para guardar la jugada del contrincante. (0:Red, 1:Black)
    ;          Ej. 0 -> 1 : Red Player Finished turn, prevTurn[1] = inputPos:byte, identificador, viceversa
    ;       b) En otros turnos, se mantiene la dinámica pero antes de insertar, se recupera la posición del turno previo para comparar si la jugada es valida.
    ;          Como debe alinearse en cruz, debe tener la misma fila o la misma columna, pero no ambas. Si está en cruz, luego se recupera la dirección en DI
    ;          de donde quiere colocarse la ficha. A partir de ahí, se revisa que el panel este vacío, luego que el identificador no sea el mismo que el del
    ;          turno del contrincante. Si todo está en orden, se coloca el contenido respectivo.
    ;       c) Un detalle IMPORTANTE: Al finalizar el turno, se debe actualizar ademas el sentinela de la jugada. Es decir, en otros turnos, tras colocar el nuevo
    ;          sentinela (se puede indexar el caracter a colocar en otro arreglo con 0 y 1), se debe "normalizar" la posición anterior para que tenga un caracter
    ;          regular. Luego de ello, se puede actualizar el contador de turno, y luego se guarda la jugada en la celda del contrincante.
    ;       d) Al finalizar la jugada en turnos distintos del primero, es conveniente hacer la revisión de la nueva cruz que debe cumplir el siguiente jugador.
    ;          Nota a futuro: Se que podría parecer que la revisión se necesita antes de mover el contador de turno. Sin embargo, lo que se ocupa es determinar
    ;          por adelantado si la cruz esta llena antes de permitir un nuevo turno. Debió existir por lo menos un turno inicial que condicionó otro turno y ese
    ;          turno ha revisado la cruz para el siguiente turno y viceversa en cascada. Otra forma de verlo es que la cruz en la que jugo un jugador tenia campos
    ;          de sobra, pero uno de esos llevaba a una posición de gane en la que el otro jugador no puede participar más.
    ;       e) Finalmente, debe revisarse también que queden fichas para el siguiente jugador. Nuevamente, esto se puede manejar con un sencillo arreglo al que
    ;          se apunta con el contador de turno. Una opción sería mezclar el arreglo del que se toma el caracter, pero veo mejor el no alambrar estos datos
    ;          solo porque se puede.
    ;
    ; Una vez establecido el estado de fin del juego, el programa puede hacer el conteo de puntos iterando sobre el arreglo estático de piezas. Por cada una
    ; se recorre su área para contar que ficha domina. Según el código identificador, se puede otorgar los puntos respectivos. Si hay empate, se detiene la iteración.
    ; También se agrega un conteo de cuantas areas ganó cada uno.
    ;
    ; Otro aspecto relevante sería el agrupamiento de variables en memoria. Sería conveniente que todas las que se escriben al archivo estén juntas, pues se podría
    ; dar un simple puntero al inicio y usar una variable del preprocesador para calcular la longitud de la dirección. Con ello se manda a escribir al archivo y listo.

    ; Borrador de la estructura del archivo de juego
    ;
    ; Los datos pertinentes a la funcionalidad del programa son
    ;       programState (word) : Determina el contexto de la partida para el programa, defaults to 0000h for new games
    ;       turnCounter  (word) : Determina turno del jugador y permite acceder datos pertinentes al mismo (ultimo mov del contrincante, representacion de piezas)
    ;       panelCounters byte array[4] : Lleva conteo de 0 a k_i para determinar disponibilidad de piezas
    ;       panelList word array[17] : Inicia nulo, en el se registrara el orden en que se colocaron las piezas
    ;       listSize (byte)          : Lleva conteo de piezas colocadas
    ;       previousTurn word array[2] : Cada elemento es la ultima posicion jugada por el contrincante y el panelID asociado
    ;       tokenCounters byte array[2] : Similar al anterior, lleva registro de cuantas fichas/esferas quedan para cada jugador
    ;       boardGrid dword array[10][10] : Inicializado en 00h para toda celda. Esta informacion se sobreescribe al colocar paneles y fichas
    ;
    ; Otro dato relevante, pero que es estatico y por lo tanto no se almacenara, es la letra de escritura para el contenido de una celda
    ;       tokenData word array[2]
    ; Igualmente se referencia con el turn counter, pero este contiene dos chars. Uno que identifica una pieza regular y otro para piezas sentinelas
    ; Para mayor conveniencia, se ordenaran dichas variables pertinentes en secuencia para poder escribir y leerlas como si se tratasen de un buffer
    ; dedicado de archivos

    main:
        Mov ax, ds
        Mov es, ax ; Save PSP's address

        Mov ax, StackSegment
        Mov ss, ax ; Set stack's address

        Mov ax, DataSegment
        Mov ds, ax ; Set data's address


        Call LoadGameFile
        Call FileRestartWrapper
        Jmp exit

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