#include "inkey.ch"


SETBLINK( .F. )

SETCOLOR( "07/00" )
CLS

L11 := "┌────┬────┬────┬────┐   ┌─────────┐"
L12 := "├────┼────┼────┼────┤   ├─────────┤"
L13 := "└────┴────┴────┴────┘   └─────────┘"
L21 := "│    │    │    │    │   │         │"

FOR i := 4 TO 24 STEP 2
    @ i, 02 SAY IF( i == 4, L11, IF( i == 24, L13, L12 ) )
    IF i != 24
        @ i + 1, 02 SAY L21
    ENDIF
NEXT

@ 00, 02 SAY "┌────┬────┬────┬────┐"
@ 01, 02 SAY "│ ██ │ ██ │ ██ │ ██ │"
@ 02, 02 SAY "└────┴────┴────┴────┘"

@ 02, 28 SAY "■" COLOR "15/00"
@ 02, COL() + 1 SAY "posiçäo errada"

@ 03, 28 SAY "■" COLOR "08/00"
@ 03, COL() + 1 SAY "posiçäo certa"

@ 00, 49 SAY "Cores" COLOR "15/00"

FOR i := 1 TO 6
    @ 01, 45 + ( i * 4 ) + INT( i * 1.1 ) - 1 SAY STR( i, 1 ) + " " COLOR "00" + SUBSTR( Cor( i ), 3, 3 )
NEXT

Senha := { 0, 0, 0, 0, 0, 0 }  // Azul, Verde, Vermelho, Roxo, Marrom, Amarelo

p := 1

WHILE .T.
      C := INT( RND() * 6 ) + 1
      IF Senha[ C ] == 0
         Senha[ C ] := p
         p ++
         IF p == 5
            EXIT
         ENDIF
      ENDIF
ENDDO

P := 10
L := 5

WHILE .T.
      Fila := { 0, 0, 0, 0 }
      Foco := 1

      WHILE .T.
            SETPOS( L, ( Foco * 4 ) + INT( Foco * 1.1 ) - 1 )
            Tecla := INKEY( 0 )

            IF Tecla == K_RIGHT
               Foco := IF( Foco == 4, 1, Foco + 1 )

            ELSEIF Tecla == K_LEFT
               Foco := IF( Foco == 1, 4, Foco - 1 )

            ELSEIF Tecla == K_UP
               Fila[ Foco ] := IF( Fila[ Foco ] == 6, 1, Fila[ Foco ] + 1 )

            ELSEIF CHR( Tecla ) >= "1" .AND. CHR( Tecla ) <= "6"
               Fila[ Foco ] := VAL( CHR( Tecla ) )
               KEYBOARD CHR( K_RIGHT )

            ELSEIF Tecla == K_DEL .OR. Tecla == K_SPACE
               Fila[ Foco ] := 0

            ELSEIF Tecla == K_DOWN
               Fila[ Foco ] := IF( Fila[ Foco ] <= 1, 6, Fila[ Foco ] - 1 )

            ELSEIF Tecla == K_ESC
               CLS
               QUIT

            ELSEIF Tecla == K_ENTER
               Temp := { 0, 0, 0, 0, 0, 0 }
               Pode := .T.
               FOR i := 1 TO 4
                   IF Fila[ i ] == 0
                      Pode := .F.
                      EXIT
                   ENDIF
                   IF Temp[ Fila[ i ] ] == 0
                      Temp[ Fila[ i ] ] := 1
                   ELSE
                      Pode := .F.
                      EXIT
                   ENDIF
               NEXT

               IF Pode
                  EXIT
               ENDIF

            ENDIF

            @ L, ( Foco * 4 ) + INT( Foco * 1.1 ) - 1 SAY "  " COLOR Cor( Fila[ Foco ] )

      ENDDO
      IF ( Ganhou := SayPinos() ) .OR. P == 1
         FOR i := 1 TO 6
             IF Senha[ i ] != 0
                @ 01, ( Senha[ i ] * 4 ) + INT( Senha[ i ] * 1.1 ) - 1 SAY "  " COLOR Cor( i )
             ENDIF
         NEXT

         IF Ganhou
            @ 12, 50 SAY "Você fez " + LTRIM( STR( P ) ) + " ponto" + IF( p > 1, "s.", "." )
         ELSE
            @ 12, 50 SAY "Você perdeu."
         ENDIF
         INKEY( 0 )
         CLS
         QUIT
      ENDIF

      P --
      L += 2
      IF P == 0
         EXIT
      ENDIF

ENDDO

SETCOLOR( "07/00" )
CLS


FUNCTION SayPinos()

LOCAL Brancos := 0, ;
      Pretos  := 0

LOCAL Pos, i

FOR i := 1 TO 4
    IF ( Pos := Senha[ Fila[ i ] ] ) == i
       Pretos ++
    ELSEIF Pos > 0
       Brancos ++
    ENDIF
NEXT

@ L, 28    SAY REPLICATE( "■ ", Brancos ) COLOR "15/00"
@ L, COL() SAY REPLICATE( "■ ", Pretos )  COLOR "08/00"

RETURN ( IF( Pretos == 4, .T., .F. ) )


FUNCTION Cor( C )

IF C == 0
   RETURN ( "07/00" )
ELSEIF C == 1
   RETURN ( "07/01" )
ELSEIF C == 2
   RETURN ( "07/02" )
ELSEIF C == 3
   RETURN ( "07/04" )
ELSEIF C == 4
   RETURN ( "07/05" )
ELSEIF C == 5
   RETURN ( "07/06" )
ELSEIF C == 6
   RETURN ( "07/14" )
ENDIF


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
