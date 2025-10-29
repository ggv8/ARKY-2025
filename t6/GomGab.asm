; Documentacion
    ; ╔═════════════════════════════════════╦═══════════════════════════════════╗
    ; ║ Instituto Tecnologico de Costa Rica ║ Gabriel Gomez Vega                ║
    ; ║ Escuela de Computacion              ║ 2021106483                        ║
    ; ║ Arquitectura de Computadoras        ║ 27 de Octubre del 2025            ║
    ; ╚═════════════════════════════════════╩═══════════════════════════════════╝
    ; ╔═════════════════════════════════════════════════════════════════════════╗
    ; ║                            Manual de Usuario                            ║
    ; ╠═════════════════════════════════════════════════════════════════════════╣
    ; ║ Este programa es una adaptacion del juego de arcade llamado Qix. En es- ║
    ; ║ ta version miniatura, tanto el protagonista como el antagonista tienen  ║
    ; ║ el tamaño de un caracter. El juego cuenta con una ventana para el menu  ║
    ; ║ principal, que se despliega encima del tablero del juego al iniciar el  ║
    ; ║ programa. Cada opcion del menu se accede con la letra respectiva que se ║
    ; ║ indica a su lado, ya sea minuscula o mayuscula. La funciones son las si-║
    ; ║ guientes:                                                               ║
    ; ║                                                                         ║
    ; ║ <N> Comenzar una partida nueva                                          ║
    ; ║     Esta opcion limpia el tablero de juego y reinicia los valores y po- ║
    ; ║     siciones de los personajes. Por defecto, el programa siempre inicia ║
    ; ║     con una partida nueva. Esta opcion sirve sobretodo para jugadores   ║
    ; ║     que ya han avanzado y quieren comenzar una partida nueva. Siempre   ║
    ; ║     solicita por la confirmación del usuario, quien debe responder si   ║
    ; ║     acepta continuar con <S> o si desea cancelar la operacion con <N>   ║
    ; ║                                                                         ║
    ; ║ <C> Continuar partida actual                                            ║
    ; ║     Con esta opcion se cambia al modo de juego y se puede controlar al  ║
    ; ║     protagonista. Durante este modo de juego se puede usar las flechas  ║
    ; ║     del teclado para mover al personaje. Para volver al menu de pausa,  ║
    ; ║     se utiliza la barra espaciadora.                                    ║
    ; ║                                                                         ║
    ; ║ <H> Ver puntajes altos                                                  ║
    ; ║     Con esta opcion se mostraria en pantalla los 20 puntajes mas signi- ║
    ; ║     ficativos que se han registrado en el programa.                     ║
    ; ║                                                                         ║
    ; ║ <D> Vaciar puntajes altos                                               ║
    ; ║     Esta opcion es para eliminar todos los puntajes registrados del pro-║
    ; ║     grama. Para ello, se dejan por defecto puntajes placeholder anonimos║
    ; ║     Esta opcion tambien pregunta por la confirmación del usuario.       ║
    ; ║                                                                         ║
    ; ║ <A> Ayuda del programa                                                  ║
    ; ║     Esta opcion explica brevemente la dinámica del juego, la simbología ║
    ; ║     y los controles básicos del modo de juego. Esta ventana de informa- ║
    ; ║     cion se mantiene hasta que el usuario ingrese la entrada <C>        ║
    ; ║                                                                         ║
    ; ║ <M> Acerca de                                                           ║
    ; ║     Este programa detalla datos sobre el proprio programa, su propósito ║
    ; ║     fecha de creación y autor. Esta ventana tambien se mantiene activa  ║
    ; ║     hasta que el usuario la cierre con una entrada <C>                  ║
    ; ║                                                                         ║
    ; ║ <E> Salir al Sistema Operativo                                          ║
    ; ║     Esta opcion retorna el control de la computadora al S.O. Antes de   ║
    ; ║     hacerlo, pregunta por la confirmación del usuario.                  ║
    ; ║                                                                         ║
    ; ║ Respecto al modo de juego, el enemigo recorrera el area de forma aleato-║
    ; ║ ria con la intención de tocar directamente al jugador o la linea que es-║
    ; ║ ta trazando. Si eso sucede, el jugador perdera la partida. El programa  ║
    ; ║ reiniciara la partida de forma automática y regresara al menu, donde el ║
    ; ║ jugador puede continuar jugando con una partida nueva.                  ║
    ; ╚═════════════════════════════════════════════════════════════════════════╝
    ; ╔═════════════════════════════════════════════════════════════════════════╗
    ; ║                        Analisis de Resultados                           ║
    ; ╠══════════════════════════════════════════════════════════╦══════════════╣
    ; ║                          Aspectos                        ║ Calificacion ║
    ; ╠══════════════════════════════════════════════════════════╬══════════════╣
    ; ║ Documentacion                                            ║      B       ║
    ; ╠══════════════════════════════════════════════════════════╬══════════════╣
    ; ║ Despliegue de la ventana del menu                        ║      A       ║
    ; ╠══════════════════════════════════════════════════════════╬══════════════╣
    ; ║ Procesamiento de entradas a las opciones del menu        ║      A       ║
    ; ╠══════════════════════════════════════════════════════════╬══════════════╣
    ; ║ Despliegue y procesamiento de ventanas de confirmacion   ║      A       ║
    ; ╠══════════════════════════════════════════════════════════╬══════════════╣
    ; ║ Despliegue de los puntajes altos en ventana              ║      E       ║
    ; ╠══════════════════════════════════════════════════════════╬══════════════╣
    ; ║ Vaciar el archivo de los puntajes altos                  ║      E       ║
    ; ╠══════════════════════════════════════════════════════════╬══════════════╣
    ; ║ Despliegue de la ayuda en ventana                        ║      A       ║
    ; ╠══════════════════════════════════════════════════════════╬══════════════╣
    ; ║ Despliegue del acerca de en ventana                      ║      A       ║
    ; ╠══════════════════════════════════════════════════════════╬══════════════╣
    ; ║ Salir del programa al SO                                 ║      A       ║
    ; ╠══════════════════════════════════════════════════════════╬══════════════╣
    ; ║ Despliegue del modo de juego                             ║      B       ║
    ; ╠══════════════════════════════════════════════════════════╬══════════════╣
    ; ║ Inicializar una partida nueva                            ║      A       ║
    ; ╠══════════════════════════════════════════════════════════╬══════════════╣
    ; ║ Reanudar una partida en pausa                            ║      A       ║
    ; ╠══════════════════════════════════════════════════════════╬══════════════╣
    ; ║ Pausar una partida y desplegar el menu                   ║      A       ║
    ; ╠══════════════════════════════════════════════════════════╬══════════════╣
    ; ║ Mover al protagonista en el area de juego                ║      B       ║
    ; ╠══════════════════════════════════════════════════════════╬══════════════╣
    ; ║ Movimiento independiente y aleatorio del antagonista     ║      A       ║
    ; ╠══════════════════════════════════════════════════════════╬══════════════╣
    ; ║ Logica de juego: trazar linea, areas, perder, ganar)     ║      C       ║
    ; ╠══════════════════════════════════════════════════════════╬══════════════╣
    ; ║ Registro del tiempo de juego activo                      ║      E       ║
    ; ╠══════════════════════════════════════════════════════════╬══════════════╣
    ; ║ Niveles y parametros de dificultad (velocidad, umbral)   ║      D       ║
    ; ╚══════════════════════════════════════════════════════════╩══════════════╝


    ; Explicación adicional
    ;
    ; Aspectos con Calificación E
    ; Lo que respecta al manejo de puntajes altos, ya sea desplegarlos o vaciar el archivo,
    ; no se llego a intentar ya que no se pudo implementar por completo la lógica base del
    ; juego y por lo tanto no hay puntajes de tiempo y áreas que se puedan registrar.
    ;
    ; Niveles y parametros de dificultas (D)
    ; Como la logica no se logro completar, lo que se tiene respecto a esto es meramente el diseño
    ; Se cuenta con la variable de velocidad del enemigo, que se incrementaria por cada iteracion
    ; del juego
    ;
    ; Lógica del juego (C)
    ; Como se cuenta con el movimiento de ambos personajes, y la creación de líneas, se tiene
    ; como mínimo la lógica para perder el juego. Esto es ya sea porque el jugador y el enemigo
    ; colisionen el uno con el otro, o que el enemigo toque la linea que se esta trazando. Sin embargo,
    ; no se logró concluir la creación de áreas y por lo tanto sólo sirve esa porción del juego.
    ;
    ; Mover al protagonista (B)
    ; Se logro que el personaje se mueva y se despliegue correctamente en pantalla. Incluso se puede
    ; mover de forma circular. Sin embargo, hay una pulga extraña entre el manejo del movimiento lógico
    ; y su despliegue en pantalla. Al introducir la restricción de velocidad con el contador del juego,
    ; en la rutina MovePlayer, el despliegue de los colores da resultados inesperados. No se logro
    ; identificar con exactitud la pulga, pero sospecho un descuido a la hora de combinar el color de frente
    ; de la nueva posición, para dar la ilusión de que es el color de fondo. Por lo tanto, se opto por mantener
    ; el movimiento sin restricción de velocidad, que al menos genera mejores resultados en pantalla que la
    ; alternativa
    ;
    ; Despliegue del modo de juego (B)
    ; Presenta la falla de que solo se despliega el area de juego, los personajes, y las lineas. No se 
    ; despliega la leyenda de opciones de juego en pantalla, ni los puntajes de tiempo y áreas
    ;
    ; Documentación (B)
    ; Se halla incompleta debido a rutinas planeadas que no se lograron terminar, como las rutinas que atiende
    ; peticiones de los puntajes
;

; Macros

    ; Pushes a list of registers to the CPU stack in order
    ; Inputs: R1~R12 : List of comma-separated registers
    PUSHLIST Macro R1:REQ,R2,R3,R4,R5,R6,R7,R8,R9,R10,R11,R12
        IRP item, <R1,R2,R3,R4,R5,R6,R7,R8,R9,R10,R11,R12>
            IFB <item>
                exitM ;; Halt early if list is shorter than 12 regs
            endIF
            Push item
        endM
    endM

    ; Pops a list of registers from the CPU stack in reverse order
    ; Inputs: R1~R12 : List of comma-separated registers
    POPLIST Macro R1:REQ,R2,R3,R4,R5,R6,R7,R8,R9,R10,R11,R12
        IFNB <R2> ;; General case: Recursive for lists larger than 1
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

    ; Tests if a word sized value is divisible by another word size value
    ; Inputs: Dividend, Divisor - 16-bit Reg/Mem values
    ; Outputs: Sets flags accordingly for CMP between quotient and 0
    IS_DIVISIBLE Macro Dividend:REQ, Divisor:REQ
        Mov ax, Dividend
        Xor dx, dx
        Div divisor
        Cmp dx, 0
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
        CHAR_INV_QUESTION = 0A8h

        CHAR_UR_CORNER = 187 ; ╗
        CHAR_DR_CORNER = 188 ; ╝

        CHAR_DL_CORNER = 200 ; ╚
        CHAR_UL_CORNER = 201 ; ╔

        CHAR_V_LINE = 186 ; ║
        CHAR_H_LINE = 205 ; ═

        CHAR_UP_ARROW = 30
        CHAR_DOWN_ARROW = 31
        CHAR_LEFT_ARROW = 17
        CHAR_RIGHT_ARROW = 16
    ;

    ; State Machine
        STATE_HALT    = 0000h
        STATE_DEFAULT = 0001h
        STATE_MENU    = 0002h
        STATE_GAME    = 0003h
        STATE_NEWGAME = 0004h
        STATE_SCORES  = 0005h
        STATE_DELETE  = 0006h
        STATE_HELP    = 0007h
        STATE_ABOUTME = 0008h
        STATE_EXIT    = 0009h
        STATE_GAME_OVER = 000Ah
    ;

    ; Misc
        ROW_LENGTH    = 80
        COL_LENGTH    = 25
        MAX_COL_INDEX = ROW_LENGTH - 1
        MAX_ROW_INDEX = COL_LENGTH - 1
        PLAY_AREA_COL = 30
        PLAY_AREA_WIDTH = 50

        MENU_AREA_COL = 24
        MENU_AREA_ROW =  7
        MENU_AREA_WIDTH  = 32
        MENU_AREA_HEIGHT = 10

        HELP_AREA_COL    = 1
        HELP_AREA_ROW    = 5
        HELP_AREA_WIDTH  = 78
        HELP_AREA_HEIGHT = 15
        
        ABOUTME_AREA_COL = 6
        ABOUTME_AREA_ROW = 5
        ABOUTME_AREA_WIDTH = 68
        ABOUTME_AREA_HEIGHT = 15
        
        CONFIRM_AREA_COL = 28
        CONFIRM_AREA_ROW = 10
        CONFIRM_AREA_WIDTH = 24
        CONFIRM_AREA_HEIGHT = 4
    ;

    ; Scan Codes
        KEY_UP = 48h
        KEY_DOWN = 50h
        KEY_LEFT = 4Bh
        KEY_RIGHT = 4Dh
        KEY_SPACE = 39h
        KEY_ESCAPE = 01h
        KEY_RETURN = 1Ch

        KEY_N = 31h
        KEY_C = 2Eh
        KEY_H = 23h
        KEY_D = 20h
        KEY_A = 1Eh
        KEY_M = 32h
        KEY_E = 12h
        KEY_S = 1Fh
    ;

    ; Icon and Color Values
        PLAYER_ICON   =  02h
        ENEMY_ICON    =  0Fh
        LINE_ICON     = 0DBh


        PLAYER_COLOR  = 00001001b ; Green FG
        ENEMY_COLOR   = 00001100b ; Red FG
        LINE_COLOR    = 00000111b ; Light Grey FG
        TRACK_COLOR   = 00000110b ; Dark Grey FG
        SPACE_COLOR   = 00000000b ; Black FG

        MENU_COLOR    = 01001110b ; Red BG, Yellow FG
        HELP_COLOR    = 00100000b ;
        ABOUTME_COLOR = 00011111b ;
        CONFIRM_COLOR = 01001111b ;
    ;

    VECTOR_UP    EQU -1,  0
    VECTOR_DOWN  EQU  1,  0
    VECTOR_LEFT  EQU  0, -1
    VECTOR_RIGHT EQU  0,  1
    VECTOR_UP_LEFT    EQU -1,  0
    VECTOR_UP_RIGHT   EQU -1,  1
    VECTOR_DOWN_LEFT  EQU  1, -1
    VECTOR_DOWN_RIGHT EQU  1,  1
    VECTOR_COUNT = 8
    TURN_RIGHT   = 9
    TURN_LEFT    = 7
    TURN_AROUND  = 4
    LEFT_CHANCE  = 60
    RIGHT_CHANCE = 80
;

; String literals
    menuDisplay db CHAR_UL_CORNER, 30 dup(CHAR_H_LINE), CHAR_UR_CORNER
                db CHAR_V_LINE, "          QIX - Menu          ", CHAR_V_LINE
                db CHAR_V_LINE, " <N> Comenzar partida nueva   ", CHAR_V_LINE
                db CHAR_V_LINE, " <C> Continuar partida actual ", CHAR_V_LINE
                db CHAR_V_LINE, " <H> Ver puntajes altos       ", CHAR_V_LINE
                db CHAR_V_LINE, " <D> Vaciar puntajes altos    ", CHAR_V_LINE
                db CHAR_V_LINE, " <A> Ver la ayuda             ", CHAR_V_LINE
                db CHAR_V_LINE, " <M> Ver el acerca de         ", CHAR_V_LINE
                db CHAR_V_LINE, " <E> Salir al SO              ", CHAR_V_LINE
                db CHAR_DL_CORNER, 30 dup(CHAR_H_LINE), CHAR_DR_CORNER

    helpDisplay db CHAR_UL_CORNER, 76 dup(CHAR_H_LINE), CHAR_UR_CORNER
                db CHAR_V_LINE, "                                   Ayuda                                    ", CHAR_V_LINE
                db CHAR_V_LINE, " En la partida, debe controlar un personaje en un area de juego delimitada. ", CHAR_V_LINE
                db CHAR_V_LINE, " Su meta es tomar control de una proporcion del area en el menor tiempo po- ", CHAR_V_LINE
                db CHAR_V_LINE, " sible. Para ello debe cerrar la figura que traza el protagonista en su re- ", CHAR_V_LINE
                db CHAR_V_LINE, " corrido. Existe un ente enemigo que busca eliminarlo a usted y tomando un  ", CHAR_V_LINE
                db CHAR_V_LINE, " camino aleatorio. Si este lo toca a usted o su traza antes de completarla, ", CHAR_V_LINE
                db CHAR_V_LINE, " pierde la partida. Usted estara seguro siempre que este en el borde el ma- ", CHAR_V_LINE
                db CHAR_V_LINE, " pa o dentro de una area que haya tomado previamente.                       ", CHAR_V_LINE
                db CHAR_V_LINE, "                                                                            ", CHAR_V_LINE
                db CHAR_V_LINE, " Simbologia: Protagonista (",PLAYER_ICON,") - Villano (",ENEMY_ICON,")                                 ", CHAR_V_LINE
                db CHAR_V_LINE, " Controles: Flechas (",CHAR_UP_ARROW,", ",CHAR_DOWN_ARROW,", ",CHAR_LEFT_ARROW,", ",CHAR_RIGHT_ARROW,") para moverse arriba, abajo, izq., derecha  ", CHAR_V_LINE
                db CHAR_V_LINE, "                                                                            ", CHAR_V_LINE
                db CHAR_V_LINE, "                                                   <C>: Cerrar ventana      ", CHAR_V_LINE
                db CHAR_DL_CORNER, 76 dup(CHAR_H_LINE), CHAR_DR_CORNER
    
    aboutMeDisplay db CHAR_UL_CORNER, 66 dup(CHAR_H_LINE), CHAR_UR_CORNER
                   db CHAR_V_LINE, "                           Acerca De...                           ", CHAR_V_LINE
                   db CHAR_V_LINE, "                                                                  ", CHAR_V_LINE
                   db CHAR_V_LINE, "                   ITCR: Escuela de Computacion                   ", CHAR_V_LINE
                   db CHAR_V_LINE, "                   Arquitectura de Computadoras                   ", CHAR_V_LINE
                   db CHAR_V_LINE, "                    Fecha: 27 de Octubre, 2025                    ", CHAR_V_LINE
                   db CHAR_V_LINE, "                    Autor:  Gabriel Gomez Vega                    ", CHAR_V_LINE
                   db CHAR_V_LINE, "                        Carnet: 2021106483                        ", CHAR_V_LINE
                   db CHAR_V_LINE, "                                                                  ", CHAR_V_LINE
                   db CHAR_V_LINE, " Este programa es una version modificada del juego de arcade Qix, ", CHAR_V_LINE
                   db CHAR_V_LINE, " implementada en ensamblador. Pone en practica conocimientos del  ", CHAR_V_LINE
                   db CHAR_V_LINE, " manejo de video en modo texto.                                   ", CHAR_V_LINE
                   db CHAR_V_LINE, "                                                                  ", CHAR_V_LINE
                   db CHAR_V_LINE, "                                         <C>: Cerrar ventana      ", CHAR_V_LINE
                   db CHAR_DL_CORNER, 66 dup(CHAR_H_LINE), CHAR_DR_CORNER
    
    confirmDisplay db CHAR_UL_CORNER, 22 dup(CHAR_H_LINE), CHAR_UR_CORNER
                   db CHAR_V_LINE, "    ", CHAR_INV_QUESTION,"Esta  seguro?    ", CHAR_V_LINE
                   db CHAR_V_LINE, "  <S>: Si    <N>: No  ", CHAR_V_LINE
                   db CHAR_DL_CORNER, 22 dup(CHAR_H_LINE), CHAR_DR_CORNER



    displayBackup dw (ROW_LENGTH * COL_LENGTH) dup(?)
    
;

; Look-up Tables
    stateTable  dw STATE_DEFAULT,   StartWrapper
    STATE_OFFSET = ($ - stateTable)
                dw STATE_MENU,      MenuWrapper
                dw STATE_GAME,      ContinueGameWrapper
                dw STATE_NEWGAME,   NewGameWrapper
                dw STATE_SCORES,    HighscoreWrapper
                dw STATE_DELETE,    DeleteScoreWrapper
                dw STATE_HELP,      ViewHelpWrapper
                dw STATE_ABOUTME,   AboutMeWrapper
                dw STATE_EXIT,      ExitGameWrapper
                dw STATE_GAME_OVER, GameOverWrapper
    TABLE_SIZE = ($ - stateTable) / STATE_OFFSET

    menuInputs  db KEY_N, STATE_NEWGAME
                db KEY_C, STATE_GAME
                db KEY_H, STATE_SCORES
                db KEY_D, STATE_DELETE
                db KEY_A, STATE_HELP
                db KEY_M, STATE_ABOUTME
                db KEY_E, STATE_EXIT
    MENU_INPUT_COUNT = ($ - menuInputs) / word

    keyMovements db KEY_UP,    VECTOR_UP
                 db KEY_DOWN,  VECTOR_DOWN
                 db KEY_RIGHT, VECTOR_RIGHT
                 db KEY_LEFT,  VECTOR_LEFT

    ; Turning right is equivalent to increasing index to enemyMovement, decreasing is turning left
    ; Index will roll over to 0 after 7, and viceversa
    ; Bouncing is equivalent to an index inc or dec of 4, applying the same wrap around
    ; To simplify, and thanks to wrap around, turning right is +9, turning left is +7, turning around is +4
    enemyMovement db VECTOR_UP, VECTOR_UP_RIGHT, VECTOR_RIGHT, VECTOR_DOWN_RIGHT ; Word array
                  db VECTOR_DOWN, VECTOR_DOWN_LEFT, VECTOR_LEFT, VECTOR_UP_LEFT
;
    seed           dw (?)
    gameCounter    dw 00h

    movementBuffer db 0, 0
    playerPosition db 24, 24 ; Row, Column
    playerAreaData db LINE_COLOR
    prevPlayerPos  db 24, 24

    enemyPosition  db 2, 25
    prevEnemyPos   db 2, 25

    playerSpeed dw 60
    playerDirection dw 0
    enemySpeed  dw 60
    enemyDirection dw 0


    programState dw STATE_DEFAULT
    base dw 10
DataSegment endS

StackSegment segment stack 'stack'
   dw 256 dup(?)
StackSegment endS

CodeSegment segment
    Assume CS:CodeSegment, DS:DataSegment, SS:StackSegment

    Randomize Proc
    ; Esta rutina es la que inicializa la semilla para pedir numeros seudoaleatorios.
        PUSHLIST ax, cx, dx

        mov ah, 2Ch    ; solicitamos el tiempo del sistema.  
                       ; En el dh vienen los seg y en el dl las centesimas de segundo 
        int 21h
        mov word ptr seed, dx

        POPLIST ax, cx, dx
        ret
    Randomize EndP

    RandomXor Proc
    ; Esta rutina genera un numero aleatorio entre 0 y lo que diga el bx, lo regresa en el ax
    ; Supone que en la variable semilla se conserva la semilla con la que se debe trabajar.
    ; Debe haberse invocado previamente a la rutina Randomize

    ; Como operaciones para modificar la semilla usa un algoritmo llamado xorshift
    ; una palabra de tama�o

       push cx  
       push dx  

       mov ax, seed      ; Calculamos la nueva semilla

       mov cl, 7
       mov dx, ax
       shl dx, cl
       xor ax, dx

       mov cl, 9
       mov dx, ax
       shr dx, cl
       xor ax, dx

       mov cl, 8
       mov dx, ax
       shl dx, cl
       xor ax, dx

       mov seed, ax      ; Almacenamos la semilla para el siguiente numero
       xor dx, dx           ; normalizamos el random al rango que nos indican en el bx             
       div bx
       mov ax, dx
       pop dx
       pop cx
       ret

    RandomXor Endp

    ; Sets all characters in a text mode display to whitespaces with black bg and white fg
    ; Inputs:  [ES] - Expects pointer to VRAM area
    ; Outputs: [ES] - Sets all chars in the matrix to a whitespace
    ClearDisplay proc
        PUSHLIST ax, bx, cx

        Mov ah, SPACE_COLOR
        Mov al, CHAR_SPACE

        Xor bx, bx
        Mov cx, ROW_LENGTH * COL_LENGTH
    
    ITER_ClearDisplay:
        Mov word ptr es:[bx], ax
        INCW bx
        Loop ITER_ClearDisplay

        POPLIST ax, bx, cx
        Ret
    ClearDisplay endP

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

    ; Clears the display to show the play area, and anticipates the menu
    ; Inputs: n/a
    ; Output: programState - Sets the menu state
    StartWrapper proc
        Mov ax, 0B800h
        Mov es, ax

        Call Randomize
        Call ClearDisplay
        Call DisplayPlayArea

        Mov programState, STATE_MENU
        Ret
    StartWrapper endP

    ; Finds the corresponding state for a menu input if the scan code is valid
    ; Inputs:   AH - Scan code of a key input
    ; Outputs:  AX - State value for valid inputs
    ;           CF - Set if state is found, clear if not found
    FindMenuInput proc
        PUSHLIST si, cx

        Xor si, si
        Mov cx, MENU_INPUT_COUNT
    ITER_FindMenuInput:
        Mov al, byte ptr menuInputs[si] ; Retrieve key from entry
        Cmp ah, al
        Je FLAG_MenuInputFound ; If there's a match, handle return values
        INCW si                ; Otherwise, proceed to next entry
        Loop ITER_FindMenuInput

        Clc ; Flag not found and halt
        Jmp END_FindMenuInput

    FLAG_MenuInputFound:
        Mov al, byte ptr menuInputs[si+byte] ; Retrieve state from matched entry
        Xor ah, ah                           ; Clear scan code
        Stc
    END_FindMenuInput:
        POPLIST si, cx
        Ret
    FindMenuInput endP

    ; Displays the menu and services any option requested via keyboard
    ; Inputs: Expects an input buffered in the keyboard
    ; Outputs: programState - Sets the requested option's state
    ;          Hides the menu afterwards
    MenuWrapper proc
        Call SaveDisplay

        Mov si, offset menuDisplay
        Mov ah, MENU_COLOR
        Mov dh, MENU_AREA_ROW
        Mov dl, MENU_AREA_COL
        Mov ch, MENU_AREA_HEIGHT
        Mov cl, MENU_AREA_WIDTH
        Call DisplayWindow

    ITER_MenuWrapper:
        CHECK_KEY_INPUT
        Jz ITER_MenuWrapper ; Keep checking until a key is pressed

        READ_KEY_INPUT      ; Consumes input from buffer into AH:AL
        Call FindMenuInput
        Jnc ITER_MenuWrapper ; If input isn't found, ignore and keep checking

        Mov programState, ax ; If found, update program state to service request
        Call RestoreDisplay
        Ret
    MenuWrapper endP

    ; Displays a confirmation box and returns the answer to its prompt
    ; Inputs: Expects a key input <S> or <N> to confirm an action
    ; Outputs: CF - Sets or clears the flag depending on the answer
    ConfirmationBox proc
        Call SaveDisplay

        Mov si, offset confirmDisplay
        Mov ah, CONFIRM_COLOR
        Mov dh, CONFIRM_AREA_ROW
        Mov dl, CONFIRM_AREA_COL
        Mov ch, CONFIRM_AREA_HEIGHT
        Mov cl, CONFIRM_AREA_WIDTH
        Call DisplayWindow

    ITER_ConfirmationBox:
        CHECK_KEY_INPUT
        Jz ITER_ConfirmationBox  ; If no input, keep checking

        READ_KEY_INPUT
        Cmp ah, KEY_S
        Je FLAG_ConfirmedBox ; Flag if prompt was accepted
        Cmp ah, KEY_N
        Je FLAG_DeniedBox ; Flag if prompt was denied

        Jmp ITER_ConfirmationBox ; Otherwise, keep checking for valid answers

    FLAG_DeniedBox:
        Clc
        Jmp END_ConfirmationBox

    FLAG_ConfirmedBox:
        Stc
    END_ConfirmationBox:
        Pushf
        Call RestoreDisplay
        Popf
        Ret
    ConfirmationBox endP

    ; Sets default values for game variables
    ResetGame proc
        Call ClearDisplay
        Call DisplayPlayArea
        Mov gameCounter, 0
        Mov word ptr movementBuffer, 0
        Mov byte ptr playerPosition[0], 24
        Mov byte ptr playerPosition[1], 24
        Mov playerAreaData, LINE_COLOR
        Mov byte ptr prevPlayerPos[0], 24
        Mov byte ptr prevPlayerPos[1], 24

        Mov byte ptr enemyPosition[0], 2
        Mov byte ptr enemyPosition[1], 25
        Mov byte ptr prevEnemyPos[0], 2
        Mov byte ptr prevEnemyPos[1], 25

        Mov playerDirection, 0
        Mov enemyDirection, 0
        Mov enemySpeed, 60
        Ret
    ResetGame endP

    ; Routine that services a new game request by asking for confirmation
    ; before resetting game variables
    NewGameWrapper proc
        ; Logic that asks for confirmation
        Call ConfirmationBox
        Jnc END_NewGameWrapper
        Call ResetGame
    END_NewGameWrapper:
        Mov programState, STATE_MENU
        Ret
    NewGameWrapper endP

    ContinueGameWrapper proc
        Call GameUpdate
        Ret
    ContinueGameWrapper endP

    HighscoreWrapper proc
        
        Mov programState, STATE_MENU
        Ret
    HighscoreWrapper endP

    DeleteScoreWrapper proc
        Call ConfirmationBox
        Mov programState, STATE_MENU
        Ret
    DeleteScoreWrapper endP

    ViewHelpWrapper proc
        Call SaveDisplay

        Mov si, offset helpDisplay
        Mov ah, HELP_COLOR
        Mov dh, HELP_AREA_ROW
        Mov dl, HELP_AREA_COL
        Mov ch, HELP_AREA_HEIGHT
        Mov cl, HELP_AREA_WIDTH
        Call DisplayWindow

    ITER_ViewHelpWrapper:
        CHECK_KEY_INPUT
        Jz ITER_ViewHelpWrapper  ; If no input, keep checking

        READ_KEY_INPUT
        Cmp ah, KEY_C
        Jne ITER_ViewHelpWrapper ; Keep checking until input is for closing window

        Mov programState, STATE_MENU
        Call RestoreDisplay
        Ret
    ViewHelpWrapper endP

    ; Displays the aboutMe window until it is requested to be closed
    ; Inputs: Expects an input buffered in the keyboard
    ; Outputs: programState - Restores the menu state after displaying the window
    ;          Hides the aboutMe afterwards
    AboutMeWrapper proc
        Call SaveDisplay

        Mov si, offset aboutMeDisplay
        Mov ah, ABOUTME_COLOR
        Mov dh, ABOUTME_AREA_ROW
        Mov dl, ABOUTME_AREA_COL
        Mov ch, ABOUTME_AREA_HEIGHT
        Mov cl, ABOUTME_AREA_WIDTH
        Call DisplayWindow

    ITER_AboutMeWrapper:
        CHECK_KEY_INPUT
        Jz ITER_AboutMeWrapper ; If no input, keep checking

        READ_KEY_INPUT
        Cmp ah, KEY_C
        Jne ITER_AboutMeWrapper ; Keep checking until input is for closing window

        Mov programState, STATE_MENU
        Call RestoreDisplay
        Ret
    AboutMeWrapper endP

    ExitGameWrapper proc
        ; Logic that asks for confirmation
        Call ConfirmationBox
        Jc FLAG_HaltGame
        Mov programState, STATE_MENU
        Jmp END_ExitGameWrapper
    
    FLAG_HaltGame:
        Mov programState, STATE_HALT
    END_ExitGameWrapper:
        Ret
    ExitGameWrapper endP

    GameOverWrapper proc
        ; Display GameOver window
        ; Logic to register highscore
        Call ResetGame ; Prevent continuing a lost game by resetting values after saving score
    END_GameOverWrapper:
        Mov programState, STATE_MENU
        Ret
    GameOverWrapper endP

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

    ; Displays the square border of the play area
    ; Inputs: [ES] - Expects pointer to VRAM area
    DisplayPlayArea proc
        PUSHLIST di, ax, bx, cx

        Mov ah, LINE_COLOR ; Color in upper byte for little endian
        Mov al, LINE_ICON  ; to reverse order when written to VRAM

        Mov cx, PLAY_AREA_WIDTH ; To iter from col 30 to col 79
        Mov di, PLAY_AREA_COL*word              ; Start at row 0, column 30
        Mov bx, (MAX_ROW_INDEX*ROW_LENGTH)*word ; Offset to last row

    ITER_HorizontalBorders:
        Mov word ptr es:[di], ax    ; Write icon at top column
        Mov word ptr es:[di+bx], ax ; and at bottom column
        INCW di                     ; Point to next column
        Loop ITER_HorizontalBorders
    
        Mov cx, MAX_ROW_INDEX-1 ; Iter from row 1 to row 23 (exclude top and bottom)
        Mov di, (ROW_LENGTH*word) + (PLAY_AREA_COL*word) ; Start at row 1, col 30
        Mov bx, (PLAY_AREA_WIDTH-1)*word                   ; Offset to col 79 from col 30

    ITER_VerticalBorders:
        Mov word ptr es:[di], ax    ; Set leftmost line
        Mov word ptr es:[di+bx], ax ; and rightmost line
        Add di, ROW_LENGTH*word     ; Point to next row
        Loop ITER_VerticalBorders

        POPLIST di, ax, bx, cx
        Ret
    DisplayPlayArea endP

    ; Saves the current contents from VRAM in a buffer
    ; Inputs: [ES] - Expects pointer to VRAM area
    SaveDisplay proc
        PUSHLIST si, di, ax, cx

        Xor si, si
        Xor di, di
        Mov cx, (ROW_LENGTH*COL_LENGTH)
    ITER_SaveDisplay:
        Mov ax, word ptr es:[si]
        Mov word ptr displayBackup[di], ax
        INCW si
        INCW di
        Loop ITER_SaveDisplay

        POPLIST si, di, ax, cx
        Ret
    SaveDisplay endP

    ; Refreshes the VRAM contents with its previous backup
    ; Inputs: [ES] - Expects pointer to VRAM area
    RestoreDisplay proc
        PUSHLIST si, di, ax, cx

        Xor si, si
        Xor di, di
        Mov cx, (ROW_LENGTH*COL_LENGTH)
    ITER_RestoreDisplay:
        Mov ax, word ptr displayBackup[si]
        Mov word ptr es:[di], ax
        INCW si
        INCW di
        Loop ITER_RestoreDisplay

        POPLIST si, di, ax, cx
        Ret
    RestoreDisplay endP

    ; Obtains an offset address for text mode VRAM from a position
    ; Inputs:  DH:DL - Row:Col pair value, both within valid ranges
    ; Outputs: DI - Offset address for text mode position in VRAM
    GetVramPtrDI proc
        PUSHLIST ax, dx

        Xor ah, ah
        Mov al, dh ; Set row for address calc
        Mov dh, ROW_LENGTH*word
        Mul dh
        Mov di, ax ; Save row offset result

        Xor dh, dh
        Shl dl, 1  ; Duplicate col index to account for word size columns
        Add di, dx ; Apply column offset to row address

        POPLIST ax, dx
        Ret
    GetVramPtrDI endP

    ; Displays a text mode window buffer at a VRAM position
    ; Inputs: [ES] - Expects pointer to VRAM
    ;         CH:CL - Height:Width pair value
    ;         DH:DL - Row:Col position
    ;         AH    - BG and FG color
    ;         SI    - Pointer to window buffer
    DisplayWindow proc
        PUSHLIST di, ax, cx

        Call GetVramPtrDI
    ITER_DisplayWindow:
        Push cx ; To save CL's width for next iter
        Push di ; To save DI's row address to calc the one for next iter

    ITER_DisplayWindowRow:
        Mov al, byte ptr ds:[si] ; Retrieve window data
        Mov word ptr es:[di], ax ; Display window data with the given color in AH
        Inc si  ; Point to next window unit
        INCW di ; Point to next VRAM column
        Dec cl
        Jnz ITER_DisplayWindowRow

        Pop di
        Pop cx
        Add di, ROW_LENGTH*word ; Point to next row
        Dec ch
        Jnz ITER_DisplayWindow

        POPLIST di, ax, cx
        Ret
    DisplayWindow endP


    ; Returns a near pointer to a play area position in VRAM
    ; Inputs: DH:DL - Row:Col pair indicating the position
    ;         [ES] - Expects pointer to VRAM area
    ; Outputs: [BX] - Offset to desired position
    GetBoardPtrBX proc
        PUSHLIST ax, dx

        Xor ah, ah
        Mov al, dh              ; Set row index before address calc
        Mov dh, ROW_LENGTH*word ; Account length for row with word sized elements
        Mul dh
        Mov bx, ax ; Save row address
        Add bx, PLAY_AREA_COL*word ; Play area starts at col 30 of a VRAM row

        Xor ah, ah
        Mov al, dl   ; Set col index to calc offset within row address
        Shl al, 1    ; Duplicate to account for word sized elements

        Add bx, ax               ; Apply offset to row address
        
        POPLIST ax, dx
        Ret
    GetBoardPtrBX endP

    ; Returns the word contents at a play area position
    ; Inputs: DH:DL - Row:Col pair indicating the position
    ;         [ES] - Expects pointer to VRAM area
    ; Outputs: AH:AL - Color:Char data
    ReadPlayArea proc
        PUSHLIST bx

        Call GetBoardPtrBX
        Mov ax, word ptr es:[bx]

        POPLIST bx
        Ret
    ReadPlayArea endP

    ; Writes a word element at a play area position
    ; Inputs: AH:AL - Color:Char pair that is written
    ;         DH:DL - Row:Col pair indicating the position
    ;         [ES] - Expects pointer to VRAM area 
    ; Outputs: N/A
    WritePlayArea proc
        PUSHLIST bx

        Call GetBoardPtrBX
        Mov word ptr es:[bx], ax

        POPLIST bx
        Ret
    WritePlayArea endP

    ; Updates the enemy's direction by turning them right
    ; Inputs: DX - Desired change of direction (left,right,around)
    ; Outputs: enemyDirection - Sets new index to its movement vector
    ChangeEnemyDirection proc
        PUSHLIST ax, bx

        Mov bx, VECTOR_COUNT
        Mov ax, enemyDirection
        Add ax, dx              ; Obtain new direction index
        Div bl                  ; Avoid out-of-range with modulo operation

        Mov al, ah  ; Save remainder as index
        Xor ah, ah  ; Clear leftover value
        Mov enemyDirection, ax
        POPLIST ax, bx
        Ret
    ChangeEnemyDirection endP

    ; Determines if the enemy should randomly turn left, right, or stay the same
    DecideDirection proc
        PUSHLIST ax, bx

        Mov bx, 100
        Call RandomXor

        Cmp ax, RIGHT_CHANCE
        Jae AUX_DecideRight    ; Prep right turn if within range
        Cmp ax, LEFT_CHANCE
        Jb END_DecideDirection ; Skip if below left turning range

        Mov dx, TURN_LEFT      ; Prep left turn if within range
        Jmp AUX_ChangeDirection

    AUX_DecideRight:
        Mov dx, TURN_RIGHT    
    AUX_ChangeDirection:
        Call ChangeEnemyDirection

    END_DecideDirection:
        POPLIST ax, bx
        Ret
    DecideDirection endP

    ; Obtains a copy of the enemy's direction vector
    ; Inputs: n/a
    ; Outputs: BH:BL - Row:Col vector that matches the direction index
    GetEnemyVectorBX proc
        PUSHLIST si

        Mov si, enemyDirection
        Shl si, 1   ; Adjust index to address word-sized elements

        Mov bh, enemyMovement[si+0] ; Vectors row offset
        Mov bl, enemyMovement[si+1] ; Vector col offset

        POPLIST si
        Ret
    GetEnemyVectorBX endP

    ; Invokes enemy movement logic every time gameCounter is evenly divided by its speed
    MoveEnemy proc
        PUSHLIST ax, bx, dx

        IS_DIVISIBLE gameCounter, enemySpeed
        Jne END_MoveEnemy ; Skip logic if not evenly divided
    
        Call DecideDirection ; Otherwise, decide if enemy should change direction
        Call GetEnemyVectorBX
        Mov dx, word ptr enemyPosition ; Obtain current position
        Rol dx, 8                      ; Swap bits to set DH:DL to Row:Col
        Add dh, bh               ; And calculate new hypothetical position
        Add dl, bl

        Call ReadPlayArea ; Obtain VRAM contents of said position

        Cmp al, PLAYER_ICON
        Je FLAG_EnemyGameOver    ; If enemy touches player, flag game over and save new enemy position
        Cmp al, LINE_ICON
        Jne SET_MoveEnemy   ; If position is an empty area, save new enemy position

        Cmp ah, TRACK_COLOR
        Je FLAG_EnemyGameOver    ; If enemy touches the player's incomplete line, flag game over

        Mov dx, TURN_AROUND ; Otherwise, if line is a complete border, flip direction, and stay put
        Call ChangeEnemyDirection
        Mov dx, word ptr enemyPosition ; Retrieve current position once more
        Rol dx, 8
        Jmp SET_MoveEnemy        ; Skip GameOver flagging logic
    
    FLAG_EnemyGameOver:
        Mov programState, STATE_GAME_OVER
    SET_MoveEnemy:
        Mov ax, word ptr enemyPosition
        Mov word ptr prevEnemyPos, ax    ; Save old position
        Rol dx, 8                        ; Set DH:DL to Col:Row for little endian
        Mov word ptr enemyPosition, dx   ; Save new position

    END_MoveEnemy:
        POPLIST ax, bx, dx
        Ret
    MoveEnemy endP

    ; Obtains the vector values for a player's movement input
    ; Inputs: AH - Scan code of a key input
    ; Outputs: movementBuffer - Saves vector values for Row:Col offsets
    ;          CF - Set if the input matches a vector, clear otherwise
    FindPlayerMovement proc
        PUSHLIST si, ax, cx

        Xor si, si
        Mov cx, (VECTOR_COUNT / 2) ; Only allow orthogonal directions
    ITER_FindPlayerMovement:
        Mov al, byte ptr keyMovements[si]
        Cmp ah, al
        Je FLAG_MovementFound   ; Flag as found if there's a match
        Add si, (byte+word)     ; Skip to next Key,Vector entry
        Loop ITER_FindPlayerMovement
    
        Clc
        Jmp END_FindPlayerMovement ; Flag not found if there is no match

    FLAG_MovementFound:
        Mov ax, word ptr keyMovements[si+byte]
        Mov word ptr movementBuffer, ax   ; Save copy of vector in reverse order, Col:Row
        Stc

    END_FindPlayerMovement:
        POPLIST si, ax, cx
    FindPlayerMovement endP

    ; Processes a request to move the player if the gameCounter is evenly divided by its speed
    ; Inputs: movementBuffer - Vector value for Row:Col offset, in Col:Row order
    MovePlayer proc
        PUSHLIST ax, bx, dx

        ;IS_DIVISIBLE gameCounter, playerSpeed
        ;Jne END_MovePlayer

        Mov bx, word ptr movementBuffer
        Xchg bh, bl ; Set vector values in order Row:Col

        Mov dx, word ptr playerPosition ; Obtain current position
        Mov word ptr prevPlayerPos, dx  ; Save copy as prev position
        Rol dx, 8                       ; Swap bits to set DH:DL to Row:Col

        Add dh, bh          ; Obtain new row value
        Js AUX_PlayerRowUF  ; Adjust value if it decreased under 0
        Cmp dh, COL_LENGTH
        Jb AUX_MovePlayerCol   ; Skip to col calculation if value remained within range
        
        Xor dh, dh  ; Otherwise, adjust to 0 if row exceeded bound to ensure wrap around
        Jmp AUX_MovePlayerCol ; then proceed to col calculation

    AUX_PlayerRowUF:
        Mov dh, COL_LENGTH-1 ; Wrap around the other side
    
    AUX_MovePlayerCol:
        Add dl, bl ; Obtain new col value
        Js AUX_PlayerColUF ; Same as above, adjust 0-1 to wrap around boundary
        Cmp dl, PLAY_AREA_WIDTH
        Jb SET_MovePlayer ; Skip adjustments if within range

        Xor dl, dl ; Wrap around from max col value to 0
        Jmp SET_MovePlayer
    AUX_PlayerColUF:
        Mov dh, PLAY_AREA_WIDTH-1

    SET_MovePlayer:
        Call ReadPlayArea
        Cmp al, ENEMY_ICON
        Jne AUX_MovePlayerPos

        Mov programState, STATE_GAME_OVER ; Set game over if player touches enemy

    AUX_MovePlayerPos:
        Rol dx, 8                        ; Set DH:DL to Col:Row for little endian
        Mov word ptr playerPosition, dx   ; Save new position
        Mov word ptr movementBuffer, 0 ; Clear request after completed

    END_MovePlayer:
        POPLIST ax, bx, dx
        Ret
    MovePlayer endP

    ; Refreshes the display with the most recent logic values for the game
    DisplayGame proc
        PUSHLIST ax, dx

        Call Pause
        ; Retrieve enemy's prev row and col values
        Mov dx, word ptr prevEnemyPos
        Rol dx, 8                      ; Set DH:DL to Row:Col (*)
        Mov ah, SPACE_COLOR
        Mov al, CHAR_SPACE
        Call WritePlayArea  ; Erase enemy icon from prev position and restore empty space

        Mov dx, word ptr enemyPosition ; Obtain current position
        Rol dx, 8 ; Same as (*)
        Mov ah, ENEMY_COLOR
        Mov al, ENEMY_ICON
        Call WritePlayArea

        ; A player's prev position has to restore a solid line, or leave a track line
        Mov dx, word ptr prevPlayerPos
        Rol dx, 8 ; Same as (*)
        Mov ah, playerAreaData ; Determine the type of line by its color
        Mov al, LINE_ICON
        Call WritePlayArea

        Mov dx, word ptr playerPosition
        Rol dx, 8 ; Same as (*)
        Call ReadPlayArea ; Retrieve new area's Color:Char data

        Cmp ah, SPACE_COLOR
        Jne AUX_DisplayGame
        Mov ah, TRACK_COLOR ; If new position is an empty space, buffer a track line for next prev position
    
    AUX_DisplayGame:
        Mov playerAreaData, ah ; Save current area's color data for next display iter

        Shl ah, 4         ; Set area's FG color as Player's BG color
        Add ah, PLAYER_COLOR ; Layer Player's FG color on top of BG
        Mov al, PLAYER_ICON
        Call WritePlayArea

        POPLIST ax, dx
        Ret
    DisplayGame endP

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

    ; Updates the game's logic and display states
    ; Inputs: Accepts player inputs to control their character or to pause the game
    ; Outputs: Displays videogame to VRAM in text mode
    GameUpdate proc
        PUSHLIST ax

    ITER_GameUpdate:
        Cmp programState, STATE_GAME_OVER ; If player lost during a prev iter, halt
        Je END_GameUpdate

        Inc gameCounter     ; Advance to control execution speed
        Call DisplayGame
        Call MoveEnemy
        Call MovePlayer
        CHECK_KEY_INPUT
        Jz ITER_GameUpdate ; Keep checking until an input is found

        READ_KEY_INPUT
        Cmp ah, KEY_SPACE
        Je PAUSE_GameUpdate

        Call FindPlayerMovement ; Buffers a movement request for valid inputs
        Jmp ITER_GameUpdate
    
    PAUSE_GameUpdate:
        Mov programState, STATE_MENU

    END_GameUpdate:
        POPLIST ax
        Ret
    GameUpdate endP

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
        Call ClearDisplay
        Mov al, 00h
        Mov ah, 4Ch
        Int 21h


CodeSegment endS

end main