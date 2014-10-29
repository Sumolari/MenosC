lexico:
	rm -f lex.yy.c
	rm -f lexico
	flex lexico.l
	gcc lex.yy.c -lfl -o lexico

cleanlexico:
	rm -f lex.yy.c
	rm -f lexico

sintaxis:
	rm -f sintaxis.c
	rm -f sintaxis.h
	bison -d sintaxis.y -osintaxis.c

testsintaxis:
	rm -f sintaxis.c
	rm -f sintaxis.h
	bison -d sintaxis.y -osintaxis.c
	rm -f lex.yy.c
	rm -f lexico
	flex -olexico.c lexico.l
	gcc -oanalizador lexico.c sintaxis.c -lfl
	./analizador tests.1.c | diff tests.1.out -
	./analizador tests.2.c | diff tests.2.out -
	./analizador tests.3.c | diff tests.3.out -
	./analizador tests.4.c | diff tests.4.out -
	./analizador tests.5.c | diff tests.5.out -
	./analizador tests.6.c | diff tests.6.out -
	./analizador tests.7.c | diff tests.7.out -
	./analizador tests.8.c | diff tests.8.out -
	./analizador tests.9.c | diff tests.9.out -
	./analizador tests.10.c | diff tests.10.out -
	./analizador tests.11.c | diff tests.11.out -
	./analizador tests.12.c | diff tests.12.out -

cleansintaxis:
	rm -f sintaxis.c
	rm -f sintaxis.h

partePrimera:
	rm -f sintaxis.c
	rm -f sintaxis.h
	bison -d sintaxis.y -osintaxis.c
	rm -f lex.yy.c
	rm -f lexico
	flex -olexico.c lexico.l
	gcc -oanalizador lexico.c sintaxis.c -lfl

seminarioBisonII:
	rm -f sintaxis_bison_ii.c
	rm -f sintaxis_bison_ii.h
	bison -d sintaxis_bison_ii.y -osintaxis_bison_ii.c
	rm -f lex.yy.c
	rm -f lexico_bison_ii
	flex -olexico_bison_ii.c lexico_bison_ii.l
	gcc -oanalizador_bison_ii lexico_bison_ii.c sintaxis_bison_ii.c -lfl

cleanBisonII:
	rm -f sintaxis_bison_ii.c
	rm -f sintaxis_bison_ii.h
	rm -f lex.yy.c
	rm -f lexico_bison_ii

testSeminarioBisonII:
	rm -f sintaxis_bison_ii.c
	rm -f sintaxis_bison_ii.h
	bison -d sintaxis_bison_ii.y -osintaxis_bison_ii.c
	rm -f lex.yy.c
	rm -f lexico_bison_ii
	flex -olexico_bison_ii.c lexico_bison_ii.l
	gcc -oanalizador_bison_ii lexico_bison_ii.c sintaxis_bison_ii.c -lfl
	./analizador_bison_ii bison_ii.tests.1.c | diff bison_ii.tests.1.out -
	./analizador_bison_ii bison_ii.tests.2.c | diff bison_ii.tests.2.out -
	./analizador_bison_ii bison_ii.tests.3.c | diff bison_ii.tests.3.out -
	./analizador_bison_ii bison_ii.tests.4.c | diff bison_ii.tests.4.out -
	./analizador_bison_ii bison_ii.tests.5.c | diff bison_ii.tests.5.out -
	./analizador_bison_ii bison_ii.tests.6.c | diff bison_ii.tests.6.out -
	./analizador_bison_ii bison_ii.tests.7.c | diff bison_ii.tests.7.out -
	./analizador_bison_ii bison_ii.tests.8.c | diff bison_ii.tests.8.out -
	./analizador_bison_ii bison_ii.tests.9.c | diff bison_ii.tests.9.out - # Es normal que salga un "Floating point exception"
	./analizador_bison_ii bison_ii.tests.10.c | diff bison_ii.tests.10.out -
