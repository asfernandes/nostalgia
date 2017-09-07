#include "box.ch"
#include "inkey.ch"
#include "common.ch"

LOCAL L1 := 05, ;
      C1 := 29, ;
      L2 := 14, ;
      C2 := 50

LOCAL Ops := { "Nova Partida", ;
               "Voltar", ;
               "Abrir Partida", ;
               "Salvar Partida", ;
               "Visualizar Records", ;
               "Sair do Tetris" }

LOCAL i

SET DATE FORMAT "dd/mm/yyyy"
SET SCOREBOARD OFF
SETMODE( 25, 80 )
SETBLINK( .F. )

Jogo()
QUIT


WHILE .T.
      SETCOLOR( "07/01" )
      CLS

      SETCOLOR( "15/09" )
      @ L1, C1, L2, C2 BOX B_SINGLE
      @ L1 + 2, C1 + 2, L1 + 2, C2 - 2 BOX B_SINGLE
      @ L1 + 1, C1 + 2 SAY PADC( "Menu Principal", C2 - C1 - 3 ) COLOR "14/09"
      Sombra( L1, C1, L2, C2 )

      FOR i := 1 TO 6
          @ L1 + 2 + i, C1 + 2 SAY PADC( Ops[ i ], C2 - C1 - 3 ) COLOR "15/09"
      NEXT

      i := 1
      WHILE .T.
            @ L1 + 2 + i, C1 + 2 SAY PADC( Ops[ i ], C2 - C1 - 3 ) COLOR "00/10"
            EXIT
      ENDDO

      EXIT
ENDDO


PROCEDURE Jogo()

LOCAL L1 := 00, ;
      C1 := 58, ;
      L2 := 24, ;
      C2 := 79

LOCAL Pontos := 0, ;
      Cores  := { 10, 11, 12, 13, 11, 14, 14, 15, 15, 15, 15 }, ;
      Tela   := ARRAY( L2 - L1 + 1, ( C2 - C1 + 1 ) / 2 ), ;
      Temp   := SECONDS()

LOCAL Pec, Mov, Pec_, Mov_, Mat, ProxPec, Lin, L, Col, C, Tec, Pode, Cair, ;
      a, i, x, y

FOR i := 1 TO L2 - L1 + 1
    AFILL( Tela[ i ], .F. )
NEXT

SETCURSOR( 0 )
SETCOLOR( "07/00" )
CLS

SETCOLOR( "07/01" )
@ L1, C1, L2, C2 BOX "         "

@ 06, 02 SAY "Pontos: 0" COLOR "07/00"

Pec_ := INT( RND() * 11 ) + 1
Mov_ := INT( RND() * 4 ) + 1

WHILE .T.
      Pec := Pec_
      Mov := IF( Mov_ > MaxMov( Pec ), MaxMov( Pec ), Mov_ )

      Pec_ := INT( RND() * 11 ) + 1
      Mov_ := INT( RND() * 4 ) + 1

      ProxPec := MatPec( Pec_, Mov_ )
      @ 01, 02, 05, 09 BOX "         " COLOR "07/00"

      FOR x := 1 TO LEN( ProxPec )
          FOR y := 1 TO LEN( ProxPec[ 1 ] )
              IF ProxPec[ x, y ]
                 @ 00 + x, 02 + ( y * 2 ) - 2 SAY "" COLOR STRZERO( Cores[ Pec_ ], 2 ) + "/00"
              ENDIF
          NEXT
      NEXT

      Mat := MatPec( Pec, Mov )
      Lin := -1
      L   := 0
      Col := 68
      C   := 6

      WHILE .T.
            Tec  := INKEY( 0.01 )
            Pode := .T.

            IF Tec == K_SPACE

               PodeMov := .T.
               PMov    := 0

               IF MaxMov( Pec ) == 1
               ELSEIF Mov == MaxMov( Pec )
                  PMov := 1
               ELSE
                  PMov := Mov + 1
               ENDIF

               IF PMov > 0
                  PMat := MatPec( Pec, PMov )
                  Soma := MaisMenos( Pec, Mov )

                  IF ( TT := C + LEN( PMat[ 1 ] ) + Soma[ 2 ] - 1 ) > 11
                     Soma[ 2 ] -= TT - 11
                  ENDIF

                  IF ( TT := C + 1 + Soma[ 2 ] - 1 ) < 1
                     Soma[ 2 ] += ABS( TT ) + 1
                  ENDIF

                  FOR x := 1 TO LEN( PMat )
                      FOR y := 1 TO LEN( PMat[ 1 ] )
                          IF !( L + x + Soma[ 1 ] - 1 > 25 ) .AND. !( C + y + Soma[ 2 ] - 1 ) > 11
                             IF PMat[ x, y ] .AND. Tela[ L + x + Soma[ 1 ] - 1, C + y + Soma[ 2 ] - 1 ]
                                PodeMov := .F.
                             ENDIF
                          ENDIF
                      NEXT
                  NEXT

                  IF PodeMov
                     FOR x := 1 TO LEN( Mat )
                         FOR y := 1 TO LEN( Mat[ 1 ] )
                             IF Mat[ x, y ]
                                @ Lin - ( LEN( Mat ) - x ), Col + ( y * 2 ) - 2 SAY "  "
                             ENDIF
                         NEXT
                     NEXT

                     Mat := PMat
                     Mov := PMov
                     L   += Soma[ 1 ]
                     Lin += Soma[ 1 ]
                     C   += Soma[ 2 ]
                     Col += Soma[ 2 ] * 2

                     FOR x := 1 TO LEN( Mat )
                         FOR y := 1 TO LEN( Mat[ 1 ] )
                             IF Mat[ x, y ]
                                @ Lin - ( LEN( Mat ) - x ), Col + ( y * 2 ) - 2 SAY "" COLOR STRZERO( Cores[ Pec ], 2 ) + "/01"
                             ENDIF
                         NEXT
                     NEXT
                  ENDIF
               ENDIF

            ELSEIF Tec == K_LEFT

               FOR x := 1 TO LEN( Mat )
                   a := L + LEN( Mat ) - x - 2
                   IF LEN( Mat ) == 1
                      a += 2
                   ELSEIF LEN( Mat ) == 2
                      a += 1
                   ELSEIF LEN( Mat ) == 4
                      a -= 1
                   ENDIF

                   IF C == 1
                      Pode := .F.
                      EXIT
                   ENDIF

                   IF a <= 0
                      LOOP
                   ENDIF

                   FOR y := 1 TO LEN( Mat[ 1 ] )
                       IF Mat[ LEN( Mat ) - x + 1, y ]
                          IF Tela[ a, C + y - 2 ]
                             Pode := .F.
                             EXIT
                          ENDIF
                       ENDIF
                   NEXT
               NEXT

               IF Pode
                  FOR x := 1 TO LEN( Mat )
                      FOR y := 1 TO LEN( Mat[ 1 ] )
                          IF Mat[ x, y ]
                             @ Lin - ( LEN( Mat ) - x ), Col + ( y * 2 ) - 2 SAY "  "
                          ENDIF
                      NEXT
                  NEXT

                  Col -= 2
                  C   --

                  FOR x := 1 TO LEN( Mat )
                      FOR y := 1 TO LEN( Mat[ 1 ] )
                          IF Mat[ x, y ]
                             @ Lin - ( LEN( Mat ) - x ), Col + ( y * 2 ) - 2 SAY "" COLOR STRZERO( Cores[ Pec ], 2 ) + "/01"
                          ENDIF
                      NEXT
                  NEXT
               ENDIF

            ELSEIF Tec == K_RIGHT

               FOR x := 1 TO LEN( Mat )
                   a := L + LEN( Mat ) - x - 2
                   IF LEN( Mat ) == 1
                      a += 2
                   ELSEIF LEN( Mat ) == 2
                      a += 1
                   ELSEIF LEN( Mat ) == 4
                      a -= 1
                   ENDIF

                   IF C + LEN( Mat[ 1 ] ) - 1 >= 11
                      Pode := .F.
                      EXIT
                   ENDIF

                   IF a <= 0
                      LOOP
                   ENDIF

                   FOR y := 1 TO LEN( Mat[ 1 ] )
                       IF Mat[ LEN( Mat ) - x + 1, y ]
                          IF Tela[ a, C + y ]
                             Pode := .F.
                             EXIT
                          ENDIF
                       ENDIF
                   NEXT
               NEXT

               IF Pode
                  FOR x := 1 TO LEN( Mat )
                      FOR y := 1 TO LEN( Mat[ 1 ] )
                          IF Mat[ x, y ]
                             @ Lin - ( LEN( Mat ) - x ), Col + ( y * 2 ) - 2 SAY "  "
                          ENDIF
                      NEXT
                  NEXT

                  Col += 2
                  C   ++

                  FOR x := 1 TO LEN( Mat )
                      FOR y := 1 TO LEN( Mat[ 1 ] )
                          IF Mat[ x, y ]
                             @ Lin - ( LEN( Mat ) - x ), Col + ( y * 2 ) - 2 SAY "" COLOR STRZERO( Cores[ Pec ], 2 ) + "/01"
                          ENDIF
                      NEXT
                  NEXT
               ENDIF

            ELSEIF Tec == K_DOWN
               Temp := 0

            ENDIF

            Cair := SECONDS()
            IF Cair >= Temp
               Cair := IF( Cair - Temp >= 0.3, .T., .F. )
            ELSE
               Cair := IF( Cair + 86400 - Temp >= 0.3, .T., .F. )
            ENDIF

            Pode := .T.

            IF Cair

               FOR x := 1 TO LEN( Mat )
                   a := L + LEN( Mat ) - x - 1
                   IF LEN( Mat ) == 1
                      a += 2
                   ELSEIF LEN( Mat ) == 2
                      a += 1
                   ELSEIF LEN( Mat ) == 4
                      a -= 1
                   ENDIF

                   IF a <= 0
                      LOOP
                   ENDIF

                   FOR y := 1 TO LEN( Mat[ 1 ] )
                       IF Mat[ LEN( Mat ) - x + 1, y ]
                          IF L >= 25
                             Pode := .F.
                             EXIT
                          ENDIF

                          IF Tela[ a, C + y - 1 ]
                             Pode := .F.
                             EXIT
                          ENDIF
                       ENDIF
                   NEXT

                   IF !Pode
                      FOR x := 1 TO LEN( Mat )
                          FOR y := 1 TO LEN( Mat[ 1 ] )
                              IF Mat[ x, y ]
                                 IF L - LEN( Mat ) + x > 0
                                    Tela[ L - LEN( Mat ) + x, C + y - 1 ] := .T.
                                 ENDIF
                           ENDIF
                          NEXT
                      NEXT

                      IF ASCAN( Tela[ 1 ], .T. ) > 0
                         @ 24, 00 SAY "Fim"
                         QUIT
                      ENDIF

                      Tira := {}
                      FOR i := L - LEN( Mat ) + 1 TO L
                          IF ASCAN( Tela[ i ], .F. ) == 0
                             ADEL( Tela, i )
                             AINS( Tela, 1 )
                             Tela[ 1 ] := { .F., .F., .F., .F., .F., .F., .F., .F., .F., .F., .F. }
                             @ i - 1, C1 SAY REPLICATE( "", 11 ) COLOR "09/01"
                             AADD( Tira, i - 1 )
                          ENDIF
                      NEXT

                      IF LEN( Tira ) > 0
                         Pontos += LEN( Tira )
                         @ 06, 10 SAY PADR( LTRIM( STR( Pontos ) ), 6 ) COLOR "07/00"
                         TONE( 2000 )
                         INKEY( .1 )
                      ENDIF

                      FOR i := 1 TO LEN( Tira )
                          SCROLL( L1, C1, Tira[ i ], C2, -1 )
                      NEXT

                      EXIT
                   ENDIF
               NEXT

               IF !Pode
                  EXIT
               ENDIF

               FOR x := 1 TO LEN( Mat )
                   FOR y := 1 TO LEN( Mat[ 1 ] )
                       IF Mat[ x, y ]
                          @ Lin - ( LEN( Mat ) - x ), Col + ( y * 2 ) - 2 SAY "  "
                       ENDIF
                   NEXT
               NEXT

               Lin ++
               L   ++

               FOR x := 1 TO LEN( Mat )
                   FOR y := 1 TO LEN( Mat[ 1 ] )
                       IF Mat[ x, y ]
                          @ Lin - ( LEN( Mat ) - x ), Col + ( y * 2 ) - 2 SAY "" COLOR STRZERO( Cores[ Pec ], 2 ) + "/01"
                       ENDIF
                   NEXT
               NEXT
               Temp := SECONDS()
            ENDIF
      ENDDO
ENDDO


FUNCTION MatPec( Pec, Mov )

IF Pec == 1
   RETURN ( { { .T., .T. }, ;
              { .T., .T. } } )

ELSEIF Pec == 2
   IF Mov == 1
      RETURN ( { { .T., .F. }, ;
                 { .T., .F. }, ;
                 { .T., .T. } } )
   ELSEIF Mov == 2
      RETURN ( { { .F., .F., .T. }, ;
                 { .T., .T., .T. } } )
   ELSEIF Mov == 3
      RETURN ( { { .T., .T. }, ;
                 { .F., .T. }, ;
                 { .F., .T. } } )
   ELSEIF Mov == 4
      RETURN ( { { .T., .T., .T. }, ;
                 { .T., .F., .F. } } )
   ENDIF

ELSEIF Pec == 3
   IF Mov == 1
      RETURN ( { { .T., .T., .T. }, ;
                 { .F., .T., .F. } } )
   ELSEIF Mov == 2
      RETURN ( { { .T., .F. }, ;
                 { .T., .T. }, ;
                 { .T., .F. } } )
   ELSEIF Mov == 3
      RETURN ( { { .F., .T., .F. }, ;
                 { .T., .T., .T. } } )
   ELSEIF Mov == 4
      RETURN ( { { .F., .T. }, ;
                 { .T., .T. }, ;
                 { .F., .T. } } )
   ENDIF

ELSEIF Pec == 4
   IF Mov == 1
      RETURN ( { { .T. }, ;
                 { .T. }, ;
                 { .T. }, ;
                 { .T. } } )
   ELSE
      RETURN ( { { .T., .T., .T., .T. } } )
   ENDIF

ELSEIF Pec == 5
   IF Mov == 1
      RETURN ( { { .F., .T. }, ;
                 { .F., .T. }, ;
                 { .T., .T. } } )
   ELSEIF Mov == 2
      RETURN ( { { .T., .T., .T. }, ;
                 { .F., .F., .T. } } )
   ELSEIF Mov == 3
      RETURN ( { { .T., .T. }, ;
                 { .T., .F. }, ;
                 { .T., .F. } } )
   ELSEIF Mov == 4
      RETURN ( { { .T., .F., .F. }, ;
                 { .T., .T., .T. } } )
   ENDIF

ELSEIF Pec == 6
   IF Mov == 1
      RETURN ( { { .T., .F. }, ;
                 { .T., .T. }, ;
                 { .F., .T. } } )
   ELSE
      RETURN ( { { .F., .T., .T. }, ;
                 { .T., .T., .F. } } )
   ENDIF

ELSEIF Pec == 7
   IF Mov == 1
      RETURN ( { { .F., .T. }, ;
                 { .T., .T. }, ;
                 { .T., .F. } } )
   ELSE
      RETURN ( { { .T., .T., .F. }, ;
                 { .F., .T., .T. } } )
   ENDIF

ELSEIF Pec == 8        // Outro
   IF Mov == 1
      RETURN ( { { .T., .T., .F. }, ;
                 { .F., .T., .F. }, ;
                 { .F., .T., .T. } } )
   ELSE
      RETURN ( { { .F., .F., .T. }, ;
                 { .T., .T., .T. }, ;
                 { .T., .F., .F. } } )
   ENDIF

ELSEIF Pec == 9
   RETURN ( { { .F., .T., .F. }, ;
              { .T., .T., .T. }, ;
              { .F., .T., .F. } } )

ELSEIF Pec == 10
   IF Mov == 1
      RETURN ( { { .T., .T., .T. }, ;
                 { .T., .F., .T. } } )
   ELSEIF Mov == 2
      RETURN ( { { .T., .T. }, ;
                 { .T., .F. }, ;
                 { .T., .T. } } )
   ELSEIF Mov == 3
      RETURN ( { { .T., .F., .T. }, ;
                 { .T., .T., .T. } } )
   ELSEIF Mov == 4
      RETURN ( { { .T., .T. }, ;
                 { .F., .T. }, ;
                 { .T., .T. } } )
   ENDIF

ELSEIF Pec == 11
   RETURN ( { { .T. } } )

ENDIF


FUNCTION MaisMenos( Pec, Mov )

LOCAL Ret

IF Pec == 3 .AND. Mov == 1
   Ret := { 0, 1 }
ELSEIF Pec == 3 .AND. Mov == 2
   Ret := { 0, -1 }
ELSEIF Pec == 4 .AND. Mov == 1
   Ret := { -2, -1 }
ELSEIF Pec == 4 .AND. Mov == 2
   Ret := { 2, 1 }
ELSE
   Ret := { 0, 0 }
ENDIF

RETURN ( Ret )


FUNCTION MaxMov( Pec )

LOCAL Ret

IF Pec == 1
   Ret := 1
ELSEIF Pec == 2
   Ret := 4
ELSEIF Pec == 3
   Ret := 4
ELSEIF Pec == 4
   Ret := 2
ELSEIF Pec == 5
   Ret := 4
ELSEIF Pec == 6
   Ret := 2
ELSEIF Pec == 7
   Ret := 2
ELSEIF Pec == 8
   Ret := 2
ELSEIF Pec == 9
   Ret := 1
ELSEIF Pec == 10
   Ret := 4
ELSEIF Pec == 11
   Ret := 1
ENDIF

RETURN ( Ret )


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


FUNCTION Sombra( L1, C1, L2, C2 )

Somb( L1 + 1, C2 + 1, L2 + 1, C2 + 2 )
Somb( L2 + 1, C1 + 2, L2 + 1, C2 + 2 )


FUNCTION Somb( L1, C1, L2, C2, Cor )

LOCAL Tela, i1, i2, i

DEFAULT Cor TO "08/00"

DISPBEGIN()

FOR i1 := L1 TO L2

    Tela := SAVESCREEN( i1, C1, i1, C2 )

    @ i1, C1 SAY ""

    FOR i := 1 TO LEN( Tela ) STEP 2
        @ ROW(), COL() SAY SUBSTR( Tela, i, 1 ) COLOR Cor
        IF i >= LEN( Tela )
           EXIT
        ENDIF
    NEXT

NEXT

DISPEND()


EXIT PROCEDURE Fim()

INKEY( 0 )
SETCOLOR( "07/00" )
CLS
