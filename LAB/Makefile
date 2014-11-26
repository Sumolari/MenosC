.PHONY: fresh clean all

build-lexico:
	flex -olexico.c src/lexico.l
	mv lexico.c tmp/
lexico: clean build-lexico


build-sintaxis:
	bison -osintaxis.c -d src/sintaxis.y
	mv sintaxis.c tmp/
	mv sintaxis.h tmp/
sintaxis: clean build-sintaxis


clean-analizer:
	rm -f analizador
compile-analizer:
	gcc -oanalizador src/principal.c tmp/lexico.c tmp/sintaxis.c \
	                                        -lfl -ltds -lgci -I./include -L./lib


build: clean build-sintaxis build-lexico compile-analizer


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
	#./analizador ./tests/tests.12.c | diff ./tests/tests.12.out -
	./analizador ./lab_tests/a00.c  | diff ./lab_tests/a00.out -
	./analizador ./lab_tests/a01.c  | diff ./lab_tests/a01.out -
	./analizador ./lab_tests/a02.c  | diff ./lab_tests/a02.out -
	./analizador ./lab_tests/a03.c  | diff ./lab_tests/a03.out -
	./analizador ./lab_tests/b00.c  | diff ./lab_tests/b00.out -
	./analizador ./lab_tests/b01.c  | diff ./lab_tests/b01.out -
	./analizador ./lab_tests/b02.c  | diff ./lab_tests/b02.out -
	./analizador ./lab_tests/b03.c  | diff ./lab_tests/b03.out -
	./analizador ./lab_tests/b04.c  | diff ./lab_tests/b04.out -
	#./analizador ./lab_tests/c00.c  | diff ./lab_tests/c00.out -
	#./analizador ./lab_tests/c01.c  | diff ./lab_tests/c01.out -
	#./analizador ./lab_tests/c02.c  | diff ./lab_tests/c02.out -
	#./analizador ./lab_tests/c03.c  | diff ./lab_tests/c03.out -
	#./analizador ./lab_tests/c04.c  | diff ./lab_tests/c04.out -
	#./analizador ./lab_tests/c05.c  | diff ./lab_tests/c05.out -
	#./analizador ./lab_tests/c06.c  | diff ./lab_tests/c06.out -


quicktest: clean build dotest
quicklabtest: clean build dolabtest


dotest:
	./analizador ./tests/$(TEST).c  | diff ./tests/$(TEST).out -
dolabtest:
	./analizador ./lab_tests/$(TEST).c  | diff ./lab_tests/$(TEST).out -


clean-tmp:
	rm -f tmp/*
clean: clean-tmp clean-analizer


all: clean build test