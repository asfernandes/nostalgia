set scoreboard off
y=0
a=0
d=0
clear
do while .t.
@0,0 to 24,79
@2,34 say "CALCULADORA"
E=CHR(219)
@2,1 SAY REPLICATE(E,33)
@2,45 SAY REPLICATE(E,34)
a=d
b=" "
c=0
@5,30 GET A picture "9,999,999,999,999,999,999.99999"
DO WHILE .T.
@7,39 GET B
@9,30 GET C picture "9,999,999,999,999,999,999.99999"
READ
IF B<>"+" .AND. B<>"*" .AND. B<>"-" .AND. B<>"/"
LOOP
ENDIF
EXIT
ENDDO
IF B="+"
D=A+C
@11,1 say d picture "9,999,999,999,999,999,999.99999"
ENDIF
IF B="*"
D=A*C
@11,1 say d picture "9,999,999,999,999,999,999.99999"
ENDIF
IF B="-"
D=A-C
@11,1 say d picture "9,999,999,999,999,999,999.99999"
ENDIF
IF B="/"
if c=0
loop
endif
D=A/C
@11,1 say d picture "9,999,999,999,999,999,999.99999"
ENDIF
@13,1 SAY "Digite a fun"+chr(135)+chr(132)+"o"
@14,1 say "M-Memoriza"
@14,12 say "D-Desmemoriza"
@14,26 say "N-Normal"
z="N"
@13,17 get z picture "!"
read
if z="M"
y=y+d
@16,1 say y picture "9,999,999,999,999,999,999.99999"
loop
endif
if z="N"
loop
endif
if z="D"
y=0
@16,1 say y picture "9,999,999,999,999,999,999.99999"
endif
enddo
