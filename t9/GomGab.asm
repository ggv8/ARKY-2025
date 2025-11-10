; Documentacion
    ; ╔═════════════════════════════════════╦═══════════════════════════════════╗
    ; ║ Instituto Tecnologico de Costa Rica ║ Gabriel Gomez Vega                ║
    ; ║ Escuela de Computacion              ║ 2021106483                        ║
    ; ║ Arquitectura de Computadoras        ║ 14 de Noviembre del 2025          ║
    ; ╚═════════════════════════════════════╩═══════════════════════════════════╝
    ; ╔═════════════════════════════════════════════════════════════════════════╗
    ; ║                            Manual de Usuario                            ║
    ; ╠═════════════════════════════════════════════════════════════════════════╣
    ; ║ Este programa es una demo de las capacidades que tiene el modo gráfico  ║
    ; ║ de video a 16 colores. Para ello se muestran las banderas de diferentes ║
    ; ║ lugares del mundo en la pantalla. Se muestra sólo una bandera a la vez  ║
    ; ║ y debe ingresarse el nombre del país en la línea de comandos después de ║
    ; ║ invocar al programa. No es 'case-sensitive' así que puede ingresar el   ║
    ; ║ nombre en mayúsculas, minúsculas, o como desee. El programa goza de es- ║
    ; ║ ta capacidad para facilitar su uso. En el caso de la ñ, tampoco se dis- ║
    ; ║ tingue si es o no mayúscula. Sin embargo, tenga en cuenta que debe in-  ║
    ; ║ gresarse mediante el código ASCII. Para la minúsucula, use ALT+164 y    ║
    ; ║ ALT+165 para la mayúscula.                                              ║
    ; ║                                                                         ║
    ; ║ Si el programa no recibe una entrada, desplegará una bandera personali- ║
    ; ║ zada y cuadro de texto detallando los datos Acerca De sobre el programa ║
    ; ║ su creador y su propósito. Se desplega también una pequeña ayuda sobre  ║
    ; ║ los países que forman parte de la demo de banderas y cómo puede cerrar- ║
    ; ║ se el programa. Para ello se utiliza la tecla <C>, sin distinguir si es ║
    ; ║ mayúscula o minúsucula, pues se revisa código de rastreo y no el código ║
    ; ║ ASCII. Al desplegar las banderas, no se muestra esta nota para no tapar ║
    ; ║ la bandera y por lo tanto debe recordar con cual tecla se sale al SO.   ║
    ; ║                                                                         ║
    ; ║ El programa recurre al algoritmo de Bresenham para dibujar líneas in-   ║
    ; ║ clinadas con grados distintos a 45°. Se hizo una implementación propia  ║
    ; ║ para aprovechar el control de directo bajo nivel que ofrece ensamblador.║
    ; ║ A continuación se listan los países que puede ingresar para ver la ban- ║
    ; ║ dera y notas acerca de la opción:                                       ║
    ; ║                                                                         ║
    ; ║ <Costa Rica>                                                            ║
    ; ║ Presenta franjas horizontales y es el país de origen del autor :)       ║
    ; ║                                                                         ║
    ; ║ <Alemania>                                                              ║
    ; ║ Otra bandera con franjas horizontales. Al cambiar al modo gráfico lim-  ║
    ; ║ pia la pantalla, en realidad no se despliega su franja negra ya que se- ║
    ; ║ ría redundante frente al lienzo en negro. Por ello tal vez note que su  ║
    ; ║ despliegue es más rápido que la anterior.                               ║
    ; ║                                                                         ║
    ; ║     <Chad>                                                              ║
    ; ║ Este país tiene una bandera que presenta franjas verticales             ║
    ; ║                                                                         ║
    ; ║     <Noruega>                                                           ║
    ; ║ Su diseño es más complejo y se realiza por capas. Presenta una cruz a-  ║
    ; ║ nidada de color azul en una cruz blanca. Por ello vera que primero se   ║
    ; ║ dibujan segmentos del fondo por separado y luego se pintan las franjas  ║
    ; ║ blancas y azules.                                                       ║
    ; ║                                                                         ║
    ; ║     <Palestina>                                                         ║
    ; ║ Tiene un medio rombo rojo en su lado izquierdo. Esta figura se dibuja   ║
    ; ║ con líneas inclinadas de 45°                                            ║
    ; ║                                                                         ║
    ; ║     <Gran Bretaña>                                                      ║
    ; ║ Uno de los diseños más elaborados en cuanto a capas, especialmente por  ║
    ; ║ requerir líneas hechas con el algoritmo de Bresenham. Al dibujar las    ║
    ; ║ franjas inclinadas en un mismo ciclo, se logra un efecto visual intere- ║
    ; ║ sante.                                                                  ║
    ; ║                                                                         ║
    ; ║     <Chile>                                                             ║
    ; ║ Esta bandera presenta una estrella y por ello requiere el algoritmo de  ║
    ; ║ Bresenham. Sin embargo, consiste en pintar triágulos que construyan la  ║
    ; ║ figura.                                                                 ║
    ; ║                                                                         ║
    ; ║     <Uruguay>                                                           ║
    ; ║ El sol de esta bandera presentó un reto interesante ya que tiene varias ║
    ; ║ capas complejas de construir simultáneamente. Primero se dibujan los ra-║
    ; ║ yos del sol en un ciclo doble que dibuja su mitad de un color y luego   ║
    ; ║ con otro. Dependiendo de la posición del rayo se debe invertir el color ║
    ; ║ para mantener la perspectiva de la luz vista en el diseño.              ║
    ; ║                                                                         ║
    ; ║ Dibujar el círculo emplea una estrategia similar al algoritmo Bresenham ║
    ; ║ Para rellenarlo se utiliza Bresenham para hacer un barrido del radio.   ║
    ; ║ Más detalles en la explicación de Bresenham. Los rasgos faciales se a-  ║
    ; ║ proximaron colocando circulos encima de otros para lograr curvas cónca- ║
    ; ║ vas.                                                                    ║
    ; ║                                                                         ║
    ; ║     <Canada>                                                            ║
    ; ║ La hoja en esta bandera requiere dibujar varios triángulos desde ángu-  ║
    ; ║ los particulares para obtener su figura.                                ║
    ; ║                                                                         ║
    ; ║ Nota: La documentación adicional sobre Bresenham se encuentra después   ║
    ; ║ del análisis de resultados.                                             ║
    ; ╚═════════════════════════════════════════════════════════════════════════╝
    ; ╔═════════════════════════════════════════════════════════════════════════╗
    ; ║                        Analisis de Resultados                           ║
    ; ╠══════════════════════════════════════════════════════════╦══════════════╣
    ; ║                          Aspectos                        ║ Calificacion ║
    ; ╠══════════════════════════════════════════════════════════╬══════════════╣
    ; ║ Documentacion                                            ║      A       ║
    ; ╠══════════════════════════════════════════════════════════╬══════════════╣
    ; ║ Uso del modo gráfico (640x480, 16 colores)               ║      A       ║
    ; ╠══════════════════════════════════════════════════════════╬══════════════╣
    ; ║ Lectura y reconocimiento de la entrada por línea de cmd  ║      A       ║
    ; ╠══════════════════════════════════════════════════════════╬══════════════╣
    ; ║ Pausa y salida al SO hasta recibir tecla pedida          ║      A       ║
    ; ╠══════════════════════════════════════════════════════════╬══════════════╣
    ; ║ Acerca De (bandera propia y despliegue de los datos)     ║      A       ║
    ; ╠══════════════════════════════════════════════════════════╬══════════════╣
    ; ║ Bandera de Costa Rica                                    ║      A       ║
    ; ╠══════════════════════════════════════════════════════════╬══════════════╣
    ; ║ Bandera horizontal (3a. Alemania)                        ║      A       ║
    ; ╠══════════════════════════════════════════════════════════╬══════════════╣
    ; ║ Bandera vertical (4e. Chad)                              ║      A       ║
    ; ╠══════════════════════════════════════════════════════════╬══════════════╣
    ; ║ Bandera con cruz (5d. Noruega)                           ║      A       ║
    ; ╠══════════════════════════════════════════════════════════╬══════════════╣
    ; ║ Bandera con líneas 45° (6c. Palestina)                   ║      A       ║
    ; ╠══════════════════════════════════════════════════════════╬══════════════╣
    ; ║ Algoritmo de Bresenham                                   ║      A       ║
    ; ╠══════════════════════════════════════════════════════════╬══════════════╣
    ; ║ Bandera con líneas != 45° (7b. Gran Bretaña)             ║      A       ║
    ; ╠══════════════════════════════════════════════════════════╬══════════════╣
    ; ║ Bandera con estrellas (8e. Chile)                        ║      A       ║
    ; ╠══════════════════════════════════════════════════════════╬══════════════╣
    ; ║ Bandera con soles (9d. Uruguay)                          ║      A       ║
    ; ╠══════════════════════════════════════════════════════════╬══════════════╣
    ; ║ Bandera compleja (10c. Canada)                           ║      A       ║
    ; ╚══════════════════════════════════════════════════════════╩══════════════╝
;

; Explicación sobre el algoritmo de Bresenham
;
; Este algoritmo parte primero de la teoría básica de rectas. Visto brevemente, las
; rectas se representan con la ecuación y = mx + b, donde m es la pendiente y se puede
; obtener a partir de dos puntos donde pase la recta. Consiste en tomar la diferencia
; de las y, luego se divide entre la diferencia de las x. Esta razón de cambio permite
; calcular otros puntos por donde pase la recta una vez despejado la b. Los problemas de
; usar esta ecuación tal cual para calcular la trayectoria de pixeles son:
;   - El manejo de punto flotante implícito en la pendiente y el rango de la función
;   - Que la función se estaría graficando en valores discretos (pixeles), no la recta numérica
;
; Dependiendo de la pendiente, esta puede darle prioridad al movimiento de un eje sobre otro
; según el valor de las diferencias, que son en sí un desplazamiento de un punto de partida a
; un punto final. Por ejemplo, los puntos (1,2) al (2,4) tienen una razón 2/1 = 2, que dice
; que y crece linealmente por 2 conforme crece x. Si se invierten los pares, (2,1) a (4,2),
; m= 1/2 = 0.5. Si bien desde la parte real podemos decir que aumenta por 0.5 según x, otra
; forma de verlo es comparando los tamaños de los desplazamientos. Es decir, y cambia por 1
; cada 2 pasos de x. Lo mismo ocurre con el ejemplo anterior, x cambia por 1 cada 2 pasos de y.
;
; Debido a este comportamiento condicionado, se distingue entre un eje conductor (driving axis)
; y un eje dependiente (passive axis). A ello se le suman los casos dados según la dirección del
; desplazamiento. Entonces el algoritmo de Bresenham consiste en hacer el recorrido del eje conductor
; y compara en cada iteración si su posición actual se ha acercado a un umbral de cambio para
; mover al eje dependiente. De lo investigado, la explicación más intuitiva a mi parecer es la
; siguiente:
;
; Si se traza una línea en una cuadrícula, esta pasa a través los pixeles cada unidad discreta.
; Por ello, se tiene un margen de error dado por m-1. El 1 del criterio viene del tamaño del pixel,
; que es discreto. Si m fuera 0.3, el margen sería -0.7 por ejemplo. Cuando se mueve el eje conductor,
; se ajusta el margen de error con un incremento de m para reflejar que se acerco al punto final.
; El movimiento del eje pasivo lo que debe hacer es reajustar el criterio a la nueva fila, decrementando
; por 1 unidad de pixel. Este se da sólo si el criterio se vuelve no negativo.
;
; El truco de Bresenham para trabajar con enteros es realizar una transformación
; algebraica de estos valores. m-1 = (difY/difX) - 1. Para deshacerce de la división, se multiplica por
; el denominador y se obtiene difY - difX. El algoritmo se detiene cuando se alcanza el punto final.
; Esto es, por supuesto, asumiendo que X es el eje conductor y Y es el eje dependiente.
;
; Para la implementación, sin embargo, utilicé la versión de Bresenham de las fuentes recomendadas.
; Esta utiliza otra transformación que resulta en tres valores constantes distintos a los mencionados
; anteriormente. El criterio es 2(difY) - (difX). El ajuste del conductor es incE = 2(difY). El ajuste
; del eje dependiente es 2(difY) - 2(difX) o 2(difY - difX). Siendo honesto, esta transformación no me
; queda clara para nada de donde ha salido a pesar de consultar las fuentes. Intente implementar la versión
; mencionada, pero estaba teniendo problemas con ella, posiblemente debido algún error de mi parte. Sin
; embargo, la idea central del algoritmo es la misma en ambas versiones. Se tiene un criterio, un eje conductor
; y uno dependiente. Cada iteración se revisa si la posición actual cumple o no el criterio para hacer un movimiento
; en el eje dependiente. Al hacerlo, se realiza un ajuste el criterio para reflejar el cambio. Se itera hasta llegar
; al punto objetivo.
;
; Un detalle que ajuste fue como determinar la dirección de los movimientos y cual rol debe tomar cada eje. En lugar
; de hacer una estructura if-else-then, calculo los valores pertinentes al eje asumiendo que la fila es el eje conductor.
; Luego reviso si fallé en la predicción, en cuyo caso es un intercambio de punteros y valores antes de calcular las
; constantes del criterio y ajustes. Aunque es mucho más compacto que una implementación 1:1 del algoritmo ejemplificado
; en las fuentes, es bastante código boilerplate y por ello decidí encapsularlo en una macro de inicialización. Así, al
; rutina de Bresenham se puede apreciar directamente el diseño iterativo del algoritmo.
;
; Si bien no estaba en el enunciado, consideré relevante explicar como hice para implementar el círculo. Tomando lo
; aprendido de Bresenham, el trazo del circulo debe cumplir un margen (la distancia del radio) y su calculo involucra
; puntos flotantes (por el despeje de la fórmula de distancia y la raíz cuadrada). Si se analiza por octantes, el
; círculo también presenta un comportamiento de eje conductor y eje dependiente. Para no usar punto flotante, se mantiene
; ambos lados de la ecuación del círculo con las potencias cuadradas. Se agrega además un margen de error r, que en realidad viene
; del tamaño del pixel, osea r+1, pero por la potencia al cuadrado de la ecuación, se multiplicaría por r y se obtiene un criterio
; r^2 + 1. Si la posición actual deja de ser menor, se mueve el eje dependiente. La diferencia entre este y Bresenham, es que se puede
; implementar simetría de octantes en el círculo para obtener los demás lados simultáneamente. Para rellenarlo hice que se dibujaran
; líneas de Bresenham desde el origen hacía el punto calculado en cada iteración. Presenta fallo sin embargo, ya que tiene a dejar
; uno que otro pixel sin rellenar. Sin embargo, la simetría le da un tono de textura que se ve agradable.

; Fuentes consultadas:
; Joy, K.I. (n.d.). BRESHENHAM’S ALGORITHM. Department of Computer Science University of California,
; Davis. https://www.cs.put.poznan.pl/swilk/pmwiki/uploads/Dydaktyka/bresenham-int.pdf
;
; Algoritmo basado en la ecuación de la recta. (n.d.). http://galia.fc.uaslp.mx/~medellin/Applets/LineasRectas/Recta.htm
;
; Caballero Hurtado, A. V. (n.d.). 23.1.2 Algoritmo de Bresenham.
; Abre los Ojos a la Programación. https://abreojosensamblador.epizy.com/?Tarea=1&SubTarea=23#Bresenham


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

    ; Consumes a key input that has been buffered or waits for one if necessary
    READ_KEY_INPUT Macro
        Xor al, al
        Mov ah, BIOS_GET_KEY
        Int 16h
    endM

    ; Moves the text cursor to a row and column position within a page
    ; Inputs: pRow, pCol - New position of the cursor
    ;              pPage - Page of the cursor
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

    ; Changes the display mode to VGA's 16 color graphic mode
    ; which also clears the display contents into a black screen
    SET_GRAPHIC_MODE Macro
        Mov ah, BIOS_SET_VIDEO_MODE
        Mov al, VGA_640x480_16C
        Int 10h
    endM

    ; Changes the display mode to the regular 80x25 colored text mode
    ; which also clears the display contents into a black screen
    SET_TEXT_MODE Macro
        Mov ah, BIOS_SET_VIDEO_MODE
        Mov al, TEXT_MODE_80x25
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
    stateTable  dw STATE_DEFAULT,       ReadInput
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

        Xor ch, ch  ; Ignore high counter
        Inc si      ; Point to first char of entry
    ITER_CompareInput:
        Mov al, byte ptr es:[bx]

        Cmp al, CHAR_SPACE
        Je AUX_CompareInput ; Skip lowercase mask if char is ' '
        Cmp al, CHAR_ENNE
        Je AUX_CompareInput ; or if it is 'ñ'

        Cmp al, CHAR_ENNE+1
        Jne AUX_CompareLowercase
        Dec al ; If it is 'Ñ', manually set to lowercase and compare directly
        Jmp AUX_CompareInput

    AUX_CompareLowercase:
        Or al, 60h ; Assume alpha char, enforce lowercase to be case insensitive
    
    AUX_CompareInput:
        Cmp al, byte ptr inputTable[si]
        Jne FLAG_Different ; If a single character is off, flag not equal
        Inc bx
        Inc si ; Point to next byte of both strings
        Loop ITER_CompareInput

        Stc ; Flag equal if all chars matched
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
        Add si, ax                      ; Point to next entry by skipping entry's length
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
    ; Inputs: Expects a string matching the name of a country
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

    ; Auxiliar routine to DrawLine
    ; Prepares the next line position to draw a pixel at based on a direction parameter
    ; Inputs: pDirection (int) - Enum of direction the line is taking
    ;         DX - Row index
    ;         CX - Column index    
    ; Outputs: Sends colored pixels to the graphic memory display
    NextLinePosition proc near
        ; Symb.Constants for function parameters
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
    NextLinePosition endP

    ; Displays a line at a coordinate with a specified length
    ; Inputs:   pColor     (RGB) - Color coded byte
    ;           pRow       (int) - Index to VRAM row
    ;           pCol       (int) - Index to VRAM column
    ;           pLength    (int) - Length of line from top corner to bottom corner
    ;           pDirection (int) - Direction the line is taking
    ; Outputs: Sends colored pixels to the graphic memory display
    DrawLine proc near
        ; Symb.Constants for function parameters
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
        ; Symb.Constants for function parameters
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
        Mov cx, word ptr pHeight ; To iter for each vertical line
        Mov dx, word ptr pLength
    ITER_DrawRect:
        Push word ptr pColor
        PUSHLIST ax, bx, dx, GO_RIGHT
        Call DrawLine ; Draw line at row,col position up to lenght, from left to right
        Inc ax        ; Next row position
        Loop ITER_DrawRect

        POPLIST ax, bx, cx, dx
        END_STACKFRAME ArgSize
    DrawRect endP

    ; Sets a single colored pixel in graphic mode
    ; Inputs: pColor     - Color of pixel
    ;         pRow, pCol - Target position
    ; Outputs: Prints a pixel onto the display
    SetPixel proc
        ; Symb.Constants for function parameters
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

    ; Obtains the abs(difference) between two coordinates and the direction of it's step
    ; Auxiliar macro to Bresenham's init macro
    INIT_DIFF_STEP Macro pDifference:REQ, pVal1:REQ, pVal2:REQ, pStep:REQ
        Local END_Abs
        Mov pStep, 1                    ; Assume step is forward
        Mov pDifference, word ptr pVal2
        Sub pDifference, word ptr pVal1 ; Dif = Val2 - Val1
        Jns END_Abs                     ; Halt if Dif is non negative
        Neg pDifference ; Otherwise, get absolute value
        Neg pStep       ; and fix step assumption to be backwards
        END_Abs:
    endM

    ; Initializes relevant stack variables and registers for Bresenham's line algorithm
    ; Auxiliar macro to abstract initialization from main function
    INIT_BRESENHAM Macro
        ; Assume row is driving axis:
        ; SI = Ptr to driving axis index, DX = Driving Offset/Difference, AX = Driving Step Direction
        ; DI = Ptr to passive axis index, BX = Passive Offset/Difference, CX = Passive Step Direction
        Lea si, word ptr pRow1
        Lea di, word ptr pCol1
        INIT_DIFF_STEP dx, pRow1, pRow2, ax ; Get each coordinate's abs(difference)
        INIT_DIFF_STEP bx, pCol1, pCol2, cx ; and their step direction

        Cmp dx, bx            ; Determine if assumptions are correct by comparing pace of row vs column
        Jge END_InitBresenham ; Continue init if correct (row increases at same or greater pace)

        Xchg si, di ; Otherwise, set col as driving axis and row as passive
        Xchg dx, bx ; Swap their differences and their
        Xchg ax, cx ; step directions to match their role
    
    END_InitBresenham: ; Store calculated steps in respective local variable and init constant values
        Mov word ptr drivingStep, ax ; Store driving and passive
        Mov word ptr passiveStep, cx ; steps in respective vars

        Mov cx, dx ; Use driving offset to control upcoming iter
        
        ; Constant values: BX = incE, DX = incNE, pixelBound
        Shl bx, 1  ; incE = 2*(Passive Offset)
        Mov ax, bx
        Sub ax, dx
        Mov word ptr pixelBound, ax ; 2*(Passive Offset) - (Driving Offset)

        Shl dx, 1 ; 2*(Driving Offset)
        Neg dx
        Add dx, bx ; Obtain 2(Passive - Driving) = -2(Driving) + 2(Passive)
    endM

    ; Implementation of Bresenham's line algorithm to draw lines between two
    ; points with an accurate representation in matrix displays
    ; Inputs:   pColor - RGB byte representation of line's color
    ;           pRow1, pCol1 - Starting point of the line
    ;           pRow2, pCol2 - End point of the line
    ; Outputs: Prints each pixel of the line in traversal order to the display
    Bresenham proc near
        ; Symb.Constants for function parameters
        Local pColor, pRow1, pCol1, pRow2, pCol2, ArgSize
            pColor = [bp + 4*word + NEAR_BOUND]
            pRow1  = [bp + 3*word + NEAR_BOUND]
            pCol1  = [bp + 2*word + NEAR_BOUND]
            pRow2  = [bp + 1*word + NEAR_BOUND]
            pCol2  = [bp + 0*word + NEAR_BOUND]
            ArgSize = 5*word
        ; Symb.Constants for function variables
        Local difRow, difCol, pixelBound, stepRow, stepCol
            pixelBound  = [bp - 1*word]
            drivingStep = [bp - 2*word]
            passiveStep = [bp - 3*word]
            VarSize = 3*word
        SET_STACKFRAME VarSize ; Allocate space for variables as well
        PUSHLIST si, ax, bx, cx, dx

        INIT_BRESENHAM ; Initializes local variables, constants, and registers to match instance     
    
        Push word ptr pColor
        Push word ptr pRow1
        Push word ptr pCol1
        Call SetPixel
    ITER_Bresenham:
        Mov ax, word ptr drivingStep
        Add word ptr ss:[si], ax    ; Always move drivingAxis += step

        Cmp word ptr pixelBound, 0  ; Check if passiveAxis should be moved
        Jl AUX_Bresenham            ; If pixelBound < 0, ignore passiveAxis

        Mov ax, word ptr passiveStep ; Otherwise, movve
        Add word ptr ss:[di], ax     ; passiveAxis += step
        Add word ptr pixelBound, dx  ; Update pixelBound criteria with += incNE
        Jmp PRINT_Bresenham

    AUX_Bresenham:
        Add word ptr pixelBound, bx ; Update pixelBound criteria with += INCE
    PRINT_Bresenham:
        Push word ptr pColor
        Push word ptr pRow1
        Push word ptr pCol1
        Call SetPixel
        Loop ITER_Bresenham

    END_Bresenham:
        POPLIST si, ax, bx, cx, dx
        END_STACKFRAME ArgSize
    Bresenham endP

    ; Draws all octants of a circle based on the offset from the origin of the 1st octant
    ; Inputs: pColor                 - Fill color of the shape
    ;         pRowOrigin, pColOrigin - Middle point of the circle
    ;         AX, BX                 - Row, and column offsets to a point in the circumference
    DrawOctants proc
        ; Symb.Constants for function parameters
        Local pColor, pRowOrigin, pColOrigin, ArgSize
            pColor      = word ptr [bp + 2*word + NEAR_BOUND]
            pRowOrigin  = word ptr [bp + 1*word + NEAR_BOUND]
            pColOrigin  = word ptr [bp + 0*word + NEAR_BOUND]
            ArgSize = 3*word
        ; Symbolic Aliases
        Local pRowLength, pColLength
            pRowLength  = ax
            pColLength  = bx
        SET_STACKFRAME
        PUSHLIST ax, bx, cx, dx

        ; 1st Octant
        Mov dx, pRowOrigin
        Mov cx, pColOrigin
        Add dx, pRowLength
        Add cx, pColLength ; Obtain endpoint offset from origin

        PUSHLIST pColor, pRowOrigin, pColOrigin, dx, cx
        Call Bresenham ; Draw 1st octant curve

        ; 2nd Octant
        Mov dx, pRowOrigin
        Mov cx, pColOrigin
        Add dx, pColLength
        Add cx, pRowLength
        PUSHLIST pColor, pRowOrigin, pColOrigin, dx, cx
        Call Bresenham ; Draw 2nd octant curve
        
        ; 3rd Octant
        Mov dx, pRowOrigin
        Mov cx, pColOrigin
        Add dx, pColLength
        Sub cx, pRowLength

        PUSHLIST pColor, pRowOrigin, pColOrigin, dx, cx
        Call Bresenham

        ; 4th Octant
        Mov dx, pRowOrigin
        Mov cx, pColOrigin
        Add dx, pRowLength
        Sub cx, pColLength
        PUSHLIST pColor, pRowOrigin, pColOrigin, dx, cx
        Call Bresenham

        ; 5th Octant
        Mov dx, pRowOrigin
        Mov cx, pColOrigin
        Sub dx, pRowLength
        Sub cx, pColLength
        PUSHLIST pColor, pRowOrigin, pColOrigin, dx, cx
        Call Bresenham

        ; 6th Octant
        Mov dx, pRowOrigin
        Mov cx, pColOrigin
        Sub dx, pColLength
        Sub cx, pRowLength
        PUSHLIST pColor, pRowOrigin, pColOrigin, dx, cx
        Call Bresenham

        ; 7th Octant
        Mov dx, pRowOrigin
        Mov cx, pColOrigin
        Sub dx, pColLength
        Add cx, pRowLength
        PUSHLIST pColor, pRowOrigin, pColOrigin, dx, cx
        Call Bresenham

        ; 8th Octant
        Mov dx, pRowOrigin
        Mov cx, pColOrigin
        Sub dx, pRowLength
        Add cx, pColLength
        PUSHLIST pColor, pRowOrigin, pColOrigin, dx, cx
        Call Bresenham
        
        POPLIST ax, bx, cx, dx
        END_STACKFRAME ArgSize
        Ret
    DrawOctants endP

    ; Draws a filled circle at a position with a given radius
    ; Inputs:   pColor                 - Color of the shape
    ;           pRowOrigin, pColOrigin - Middle point of the circle
    ;           pRadius                - Length of the circle's radius
    ; Outputs: Prints all lines of the shape to the display
    DrawCircle proc
        ; Symb.Constants for function parameters
        Local pColor, pRowOrigin, pColOrigin, pRadius, ArgSize
            pColor     = [bp + 3*word + NEAR_BOUND]
            pRowOrigin = [bp + 2*word + NEAR_BOUND]
            pColOrigin = [bp + 1*word + NEAR_BOUND]
            pRadius    = [bp + 0*word + NEAR_BOUND]
            ArgSize = 4*word
        ; Symb.Constants for function variables
        Local radiusBound, rowEnd, colEnd, VarSize
            radiusBound = [bp - 1*word]
            rowDistance = [bp - 2*word]
            colDistance = [bp - 3*word]
            VarSize = 3*word
        SET_STACKFRAME VarSize
        PUSHLIST ax, bx, cx, dx

        Mov ax, word ptr pRadius
        Mov word ptr rowDistance, 0
        Mov word ptr colDistance, ax ; Start at offset (0, r) to calculate 1st octant

        Mov bx, ax ; Copy radius to obtain product
        Mul bx
        Add ax, bx ; Add margin error
        Mov word ptr radiusBound, ax ; Save (r^2) + r as criteria for change

    ITER_DrawCircle:
        Mov ax, word ptr rowDistance
        Mov bx, word ptr colDistance
        Cmp ax, bx
        Ja END_DrawCircle ; Halt if coordinates have already crossed paths (i.e while row <= col)

        Push word ptr pColor
        Push word ptr pRowOrigin
        Push word ptr pColOrigin
        Call DrawOctants ; Draw all octant end points for the current offsets in AX, BX

        Inc word ptr rowDistance ; Always advance driving axis (Row=AX for the 1st octant)

        ; Get rowDistance^2
        Mov bx, ax
        Mul bx
        Mov bx, ax

        ; Get colDistance^2
        Mov ax, word ptr colDistance
        Mov cx, ax
        Mul cx
        Add ax, bx ; Sum them to obtain length from origin to endpoint

        Cmp ax, word ptr radiusBound ; Compare length to (r^2 + r)
        Jb ITER_DrawCircle       ; Next iter if within radius bound
        Dec word ptr colDistance ; Otherwise, move passive axis closer to origin
        Dec word ptr radiusBound ; Adjust radius bound to account for passive change
        Jmp ITER_DrawCircle

    END_DrawCircle:
        POPLIST ax, bx, cx, dx
        END_STACKFRAME ArgSize
    DrawCircle endP

    ; Routine that pauses the program's execution until a close command is detected
    ; Inputs: Expects a C-key input to resume program execution
    ; Outputs: n/a
    StandBy proc
        CHECK_KEY_INPUT
        Jz StandBy  ; If no input, keep checking

        READ_KEY_INPUT
        Cmp ah, KEY_C
        Jne StandBy ; Keep checking until input is for closing window
        Ret
    StandBy endP

    ; Wrapper routine that draws the flag of Costa Rica in graphic mode
    ; Inputs: n/a
    ; Outputs: Prints colors and shapes to the display to represent the flag
    CostaRica proc
        PUSHLIST ax
        SET_GRAPHIC_MODE

        PUSHLIST COLOR_DARK_BLUE, 0, 0, VIDEO_WIDTH, 80
        Call DrawRect ; Top blue stripe

        PUSHLIST COLOR_WHITE, 80, 0, VIDEO_WIDTH, 80
        Call DrawRect ; Top white stripe
        
        PUSHLIST COLOR_LIGHT_RED, 2*80, 0, VIDEO_WIDTH, 2*80
        Call DrawRect ; Middle red stripe

        PUSHLIST COLOR_WHITE, 4*80, 0, VIDEO_WIDTH, 80
        Call DrawRect ; Bottom white strip

        PUSHLIST COLOR_DARK_BLUE, 5*80, 0, VIDEO_WIDTH, 80
        Call DrawRect ; Bottom blue stripe

        Call StandBy
        SET_TEXT_MODE        
        Mov programState, STATE_HALT
        POPLIST ax
        Ret
    CostaRica endP

    ; Wrapper routine that draws the flag of Germany in graphic mode
    ; Inputs: n/a
    ; Outputs: Prints colors and shapes to the display to represent the flag
    Germany proc
        PUSHLIST ax
        SET_GRAPHIC_MODE ; Changing video modes clears the screen to black
                         ; which makes it unnecesary to print the black stripe

        ;PUSHLIST COLOR_BLACK, 0, 0, VIDEO_WIDTH, 160
        ;Call DrawRect

        PUSHLIST COLOR_LIGHT_RED, 160, 0, VIDEO_WIDTH, 160
        Call DrawRect ; Middle red stripe

        PUSHLIST COLOR_YELLOW, 2*160, 0, VIDEO_WIDTH, 160
        Call DrawRect ; Bottom yellow strip        

        Call StandBy
        SET_TEXT_MODE 
        Mov programState, STATE_HALT
        POPLIST ax
        Ret
    Germany endP

    ; Wrapper routine that draws the flag of Chad in graphic mode
    ; Inputs: n/a
    ; Outputs: Prints colors and shapes to the display to represent the flag
    Chad proc
        PUSHLIST ax
        SET_GRAPHIC_MODE

        PUSHLIST COLOR_DARK_BLUE, 0, 0, 213, VIDEO_HEIGHT
        Call DrawRect ; Left blue vertical stripe

        PUSHLIST COLOR_YELLOW, 0, 213, 214, VIDEO_HEIGHT
        Call DrawRect ; Middle yellow vertical stripe

        PUSHLIST COLOR_LIGHT_RED, 0, 213+214, 213, VIDEO_HEIGHT
        Call DrawRect ; Right red vertical stripe

        Call StandBy
        SET_TEXT_MODE
        Mov programState, STATE_HALT
        POPLIST ax
        Ret
    Chad endP

    ; Wrapper routine that draws the flag of Norway in graphic mode
    ; Inputs: n/a
    ; Outputs: Prints colors and shapes to the display to represent the flag
    Norway proc
        PUSHLIST ax
        SET_GRAPHIC_MODE

        PUSHLIST COLOR_LIGHT_RED, 0, 0, 128+32, 128+32+8
        Call DrawRect ; Red rectangle of top left corner
        
        PUSHLIST COLOR_LIGHT_RED, 128+32+8+144, 0, 128+32, 128+32+8
        Call DrawRect ; Red rectangle of bottom left corner

        PUSHLIST COLOR_LIGHT_RED, 0, 128+32+128, VIDEO_WIDTH-(128+32+128), 128+32+8
        Call DrawRect ; Red rectangle of top right corner

        PUSHLIST COLOR_LIGHT_RED, 128+32+8+144, 128+32+128, VIDEO_WIDTH-(128+32+8), 128+32+8
        Call DrawRect ; Red rectangle of bottom right corner

        ; White cross background
        PUSHLIST COLOR_WHITE, 0, 128+32, 128, VIDEO_HEIGHT
        Call DrawRect ; Vertical stripe

        PUSHLIST COLOR_WHITE, 128+32+8, 0, VIDEO_WIDTH, 144
        Call DrawRect ; Horizontal stripe

        ; Blue cross foregroung
        PUSHLIST COLOR_DARK_BLUE, 0, 128+32+32, 64, VIDEO_HEIGHT
        Call DrawRect ; Vertical stripe

        PUSHLIST COLOR_DARK_BLUE, 128+32+8+36, 0, VIDEO_WIDTH, 72
        Call DrawRect ; Horizontal stripe

        Call StandBy
        SET_TEXT_MODE
        Mov programState, STATE_HALT
        POPLIST ax
        Ret
    Norway endP

    ; Wrapper routine that draws the flag of Palestine in graphic mode
    ; Inputs: n/a
    ; Outputs: Prints colors and shapes to the display to represent the flag
    Palestine proc
        PUSHLIST ax, bx, cx
        SET_GRAPHIC_MODE ; Changing video modes clears the screen to black
                         ; which makes it unnecesary to print the black stripe

        ;PUSHLIST COLOR_BLACK, 0, 0, VIDEO_WIDTH, 160
        ;Call DrawRect

        PUSHLIST COLOR_WHITE, 160, 0, VIDEO_WIDTH, 160
        Call DrawRect ; Middle white stripe

        PUSHLIST COLOR_DARK_GREEN, 2*160, 0, VIDEO_WIDTH, 160
        Call DrawRect ; Bottom green stripe

        Xor ax, ax              ; To index from the top row
        Mov bx, VIDEO_HEIGHT-1  ; and from the bottom row
        Mov cx, VIDEO_HEIGHT/2  ; Iters until the middle row
    ITER_PalestineFG:
        PUSHLIST COLOR_LIGHT_RED, ax, 0, cx, GO_DOWN_RIGHT
        Call DrawLine ; Print diagonal from the top up to the middle row

        PUSHLIST COLOR_LIGHT_RED, bx, 0, cx, GO_UP_RIGHT
        Call DrawLine ; Print diagonal from the bottom up to the middle row
        Inc ax ; Move both indexes close to the middle row
        Dec bx
        Loop ITER_PalestineFG
    END_Palestine:
        Call StandBy
        SET_TEXT_MODE
        Mov programState, STATE_HALT
        POPLIST ax, bx, cx
        Ret
    Palestine endP

    ; Draws an X shaped cross figure that spans across the entire screen
    ; Inputs:   pColor  - Color of the shape
    ;           pLength - Length to extend from each diagonal's middle line
    ; Outputs: Print all stripes of the shape to the display
    DrawCross proc
        ; Symb.Constants for function parameters
        Local pColor, pLength, ArgSize
            pColor  = [bp + 1*word + NEAR_BOUND]
            pLength = [bp + 0*word + NEAR_BOUND]
            ArgSize = 2*word
        SET_STACKFRAME
        PUSHLIST ax, bx, cx, dx
        Xor ax, ax               ; To index length from 0
        Mov cx, word ptr pLength
    ITER_DrawCross:
        Mov bx, VIDEO_HEIGHT-1
        Sub bx, ax              ; Mirrow length index from bottom side
        Mov dx, VIDEO_WIDTH-1
        Sub dx, ax              ; Mirror length index from right side

        Push word ptr pColor
        PUSHLIST 0, ax, bx, VIDEO_WIDTH-1
        Call Bresenham ; '\' diagonal's upper thickness [\*] with sweep from middle to top right corner

        Push word ptr pColor
        PUSHLIST VIDEO_HEIGHT-1, dx, ax, 0
        Call Bresenham ; '\' diagonal's lower thickness [.\] with sweep from middle to bottom left corner

        Push word ptr pColor
        PUSHLIST VIDEO_HEIGHT-1, ax, ax, VIDEO_WIDTH-1
        Call Bresenham ; '/' diagonal's lower thickness [/.] with sweep from middle to bottom right corner

        Push word ptr pColor
        PUSHLIST 0, dx, bx, 0
        Call Bresenham ; '/' diagonal's upper thickness [*/] with sweep from middle to top left corner

        Inc ax ; Advance distance from middle
        Dec cx
        Jcxz END_DrawCross
        Jmp ITER_DrawCross
    END_DrawCross:
        POPLIST ax, bx, cx, dx
        END_STACKFRAME ArgSize
    DrawCross endP

    ; Wrapper routine that draws the flag of Great Britain in graphic mode
    ; Inputs: n/a
    ; Outputs: Prints colors and shapes to the display to represent the flag
    GreatBritain proc
        PUSHLIST ax
        SET_GRAPHIC_MODE

        PUSHLIST COLOR_DARK_BLUE, 0, 0, VIDEO_WIDTH, VIDEO_HEIGHT
        Call DrawRect ; Blue background

        PUSHLIST COLOR_WHITE, 48
        Call DrawCross ; White X cross background

        PUSHLIST COLOR_DARK_RED, 24
        Call DrawCross ; Red X cross foreground

        ; White + cross
        PUSHLIST COLOR_WHITE, 0, 256, 128, VIDEO_HEIGHT
        Call DrawRect ; Vertical stripe 

        PUSHLIST COLOR_WHITE, 96*2, 0, VIDEO_WIDTH, 96
        Call DrawRect ; Horizontal stripe

        ; Red + cross
        PUSHLIST COLOR_DARK_RED, 0, 256+32, 64, VIDEO_HEIGHT
        Call DrawRect ; Vertical stripe

        PUSHLIST COLOR_DARK_RED, 96*2+24, 0, VIDEO_WIDTH, 48
        Call DrawRect ; Horizontal stripe

        Call StandBy
        SET_TEXT_MODE
        Mov programState, STATE_HALT
        POPLIST ax
        Ret
    GreatBritain endP

    ; Draws Chile's flag's white star to fit in a 120x120 space by drawing 4 triangles
    ; Inputs: n/a
    ; Outputs: Prints shapes to the display to represent the figure
    DrawStar proc
        PUSHLIST ax, bx, cx
        ; Draws an isosceles triangle from the top spike with width prior to the star's "legs"
        Mov ax, 60+30 ; Length from display bordar to the width prior to the legs
        Mov cx, 60    ; Width of the star prior to its legs
    ITER_DrawStar1:
        PUSHLIST COLOR_WHITE, 60, 120, 60+90, ax
        Call Bresenham
        Inc ax
        Loop ITER_DrawStar1

        ; Draws an upside down isosceles from the middle of the "legs" up to the height of the "arms"
        Mov ax, 60  ; Length from display border to the left arm's tip
        Mov cx, 120 ; Full width of the star
    ITER_DrawStar2:
        PUSHLIST COLOR_WHITE, 60+90, 120, 60+30+10, ax
        Call Bresenham
        Inc ax
        Loop ITER_DrawStar2
    
        ; Draws two triangles from the tip of each "leg" of the star up to their middle
        Mov ax, 60+30 ; Length from display bordar to the width prior to the legs
        Mov bx, 60+60 ; Length from display border to the middle of the legs
        Mov cx, 30
    ITER_DrawStar3:
        PUSHLIST COLOR_WHITE, 60+120, 60+20, 60+90, ax ; Draws from left tip
        Call Bresenham

        PUSHLIST COLOR_WHITE, 60+120, 60+100, 60+90, bx ; Draws from right tip
        Call Bresenham  
        Inc ax
        Inc bx
        Loop ITER_DrawStar3

        POPLIST ax, bx, cx
        Ret
    DrawStar endP

    ; Wrapper routine that draws the flag of Chile in graphic mode
    ; Inputs: n/a
    ; Outputs: Prints colors and shapes to the display to represent the flag
    Chile proc
        PUSHLIST ax, cx
        SET_GRAPHIC_MODE

        PUSHLIST COLOR_DARK_BLUE, 0, 0, VIDEO_HEIGHT/2, VIDEO_HEIGHT/2
        Call DrawRect ; Blue rectangle from top left side

        PUSHLIST COLOR_WHITE, 0, VIDEO_HEIGHT/2, VIDEO_WIDTH-(VIDEO_HEIGHT/2), VIDEO_HEIGHT/2
        Call DrawRect ; White rectangle from top right side

        PUSHLIST COLOR_DARK_RED, VIDEO_HEIGHT/2, 0, VIDEO_WIDTH, VIDEO_HEIGHT/2
        Call DrawRect ; Red stripe

        call DrawStar

        Call StandBy
        SET_TEXT_MODE
        Mov programState, STATE_HALT
        POPLIST ax, cx
        Ret
    Chile endP

    ; Shows the sunrays from Uruguay's flag by drawing multiple triangles
    ; Inputs: n/a
    ; Outputs: Print all shapes to the display
    DrawSunrays proc
        PUSHLIST ax, bx, cx, dx

        Mov ax, 102   ; To index each triangle's base
        Mov bx, COLOR_BROWN
        Mov dx, COLOR_YELLOW
        Mov cx, 18    ; Iter for half the triangle's base
    ITER_DrawSunrays: ; Draws isosceles triangles to represent sunrays
        PUSHLIST bx, 45, 88, 120, ax ; North NW sunray
        Call Bresenham
        PUSHLIST bx, 30, 120, 120, ax ; North sunray
        Call Bresenham
        PUSHLIST bx, 45, 152, 120, ax ; North NE sunray
        Call Bresenham
        PUSHLIST bx, 60, 185, 120, ax; North-east sunray
        Call Bresenham
        PUSHLIST bx, 90, 197, ax, 120  ; East NE sunray
        Call Bresenham
        PUSHLIST bx, 120, 210, ax, 120 ; East sunray
        Call Bresenham
        PUSHLIST bx, 150, 197, ax, 120  ; East SE sunray
        Call Bresenham
        PUSHLIST bx, 180, 185, ax, 120 ; South-east sunray
        Call Bresenham

        PUSHLIST dx, 195, 152, 120, ax ; South SE sunray
        Call Bresenham
        PUSHLIST dx, 210, 120, 120, ax ; South sunray
        Call Bresenham
        PUSHLIST dx, 195, 87, 120, ax ; South SW sunray
        Call Bresenham
        PUSHLIST dx, 180, 55, 120, ax ; South-west sunray
        Call Bresenham
        PUSHLIST dx, 150, 42, ax, 120 ; East SW sunray
        Call Bresenham
        PUSHLIST dx, 120, 30, ax, 120 ; West sunray
        Call Bresenham
        PUSHLIST dx, 90, 42, ax, 120 ; West NW sunray
        Call Bresenham
        PUSHLIST dx, 60, 55, ax, 120 ; North-west sunray
        Call Bresenham

        Inc ax ; Point to next index in base
        Dec cx
        Jcxz AUX_DrawSunrays
        Jmp ITER_DrawSunrays

    AUX_DrawSunrays:
        Cmp dx, COLOR_BROWN ; If colors have already been swapped, halt
        Je END_DrawSunrays
        Mov cx, 18  ; Otherwise, draw the remaining half of each triangle
        Xchg bx, dx ; with inverted colors to achieve a shade efect
        Jmp ITER_DrawSunrays

    END_DrawSunrays:
        POPLIST ax, bx, cx, dx
        Ret
    DrawSunrays endP

    ; Draws the sun from Uruguay's flag by drawing multiple circles
    ; Inputs: n/a
    ; Outputs: Print all shapes to the display
    DrawSun proc
        ; Background Circle
        PUSHLIST COLOR_BROWN, 120, 120, 38
        Call DrawCircle
        ; Foreground Circle
        PUSHLIST COLOR_YELLOW, 120, 120, 36
        Call DrawCircle
        
        ; Approximate face features by drawing overlapping circles
        ; Left eye
        PUSHLIST COLOR_BROWN, 114, 108, 6
        Call DrawCircle
        PUSHLIST COLOR_YELLOW, 119, 108, 8
        Call DrawCircle
        ; Left pupil
        PUSHLIST COLOR_BROWN, 112, 108, 2
        Call DrawCircle

        ; Right eye
        PUSHLIST COLOR_BROWN, 114, 132, 6
        Call DrawCircle
        PUSHLIST COLOR_YELLOW, 119, 132, 8
        Call DrawCircle
        ; Right pupil
        PUSHLIST COLOR_BROWN, 112, 132, 2
        Call DrawCircle

        ; Mouth
        PUSHLIST COLOR_BROWN, 129, 120, 8
        Call DrawCircle
        PUSHLIST COLOR_YELLOW, 126, 120, 9
        Call DrawCircle

        ; Nose
        PUSHLIST COLOR_BROWN, 125, 120, 4
        Call DrawCircle
        PUSHLIST COLOR_YELLOW, 122, 120, 4
        Call DrawCircle
        Ret
    DrawSun endP

    ; Wrapper routine that draws the flag of Uruguay in graphic mode
    ; Inputs: n/a
    ; Outputs: Prints colors and shapes to the display to represent the flag
    Uruguay proc
        PUSHLIST ax, bx, cx, dx
        SET_GRAPHIC_MODE

        Xor ax, ax ; To index row
        Mov cx, 9  ; Amount of stripes to draw
        Mov bx, COLOR_WHITE
        Mov dx, COLOR_DARK_BLUE
    ITER_UruguayBG:
        PUSHLIST bx, ax, 0, VIDEO_WIDTH, 53
        Call DrawRect
        Add ax, 53  ; Next stripe's first row
        Xchg bx, dx ; Swap active color
        Loop ITER_UruguayBG

        PUSHLIST dx, 53, 0, VIDEO_HEIGHT/2, 53*3
        Call DrawRect ; Set white square background for sun

        Call DrawSunrays
        Call DrawSun
        
        Call StandBy
        SET_TEXT_MODE
        Mov programState, STATE_HALT
        POPLIST ax, bx, cx, dx
        Ret
    Uruguay endP

    ; Draws the leaft from Canada's flag by drawing multiple shapes
    ; Inputs: n/a
    ; Outputs: Print all shapes to the display
    DrawLeaf proc
        PUSHLIST ax, bx, cx

        ; Draw the 3 spikes from the middle
        Mov ax, 270
        Mov cx, 100
    ITER_DrawLeaf1: ; Draws the central spike as an isosceles triangle
        PUSHLIST COLOR_DARK_RED, 120, 320, 255, ax
        Call Bresenham
        Inc ax
        Loop ITER_DrawLeaf1

        Mov ax, 160+130
        Mov cx, 60
    ITER_DrawLeaf2: ; Draws the left and right adjacent spikes as triangles
        PUSHLIST COLOR_DARK_RED, 140, 280, 120+80, ax
        Call Bresenham
        PUSHLIST COLOR_DARK_RED, 140, 360, 120+80, ax
        Call Bresenham
        Inc ax
        Loop ITER_DrawLeaf2

        ; Draws the both 3-angled spikes from the left and right side
        Mov ax, 160+70
        Mov cx, 180
    ITER_DrawLeaf3: ; Draws the middle spike from both sides
        PUSHLIST COLOR_DARK_RED, 180, 220, 230, ax
        Call Bresenham
        PUSHLIST COLOR_DARK_RED, 180, 420, 230, ax
        Call Bresenham
        Inc ax
        Loop ITER_DrawLeaf3

        Mov ax, 202
        Mov cx, 57
    ITER_DrawLeaf4: ; Draws the spike below the middle one from both sides
        PUSHLIST COLOR_DARK_RED, 230, 210, ax, 280
        Call Bresenham
        PUSHLIST COLOR_DARK_RED, 230, 430, ax, 360
        Call Bresenham
        Inc ax
        Loop ITER_DrawLeaf4

        Mov ax, 250
        Mov bx, 390
        Mov cx, 38
    ITER_DrawLeaf5: ; Draws the spike above the middle one from both sides
        PUSHLIST COLOR_DARK_RED, 170, 260, 200, ax
        Call Bresenham
        PUSHLIST COLOR_DARK_RED, 170, 380, 200, bx
        Call Bresenham
        Inc ax
        Dec bx
        Loop ITER_DrawLeaf5

        ; Draws the two spikes at the bottom of the leaf
        Mov ax, 270
        Mov bx, 370
        Mov cx, 100
    ITER_DrawLeaf6:
        PUSHLIST COLOR_DARK_RED, 280, 260, 255, ax
        Call Bresenham
        PUSHLIST COLOR_DARK_RED, 280, 380, 255, bx
        Call Bresenham
        Inc ax
        Dec bx
        Loop ITER_DrawLeaf6

        ; Draws the stem of the leaf
        PUSHLIST COLOR_DARK_RED, 255, 316, 8, 60
        Call DrawRect
        POPLIST ax, bx, cx
        Ret
    DrawLeaf endP

    ; Wrapper routine that draws the flag of Canada in graphic mode
    ; Inputs: n/a
    ; Outputs: Prints colors and shapes to the display to represent the flag
    Canada proc
        PUSHLIST ax
        SET_GRAPHIC_MODE

        PUSHLIST COLOR_DARK_RED, 0, 0, 160, VIDEO_HEIGHT
        Call DrawRect ; Red vertical left stripe

        PUSHLIST COLOR_WHITE, 0, 160, 160*2, VIDEO_HEIGHT
        Call DrawRect ; White vertical middle stripe

        PUSHLIST COLOR_DARK_RED, 0, 160*3, 160, VIDEO_HEIGHT
        Call DrawRect ; Red vertical right stripe

        call DrawLeaf

        Call StandBy
        SET_TEXT_MODE
        Mov programState, STATE_HALT
        POPLIST ax
        Ret
    Canada endP

    ; Wrapper routine that draws a custom flag before printing the AboutMe info
    ; Inputs: n/a
    ; Outputs: Prints colors, shapes, and text to the display
    AboutMe proc
        PUSHLIST si, ax, bx, cx, dx
        SET_GRAPHIC_MODE

        ; Prints 7 colored columns simultaneously from top to bottom
        Xor ax, ax             ; To index the current row being drawn
        Mov cx, CHAR_HEIGHT*18 ; Iters up to a text mode based length to leave space for text
    ITER_AboutMe1:
        Mov dx, COLOR_WHITE    ; Set starting color
        Xor bx, bx             ; To index column being drawn
        PUSHLIST ax, cx        ; Save values from outer loop before setting inner loop
        Mov cx, 7              ; Iter for each color rotation
    ITER_AboutMe2:
        PUSHLIST dx, ax, bx, 94, GO_RIGHT
        Call DrawLine   ; Print a horizontal line of one color
        Dec dx          ; Change active color
        Add bx, 91      ; Offset to next col, slight overlap to ensure each line has similar length
        Loop ITER_AboutMe2
        POPLIST ax, cx
        Inc ax          ; Next row
        Loop ITER_AboutMe1

        Mov bx, COLOR_WHITE
        Mov cx, 7

        PUSHLIST COLOR_LIGHT_GREY, CHAR_HEIGHT*18, 0, CHAR_WIDTH*80, CHAR_HEIGHT*12
        Call DrawRect ; Print grey background to serve as a frame

        PUSHLIST COLOR_DARK_GREY, (CHAR_HEIGHT*18)+10, 4, (CHAR_WIDTH*78)+(4*2), (CHAR_HEIGHT*10)+(6*2)
        Call DrawRect ; Print dark grey foreground to give depth to frame

        PUSHLIST COLOR_BLACK, (CHAR_HEIGHT*18)+16, CHAR_WIDTH, CHAR_WIDTH*78, CHAR_HEIGHT*10
        Call DrawRect ; Print black foreground to serve as a screen for text

        ; Displays each line in the designated area with centered text
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
        SET_TEXT_MODE
        Mov programState, STATE_HALT
        POPLIST si, ax, bx, cx, dx
        Ret
    AboutMe endP

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