; Documentacion
    ; ╔═════════════════════════════════════╦═══════════════════════════════════╗
    ; ║ Instituto Tecnologico de Costa Rica ║ Gabriel Gomez Vega                ║
    ; ║ Escuela de Computacion              ║ 2021106483                        ║
    ; ║ Arquitectura de Computadoras        ║ 17 de Octubre del 2025            ║
    ; ╚═════════════════════════════════════╩═══════════════════════════════════╝
    ; ╔═════════════════════════════════════════════════════════════════════════╗
    ; ║                            Manual de Usuario                            ║
    ; ╠═════════════════════════════════════════════════════════════════════════╣
    ; Este es un prototipo del juego de mesa Kulami
    ; Presenta funcionalidad para crear un juego nuevo (o borrar uno existente)
    ; Para ver una representacion del tablero
    ; Y para crear el tablero pieza a pieza
    ; El programa acepta 4 comandos de entrada. No es case sensitive para facilitar
    ; su uso
    ; Los comandos N y K, crear partida y desplegar tablero, no ocupan parametros
    ; e ignoran cualquier entrada adicional
    ; El comando de panel espera un identificador de la pieza (2,3,4,6)
    ; la orientacion H o V
    ; y la posicion fila y columna
    ; La funcionalidad de juego no esta implementada :(
    ; Sin embargo, el programa si valida la creacion del tablero hasta su completitud
    ; ╚═════════════════════════════════════════════════════════════════════════╝
    ; ╔═════════════════════════════════════════════════════════════════════════╗
    ; ║                        Analisis de Resultados                           ║
    ; ╠══════════════════════════════════════════════════════════╦══════════════╣
    ; ║                          Aspectos                        ║ Calificacion ║
    ; ╠══════════════════════════════════════════════════════════╬══════════════╣
    ; ║ Documentacion                                            ║      B       ║
    ; ╠══════════════════════════════════════════════════════════╬══════════════╣
    ; ║ Despliegue de la Ayuda                                   ║      A       ║
    ; ╠══════════════════════════════════════════════════════════╬══════════════╣
    ; ║ Lectura de la linea de comandos                          ║      A       ║
    ; ╠══════════════════════════════════════════════════════════╬══════════════╣
    ; ║ Restricciones de la entrada                              ║      B       ║
    ; ╠══════════════════════════════════════════════════════════╬══════════════╣
    ; ║ Manejo de errores                                        ║      B       ║
    ; ╠══════════════════════════════════════════════════════════╬══════════════╣
    ; ║ Creacion de archivos / partida nueva                     ║      A       ║
    ; ╠══════════════════════════════════════════════════════════╬══════════════╣
    ; ║ Insercion de paneles                                     ║      A       ║
    ; ╠══════════════════════════════════════════════════════════╬══════════════╣
    ; ║ Despliegue del tablero                                   ║      D       ║
    ; ╚══════════════════════════════════════════════════════════╩══════════════╝
    ; ║ Juego (colocar piezas, turnos, reglas)                   ║      D       ║
    ; ╚══════════════════════════════════════════════════════════╩══════════════╝

    ; Explicacion adicional
    ;
    ; Respecto a la documentacion, este no cuenta con el nivel usual de detalle
    ; que acostumbro para las rutinas debido a falta de tiempo y, en particular
    ; con el despliegue del tablero, a que eran versiones experimentales. Por lo
    ; tanto, estas rutinas tienen documentacion escasa y un codigo algo obtuso.
    ; 
    ; Las restricciones de la entrada por linea de comandos son validadas con
    ; exito en lo que respecta a valores validos. No se hace una revision minuciosa,
    ; se espera que los espacios vengan bien por ejemplo. Sin embargo, si se verifica
    ; que se ingresen todos los parametros. Lo califico con B debido a que, al faltar
    ; la implementacion de la fase de juego, no se llega a validar casos como 
    ; posiciones que no esten alineadas en cruz con la ultima pieza del contrincante,
    ; etc. Sin embargo, si se tenia un diseño en mente. Muy brevemente, hay una sección
    ; en el segmento de datos del cual se escribe directamente en disco y viceversa.
    ; Esas son las variables mas importantes de juego y en ellas se llevaba un registro
    ; del turno (0 o 1) que ademas serviria para indexar una entrada de un arreglo que
    ; respalda los datos mas importantes del turno anterior del rival (posicion de juego,
    ; id del tablero).

    ; De igual forma, el manejo de errores no esta completo debido a que falta la fase de
    ; juego. Sin embargo, este programa igual utiliza un diseño de automata como he hecho
    ; en tareas anteriores, asi que agregar esos errores seria casi inmediato de haber hecho
    ; los procedimientos.

    ; Lo que respecta al despliegue, como se menciono, esta incompleto. Se cuenta con una idea
    ; general de como desplegar. Se analiza la fila y en un buffer aparte se contruye el marco
    ; progresivamente. Hay 3 de 4 algoritmos hechos: Uno que crea un encabezado, destinado para
    ; la primer fila, otro que crea un pie de pagina para la última, y otro que crea el formato
    ; para la misma fila. Falta la funcion de intermedio, que seria la que conecta las lineas
    ; entre filas de la 2 a la N. Esta no se implemento por tiempo, pero si tenia claro que debia
    ; analizar simultaneamente la fila actual y la siguiente, tomando en cuenta el elem. anterior
    ; como se hizo en las otras 3

    ; Del juego, se puede crear el tablero y se tienen los controles previstos para entrar en dicha
    ; fase. Sin embargo, quedo pendiente hacer las rutinas que toman los datos ya ingresados y
    ; validan posicion, que el espacio este vacio, que este alineado con la ultima pieza, etc.
    ; Para la fase de conteo de puntos, en la misma construccion del tablero se habia previsto
    ; una lista tipo arreglo que identifcaba posicion e identificador de cada pieza. La idea era
    ; que al detectar una partida acabada, se tomaria cada entrada del arreglo y una funcion haria
    ; el recorrido con sus datos. Esta regresaria el puntaje del panel individual y la iteracion
    ; obtendria el acumulado.
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

    ; Increases a register with a word-sized step
    ; Inputs: R - Register to increase
    INCW Macro R:REQ
        Inc R
        Inc R
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

        CHAR_UL_CORNER = 218 ; ┌
        CHAR_UR_CORNER = 191 ; ┐
        CHAR_DL_CORNER = 192 ; └
        CHAR_DR_CORNER = 217 ; ┘

        CHAR_R_JOINT = 180 ; ┤
        CHAR_L_JOINT = 195 ; ├
        CHAR_U_JOINT = 194 ; ┬
        CHAR_D_JOINT = 193 ; ┴
        CHAR_A_JOINT = 197 ; ┼

        CHAR_V_LINE = 179 ; │
        CHAR_H_LINE = 196 ; ─
    ;

    ; State Machine
        STATE_HALT    = 0000h
        STATE_DEFAULT = 0001h
        STATE_HELP    = 0002h
        STATE_RESTART = 0003h
        STATE_DISPLAY = 0004h
        STATE_FIRST_PANEL = 0005h
        STATE_PLACE_PANEL = 0006h
        STATE_FIRST_TURN  = 0007h
        STATE_PLAY_TURN   = 0008h
        STATE_GAME_OVER   = 0009h
        ; 8000h to FFFFh are reserved for errors, 8000h is a failsafe state
        STATE_ERROR   = 8000h ; Used as reference for comparisons
        ERROR_UNKNOWN_CMD    = 8001h
        ERROR_MISSING_INPUT  = 8002h
        ERROR_UNKNOWN_PANEL  = 8003h ; Panel ID different from 2,3,4,6
        ERROR_INVALID_PANEL  = 8004h ; Chosen panel ran out
        ERROR_ORIENTATION    = 8005h ; Invalid orientation code
        ERROR_NON_INTEGER    = 8006h ; Non-int input for row/col
        ERROR_INPUT_RANGE    = 8007h ; Row/Col exceeds range 0 to 9 (Unused)
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
        GAME_NO_TOKEN       = 'O'

        ; Turn and panel shapes
        PLAYER_RED_TURN     = 0
        PLAYER_BLACK_TURN   = 1
        TOTAL_TOKENS        = 28

        PANEL_LINE_2_ID     = '2'
        PANEL_LINE_3_ID     = '3'
        PANEL_SQUARE_ID     = '4'
        PANEL_RECT_6_ID     = '6'

        PANEL_VERTICAL      = 'V'
        PANEL_HORIZONTAL    = 'H'

        PANEL_LINE_2_OFFSET = 0201h ; Row:Col offsets are vertical by default
        PANEL_LINE_3_OFFSET = 0301h
        PANEL_SQUARE_OFFSET = 0202h
        PANEL_RECT_6_OFFSET = 0302h

        PANEL_TYPES         = 4
        PANEL_SHAPE_LIMIT   = 4
        PANEL_SQUARE_LIMIT  = 5
        TOTAL_PANELS        = 17
        VOID_PANEL          = 0
    ;

    ; Misc
        PSP_INPUT_OFFSET = 80h  
    ;
;

; String literals
    aboutMe db "ITCR: Escuela de Computacion - Arquitectura de Computadoras. 17/Oct/2025", CHAR_CR, CHAR_LF
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

    headerRow db "    0   1   2   3   4   5   6   7   8   9", CHAR_NULL
;

; Look-up Tables
    stateTable  dw STATE_DEFAULT,       StartWrapper
    STATE_OFFSET = ($ - stateTable)
                dw STATE_HELP,          PrintHelp
                dw STATE_RESTART,       FileRestartWrapper
                dw STATE_DISPLAY,       DisplayWrapper
                dw STATE_FIRST_PANEL,   AddPanelWrapper
                dw STATE_PLACE_PANEL,   AddPanelWrapper
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

    counterPtrVector db PANEL_LINE_2_ID, byte*0 ; Matches each ID to a counter, and a position offset
                     db PANEL_LINE_3_ID, byte*1
                     db PANEL_SQUARE_ID, byte*2
                     db PANEL_RECT_6_ID, byte*3

    posOffsetVector dw PANEL_LINE_2_OFFSET, PANEL_LINE_3_OFFSET, PANEL_SQUARE_OFFSET, PANEL_RECT_6_OFFSET
;
    base dw 10

    gamefilePath    db ".\kulami.raw", CHAR_NULL
    gamefileHandle  dw (?)

    tokenData   db GAME_RED_TOKEN, GAME_RED_SENTINEL        ; Word array[2]
                db GAME_BLACK_TOKEN, GAME_BLACK_SENTINEL
    
    commandParam   db (?)
    panelParam     db (?)
    directionParam db (?)
    rowParam       db (?)
    colParam       db (?)

    printBuffer   db 41 dup(0), CHAR_NULL
    prevPrintChar db (?)

    ; Upcoming data variables are stored and recovered from disk
    programState   dw STATE_DEFAULT
    turnCounter    dw PLAYER_BLACK_TURN
    tokenCounters  db 2 dup(TOTAL_TOKENS)
    panelCounters  db 4 dup(0)
    panelArrayList dw TOTAL_PANELS dup(0)
    arrayListSize  db 0
    previousTurn   dw 2 dup(0)
    boardGrid      dd MATRIX_SIZE dup(MATRIX_SIZE dup(VOID_PANEL))
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

    ; Reads a command line parameter for a command code
    ; Inputs: [BX] - Expects pointer to the parameter char in the command tail
    ; Outputs: [commandParam]   - Saves the input in byte sized buffer
    ;          [programState] - May set an error state if invalid
    ;           CF            - Set if input parsing must halt early (due to error or no params required)
    ReadCommandParam proc
        Mov al, byte ptr es:[PSP_INPUT_OFFSET + bx]
        And al, 11011111b                           ; Enforce upper case to allow leniency
        Mov commandParam, al    ; Save command input for later use

        Cmp al, CMD_NEW_GAME
        Jne TEST_IsOverrideCmd  ; Check if command can override state

        Mov programState, STATE_RESTART ; Override game state to handle restart request
        Jmp FLAG_HaltEarly

    TEST_IsOverrideCmd:
        Cmp al, CMD_DISPLAY_GAME
        Jne AUX_ReadCommandParam   ; If not a display request, avoid override and check remaining options
        
        Mov programState, STATE_DISPLAY ; Override state to handle display request
        Jmp FLAG_HaltEarly

    AUX_ReadCommandParam:
        Cmp al, CMD_PLAY_TURN
        Je FLAG_RequiresParams ; Known parametrized command, flag accordingly
        Cmp al, CMD_ADD_PANEL
        Jne FLAG_UnknownCmd    ; Flag error if command is unknown, otherwise proceed to parametrized flag

    FLAG_RequiresParams:
        Clc
        Jmp END_ReadCommandParam

    FLAG_UnknownCmd:
        Mov programState, ERROR_UNKNOWN_CMD
    FLAG_HaltEarly:
        Stc
    END_ReadCommandParam:
        Ret
    ReadCommandParam endP

    ; Reads a command line parameter for a panel code
    ; Inputs: [BX] - Expects pointer to the parameter char in the command tail
    ; Outputs: [panelParam]   - Saves the input in byte sized buffer
    ;          [programState] - May set an error state if invalid
    ;           CF            - Set if an error state was flagged
    ReadPanelParam proc
        Mov al, byte ptr es:[PSP_INPUT_OFFSET + bx] ; Get panel param code
        Mov panelParam, al                          ; Assume valid and store it

        Cmp al, PANEL_LINE_2_ID ; Compare param with each known code
        Je FLAG_ValidPanel
        Cmp al, PANEL_LINE_3_ID
        Je FLAG_ValidPanel
        Cmp al, PANEL_SQUARE_ID
        Je FLAG_ValidPanel
        Cmp al, PANEL_RECT_6_ID
        Je FLAG_ValidPanel

        Mov programState, ERROR_UNKNOWN_PANEL ; Flag error if input is unrecognized
        Stc
        Jmp END_ReadPanelParam
    FLAG_ValidPanel:
        Clc
    END_ReadPanelParam:
        Ret
    ReadPanelParam endP

    ; Reads a command line parameter for a panel's orientation
    ; Inputs: [BX] - Expects pointer to the parameter char in the command tail
    ; Outputs: [directionParam] - Saves the input in byte sized buffer
    ;          [programState]   - May set an error state if invalid
    ;           CF              - Set if an error state was flagged
    ReadDirectionParam proc
        Mov al, byte ptr es:[PSP_INPUT_OFFSET + bx] ; Get param code
        And al, 11011111b                           ; Enforce upper case to allow leniency
        Mov directionParam, al                      ; Assume valid and store it

        Cmp al, PANEL_VERTICAL
        Je FLAG_ValidDirection
        Cmp al, PANEL_HORIZONTAL
        Je FLAG_ValidDirection

        Mov programState, ERROR_ORIENTATION ; Flag error if code is invalid
        Stc
        Jmp END_ReadDirectionParam

    FLAG_ValidDirection:
        Clc 
    END_ReadDirectionParam:
        Ret
    ReadDirectionParam endP

    ; Reads a command line parameter for a digit
    ; Inputs:  [BX]    - Expects pointer to the parameter char in the command tail
    ;          DS:[DI] - Address of byte sized buffer
    ; Outputs: DS:[DI]          - Saves the input at specified address
    ;          [programState]   - May set an error state if invalid
    ;           CF              - Set if an error state was flagged
    ReadDigitParam proc
        Mov al, byte ptr es:[PSP_INPUT_OFFSET + bx] ; Get param char

        Xor al, 30h  ; Bit mask to obtain int val from char
        Cmp al, 0Ah
        Jb FLAG_ValidDigit ; Valid if within 0 to 9

        Mov programState, ERROR_NON_INTEGER
        Stc
        Jmp END_ReadDigitParam

    FLAG_ValidDigit:
        Mov byte ptr ds:[di], al
        Clc
    END_ReadDigitParam:
        Ret
    ReadDigitParam endP

    ; Reads a command line parameter for a board position
    ; Inputs:  [BX] - Expects pointer to the previous parameter in the command tail
    ; Outputs: [rowParam] and [colParam] - Saves the inpust in byte sized buffers
    ;          [programState]            - May set an error state if invalid
    ReadPositionParam proc
        Push di

        INCW bx
        Cmp bx, cx
        Ja FLAG_MissingPosition  ; Halt if input is over before required param
        Mov di, offset rowParam
        Call ReadDigitParam
        Jc END_ReadPositionParam ; Halt if input is not a decimal digit

        INCW bx
        Cmp bx, cx
        Ja FLAG_MissingPosition
        Mov di, offset colParam
        Call ReadDigitParam
        Jmp END_ReadPositionParam ; Skip further error flagging, implicit in prev call

    FLAG_MissingPosition:
        Mov programState, ERROR_MISSING_INPUT
    
    END_ReadPositionParam:
        Pop di
        Ret
    ReadPositionParam endP

    ; Reads the command line's input and stores parameters if present
    ; Inputs: Expects a command code, and some parameters depending on it
    ; Outputs: Stores values in data variables, and flags errors if necessary
    ReadInput proc
        Push ax
        Push bx
        Push cx

        Xor bx, bx
        Xor ch, ch 
        Mov cl, byte ptr es:[PSP_INPUT_OFFSET]
        Cmp cl, 0                  ; Is there an input?
        Je FLAG_NoInput            ; If not, set new state, and halt proc

        ; If there is, analize parameters required
        INCW bx ; Skip input-preceding whitespace, and point to first char
        Call ReadCommandParam
        Jc END_ReadInput        ; Halt early if cmd does not require params or for flagged error

        Cmp commandParam, CMD_PLAY_TURN
        Je AUX_ReadInput                ; Only parse position for play commands

        INCW bx
        Cmp bx, cx
        Ja FLAG_MissingInput ; Halt if input is over before required param
        Call ReadPanelParam
        Jc END_ReadInput     ; Halt if input is unknown

        INCW bx
        Cmp bx, cx
        Ja FLAG_MissingInput
        Call ReadDirectionParam
        Jc END_ReadInput        ; Halt if invalid
        
    AUX_ReadInput:
        Call ReadPositionParam

        Jmp END_ReadInput  ; Skip error flagging line
    FLAG_MissingInput:
        Mov programState, ERROR_MISSING_INPUT
        Jmp END_ReadInput
    FLAG_NoInput:
        Mov programState, STATE_HELP
    END_ReadInput:
        Pop cx
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
        Mov programState, STATE_HALT
        POPLIST ax, si
        Ret
    FileRestartWrapper endP

    ; Obtains a board address to use as pivot for panel data
    ; Inputs:  CH:CL - Row and column, assumed within 0-9
    ; Outputs: [SI]  - Offset to row and column inside board matrix
    GetPivotOffsetSI proc
        Push ax

        Mov ax, MATRIX_SIZE*dword ; Row size for calculation
        Mul ch
        Mov si, ax  ; Save offset to row

        Mov ax, dword ; Col size
        Mul cl
        Add si, ax  ; Apply offset to column within row

        Pop ax
        Ret
    GetPivotOffsetSI endP

    ; Writes each data column of a panel's row. Auxiliar to CreatePanel
    ; Inputs: [SI] - Starting address within a row of the boardGrid
    ;         CL   - Columns to write
    ; Outputs: [programState]   - May set an error state if panel can't be created
    ;          CF - Set if an error was flagged
    WritePanelRow proc
        Push si
        Push cx
    
    ITER_WritePanelRow:
        Mov bx, word ptr boardGrid[si]
        Cmp bx, VOID_PANEL
        Jne FLAG_PanelOverlap ; If another panel already exists, flag placement collision

        Mov word ptr boardGrid[si],      ax ; Store panel identifier and content buffer first
        Mov word ptr boardGrid[si+word], dx ; Then store DH:DL as pivot coord, and offset to lower corner
        Add si, dword                       ; Point to next column
        Dec cl                              ; Discard processed column from count
        Jnz ITER_WritePanelRow

        Clc
        Jmp END_WritePanelRow

    FLAG_PanelOverlap:
        Mov programState, ERROR_PANEL_OVERLAP
        Stc

    END_WritePanelRow:
        Pop cx
        Pop si
        Ret
    WritePanelRow endP

    ; Writes panel data inside the board from a pivot location, and enlists it
    ; Inputs:   CH:CL - Row and colum, assumes values within 0-9
    ;           DH:DL - Row count and column count
    ;           AH:AL - Panel code, and id
    ; Outputs: [programState]   - May set an error state if panel can't be created
    ;          [panelArrayList] - Enlists panel data if operation is valid
    ;          [arrayListSize]  - Updates list size
    ;           AH:AL           - Compressed panel identifier : Panel Content
    ;           CF              - Set if an error was flagged, cleared if successful
    CreatePanel proc
        PUSHLIST si, bx, cx, dx

        Call GetPivotOffsetSI
        Mov bx, cx  ; Copy upper corner data to calc lower corner position
        Add bh, dh  ; Add counts to determine halt position
        Add bl, dl              
        Dec bh      ; Adjustment to express proper range utilized. E.g If count = 1
        Dec bl      ; and pos = 0, row/col 0 will be used, not row/col 1
        Cmp bh, MATRIX_SIZE
        Jae FLAG_PanelOverflow
        Cmp bl, MATRIX_SIZE
        Jae FLAG_PanelOverflow  ; Flag if panel placement extends beyond valid range

        Xchg cx, dx ; If valid placement range, set counts in CH:CL for upcoming loops

        Shl dh, 4   ; Set pivot corner's row as high nibble
        Add dh, dl  ; Compress pivot corner as DH = row:col
        Mov dl, ch  ; Obtain row count copy
        Shl dl, 4   ; Set as high nibble
        Add dl, cl  ; Compress offset from corner as DL = row:col counts
        Shl ah, 4   ; Set panel code as upper nibble
        Add ah, al
        Mov al, GAME_NO_TOKEN ; Compress AH = PanelCode:ID, and AL = Panel Contents (empty default)

    ITER_CreatePanelRow:
        Call WritePanelRow
        Jc END_CreatePanel        ; Halt if an error was flagged
        Add si, MATRIX_SIZE*dword ; Jump to next row
        Dec ch                    ; Discard processed row from count
        Jnz ITER_CreatePanelRow

        Mov si, word ptr arrayListSize ; Retrieve list size (byte capacity)
        And si, 00FFh                  ; Clear unrelated upper byte data
        Shl si, byte                   ; Adjust index for word-sized item addressing

        Mov byte ptr panelArrayList[si+byte], ah ; Enlist panel identifier
        Mov byte ptr panelArrayList[si],      dh ; and its location
        Inc arrayListSize                        ; Update item counter
        Clc                                      ; Denote successful operation
        Jmp END_CreatePanel ; Halt without error state

    FLAG_PanelOverflow:
        Mov programState, ERROR_PANEL_OVERFLOW
        Stc ; Denote operation error
    
    END_CreatePanel:
        POPLIST si, bx, cx, dx
        Ret
    CreatePanel endP

    ; Determines whether a panel has ran out or if it is available for use
    ; Inputs:   AH - Valid code that identifies a panel type
    ; Outputs:  AL - Current count of the panel type
    ;           CF - Set if panel is available, clear if it ran out
    ;           BX - Address to current count's byte
    ;           DH:DL - Position offset in row:col format
    GetPanelData proc
        PUSHLIST si, cx

        Xor bx, bx
        Mov cx, PANEL_TYPES
    ITER_GetPanelData:
        Mov dx, word ptr counterPtrVector[bx] ; Get entry DH:DL = Index:ID
        Cmp ah, dl
        Je AUX_PanelMatch ; Halt if a match is found
        INCW bx           ; Otherwise, proceed to next entry
        Loop ITER_GetPanelData ; Always finds a match assuming AH was validated previously

    AUX_PanelMatch:
        Mov bl, dh                         ; Retrieve countPtr to obtain
        Mov al, byte ptr panelCounters[bx] ; copy of current count, used as an ID enumerator
        Mov dh, PANEL_SHAPE_LIMIT   ; To test availability

        Cmp ah, PANEL_SQUARE_ID
        Jne TEST_IsPanelAvailable   ; If panel is not a square, perform default test
        Mov dh, PANEL_SQUARE_LIMIT  ; Otherwise, use respective boundary

    TEST_IsPanelAvailable:
        Cmp al, dh
        Jb FLAG_PanelAvailable  ; Flag panel as ready for use
        Clc
        Jmp END_GetPanelData    ; Otherwise, flag unavailable

    FLAG_PanelAvailable:
        Stc
    END_GetPanelData:
        Pushf ; To avoid SHL from altering CF result
        Shl bx, 1            ; Adjust index to address word sized items
        Popf
        Mov dx, word ptr posOffsetVector[bx] ; Retrieve position offset
        POPLIST si, cx
        Ret
    GetPanelData endP

        ; Determines if another panel unit belongs to a different identifier
    ; Inputs:   AH - Panel identifier from current panel
    ;           BH - Assumed panel identifier from another panel
    ; Outputs: CF - Set if both panels are different, cleared if the target is void or the same panel
    IsPanelDifferent proc
        Cmp bh, VOID_PANEL
        Je FLAG_NotDifferent ; Flag not different if the assumed panel is a void area
        Cmp bh, ah
        Je FLAG_NotDifferent ; Jump if both area units belong to the same panel identifier
        Stc
        Jmp END_IsPanelDifferent ; Otherwise, flag for different parent identifiers and halt
    
    FLAG_NotDifferent:
        Clc
    END_IsPanelDifferent:
        Ret
    IsPanelDifferent endP

    ; Checks if the a panel's surrounding area is void
    ; Inputs: CH:CL - Row and colum of panel's pivot
    ;         DH:DL - Row count and column count
    ;         AH    - Compressed panel identifier
    ; Outputs: CF - Set if panel is alone, cleared if surrounded
    IsLonePanel proc
        PUSHLIST si, ax, bx, cx

        Call GetPivotOffsetSI
    ITER_LonePanelRow: ; CH:CL tracks row:col position of SI, DH:DL track remaining loops for row:col
        PUSHLIST si, cx, dx ; Preserve row and it offset's values to avoid permanent alteration in inner loop
    ITER_LonePanelCol:
        
        Cmp ch, 0
        Je TEST_AreaBelow ; If row is 0, skip as there are no rows above it

        Mov bx, word ptr boardGrid[si - MATRIX_SIZE*dword] ; Check area unit from above
        Call IsPanelDifferent
        Jc FLAG_PanelSurrounded    ; Halt if another panel structure is adjacent, flag is already set

    TEST_AreaBelow:
        Cmp ch, MATRIX_SIZE-1
        Je TEST_LeftArea       ; Skip if last row, there are none below it

        Mov bx, word ptr boardGrid[si + MATRIX_SIZE*dword] ; Check area unit from below
        Call IsPanelDifferent
        Jc FLAG_PanelSurrounded

    TEST_LeftArea:
        Cmp cl, 0
        Je TEST_RightArea      ; Skip if last column, there are none next to it

        Mov bx, word ptr boardGrid[si - dword]  ; Check area unit to its left
        Call IsPanelDifferent
        Jc FLAG_PanelSurrounded

    TEST_RightArea:
        Cmp cl, MATRIX_SIZE-1
        Je AUX_IsLonePanel  ; Skip if first column, there are none prior to it

        Mov bx, word ptr boardGrid[si + dword]  ; Check area unit to its right
        Call IsPanelDifferent
        Jc FLAG_PanelSurrounded
    
    AUX_IsLonePanel:
        Add si, dword ; Jmp to next column
        Inc cl        ; Update col value to track SI position
        Dec dl        ; Discard processed col from count
        Jnz ITER_LonePanelCol

        POPLIST si, cx, dx
        Add si, MATRIX_SIZE*dword ; Jump to next row
        Inc ch                    ; Update row value to track SI position
        Dec dh                    ; Discard processed row
        Jnz ITER_LonePanelRow

        Stc ; Set to denote no adjacent panel structure different from itself exists
        Jmp END_IsLonePanel
    
    FLAG_PanelSurrounded:
        POPLIST si, cx, dx ; Resolve pending stack clean up from iter
        Clc                ; Clear to denote condition as false

    END_IsLonePanel:
        POPLIST si, ax, bx, cx
        Ret
    IsLonePanel endP

    ; Processes an add panel request, and performs any validations necessary
    ; Inputs: [panelParam]      - Valid panel code requested
    ;         [directionParam]  - Valid panel orientation code
    ;         [rowParam]        - Row position for pivot (upper corner) of panel
    ;         [colParam]        - Col position for pivot
    ; Outputs: [boardGrid]      - Updates matrix contents with panel
    ;          [programState]   - May set an error state if panel ran out, overflows,
    ;                             overlaps, is alone (2nd onwards), or if a play request
    ;                             was sent instead. It may also transition to the gameplay
    ;                             stage when the board is finished
    AddPanelWrapper proc
        PUSHLIST ax, bx, cx, dx

        Cmp commandParam, CMD_PLAY_TURN
        Je FLAG_InvalidPlay ; Block play requests until board is created

        Mov ah, panelParam
        Call GetPanelData              ; Get AL:countEnum, and [BX} to index original counter, and posOffset in DX
        Jnc FLAG_PanelUnavailable      ; Halt if requested panel already ran out
        Inc byte ptr panelCounters[bx] ; Otherwise, update to account for current panel request

        Mov ch, rowParam ; Set row:col position prior to proc call
        Mov cl, colParam ; AH:AL and DH:DL already set
        Cmp directionParam, PANEL_VERTICAL
        Je WRITE_AddPanelWrapper            ; Proceed to panel creation for default direction
        Xchg dh, dl                         ; Otherwise, exchange row:col values in posOffset   

    WRITE_AddPanelWrapper:
        Call CreatePanel
        Jc END_AddPanelWrapper ; Halt if panel creation resulted in an error

        Cmp programState, STATE_FIRST_PANEL ; If not the first panel, test it is adjacent to existing panels
        Jne TEST_PanelAdjacency
        Mov programState, STATE_PLACE_PANEL ; Otherwise, update game state for future panel operations, and skip
        Jmp  AUX_AddPanelWrapper            ; adjacency test
    
    TEST_PanelAdjacency:
        Call IsLonePanel
        Jc FLAG_LonePanel
    
    AUX_AddPanelWrapper:
        Cmp arrayListSize, TOTAL_PANELS
        Jb SAVE_AddPanelWrapper
        Mov programState, STATE_FIRST_TURN ; If play area is complete, update game state to allow play commands
    
    SAVE_AddPanelWrapper:
        Call WriteGameFile ; If operation was successful, save to disk
        Mov programState, STATE_HALT
        Jmp END_AddPanelWrapper ; Skip error flagging logic
    FLAG_LonePanel:
        Mov programState, ERROR_PANEL_ALONE
        Jmp END_AddPanelWrapper
    FLAG_PanelUnavailable:
        Mov programState, ERROR_INVALID_PANEL
        Jmp END_AddPanelWrapper
    FLAG_InvalidPlay:
        Mov programState, ERROR_INVALID_PLAY
    END_AddPanelWrapper:
        POPLIST ax, bx, cx, dx
        Ret
    AddPanelWrapper endP

    ; Prepares a printable buffer with a row's header
    ; Inputs: [SI] - Pointer to the start of the row
    ; Outputs: [printBuffer] - Contents to print
    WriteRowHeader proc
        PUSHLIST si, di, ax, cx, dx

        Xor di, di ; To index within printBuffer
        Mov cx, MATRIX_SIZE
        Mov prevPrintChar, VOID_PANEL
    ITER_WriteRowHeader:
        Mov dh, CHAR_SPACE
        Mov dl, CHAR_SPACE ; Assume empty print
        Mov ax, word ptr boardGrid[si] ; AH:AL = ID:Content

        Cmp ah, prevPrintChar ; Determine if area is continuous or not
        Je EQUAL_WriteRowHeader

    DIFF_WriteRowHeader:
        Mov dh, CHAR_UL_CORNER
        Mov dl, CHAR_H_LINE

        Cmp prevPrintChar, VOID_PANEL ; Case: New panel after void area
        Je WRITE_WriteRowHeader

        Cmp ah, VOID_PANEL
        Jne AUX_WriteRowHeader    ; Case: 2 different adjacent panels
        Mov dh, CHAR_UR_CORNER
        Mov dl, CHAR_SPACE
        Jmp WRITE_WriteRowHeader ; Case: Void area after panel
    
    AUX_WriteRowHeader:
        Mov dh, CHAR_U_JOINT    ; Set left-right top joint between panels
        Jmp WRITE_WriteRowHeader

    EQUAL_WriteRowHeader:
        Cmp ah, VOID_PANEL
        Je WRITE_WriteRowHeader ; Case: Continuous void area
        Mov dh, CHAR_H_LINE
        Mov dl, CHAR_H_LINE ; Case: Continuous panel area

    WRITE_WriteRowHeader:
        Mov byte ptr printBuffer[di],   dh ; Write area opener
        Mov byte ptr printBuffer[di+1], dl ; Write header of area content
        Mov byte ptr printBuffer[di+2], dl
        Mov byte ptr printBuffer[di+3], dl

        Add si, dword ; Read next board area
        Add di, dword ; and point to next buffer area
        Mov prevPrintChar, ah
        Loop ITER_WriteRowHeader

        Mov dh, CHAR_SPACE
        Cmp prevPrintChar, VOID_PANEL
        Je END_WriteRowHeader
        Mov dh, CHAR_UR_CORNER

    END_WriteRowHeader:
        Mov byte ptr printBuffer[di], dh
        POPLIST si, di, ax, cx, dx
        Ret
    WriteRowHeader endP

    ; Prepares a printable buffer with a row's footer
    ; Inputs: [SI] - Pointer to the start of the row
    ; Outputs: [printBuffer] - Contents to print
    WriteRowFooter proc
        PUSHLIST si, di, ax, cx, dx

        Xor di, di ; To index within printBuffer
        Mov cx, MATRIX_SIZE
        Mov prevPrintChar, VOID_PANEL
    ITER_WriteRowFooter:
        Mov dh, CHAR_SPACE
        Mov dl, CHAR_SPACE ; Assume empty print
        Mov ax, word ptr boardGrid[si] ; AH:AL = ID:Content

        Cmp ah, prevPrintChar ; Determine if area is continuous or not
        Je EQUAL_WriteRowFooter

    DIFF_WriteRowFooter:
        Mov dh, CHAR_DL_CORNER
        Mov dl, CHAR_H_LINE

        Cmp prevPrintChar, VOID_PANEL ; Case: New panel after void area
        Je WRITE_WriteRowFooter

        Cmp ah, VOID_PANEL
        Jne AUX_WriteRowFooter    ; Case: 2 different adjacent panels
        Mov dh, CHAR_DR_CORNER
        Mov dl, CHAR_SPACE
        Jmp WRITE_WriteRowFooter ; Case: Void area after panel
    
    AUX_WriteRowFooter:
        Mov dh, CHAR_D_JOINT    ; Set left-right bottom joint between panels
        Jmp WRITE_WriteRowFooter

    EQUAL_WriteRowFooter:
        Cmp ah, VOID_PANEL
        Je WRITE_WriteRowFooter ; Case: Continuous void area
        Mov dh, CHAR_H_LINE
        Mov dl, CHAR_H_LINE ; Case: Continuous panel area

    WRITE_WriteRowFooter:
        Mov byte ptr printBuffer[di],   dh ; Write area opener
        Mov byte ptr printBuffer[di+1], dl ; Write header of area content
        Mov byte ptr printBuffer[di+2], dl
        Mov byte ptr printBuffer[di+3], dl

        Add si, dword ; Read next board area
        Add di, dword ; and point to next buffer area
        Mov prevPrintChar, ah
        Loop ITER_WriteRowFooter

        Mov dh, CHAR_SPACE
        Cmp prevPrintChar, VOID_PANEL
        Je END_WriteRowFooter
        Mov dh, CHAR_UR_CORNER

    END_WriteRowFooter:
        Mov byte ptr printBuffer[di], dh
        POPLIST si, di, ax, cx, dx
        Ret
    WriteRowFooter endP

    ; Prepares a printable buffer with a row's inner contents
    ; Inputs: [SI] - Pointer to the start of the row
    ; Outputs: [printBuffer] - Contents to print
    WriteInnerRow proc
        PUSHLIST si, di, ax, cx, dx

        Xor di, di ; To index within printBuffer
        Mov cx, MATRIX_SIZE
        Mov prevPrintChar, VOID_PANEL
    ITER_WriteInnerRow:
        Mov dh, CHAR_SPACE ; Assume empty print
        Mov ax, word ptr boardGrid[si] ; AH:AL = ID:Content

        Cmp ah, prevPrintChar ; Determine if area is continuous or not
        Je EQUAL_WriteInnerRow

    DIFF_WriteInnerRow:
        Mov dh, CHAR_V_LINE

        Cmp ah, VOID_PANEL
        Jne WRITE_WriteInnerRow ; Case: Current area is a panel
        Mov al, CHAR_SPACE
        Jmp WRITE_WriteInnerRow ; Case: Void area after panel
    
    AUX_WriteInnerRow:
        Mov dh, CHAR_U_JOINT    ; Set left-right top joint between panels
        Jmp WRITE_WriteInnerRow

    EQUAL_WriteInnerRow:
        Cmp ah, VOID_PANEL
        Jne WRITE_WriteInnerRow ; Case: Continuous panel area
        Mov al, CHAR_SPACE ; Case: Continuous void area

    WRITE_WriteInnerRow:
        Mov byte ptr printBuffer[di],   dh ; Write area opener
        Mov byte ptr printBuffer[di+2], al ; Write panel contents or empty space

        Mov dh, '<'
        Mov dl, '>'

        Cmp al, GAME_RED_SENTINEL
        Je EDGE_WriteInnerRow
        Cmp al, GAME_BLACK_SENTINEL
        Je EDGE_WriteInnerRow

        Mov dh, CHAR_SPACE
        Mov dl, CHAR_SPACE
    
    EDGE_WriteInnerRow:
        Mov byte ptr printBuffer[di+1], dl ; Write filler content
        Mov byte ptr printBuffer[di+3], dl

        Add si, dword ; Read next board area
        Add di, dword ; and point to next buffer area
        Mov prevPrintChar, ah
        Loop ITER_WriteInnerRow

        Mov dh, CHAR_SPACE
        Cmp prevPrintChar, VOID_PANEL
        Je END_WriteInnerRow
        Mov dh, CHAR_V_LINE

    END_WriteInnerRow:
        Mov byte ptr printBuffer[di], dh
        POPLIST si, di, ax, cx, dx
        Ret
    WriteInnerRow endP

    ; Placeholder display routine
    DisplayWrapper proc
        PUSHLIST si, di, ax, cx, dx

        Mov si, offset headerRow
        Call PrintLikeC
        Call PrintCRLF

        Xor si, si ; To index board contents
        Mov cx, MATRIX_SIZE
        Mov ah, DOS_PRINT_CHAR
    ITER_DisplayWrapper:
        Mov dl, CHAR_SPACE
        Int 21h
        Int 21h ; Print header prefix

        Call WriteRowHeader
        Mov di, offset printBuffer
        Xchg si, di
        Call PrintLikeC
        Call PrintCRLF
        Xchg si, di

        Mov dl, 3Ah
        Sub dl, cl  ; Print row num and
        Int 21h
        Mov dl, CHAR_SPACE
        Int 21h     ; space for row prefix

        Call WriteInnerRow
        Mov di, offset printBuffer
        Xchg si, di
        Call PrintLikeC
        Call PrintCRLF
        Xchg si, di

        Add si, MATRIX_SIZE*dword ; Point to next row's start
        Loop ITER_DisplayWrapper

        Mov dl, CHAR_SPACE
        Int 21h
        Int 21h                    ; Print row footer prefix
        
        Sub si, MATRIX_SIZE*dword ; Point back to last row
        Call WriteRowFooter

        Mov si, offset printBuffer ; Print row's footer
        Call PrintLikeC
        Call PrintCRLF

        Mov programState, STATE_HALT

        POPLIST si, di, ax, cx, dx
        Ret
    DisplayWrapper endP

    ; Routine for example state
    ; Inputs: ...
    ; Outputs: Sets programState to halt if no error occured
    ExampleRoutine proc
        Mov ax, programState
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
        Mov al, 00h
        Mov ah, 4Ch
        Int 21h


CodeSegment endS

end main