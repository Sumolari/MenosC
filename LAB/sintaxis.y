%{
    #include <stdio.h>
    #include "header.h"
    #include "libtds.h"
%}

%union
{
    char *ident;  /* Nombre del identificador */
    int cent;     /* Valor de la cte numerica entera */
    int isNot;    /* Tipo de operador unario */
}

%error-verbose

%token <ident> ID_
%token SEMICOLON_
%token BROP_ BRCL_
%token INT_ FLOAT_
%token SQBROP_ SQBRCL_
%token ASSIGN_
%token READ_ PRINT_
%token PAOP_ PACL_
%token <isNot> ADD_
%token AND_
%token BOOL_
%token <cent> CTE_
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
%token <isNot> NOT_
%token OR_
%token <isNot> SUB_
%token <cent> TRUE_
%token <cent> FALSE_
%token CMNT_

%%

program: BROP_ statementsSequence BRCL_;

statementsSequence: statement | statementsSequence statement;

statement: declaration | instruction;

declaration: simpleType ID_ SEMICOLON_ {
                // En los identificadores solo los 14 primeros caracteres son
                // significativos.
                insertarTSimpleTDS( sub14( $2 ), $1, dvar );
                dvar += TALLA_TIPO_SIMPLE;
             } |
             simpleType ID_ SQBROP_ CTE_ SQBRCL_ SEMICOLON_ {
                // El número de elementos de un vector debe ser un entero
                // positivo.
                if ( $4 < 1 ) {
                    yyerror( "Numero de elementos invalido" );
                }
                // En los identificadores solo los 14 primeros caracteres son
                // significativos.
                insertarTVectorTDS( sub14( $2 ), T_ARRAY, dvar, $1, $4 );
                dvar += $4 * TALLA_TIPO_SIMPLE;
             };

simpleType: INT_ {
                $$ = T_ENTERO
            } |
            BOOL_ {
                $$ = T_LOGICO
            };

instructionList: | instructionList instruction;

instruction: BROP_ instructionList BRCL_ |
             assignmentInstruction |
             inputOutputInstruction |
             selectionInstruction |
             iterationInstruction;

assignmentInstruction: ID_ ASSIGN_ expression SEMICOLON_ {
                            // Todas las variables deben declararse antes de ser
                            // utilizadas.
                            // Comprobar que el tipo es compatible.
                            comprobarTipo( $1, $3 );
                       } |
                       ID_ SQBROP_ expression SQBRCL_ ASSIGN_ expression SEMICOLON_ {
                            // Todas las variables deben declararse antes de ser
                            // utilizadas.
                            // Comprobar que el tipo es compatible.
                            comprobarTipo( $1, $3 );
                       };

inputOutputInstruction: READ_ PAOP_ ID_ PACL_ SEMICOLON_ {
                            // Todas las variables deben declararse antes de ser
                            // utilizadas.
                            // Comprobar que el tipo es compatible.
                            //comprobarTipo( $3, $READ_ESPERADO );
                        } |
                        PRINT_ PAOP_ expression PACL_ SEMICOLON_ {
                            // Todas las variables deben declararse antes de ser
                            // utilizadas.
                            // Comprobar que el tipo es compatible.
                            //comprobarTipo( $3, $PRINT_ESPERADO );
                        };

selectionInstruction: IF_ PAOP_ expression PACL_ instruction ELSE_ instruction {
                            // Todas las variables deben declararse antes de ser
                            // utilizadas.
                            // Comprobar que el tipo es compatible.
                            comprobarTipo( $3, T_LOGICO );
                       };

iterationInstruction: FOR_ PAOP_ optionalExpression SEMICOLON_ expression SEMICOLON_ optionalExpression PACL_ instruction {
                            // Todas las variables deben declararse antes de ser
                            // utilizadas.
                            // Comprobar que el tipo es compatible.
                            comprobarTipo( $5, T_LOGICO );
                       };

optionalExpression: | expression | ID_ ASSIGN_ expression {
                        // Todas las variables deben declararse antes de ser
                        // utilizadas.
                        // Comprobar que el tipo es compatible.
                        comprobarTipo( $1, $3 );
                    };

expression: equalityExpression | expression logicalOperator equalityExpression {
                 // Todas las variables deben declararse antes de ser
                 // utilizadas.
                 // Comprobar que el tipo es compatible.
                 comprobarTipo( $1, T_LOGICO );
                 comprobarTipo( $3, T_LOGICO );
            };

equalityExpression: relationalExpression |
                    equalityExpression equalityOperator relationalExpression {
                        // Todas las variables deben declararse antes de ser
                        // utilizadas.
                        // Comprobar que el tipo es compatible.
                        comprobarTipo( $1, $3 );
                    };

relationalExpression: additiveExpression |
                    relationalExpression relationalOperator additiveExpression {
                        // Todas las variables deben declararse antes de ser
                        // utilizadas.
                        // Comprobar que el tipo es compatible.
                        comprobarTipo( $1, T_ENTERO );
                        comprobarTipo( $3, T_ENTERO );
                    };

additiveExpression: multiplicativeExpression |
                    additiveExpression additiveOperator multiplicativeExpression {
                         // Todas las variables deben declararse antes de ser
                         // utilizadas.
                         // Comprobar que el tipo es compatible.
                         comprobarTipo( $1, T_ENTERO );
                         comprobarTipo( $3, T_ENTERO );
                    };

multiplicativeExpression: unaryExpression |
                          multiplicativeExpression multiplicativeOperator unaryExpression {
                            // Todas las variables deben declararse antes de ser
                            // utilizadas.
                            // Comprobar que el tipo es compatible.
                            comprobarTipo( $1, T_ENTERO );
                            comprobarTipo( $3, T_ENTERO );
                         };

unaryExpression: suffixedExpression |
                 unaryOperator unaryExpression {
                        // Todas las variables deben declararse antes de ser
                        // utilizadas.
                        // Comprobar que el tipo es compatible.
                        if ( $2 ) {
                            comprobarTipo( $1, T_LOGICO );
                        } else {
                            comprobarTipo( $1, T_ENTERO );
                        }
                 } |
                 incrementOperator ID_ {
                        // Todas las variables deben declararse antes de ser
                        // utilizadas.
                        // Comprobar que el tipo es compatible.
                        comprobarTipo( $2, T_ENTERO );
                 };

suffixedExpression: ID_ SQBROP_ expression SQBRCL_ {
                        // Todas las variables deben declararse antes de ser
                        // utilizadas.
                        // Comprobar que el tipo es compatible.
                        if (
                            comprobarTipo( $2, T_ARRAY ) &&
                            comprobarTipo( $3, T_ENTERO )
                        ) {
                            SIMB s = obtenerTDS( sub14( $1 ) );
                            $$ = s.telem;
                        } else {
                            $$ = T_ERROR;
                        }
                    } |
                    PAOP_ expression PACL_ | { $$ = $2 }
                    ID_ {
                        // Todas las variables deben declararse antes de ser
                        // utilizadas.
                        // Comprobar que el tipo es compatible.
                        if ( existeTDS( sub14( $1 ) ) ) {
                            SIMB s = obtenerTDS( sub14( $1 ) );
                            $$ = s.tipo;
                        } else {
                            $$ = T_ERROR;
                        }
                    } |
                    ID_ incrementOperator {
                        // Todas las variables deben declararse antes de ser
                        // utilizadas.
                        // Comprobar que el tipo es compatible.
                        if ( comprobarTipo( $1, T_ENTERO ) ) {
                            $$ = T_ENTERO;
                        } else {
                            $$ = T_ERROR;
                        }
                    } |
                    CTE_ { $$ = T_ENTERO } |
                    TRUE_ { $$ = T_LOGICO } |
                    FALSE_ { $$ = T_LOGICO };

logicalOperator:        AND_  | OR_;
equalityOperator:       EQ_   | NEQ_;
relationalOperator:     GT_   | LT_ | GEQ_ | LEQ_;
additiveOperator:       ADD_  | SUB_;
multiplicativeOperator: MUL_  | DIV_;
unaryOperator:          ADD_  | SUB_ | NOT_;
incrementOperator:      INC_  | DEC_;

%%
