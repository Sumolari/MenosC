seminarioBisonII:
	rm -f sintaxis_bison_ii.c
	rm -f sintaxis_bison_ii.h
	bison -d sintaxis_bison_ii.y -osintaxis_bison_ii.c
	rm -f lex.yy.c
	rm -f lexico_bison_ii
	flex -olexico_bison_ii.c lexico_bison_ii.l
	gcc -oanalizador_bison_ii lexico_bison_ii.c sintaxis_bison_ii.c -lfl