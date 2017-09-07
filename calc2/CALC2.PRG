SETCURSOR( 0 )
SETBLINK( .F. )
SETCOLOR( "07/01" )
SET DECIMALS TO 2
CLEAR

SETCOLOR( "08/00" )
@02,04 CLEAR TO 12,24

SETCOLOR( "00/15" )

@01,02 SAY "┌───────────────────┐"
@02,02 SAY "│                   │"
@03,02 SAY "├───┬───┬───┬───┬───┤"
@04,02 SAY "│ 7 │ 8 │ 9 │ / │ C │"
@05,02 SAY "├───┼───┼───┼───┼───┤"
@06,02 SAY "│ 4 │ 5 │ 6 │ * │ Q │"
@07,02 SAY "├───┼───┼───┼───┼───┤"
@08,02 SAY "│ 1 │ 2 │ 3 │ - │ E │"
@09,02 SAY "├───┼───┼───┼───┼───┤"
@10,02 SAY "│ 0 │ . │ = │ + │ S │"
@11,02 SAY "└───┴───┴───┴───┴───┘"

SETCOLOR( "15/04" )
@02,04 SAY "                 "

cNumero1 := "                 "
cNumero2 := "                 "
cSinal   := " "
cSinal_t := " "
cProcedu := "Numero1"

WHILE .T.

IF &( "c" + cProcedu ) <> "                 "
   @02,04 SAY &( "c" + cProcedu )
ENDIF

      @02,25 SAY ""
      cTecla := UPPER( CHR( INKEY( 0 ) ) )
      DO &cProcedu

ENDDO


PROCEDURE Numero1( )

@02,04 SAY cNumero1
cNumero2 := "                 "

WHILE .T.

      IF .NOT. cTecla $ "0123456789/*-+=.CQES"
         EXIT
      ENDIF

      IF cTecla $ "0123456789" .AND. SUBSTR( cNumero1, 1, 1 ) = " "

         PUBLIC cSinal_t := cSinal
         PUBLIC cSinal   := " "
         cNumero1        := SUBSTR( cNumero1, 2, 17 ) + cTecla
         cProcedu        := "Numero1"
         RETURN

      ENDIF

      IF cTecla == "." .AND. SUBSTR( cNumero1, 1, 1 ) = " " .AND. AT( ".", cNumero1 ) = 0

         cNumero1 := SUBSTR( cNumero1, 2, 17 ) + "."
         cProcedu := "Numero1"
         RETURN

      ENDIF

      IF cTecla $ "+-*/" .AND. cNumero1 <> "                 " .AND. cSinal = " "

         cProcedu      := "Numero2"
         PUBLIC cSinal := cTecla
         RETURN

      ENDIF


      IF cTecla = "Q"

         cProcedu := "Numero1"
         cNumero1 := STR( SQRT( VAL( cNumero1 ) ), 17, 2 )
         RETURN

      ENDIF

      IF cTecla == "S"

         SETCURSOR( 1 )
         SETCOLOR( "07/00" )
         CLEAR
         QUIT

       ENDIF

       EXIT

ENDDO


PROCEDURE Numero2( )

cTemp    := cNumero1 + cSinal_t + cNumero2

IF cNumero2 <> "                 "
   @02,04 SAY cNumero2
ENDIF

WHILE .T.

      IF .NOT. cTecla $ "0123456789/*-+=.CQES"
         EXIT
      ENDIF

      IF cTecla $ "0123456789" .AND. SUBSTR( cNumero2, 1, 1 ) = " "

         PUBLIC cSinal_t := cSinal
         PUBLIC cSinal   := " "
         cNumero2        := SUBSTR( cNumero2, 2, 17 ) + cTecla
         cProcedu        := "Numero2"
         RETURN

      ELSEIF .NOT. cTecla $ "0123456789."

         cProcedu := "Numero1"

      ENDIF

      IF cTecla == "." .AND. SUBSTR( cNumero2, 1, 1 ) = " " .AND. AT( ".", cNumero2 ) = 0

         cNumero2 := SUBSTR( cNumero2, 2, 17 ) + "."
         cProcedu := "Numero2"
         RETURN

      ENDIF

      IF cTecla $ "+-*/" .AND. cNumero2 <> "                 " .AND. cSinal = " "

         cTemp           := cNumero1 + cTecla + cNumero2
         cProcedu        := "Numero1"
         cNumero1        := STR( &cTemp, 17, 2 )
         PUBLIC cSinal_T := cSinal
         PUBLIC cSinal   := " "
         KEYBOARD cTecla
         RETURN

      ENDIF

      IF cTecla == "=" .AND. cNumero2 <> "                 "

         cTemp           := cNumero1 + cSinal_t + cNumero2
         cProcedu        := "Numero1"
         cNumero1        := STR( &cTemp, 17, 2 )
         PUBLIC cSinal   := " "
         RETURN

      ENDIF

      IF cTecla = "Q"

         cProcedu := "Numero1"
         cNumero1 := STR( SQRT( VAL( STR( &cTemp, 17, 2 ) ) ), 17, 2 )
         RETURN

      ENDIF

      IF cTecla == "S"

         SETCURSOR( 1 )
         SETCOLOR( "07/00" )
         CLEAR
         QUIT

       ENDIF

       EXIT

ENDDO
