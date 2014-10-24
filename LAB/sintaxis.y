%{
	#include <stdio.h>
	extern int yylineno;
%}

%error-verbose

%token ID_ SEMICOLON_
%token BROP_ BRCL_
%token INT_ FLOAT_
%token SQBROP_ SQBRCL_
%token ASSIGN_
%token READ_ PRINT_
%token PAOP_ PACL_
%token ADD_
%token AND_
%token BOOL_
%token CTE_
%token DEC_
%token DIV_
%token ELSE_
%token EQ_
%token FOR_
%token GEQ_
%token GT_
%token IF_
%token INC_
%token LEQ_
%token LT_
%token MUL_
%token NEQ_
%token NOT_
%token OR_
%token SUB_
%token TRUE_
%token FALSE_
%token CMNT_

%%

programa: BROP_ secuenciaSentencias BRCL_;

secuenciaSentencias: sentencia | secuenciaSentencias sentencia;

sentencia: declaracion | instruccion;

declaracion: tipoSimple ID_ SEMICOLON_ |
             tipoSimple ID_ SQBROP_ CTE_ SQBRCL_ SEMICOLON_;

tipoSimple: INT_ | BOOL_;

listaInstrucciones: | listaInstrucciones instruccion;

instruccion: BROP_ listaInstrucciones BRCL_ |
             instruccionAsignacion |
             instruccionEntradaSalida |
             instruccionSeleccion |
             instruccionIteracion;

instruccionAsignacion: ID_ ASSIGN_ expresion SEMICOLON_ |
                       ID_ SQBROP_ expresion SQBRCL_ ASSIGN_ expresion SEMICOLON_;

instruccionEntradaSalida: READ_ PAOP_ ID_ PACL_ SEMICOLON_ |
                          PRINT_ PAOP_ expresion PACL_ SEMICOLON_;

instruccionSeleccion: IF_ PAOP_ expresion PACL_ instruccion ELSE_ instruccion;

instruccionIteracion: FOR_ PAOP_ expresionOpcional SEMICOLON_ expresion SEMICOLON_ expresionOpcional PACL_ instruccion;

expresionOpcional: | expresion | ID_ ASSIGN_ expresion;

expresion: expresionIgualdad | expresion operadorLogico expresionIgualdad;

expresionIgualdad: expresionRelacional |
                   expresionIgualdad operadorIgualdad expresionRelacional;

expresionRelacional: expresionAditiva |
                     expresionRelacional operadorRelacional expresionAditiva;

expresionAditiva: expresionMultiplicativa |
                  expresionAditiva operadorAditivo expresionMultiplicativa;

expresionMultiplicativa: expresionUnaria |
                         expresionMultiplicativa operadorMultiplicativo expresionUnaria;

expresionUnaria: expresionSufija |
                 operadorUnario expresionUnaria |
                 operadorIncremento ID_;

expresionSufija: ID_ SQBROP_ expresion SQBRCL_ |
                 PAOP_ expresion PACL_ |
                 ID_ |
                 ID_ operadorIncremento |
                 CTE_ | TRUE_ | FALSE_;

operadorLogico: AND_ | OR_;
operadorIgualdad: EQ_ | NEQ_;
operadorRelacional: GT_ | LT_ | GEQ_ | LEQ_;
operadorAditivo: ADD_ | SUB_;
operadorMultiplicativo: MUL_ | DIV_;
operadorUnario: ADD_ | SUB_ | NOT_;
operadorIncremento: INC_ | DEC_;

%%

/**
 * Llamada por yyparse ante un error
 * @param {char*} s Mensaje de error.
 */
yyerror( char *s )
{
	printf( "Linea %d: %s\n", yylineno, s );
}