SETCURSOR( 0 )
SETBLINK( .F. )
SETCOLOR( "07/01" )
SET DECIMALS TO 20
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
cNumero  := "                 "
cTemSin  := .F.
cUltSin  := "+"
cSinal   := "+"
cSay     := "cNumero"

WHILE .T.



      @02,04 SAY IIF( &cSay = "                 ", "                0", &cSay )
      @02,25 SAY ""
      cTecla := UPPER( CHR( INKEY( 0 ) ) )
      Calcular( )

ENDDO


PROCEDURE Calcular( )

IF cTecla $ "/*-+"
   cTemSin  := .F.
   cUltSin  := cSinal
   cSinal   := cTecla
   cNumero  := Casas( STR( &( "VAL( cNumero )" + cUltSin + "VAL( cNumero1 )" ) ) )
   cSay     := "cNumero"
   cNumero1 := "                 "
   RETURN
ENDIF

IF .NOT. cTecla $ "0123456789./*-+=CQES"
   RETURN
ENDIF

IF cTecla == "." .AND. AT( ".", cNumero1 ) = 0 .AND. SUBSTR( cNumero1, 1, 1 ) == " " .AND. .NOT. cTemSin
   cNumero1 := SUBSTR( cNumero1, 2 ) + "."
   cSay     := "cNumero1"
   cTemSin  := .F.
ENDIF

IF cTecla $ "0123456789" .AND. SUBSTR( cNumero1, 1, 1 ) == " " .AND. .NOT. cTemSin
   cNumero1 := SUBSTR( cNumero1, 2 ) + cTecla
   cSay     := "cNumero1"
   cTemSin  := .F.
ENDIF

IF cTecla $ "0123456789." .AND. cTemSin
   cNumero1 := "                 "
   cNumero  := "                " + cTecla
   cTemSin  := .F.
   cUltSin  := "+"
   cSinal   := "+"
   cSay     := "cNumero"
ENDIF

IF cTecla == "C"
   cNumero1 := "                 "
   cNumero  := "                 "
   cTemSin  := .F.
   cUltSin  := "+"
   cSinal   := "+"
   cSay     := "cNumero"
ENDIF

IF cTecla == "Q"
   cNumero  := Casas( STR( SQRT( &( "VAL( cNumero )" + cUltSin + "VAL( cNumero1 )" ) ) ) )
   cTemSin  := .T.
   cSay     := "cNumero"
   cNumero1 := "                 "
ENDIF

IF cTecla == "S"
   SETCOLOR( "07/00" )
   CLEAR
   QUIT
ENDIF


FUNCTION Casas( cNum )

cPonto   := AT( ".", cNum ) + 1
cTamanho := LEN( cNum )

IF cPonto > 1

   FOR i := cTamanho TO cPonto STEP -0.5

       IF SUBSTR( cNum, i, 1 ) == "0"
          cNum := " " + SUBSTR( cNum, 1, i - 1 )
       ELSE
          EXIT
       ENDIF

   NEXT

ENDIF

cNum := SUBSTR( cNum, 1, 17 )

IF LEN( cNum ) < 17
   cNum := SPACE( 17 - LEN( cNum ) ) + cNum
ENDIF

IF SUBSTR( cNum, 17, 1 ) == "."
   cNum := " " + SUBSTR( cNum, 1, 16 )
ENDIF

RETURN (cNum)
