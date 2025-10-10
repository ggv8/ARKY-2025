; Documentacion
    ; ╔═════════════════════════════════════╦═══════════════════════════════════╗
    ; ║ Instituto Tecnologico de Costa Rica ║ Gabriel Gomez Vega                ║
    ; ║ Escuela de Computacion              ║ 2021106483                        ║
    ; ║ Arquitectura de Computadoras        ║ 02 de Octubre del 2025            ║
    ; ╚═════════════════════════════════════╩═══════════════════════════════════╝
    ; ╔═════════════════════════════════════════════════════════════════════════╗
    ; ║                            Manual de Usuario                            ║
    ; ╠═════════════════════════════════════════════════════════════════════════╣
    ; ║ Este programa imprime a la salida estándar una matriz de celdas en las  ║
    ; ║ que una hormiga de Langton va a alterar. Primero se imprime el estado   ║
    ; ║ inicial del mapa y luego el estado final tras la jornada de la hormiga. ║
    ; ║ El mapa o patrón inicial tiene un diseño arbitrario para que se muestre ║
    ; ║ un comportamiento variado de la hormiga.                                ║
    ; ║                                                                         ║
    ; ║ El objetivo del programa es demostrar un ejemplo particular de este mo- ║
    ; ║ delo computacional. No solicita entradas al usuario para preservar las  ║
    ; ║ condiciones iniciales alambradas del ejemplo.                           ║
    ; ║                                                                         ║
    ; ║ Para visualizar la salida del programa, debe redirigir la con el opera- ║
    ; ║ dor > tras invocar el programa. Seguido de él, debe indicar el nombre   ║
    ; ║ de archivo y su extensión .txt                                          ║
    ; ║                                                                         ║
    ; ║ El programa enmarca la salida de la matriz para facilitar su distinción ║
    ; ║ visual. Para ello utiliza el caracter '#'. Las celdas en blanco se re-  ║
    ; ║ presentan con un espacio en blanco ' ' y las celdas en negro con un as- ║
    ; ║ terisco.                                                                ║
    ; ║                                                                         ║
    ; ╚═════════════════════════════════════════════════════════════════════════╝
    ; ╔═════════════════════════════════════════════════════════════════════════╗
    ; ║                        Analisis de Resultados                           ║
    ; ╠══════════════════════════════════════════════════════════╦══════════════╣
    ; ║                          Aspectos                        ║ Calificacion ║
    ; ╠══════════════════════════════════════════════════════════╬══════════════╣
    ; ║ Documentacion (Portada, manual, análisis, código)        ║      A       ║
    ; ╠══════════════════════════════════════════════════════════╬══════════════╣
    ; ║ Despliegue del acerca de                                 ║      A       ║
    ; ╠══════════════════════════════════════════════════════════╬══════════════╣
    ; ║ Diseño de la matriz 200x200                              ║      A       ║
    ; ╠══════════════════════════════════════════════════════════╬══════════════╣
    ; ║ Movimiento de la hormiga (posición y orientación)        ║      A       ║
    ; ╠══════════════════════════════════════════════════════════╬══════════════╣
    ; ║ Procesamiento de celdas (negro a blanco y viceversa)     ║      A       ║
    ; ╠══════════════════════════════════════════════════════════╬══════════════╣
    ; ║ Ejecución de los N pasos de la hormiga                   ║      A       ║
    ; ╠══════════════════════════════════════════════════════════╬══════════════╣
    ; ║ Despliegue de la matriz inicial a salida estándar        ║      A       ║
    ; ╠══════════════════════════════════════════════════════════╬══════════════╣
    ; ║ Despliegue de la matriz resultante a salida estándar     ║      A       ║
    ; ╠══════════════════════════════════════════════════════════╬══════════════╣
    ; ║ Recomendación del tamaño de la matriz                    ║      A       ║
    ; ╚══════════════════════════════════════════════════════════╩══════════════╝

    ; ╔═════════════════════════════════════════════════════════════════════════╗
    ; ║                    Sobre el tamaño del ejercicio                        ║
    ; ╚═════════════════════════════════════════════════════════════════════════╝
    ; Yo considero que el tamaño dado fue adecuado para el ejercicio a este punto
    ; del curso. Si fue un proceso algo lento el diseñar un patrón con ese tamaño,
    ; pero tampoco diria que consumió un tiempo excesivo comparado al tiempo de
    ; programación. El que haya bastante espacio es bueno para ver que tantos pa-
    ; sos le toma a la hormiga hacer la avenida, en especial si se espera que
    ; los estudiantes tengan patrones únicos.
;

DataSegment segment
; Symbolic Constants

    ; Interruptions
        DOS_INPUT_CHAR  = 01h
        DOS_PRINT_CHAR  = 02h
        DOS_PRINT_STR   = 09h
        DOS_EXIT        = 4Ch
    ;

    ; ASCII 
        CHAR_NULL   = 00h
        CHAR_CR     = 0Dh
        CHAR_LF     = 0Ah
        CHAR_HTAB   = 09h
        CHAR_WHITE  = ' '
        CHAR_BLACK  = '*'
        CHAR_BORDER = '#'
    ;

    ; Misc
        PSP_INPUT_OFFSET = 80h

        MATRIX_SIZE = 200
        ; Vector table constants
        ENTRY_SIZE    =  2*word
        TABLE_SIZE    =  4*ENTRY_SIZE
        MOVE_FORWARD  =  1
        MOVE_BACKWARD = -1
        NO_MOVEMENT   =  0
    ;
;

; String literals
    aboutMe db "ITCR: Escuela de Computacion - Arquitectura de Computadoras. 02/Oct/2025", CHAR_CR, CHAR_LF
            db "Clases: Hormiga de Langton | Autor: Gabriel Gomez Vega, 2021106483", CHAR_NULL
    helpMe  db "Debe ingresar los siguientes datos:", CHAR_CR, CHAR_LF
            db CHAR_HTAB, "{parametro}: {explicacion}", CHAR_CR, CHAR_LF
    errorLabel db "Error: ", CHAR_NULL
    errorNoState  db "El programa ha generado un error inesperado.", CHAR_NULL
;

    ; Vectors to apply at current position (Col, Row)
    movementTable dw NO_MOVEMENT, MOVE_BACKWARD ; UP
                  dw MOVE_FORWARD, NO_MOVEMENT  ; RIGHT
                  dw NO_MOVEMENT, MOVE_FORWARD  ; DOWN
                  dw MOVE_BACKWARD, NO_MOVEMENT ; LEFT
    

    steps dw 0FFFFh
    antDirection dw 00h    ; Index to movement table
    antPosition dw 97, 20 ; Row, column
    ; Meaningful positions to test
    ; (69,33), (100,100), (97,20)

    langtonMap  db 15 dup(MATRIX_SIZE dup(CHAR_WHITE))
                db "                                                                             **************************************************                                                                         "
                db "                                                                                                    *    **    *               *                                                                        "
                db "                                                                                                   *  *                        **                                                                       "
                db "                                                                                                        *                        *                                                                      "
                db "                                                                                          *   * *         *                      **                                                                     "
                db "                                                                                          * *              *                       *                                                                    "
                db "                                                                                          *                 *      ***             **                                                                   "
                db "                                                                                        **                    *                      *                                                                  "
                db "                                                                                     *  *                      * *                   **                                                                 "
                db "                            ***************                                       *    *                                                                                                                "
                db "                                                                             *   *                                                      **                                                              "
                db "                                             *                              * * *                                                         *                                                             "
                db "                                       *   *                               *                                                               *                                                            "
                db "                               *    *   * *                               *                                                                 *                                                           "
                db "                                 * *    ** *                             *                                                                                                                              "
                db "                               *             *                         *                                                                     *                                                          "
                db "                                               *                     *                                                                        *                                                         "
                db "                               **                *                 *                                                                          *                                                         "
                db "                          *  *                     *             *                                                                                                                                      "
                db "                        *  *                         *  **                                              *                                   * *                                                         "
                db "                   *  *                                  **     *                                                                            *                                                          "
                db "                  *  *                                    **    *                                                   *                        *                                                          "
                db "                 *                                         ******                                                                             *                                                         "
                db "                                                            **                             *                    *                              * *                                                      "
                db "                **                                           **                                                                                                                                         "
                db "                  *                                           **                                                                                *                                                       "
                db "                   *                                           **                                                                                                                                       "
                db "                    *                                                                                                                            *                                                      "
                db "                                                                                                                                                   *                                                    "
                db "                                                                                                                                                    *                                                   "
                db "                                                                                                                                                                                                        "
                db "                               ***                                                                                                                 ****                                                 "
                db "                              ***                                                                                                                      ***                                              "
                db "                        *    ***                                                                                                                         **                                             "
                db "                       *     ***                                                                                                                           *                                            "
                db "                   ** *     ***                ** *                                             *                              *                            *                                           "
                db "                  *        ***                                                                           ****                                                *                                          "
                db "                  *        ***                                                                          ****                                                  *                                         "
                db "                  *        ***                      *                                                  ****                                                                                             "
                db "                *          ***                       *                                                 ****                                                    *                                        "
                db "              * *           ***                        *                                              ****                                 *                    *                                       "
                db "            *                ***                                                                      ****                                                       *                                      "
                db "          *                  ***                                                                     ****                                                                                               "
                db "        *                     ***                                                                    ****                   *                                     *                                     "
                db "       *                       ***                                                                  ****                                                           *                                    "
                db "                                ***                                                                ****                                                             *                                   "
                db "                                 ***                                   *                          **********                                                                                            "
                db "         *                         ***                                                           ****       *                                                        *                                  "
                db "         *                           ***                                                        ****         *          **                                           *                                  "
                db "         **                            ***                                                    ****             *      *   *                                         **                                  "
                db "           *                             ***                                                ****                 *    *                                                                                 "
                db "           **                               ***                        *                  ****                    *****               *        *                        *                               "
                db "            *                                ****                                       ****                   * * **                                                   *                               "
                db "                                            ***                                       ****                   *      *                                                    *                              "
                db "              *                           ***                                      ****                    **         ** *                                           *                                  "
                db "              **                       ****                                     ****                                      *                                        *    *                               "
                db "                *                    ***                                     ****                                                                                 *                                     "
                db "                *                 ***                   *                 ****                                                                                   *                                      "
                db "              *                 ***                                    ****  ***                                            ***                                 *                                       "
                db "            *                  ***                                 ****         *                                               *                          **  *                                        "
                db "            *                 ***                              ****                                                               * **                 *  *  **                                         "
                db "            *                  ****                        ****                  *                                                  *                   **                                              "
                db "            *                     ***                   ****                      *                                                 ********          *                                                 "
                db "                                    **               ****                          ******                                   ********  *              *                                                  "
                db "               *                  ***             ****                                ***                             ******           *            *                                                   "
                db "                                 ***           ****                                     **   * **                                       *          *                                                    "
                db "               *               ***           ****                                         *       *                                       *     ***                                                     "
                db "               **               **         ****                                           **  *    **                                       * *                                                         "
                db "                *          **   **       ****                                               * *                                                **                                                       "
                db "                *       ***  *****    ***                                                                                                      *                                                        "
                db "              **                  ****                                                                                                         *                                                        "
                db "               ***             ***                                                                                                             * **                                                     "
                db "             *   **              * ****                                                                                *                           *                                                    "
                db "          * *     **              *   *                                                                                          *                 *                                                    "
                db "         *                           ***                                                                                     * *                   *                                                    "
                db "        *                         ***                                                                                        *                     *                                                    "
                db "         *                     ***                                                                  *                                                *                                                  "
                db "                            ***                                                                      * *                                              *                                                 "
                db "      *                       ****                                      **********                         * *                                          **                                              "
                db "      *                     **                                                    * **                  * *    *                                                                                        "
                db "       *                      **                                                                                *                                       *                                               "
                db "                                **                                                                              *                            *          *                                               "
                db "         * *                      *                      * **  * *******                                                                     *          *                                               "
                db "                                   *                     *     *                  *                                                          *          *                                               "
                db "           *                       *                    *     *                         *                                                  * * *       *                                                "
                db "            * *                    *                    *                                 *                                               *   * *        *                                              "
                db "                ***                *                  ***                               *  * *                       *                   *   *   *****     *                                            "
                db "              *** ***        ****  *                                                   **                                              **   *      ****     *                                           "
                db "             ***    ***     **  ****                                                    **                                           ***   *          *                                                 "
                db "            ***       **  **      ***                                                   *                                           *  ****           *     *                                           "
                db "            **          ***                                                       ********                                         *     **            *     *                                          "
                db "            **                                                       ***************                                            ***     **                 *   *                                        "
                db "            **                                *                                                                                        *  *             * *                                             "
                db "            **           **                                                                                                          *    ******                                                        "
                db "            ***                                                                                                                   * *       *                                                           "
                db "              ***        **                                          *                                                            *         ******        *                                             "
                db "                            ********                                                           ***                             ****               ***                                                   "
                db "          ******         **                                                                                               *******                           **                                          "
                db "                                                                                                                        ********                               *                                        "
                db "                                                 *                                                                         ***********                           *                                      "
                db "                                                                                                                         **********                               *                                     "
                db "              **                                                                                                        **********                                                                      "
                db "                                                                                                                        ********                                   * *                                  "
                db "                                                                                               ***                    *********                                        *                                "
                db "                *                                *****************************                                       *********                                          *                               "
                db "                                                               ****                                                 *********                                                                           "
                db "             *                 **                                  *                                              *********                                                *                            "
                db "                               *                                ***                                             *********                                                   *                           "
                db "                             **                               ****                                           *********                                                        *                         "
                db "              ***            *                                    ****                                    *********                                                                                     "
                db "                ****       **                                   **                                      ********                                                                                        "
                db "                    ***                                        ***                                    ********                                                        * *                               "
                db "                       ***                                 ***********************************      ********                                                      * *                                   "
                db "                          ***                            **                                       ********                                                                                              "
                db "                             ***                       ***                                      *******                                                           *                                     "
                db "                               **               *******                                       *******                                                             *                                     "
                db "                 *****                             ***                                      ******                                                                *                                     "
                db "                     ****                           ***                                   ******                                                                  * * *                                 "
                db "                                                  **                                    ******                                                              * * *      *                                "
                db "                                                   *                                   ******                                                              *            *                               "
                db "                ****                               *                                  *****                  ***     * **                                  *              *                             "
                db "             ****                                  *                                 *****                       ***                                      **                                            "
                db "        ****                                        *                               ****                              * *                     **     *   *                  * *                         "
                db "                                                     *                             ****                              *   *                 *        *  *                         ***                    "
                db "            ****                                      *                           ****                             *       **            *      *                               *   *                   "
                db "                ***                                    *                        ****                             ***      **            *        * *          *                     *                   "
                db "                   ****                                 ***                   ****                                            *                   *            *                                        "
                db "                       ***                                 ***             *****                                               *                                 *                   *                  "
                db "                          **                                ******     *****   **                                                                                  *                  *                 "
                db "                       *    *                           ****      *****          **                                              *                                                 *                    "
                db "                      *      *                         *                           *                                             *                                  *             *                     "
                db "                    **        *                       *                             ***                                            *                                  *        **                       "
                db "                  ***          *                                                                                                   *                                 *       *     *                    "
                db "                ***             *                    *                                 *                                           *                                 *     *    *  *                    "
                db "             *****               *               ****                                   *                                                                          *   * *      * **                    "
                db "           *****                  ***           *                                                                                                                              *                        "
                db "         ***                         *         *                                         *                                            *                          *            *                         "
                db "        **                            *       *                   *                                                                     *                                   *                           "
                db "       **                              *     *                * *  *                      *                                                                                *                            "
                db "         **                             *****                       *                                                                   *                                  *                            "
                db "           **                                                *       ***                   *                                          * *                                    *                          "
                db "       ***  **                                                                               *** *                                  *                                        *                          "
                db "          *** ***                                           *           *                          *                              *                                         *                           "
                db "             *****                                       **              *                         *                         ****                                         *                             "
                db "                 *                             * * **  *                                                                    *                                        **   *                             "
                db "                  *           ***                    *                    * **       *                                    **                                            * *                             "
                db "                   *             *            *                                **  *  *                                  *                                                                              "
                db "                    *      ****   *        *** *                                      *                                 *                                                *                              "
                db "                         ****              ****                                         **                            *                                                  *                              "
                db "                    *****          ** ** *                                                *      *                    *                                                 *                               "
                db "                     *               *                                                    *     *                                                                                                       "
                db "                  ***                                                                       * *       ********        *                                               **                                "
                db "                 *                                                                                             ******                                                 *                                 "
                db "                   *                                                                                                ****    *                                         *                                 "
                db "                  ****                                                                                                  ***                                          *                                  "
                db "               ***                                                                                                         *                                     * *                                    "
                db "              *****                                                                                                     ****                                  * *                                       "
                db "                                                                                                                       **                                     *                                         "
                db "             *                                                                                                              ***                               *                                         "
                db "            *                                                                                                              *                             *    *                                         "
                db "          **                                                                                                                   *                       *  * ***                                         "
                db "        ***************                                                             ***********                                *                               *                                        "
                db "             *******************                                          *********             ***                              *                    *        **                                       "
                db "                         *****************                              *                          *                             **                  *            *                                     "
                db "                          ***      **************                  ****                             *                                                             **                                    "
                db "                          ***                *********          * *                                  *                         **                                  *                                    "
                db "                          ***                        ****       ***                                                         * *                                                                         "
                db "                        ***                             *********                                     *           * *******                                       *                                     "
                db "                                                                                                       ***********      * * *                                   *                                       "
                db "                                                                                                                              *                        *      *                                         "
                db "                         *       * **      **                                                                                  *                      *  *  **                                          "
                db "                       *   *              *  **                                                                                                            *                                            "
                db "                      *      * *      * *      ***                                                                              * *                  *                                                  "
                db "                 ** *                             *                                                                                 *       *       *                                                   "
                db "                                                   * *                                                                                *   **  * * **                                                    "
                db "                                                       *                                                                                *                                                               "
                db 9 dup(MATRIX_SIZE dup(CHAR_WHITE))

DataSegment endS

StackSegment segment stack 'stack'
   dw 256 dup(?)
StackSegment endS

CodeSegment segment
    Assume CS:CodeSegment, DS:DataSegment, SS:StackSegment

    ; Applies a movement vector to the ant's position. Loops around map if out of bounds
    ; Inputs:  [BX] - Address of vector to apply
    ; Outputs: [antPosition] - New ant position within bounds
    UpdatePosition proc
        Push ax
        Push cx

        Mov cx, MATRIX_SIZE                     ; For modulo operation

        Mov ax, antPosition[0]                  ; Retrieve current row
        Add ax, word ptr movementTable[bx+word] ; Obtain new row position
        Jns AUX_RowModulo                       ; Skip underflow correction logic
        Add ax, cx                              ; Row=-1, wrap around matrix at Row=199

    AUX_RowModulo:
        Div cl
        Shr ax, 8                           ; Remainder (AH) to AL, and clear AH
        Mov antPosition[0], ax              ; Save new row

        Mov ax, antPosition[word]          ; Current column
        Add ax, word ptr movementTable[bx] ; New position
        Jns AUX_ColumnModulo                    ; Skip underflow correction logic
        Add ax, cx                              ; Col=-1, wrap around matrix at Col=199

    AUX_ColumnModulo:
        Div cl
        Shr ax, 8                          ; Same as above
        Mov antPosition[word], ax

        Pop cx
        Pop ax
        Ret
    UpdatePosition endP

    ; Changes ant's current direction to the right, and updates its position
    ; Inputs:   [antPosition]  = Valid position within langtonMap boundaries
    ;           [antDirection] = Index to movementTable
    ;
    ; Outputs:  [antPosition]  = New position in langtonMap
    ;           [antDirection] = New direction
    TurnRight proc
        Push bx

        Mov bx, antDirection
        Add bx, ENTRY_SIZE ; Point to next vector entry: UP > RIGHT > DOWN > LEFT > out of bounds  
        Cmp bx, TABLE_SIZE ; Skip correction logic if within bounds
        Jb END_TurnRight
        Xor bx, bx         ; Set offset to first entry: out of bounds > UP

    END_TurnRight:
        Call UpdatePosition
        Mov antDirection, bx

        Pop bx
        Ret
    TurnRight endP

    ; Changes ant's current direction to the left, and updates its position
    ; Inputs:   [antPosition]  = Valid position within langtonMap boundaries
    ;           [antDirection] = Index to movementTable
    ;
    ; Outputs:  [antPosition]  = New position in langtonMap
    ;           [antDirection] = New direction
    TurnLeft proc
        Push bx

        Mov bx, antDirection
        
        Sub bx, ENTRY_SIZE ; Point to prev vector entry: Out of bounds < UP < RIGHT < DOWN < LEFT
        Jns END_TurnLeft   ; Skip correction logic if within bounds
        Mov bx, (TABLE_SIZE-ENTRY_SIZE) ; Set offset to last entry: LEFT < out of bounds

    END_TurnLeft:
        Call UpdatePosition
        Mov antDirection, bx

        Pop bx
        Ret
    TurnLeft endP

    ; Prints a horizontal border to delimit the top or bottom of the matrix
    ; Inputs: n/a
    ; Outputs: Sends as many border chars as there are columns + 2 additional ones to the std output
    PrintHorizontalBorder proc
        Push ax
        Push cx
        Push dx

        Xor al, al
        Mov ah, DOS_PRINT_CHAR
        Mov cx, MATRIX_SIZE+2
        Mov dl, CHAR_BORDER
    ITER_PrintHorizontalBorder:
        Int 21h
        Loop ITER_PrintHorizontalBorder
        Call PrintCRLF

        Pop dx
        Pop cx
        Pop ax
        Ret
    PrintHorizontalBorder endP

    ; Prints a row of the langtonMap
    ; Inputs: [SI] - Address to the start of a row in the map
    ; Outputs: Sends each byte's char representation to the standard output
    PrintRow proc
        Push ax
        Push cx
        Push dx
        Push si

        Xor dh, dh
        Xor al, al
        Mov ah, DOS_PRINT_CHAR
        Mov cx, MATRIX_SIZE

        Mov dl, CHAR_BORDER ; Precede row contents with a delimiter
        Int 21h
    ITER_PrintRow:
        Mov dl, byte ptr [si] ; Retrieve column data
        Int 21h               ; Request print to std output
        Inc si                ; Point to next column
        Loop ITER_PrintRow

        Mov dl, CHAR_BORDER ; End row with delimiter and newline
        Int 21h
        Call PrintCRLF

        Pop si
        Pop dx
        Pop cx
        Pop ax
        Ret
    PrintRow endP

    ; Prints the langtonMap matrix
    ; Inputs: n/a
    ; Outputs: Sends each row representation to the standard output
    PrintMap proc
        Push cx
        Push si

        Call PrintHorizontalBorder ; Map header
        Mov si, offset langtonMap
        Mov cx, MATRIX_SIZE
    ITER_PrintMap:
        Call PrintRow
        Add si, MATRIX_SIZE
        Loop ITER_PrintMap

        Call PrintHorizontalBorder ; Map footer
        Pop si
        Pop cx
        Ret
    PrintMap endP

    ; Make langton's ant move around the map up to a specified amount
    ; Inputs: Cx - Amount of steps the ant will take
    ; Outputs: [langtonMap] - Swaps tile contents traversed by ant
    MoveAnt proc
        Push ax
        Push bx
        Push si

    ITER_MoveAnt:
        Mov ax, MATRIX_SIZE             ; Offset for row calculation
        Mov bx, word ptr antPosition[0] ; Retrieve row. Value in range 0-200, fits in BL

        Mul bl      ; Obtain offset to current row
        Mov si, ax  ; Set as base address

        Mov bx, word ptr antPosition[word] ; Retrieve column
        Mov al, byte ptr langtonMap[si+bx] ; Use it as byte offset to index specific tile

        Cmp al, CHAR_WHITE ; If ant is in a black tile, handle accordingly
        Jne CASE_BlackTile

        Mov byte ptr langtonMap[si+bx], CHAR_BLACK ; Otherwise, swap tile with black
        Call TurnLeft                             ; and move after turning right
        Loop ITER_MoveAnt
        Jmp END_MoveAnt                            ; Skip other case when loop is over
    
    CASE_BlackTile:
        Mov byte ptr langtonMap[si+bx], CHAR_WHITE ; Swap tile with white
        Call TurnRight                             ; moves after turning left
        Loop ITER_MoveAnt


    END_MoveAnt:
        Pop si
        Pop bx
        Pop ax
        Ret
    MoveAnt endP

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

    main:
        Mov ax, ds
        Mov es, ax ; Save PSP's address

        Mov ax, StackSegment
        Mov ss, ax ; Set stack's address

        Mov ax, DataSegment
        Mov ds, ax ; Set data's address

        Call PrintAboutMe

        Call PrintMap
        Call PrintCRLF

        Mov cx, steps
        Call MoveAnt

        Call PrintMap
        Call PrintCRLF

    exit:
        Mov al, 00h
        Mov ah, 4Ch
        Int 21h


CodeSegment endS

end main