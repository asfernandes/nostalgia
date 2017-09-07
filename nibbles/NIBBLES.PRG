#include "inkey.ch"

#define CBORDA  "12"
#define CCORPO1 "14"
#define CCORPO2 "13"
#define CFUNDO  "01"
#define CNUMERO "14"
#define CPAUSA  "15/04"
#define CTITULO "15"

#define CORPO1  1
#define CORPO2  2
#define BORDA   3
#define NUMBER  4

#define UP      1
#define RIGHT   2
#define DOWN    3
#define LEFT    4

#define UP1     05
#define RIGHT1  04
#define DOWN1   24
#define LEFT1   19

#define UP2     87
#define RIGHT2  68
#define DOWN2   83
#define LEFT2   65

#define PAUSE   80

#define MOVEOK  1
#define MOVEDIE 2
#define MOVEWIN 3


SETBLINK( .F. )

SETCURSOR( 0 )

SETCOLOR( "15/" + CFUNDO )
CLS


PUBLIC Arena, Nomes, Corpo, Direc, Vidas, Pontos, Jogs, Numero, Number

Nomes := { "Jack", "Rose" }
Jogs  := 2

Jogo()


PROCEDURE Jogo()

LOCAL Fase := 1, ;
      Pri  := .T.
LOCAL Mov, Tec

Vidas  := { 5, 5 }
Pontos := { 0, 0 }

IF Jogs > 1
   @ 00, 11 SAY "Vidas:    <--" + Nomes[ 2 ]
ENDIF

@ 00, 34 SAY "Fase:"
@ 00, 53 - LEN( Nomes[ 1 ] ) SAY Nomes[ 1 ] + "-->  Vidas:  "

AtuaTitulo()


InicFase( Fase )

WHILE .T.
      Mov := Move( Pri )
      Pri := .F.

      IF Mov == MOVEDIE
         InicFase( Fase, .F. )
         Pri := .T.
         LOOP
      ELSEIF Mov == MOVEWIN
         Numero ++
         IF Numero == 10
            Pri    := .T.
            Fase   += IF( Fase == 3, 0, 1 )
            Numero := 1
            InicFase( Fase )
            LOOP
         ELSE
            PoeNumero()
         ENDIF
      ENDIF

      Tempo()

      Tec := ASC( UPPER( CHR( LASTKEY() ) ) )

      IF Tec == UP1 .AND. Direc[ 1 ] <> DOWN
         Direc[ 1 ] := UP
      ELSEIF Tec == RIGHT1 .AND. Direc[ 1 ] <> LEFT
         Direc[ 1 ] := RIGHT
      ELSEIF Tec == DOWN1 .AND. Direc[ 1 ] <> UP
         Direc[ 1 ] := DOWN
      ELSEIF Tec == LEFT1 .AND. Direc[ 1 ] <> RIGHT
         Direc[ 1 ] := LEFT

      ELSEIF Tec == UP2 .AND. Direc[ 2 ] <> DOWN
         Direc[ 2 ] := UP
      ELSEIF Tec == RIGHT2 .AND. Direc[ 2 ] <> LEFT
         Direc[ 2 ] := RIGHT
      ELSEIF Tec == DOWN2 .AND. Direc[ 2 ] <> UP
         Direc[ 2 ] := DOWN
      ELSEIF Tec == LEFT2 .AND. Direc[ 2 ] <> RIGHT
         Direc[ 2 ] := LEFT

      ELSEIF Tec == PAUSE
         SpacePause( "Pausa...  Aperte espaço." )

      ELSEIF Tec == 27
         Menu()

      ENDIF
ENDDO


FUNCTION Menu()

LOCAL TelaSave := SAVESCREEN( 00, 00, 24, 79 )
LOCAL Menus    := { { "Iniciar      ", 1, .F. }, ;
                    { "             ", 1, .F. }, ;
                    { "Fase inicial ", 2, .T., 1, 1,   3 }, ;
                    { "Velocidade   ", 2, .T., 1, 1, 100 }, ;
                    { "Limpar a cada", 2, .T., 1, 1,   3 }, ;
                    { "             ", 1, .F. }, ;
                    { "Jogadores    ", 2, .T., 1, 1,   2 }, ;
                    { "Jogador 1    ", 3, .T., Nomes[ 1 ] }, ;
                    { "Jogador 2    ", 0, .T., Nomes[ 2 ] }, ;
                    { "             ", 0, .F. }, ;
                    { "Sair         ", 1, .T. } }

@ 12 - LEN( Menus ) / 2, 39 - LEN( Menus[ 1, 1 ] ) / 2, ;
  13 + LEN( Menus ) / 2, 42 + LEN( Menus[ 1, 1 ] ) / 2 BOX "█▀███▄██ " COLOR CPAUSA

FOR i := 1 TO LEN( Menus )
    @ 12 + i - LEN( Menus ) / 2, 41 - LEN( Menus[ 1, 1 ] ) / 2 SAY Menus[ i, 1 ] COLOR CPAUSA
NEXT


INKEY( 0 )

RESTSCREEN( 00, 00, 24, 79, TelaSave )


FUNCTION Tempo()

LOCAL Sec := SECONDS(), ;
      Tec := 0

FOR i := 1 TO 1000
    IF Tec == 0 .AND. INKEY() <> 0
       Tec := 1
    ENDIF
NEXT

*WHILE ABS( SECONDS() - Sec ) <= 0
*      IF Tec == 0 .AND. INKEY() <> 0
*         Tec := 1
*      ENDIF
*ENDDO


FUNCTION Move( Pri )

LOCAL Ret, i, x

Ret := MOVEOK

IF Pri
   FOR i := 1 TO Jogs
       FOR x := 1 TO LEN( Corpo[ i ] )
           Arena( Corpo[ i, x, 1 ], Corpo[ i, x, 2 ], IF( i == 1, CORPO1, CORPO2 ) )
       NEXT
   NEXT

ELSE
   FOR i := 1 TO Jogs
       IF !( ATAIL( Corpo[ i ] )[ 1 ] == Corpo[ i, LEN( Corpo[ i ] ) - 1, 1 ] .AND. ;
             ATAIL( Corpo[ i ] )[ 2 ] == Corpo[ i, LEN( Corpo[ i ] ) - 1, 2 ] )
          Arena( ATAIL( Corpo[ i ] )[ 1 ], ATAIL( Corpo[ i ] )[ 2 ], 0 )

       ENDIF

       AINS( Corpo[ i ], 1 )

       IF " " + STR( Arena[ IF( Direc[ i ] == UP, Corpo[ i, 2, 1 ] - 1, ;
                                IF( Direc[ i ] == DOWN, Corpo[ i, 2, 1 ] + 1, ;
                                    Corpo[ i, 2, 1 ] ) ), ;
                            IF( Direc[ i ] == RIGHT, Corpo[ i, 2, 2 ] + 1, ;
                                IF( Direc[ i ] == LEFT, Corpo[ i, 2, 2 ] - 1, ;
                                    Corpo[ i, 2, 2 ] ) ) ], 1 ) $ " " + ;
          STR( CORPO1, 1 ) + " " + STR( CORPO2, 1 ) + " " + STR( BORDA, 1 )

          ADEL( Corpo[ i ], 1 )
          ASIZE( Corpo[ i ], LEN( Corpo[ i ] ) - 1 )

          Vidas[ i ]  --
          Pontos[ i ] -= Numero * 100
          AtuaTitulo()

          TONE( 500 )

          @ ROUND( Number[ 1 ] / 2, 0 ) - 1, Number[ 2 ] - 1 SAY " " COLOR "15/" + CFUNDO
          ApagaCorpo( i )
          SpacePause( Nomes[ i ] + " morreu! Aperte espaço!" )

          Ret := MOVEDIE

       ELSE
          Corpo[ i, 1 ] := { IF( Direc[ i ] == UP, Corpo[ i, 2, 1 ] - 1, ;
                                 IF( Direc[ i ] == DOWN, Corpo[ i, 2, 1 ] + 1, ;
                                     Corpo[ i, 2, 1 ] ) ), ;
                             IF( Direc[ i ] == RIGHT, Corpo[ i, 2, 2 ] + 1, ;
                                 IF( Direc[ i ] == LEFT, Corpo[ i, 2, 2 ] - 1, ;
                                     Corpo[ i, 2, 2 ] ) ) }

          IF Arena[ Corpo[ i, 1, 1 ], Corpo[ i, 1, 2 ] ] == NUMBER .OR. ;
             Arena[ Corpo[ i, 1, 1 ] + IF( LinCima( Corpo[ i, 1, 1 ] ), 1, -1 ), ;
             Corpo[ i, 1, 2 ] ] == NUMBER
             Arena( Corpo[ i, 1, 1 ], Corpo[ i, 1, 2 ], IF( i == 1, CORPO1, CORPO2 ) )

             IF Arena[ Corpo[ i, 1, 1 ] + ;
                       IF( LinCima( Corpo[ i, 1, 1 ] ), 1, -1 ), ;
                       Corpo[ i, 1, 2 ] ] == NUMBER
                Arena[ Corpo[ i, 1, 1 ] + ;
                       IF( LinCima( Corpo[ i, 1, 1 ] ), 1, -1 ), ;
                       Corpo[ i, 1, 2 ] ] := 0
             ENDIF

             Pontos[ i ] += Numero * 100
             AtuaTitulo()

             FOR x := 1 TO Numero * 5
                 ASIZE( Corpo[ i ], LEN( Corpo[ i ] ) + 1 )
                 Corpo[ i, LEN( Corpo[ i ] ) ] := Corpo[ i, LEN( Corpo[ i ] ) - x ]
             NEXT

             Ret := MOVEWIN
          ENDIF

          Arena( Corpo[ i, 1, 1 ], Corpo[ i, 1, 2 ], IF( i == 1, CORPO1, CORPO2 ) )
       ENDIF
   NEXT

ENDIF

RETURN ( Ret )


FUNCTION InicFase( Fase, Mostrar )

LOCAL i

IF VALTYPE( Mostrar ) == "U"
   Mostrar := .T.
ENDIF

InicArena()

DISPBEGIN()

IF Fase == 1
   Corpo := { { { 25, 47 }, ;
                { 25, 46 } }, ;
              { { 25, 34 }, ;
                { 25, 35 } } }
   Direc := { RIGHT, LEFT }
ELSEIF Fase == 2
   Corpo := { { { 07, 59 }, ;
                { 07, 60 } }, ;
              { { 43, 21 }, ;
                { 43, 20 } } }
   Direc := { LEFT, RIGHT }
   FOR i := 20 TO 60
       Arena( 25, i, BORDA )
   NEXT
ELSEIF Fase == 3
   Corpo := { { { 25, 50 }, ;
                { 24, 50 } }, ;
              { { 25, 30 }, ;
                { 24, 30 } } }
   Direc := { UP, DOWN }
   FOR i := 10 TO 40
       Arena( i, 20, BORDA )
       Arena( i, 60, BORDA )
   NEXT
ENDIF

DISPEND()

IF Mostrar
   SpacePause( "Fase " + LTRIM( STR( Fase ) ) + "...  Aperte espaço." )
ENDIF

Numero := 1
PoeNumero()


FUNCTION PoeNumero()

LOCAL Lin, Col

WHILE .T.
      Lin := INT( RND() * 47 ) + 4
      Col := INT( RND() * 80 ) + 1
      IF Arena[ Lin, Col ] == 0 .AND. Arena[ IF( LinCima( Lin ), Lin + 1, Lin - 1 ), Col ] == 0
         @ ROUND( Lin / 2, 0 ) - 1, Col - 1 SAY STR( Numero, 1 ) COLOR CNUMERO + "/" + CFUNDO
         Number := { Lin, Col }
         Arena[ Lin, Col ] := NUMBER
         EXIT
      ENDIF
ENDDO


FUNCTION InicArena()

LOCAL i

DISPBEGIN()

@ 01, 00, 24, 79 BOX "         " COLOR "15/" + CFUNDO

Arena := ARRAY( 50, 80 )
FOR i := 1 TO 50
    IF i == 3 .OR. i == 50
       AFILL( Arena[ i ], BORDA )
       @ IF( i == 3, 01, 24 ), 00 SAY "█" + REPLICATE( IF( i == 3, "▀", "▄" ), 78 ) + "█" COLOR CBORDA + "/" + CFUNDO
    ELSE
       AFILL( Arena[ i ], 0 )
       IF i > 3 .AND. i < 50
          Arena[ i,  1 ] := BORDA
          Arena[ i, 80 ] := BORDA
          @ ROUND( i / 2, 0 ) - 1, 00 SAY "█" COLOR CBORDA + "/" + CFUNDO
          @ ROUND( i / 2, 0 ) - 1, 79 SAY "█" COLOR CBORDA + "/" + CFUNDO
       ENDIF
    ENDIF
NEXT

DISPEND()


FUNCTION Arena( x, y, Tipo )

LOCAL Cor

Arena[ x, y ] := Tipo

IF LinCima( x )
   IF Arena[ x + 1, y ] == 0
      Cor := IF( Tipo == BORDA, CBORDA, IF( Tipo == CORPO1, CCORPO1, ;
             IF( Tipo == CORPO2, CCORPO2, CFUNDO ) ) ) + "/" + CFUNDO
   ELSE
      Cor := IF( Tipo == BORDA, CBORDA, IF( Tipo == CORPO1, CCORPO1, ;
             IF( Tipo == CORPO2, CCORPO2, CFUNDO ) ) ) + "/" + ;
             IF( Arena[ x + 1, y ] == BORDA, CBORDA, ;
             IF( Arena[ x + 1, y ] == CORPO1, CCORPO1, ;
             IF( Arena[ x + 1, y ] == CORPO2, CCORPO2, CFUNDO ) ) )
   ENDIF
   @ ROUND( x / 2, 0 ) - 1, y - 1 SAY "▀" COLOR Cor
ELSE
   IF Arena[ x - 1, y ] == 0
      Cor := IF( Tipo == BORDA, CBORDA, IF( Tipo == CORPO1, CCORPO1, ;
             IF( Tipo == CORPO2, CCORPO2, CFUNDO ) ) ) + "/" + CFUNDO
   ELSE
      Cor := IF( Tipo == BORDA, CBORDA, IF( Tipo == CORPO1, CCORPO1, ;
             IF( Tipo == CORPO2, CCORPO2, CFUNDO ) ) ) + "/" + ;
             IF( Arena[ x - 1, y ] == BORDA, CBORDA, ;
             IF( Arena[ x - 1, y ] == CORPO1, CCORPO1, ;
             IF( Arena[ x - 1, y ] == CORPO2, CCORPO2, CFUNDO ) ) )
   ENDIF
   @ ROUND( x / 2, 0 ) - 1, y - 1 SAY "▄" COLOR Cor
ENDIF


FUNCTION LinCima( nLin )

IF nLin / 2 == INT( nLin / 2 )
   RETURN .F.
ELSE
   RETURN .T.
ENDIF


FUNCTION ApagaCorpo( n )

LOCAL i

WHILE LEN( Corpo[ n ] ) > 0
      FOR i := 1 TO LEN( Corpo[ n ] ) STEP 2
          Arena( Corpo[ n, i, 1 ], Corpo[ n, i, 2 ], 0 )
          ADEL( Corpo[ n ], i )
          ASIZE( Corpo[ n ], LEN( Corpo[ n ] ) - 1 )
      NEXT
      Tempo()
ENDDO


FUNCTION AtuaTitulo()

IF Jogs > 1
   @ 00, 18 SAY STRZERO( Vidas[ 2 ], 1 )
   @ 00, 00 SAY STR( Pontos[ 2 ], 9 )
ENDIF

@ 00, 65 SAY STRZERO( Vidas[ 1 ], 1 )
@ 00, 71 SAY STR( Pontos[ 1 ], 9 )


FUNCTION RND()

STATIC Ant_ := 123
STATIC Num_ := 0
LOCAL  Ret

Num_ ++
IF Num_ == 20
   Num_ := 1
ENDIF

Ret  := ( ( SECONDS() / Num_ ) * Ant_ )
Ant_ := SECONDS()

Ret := LTRIM( STR( Ret, 19, 4 ) )
Ret := VAL( "0." + SUBSTR( Ret, AT( ".", Ret ) + 1 ) )

RETURN ( Ret )


FUNCTION SpacePause( Mens )

LOCAL TelaSave := SAVESCREEN( 11, 00, 13, 79 )

Center( 11, "█▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀█" )
Center( 12, "█"     + PADC( Mens, 31 ) +    "█" )
Center( 13, "█▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄█" )

WHILE INKEY( 0 ) != 32
ENDDO

RESTSCREEN( 11, 00, 13, 79, TelaSave )


FUNCTION Center( Lin, Mens, Cor )

IF VALTYPE( Cor ) == "U"
   Cor := CPAUSA
ENDIF

@ Lin, ( 80 - LEN( Mens ) ) / 2 SAY Mens COLOR Cor


EXIT PROCEDURE Sair()

INKEY( 0 )

SETCOLOR( "07/00" )
CLS
