CC_OPTIONS = -pedantic
CC_LIBRARY = -lfl
CC_LINKS_FLAGS = $(CC_LIBRARY) $(CC_OPTIONS)
OBJECTS = ./alex.o  ./asin.o ./principal.o

lexico:
	rm -f lex.yy.c
	rm -f lexico
	flex lexico.l
	gcc lex.yy.c -lfl -o lexico

clean-lexico:
	rm -f lex.yy.c
	rm -f lexico

sintaxis:
	rm -f sintaxis.c
	rm -f sintaxis.h
	bison -d sintaxis.y -osintaxis.c

test-sintaxis:
	rm -f sintaxis.c
	rm -f sintaxis.h
	bison -d sintaxis.y -osintaxis.c
	rm -f lex.yy.c
	rm -f lexico
	flex -olexico.c lexico.l
	gcc -oanalizador principal.c lexico.c sintaxis.c -lfl
	./analizador ./lexico_sintactico_tests/tests.1.c | diff ./lexico_sintactico_tests/tests.1.out -
	./analizador ./lexico_sintactico_tests/tests.2.c | diff ./lexico_sintactico_tests/tests.2.out -
	./analizador ./lexico_sintactico_tests/tests.3.c | diff ./lexico_sintactico_tests/tests.3.out -
	./analizador ./lexico_sintactico_tests/tests.4.c | diff ./lexico_sintactico_tests/tests.4.out -
	./analizador ./lexico_sintactico_tests/tests.5.c | diff ./lexico_sintactico_tests/tests.5.out -
	./analizador ./lexico_sintactico_tests/tests.6.c | diff ./lexico_sintactico_tests/tests.6.out -
	./analizador ./lexico_sintactico_tests/tests.7.c | diff ./lexico_sintactico_tests/tests.7.out -
	./analizador ./lexico_sintactico_tests/tests.8.c | diff ./lexico_sintactico_tests/tests.8.out -
	./analizador ./lexico_sintactico_tests/tests.9.c | diff ./lexico_sintactico_tests/tests.9.out -
	./analizador ./lexico_sintactico_tests/tests.10.c | diff ./lexico_sintactico_tests/tests.10.out -
	./analizador ./lexico_sintactico_tests/tests.11.c | diff ./lexico_sintactico_tests/tests.11.out -
	./analizador ./lexico_sintactico_tests/tests.12.c | diff ./lexico_sintactico_tests/tests.12.out -

clean-sintaxis:
	rm -f sintaxis.c
	rm -f sintaxis.h

parte-primera:
	rm -f sintaxis.c
	rm -f sintaxis.h
	bison -d sintaxis.y -osintaxis.c
	rm -f lex.yy.c
	rm -f lexico
	flex -olexico.c lexico.l
	gcc -oanalizador principal.c lexico.c sintaxis.c -lfl

seminario-bison-II:
	rm -f sintaxis_bison_ii.c
	rm -f sintaxis_bison_ii.h
	bison -d sintaxis_bison_ii.y -osintaxis_bison_ii.c
	rm -f lex.yy.c
	rm -f lexico_bison_ii
	flex -olexico_bison_ii.c lexico_bison_ii.l
	gcc -oanalizador_bison_ii lexico_bison_ii.c sintaxis_bison_ii.c -lfl

clean-bison-II:
	rm -f sintaxis_bison_ii.c
	rm -f sintaxis_bison_ii.h
	rm -f lex.yy.c
	rm -f lexico_bison_ii

test-seminario-bison-II:
	rm -f sintaxis_bison_ii.c
	rm -f sintaxis_bison_ii.h
	bison -d sintaxis_bison_ii.y -osintaxis_bison_ii.c
	rm -f lex.yy.c
	rm -f lexico_bison_ii
	flex -olexico_bison_ii.c lexico_bison_ii.l
	gcc -oanalizador_bison_ii lexico_bison_ii.c sintaxis_bison_ii.c -lfl
	./analizador_bison_ii ./bison_ii_tests/bison_ii.tests.1.c | diff ./bison_ii_tests/bison_ii.tests.1.out -
	./analizador_bison_ii ./bison_ii_tests/bison_ii.tests.2.c | diff ./bison_ii_tests/bison_ii.tests.2.out -
	./analizador_bison_ii ./bison_ii_tests/bison_ii.tests.3.c | diff ./bison_ii_tests/bison_ii.tests.3.out -
	./analizador_bison_ii ./bison_ii_tests/bison_ii.tests.4.c | diff ./bison_ii_tests/bison_ii.tests.4.out -
	./analizador_bison_ii ./bison_ii_tests/bison_ii.tests.5.c | diff ./bison_ii_tests/bison_ii.tests.5.out -
	./analizador_bison_ii ./bison_ii_tests/bison_ii.tests.6.c | diff ./bison_ii_tests/bison_ii.tests.6.out -
	./analizador_bison_ii ./bison_ii_tests/bison_ii.tests.7.c | diff ./bison_ii_tests/bison_ii.tests.7.out -
	./analizador_bison_ii ./bison_ii_tests/bison_ii.tests.8.c | diff ./bison_ii_tests/bison_ii.tests.8.out -
	./analizador_bison_ii ./bison_ii_tests/bison_ii.tests.9.c | diff ./bison_ii_tests/bison_ii.tests.9.out - # Es normal que salga un "Floating point exception"
	./analizador_bison_ii ./bison_ii_tests/bison_ii.tests.10.c | diff ./bison_ii_tests/bison_ii.tests.10.out -
