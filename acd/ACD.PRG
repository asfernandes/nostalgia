#include "inkey.ch"


REQUEST RDDSYS

FIELD NOME, DIRETORIO


PROCEDURE ACD( Diret )

LOCAL OldDir := UPPER( RTRIM( CURDIR() ) )
LOCAL Create, aDirs, a, n, s

IF VALTYPE( Diret ) != "C"
   QUIT
ENDIF

Create := ( Diret := UPPER( Diret ) ) == "/CREATE"

IF Create .OR. ! MeuFile( "\ACD.DBF" )
   DBCREATE( "\ACD", { { "Nome",      "C", 12, 0 }, ;
                       { "Diretorio", "C", 50, 0 } } )
ENDIF

USE \ACD

IF Create .OR. ! MeuFile( "\ACD.CDX" )
   ORDCREATE( "\ACD", "Nome", "UPPER(Nome)", { || UPPER( Nome ) } )
   ORDCREATE( "\ACD", "Diretorio", "UPPER(Diretorio)", { || UPPER( Diretorio ) } )
ENDIF

ORDLISTADD( "\ACD" )
ORDSETFOCUS( "Nome" )

IF Create
   CLS
   DIRCHANGE( "\" )

   aDirs := { Directories() }
   a     := { 0 }
   n     := 0
   s     := SECONDS()

   WHILE .T.
         a[ LEN( a ) ]++

         IF ATAIL( a ) > LEN( ATAIL( aDirs ) )
            IF LEN( a ) == 1
               EXIT
            ENDIF
            DIRCHANGE( ".." )
            ASIZE( aDirs, LEN( aDirs ) - 1 )
            ASIZE( a, LEN( a ) - 1 )
            LOOP
         ELSE
            DIRCHANGE( ATAIL( aDirs )[ ATAIL( a ) ] )
            AADD( aDirs, Directories() )
            AADD( a, 0 )
         ENDIF

         n++
         @ 00, 00 SAY PADR( STRZERO( n, 5 ) + " \" + CURDIR(), 80 )
         @ 01, 00 SAY SECONDS() - s

         DBAPPEND()
         REPLACE Nome      WITH aDirs[ LEN( aDirs ) - 1 ][ a[ LEN( a ) - 1 ] ], ;
                 Diretorio WITH LEFT( CURDIR(), RAT( "\", CURDIR() ) - 1 )
         IF INKEY( 0.01 ) == K_ESC
            EXIT
         ENDIF
   ENDDO
   DIRCHANGE( "\" + OldDir )
ELSE
   DBSEEK( Diret, .T., .T. )
   IF !( SUBSTR( OldDir, RAT( "\", OldDir ) + 1 ) == Diret ) .OR. ;
      OldDir == RTRIM( Diretorio ) + "\" + RTRIM( Nome )

      DBSEEK( Diret, .T. )
//      ? 1, RTRIM( Diretorio ) + "\" + Nome
//      DIRCHANGE( STRTRAN( "\" + RTRIM( Diretorio ) + "\" + RTRIM( Nome ), "\\", "\" ) )

   ELSE

      DBSEEK( Diret, .T. )
      WHILE ! ( "\" + OldDir == STRTRAN( "\" + RTRIM( Diretorio ) + "\" + RTRIM( Nome ), "\\", "\" ) )
//            ? STRTRAN( "\" + RTRIM( Diretorio ) + "\" + RTRIM( Nome ), "\\", "\" )
            DBSKIP()
      ENDDO
      DBSKIP()
//      ? 2, RTRIM( Diretorio ) + "\" + Nome
   ENDIF

   DIRCHANGE( STRTRAN( "\" + RTRIM( Diretorio ) + "\" + RTRIM( Nome ), "\\", "\" ) )
ENDIF

USE


FUNCTION Directories()

LOCAL aDirs := DIRECTORY( "*.*", "DHS" ), ;
      aRet  := {}
LOCAL i

FOR i := 1 TO LEN( aDirs )
    IF "D" $ aDirs[ i, 5 ] .AND. aDirs[ i, 1 ] != "."
       AADD( aRet, aDirs[ i, 1 ] )
    ENDIF
NEXT

RETURN ( aRet )