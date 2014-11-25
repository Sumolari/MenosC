.PHONY: fresh clean all

clean-lexico-build:
	rm -f lexico
clean-lexico-intermediate:
	rm -f lex.yy.c
clean-lexico: clean-lexico-intermediate clean-lexico-build
build-lexico:
	flex -olexico.c lexico.l
lexico: clean-lexico build-lexico


clean-sintaxis:
	rm -f sintaxis.c
	rm -f sintaxis.h
build-sintaxis:
	bison -d sintaxis.y -osintaxis.c
sintaxis: clean-sintaxis build-sintaxis


compile-analizer:
	gcc -oanalizador principal.c lexico.c sintaxis.c -lfl -ltds -I. -L.


build: clean-sintaxis build-sintaxis clean-lexico build-lexico compile-analizer


test:
	./analizador ./tests/tests.1.c  | diff ./tests/tests.1.out -
	./analizador ./tests/tests.2.c  | diff ./tests/tests.2.out -
	./analizador ./tests/tests.3.c  | diff ./tests/tests.3.out -
	./analizador ./tests/tests.4.c  | diff ./tests/tests.4.out -
	./analizador ./tests/tests.5.c  | diff ./tests/tests.5.out -
	./analizador ./tests/tests.6.c  | diff ./tests/tests.6.out -
	./analizador ./tests/tests.7.c  | diff ./tests/tests.7.out -
	./analizador ./tests/tests.8.c  | diff ./tests/tests.8.out -
	./analizador ./tests/tests.9.c  | diff ./tests/tests.9.out -
	./analizador ./tests/tests.10.c | diff ./tests/tests.10.out -
	./analizador ./tests/tests.11.c | diff ./tests/tests.11.out -
	./analizador ./tests/tests.12.c | diff ./tests/tests.12.out -
	./analizador ./lab_tests/a00.c  | diff ./lab_tests/a00.out -
	./analizador ./lab_tests/a01.c  | diff ./lab_tests/a01.out -
	./analizador ./lab_tests/a02.c  | diff ./lab_tests/a02.out -
	./analizador ./lab_tests/a03.c  | diff ./lab_tests/a03.out -
	./analizador ./lab_tests/b00.c  #| diff ./lab_tests/b00.out -
	./analizador ./lab_tests/b01.c  #| diff ./lab_tests/b01.out -
	./analizador ./lab_tests/b02.c  #| diff ./lab_tests/b02.out -
	./analizador ./lab_tests/b03.c  #| diff ./lab_tests/b03.out -


all: build test


clean: clean-lexico clean-sintaxis