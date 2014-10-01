lexico:
	rm -f lex.yy.c
	rm -f lexico
	flex lexico.l
	gcc lex.yy.c -lfl -o lexico

testlexico:
	rm -f lex.yy.c
	rm -f lexico
	flex lexico.l
	gcc lex.yy.c -lfl -o lexico
	./lexico tests.1.c | diff tests.1.out -
	./lexico tests.2.c | diff tests.2.out -
	./lexico tests.3.c | diff tests.3.out -
	./lexico tests.4.c | diff tests.4.out -
	./lexico tests.5.c | diff tests.5.out -

cleanlexico:
	rm -f lex.yy.c
	rm -f lexico