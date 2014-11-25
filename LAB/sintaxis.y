%{
    #include <stdio.h>
    #include "header.h"
    #include "libtds.h"
%}

%union
{
    char *ident;  /* Nombre del identificador        */
    int cent;     /* Valor de la cte numerica entera */
    int isNot;    /* Tipo de operador unario         */
    int tipo;     /* Tipo de la expresion            */
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

%type <tipo> simpleType
%type <tipo> expression
%type <tipo> equalityExpression
%type <tipo> relationalExpression
%type <tipo> additiveExpression
%type <tipo> multiplicativeExpression
%type <tipo> unaryExpression
%type <tipo> suffixedExpression
%type <isNot> unaryOperator

%%

program: BROP_ statementsSequence BRCL_;

statementsSequence: statement | statementsSequence statement;

statement: declaration | instruction;

declaration: simpleType ID_ SEMICOLON_ {
				//yylval.ident = yytext
                // En los identificadores solo los 14 primeros caracteres son
                // significativos.

                // TODO: Verificar que la variable no existe ya.

                if ( insertarTSimpleTDS( $2, $1, dvar ) ) {
                    dvar += TALLA_TIPO_SIMPLE;
                } else {
                    yyerror( "Redeclaracion de variable" );
                }
             } |
             simpleType ID_ SQBROP_ CTE_ SQBRCL_ SEMICOLON_ {
                // El número de elementos de un vector debe ser un entero
                // positivo.
                if ( $4 < 1 ) {
                    yyerror( "Numero de elementos invalido" );
                    insertarTSimpleTDS( $2, T_ERROR, 0 );
                } else {
                    // En los identificadores solo los 14 primeros caracteres son
                    // significativos.
                    if ( insertarTVectorTDS( $2, T_ARRAY, dvar, $1, $4 ) ) {
                        dvar += $4 * TALLA_TIPO_SIMPLE;
                    } else {
                        yyerror( "Redeclaracion de variable" );
                    }
                }
             };

simpleType: INT_ {
                $$ = T_ENTERO;
            } |
            BOOL_ {
                $$ = T_LOGICO;
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
                            if (
                                comprobarTipo( $1, T_ARRAY ) &&
                                tiposEquivalentes( $3, T_ENTERO )
                            ) {
                                SIMB s = obtenerTDS( $1 );
                                tiposEquivalentes( $6, s.telem );
                            }
                       };

inputOutputInstruction: READ_ PAOP_ ID_ PACL_ SEMICOLON_ {
                            // Todas las variables deben declararse antes de ser
                            // utilizadas.
                            // Comprobar que el tipo es compatible.
                            comprobarTipo( $3, T_ENTERO );
                        } |
                        PRINT_ PAOP_ expression PACL_ SEMICOLON_ {
                            // Todas las variables deben declararse antes de ser
                            // utilizadas.
                            // Comprobar que el tipo es compatible.
                            tiposEquivalentes( $3, T_ENTERO );
                        };

selectionInstruction: IF_ PAOP_ expression PACL_ instruction ELSE_ instruction {
                            // Todas las variables deben declararse antes de ser
                            // utilizadas.
                            // Comprobar que el tipo es compatible.
                            tiposEquivalentes( $3, T_LOGICO );
                       };

iterationInstruction: FOR_ PAOP_ optionalExpression SEMICOLON_ expression SEMICOLON_ optionalExpression PACL_ instruction {
                            // Todas las variables deben declararse antes de ser
                            // utilizadas.
                            // Comprobar que el tipo es compatible.
                            tiposEquivalentes( $5, T_LOGICO );
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
                if (
                   tiposEquivalentes( $1, T_LOGICO ) &&
                   tiposEquivalentes( $3, T_LOGICO )
                ) {
                    $$ = T_LOGICO;
                } else {
                    $$ = T_ERROR;
                }
            };

equalityExpression: relationalExpression |
                    equalityExpression equalityOperator relationalExpression {
                        // Todas las variables deben declararse antes de ser
                        // utilizadas.
                        // Comprobar que el tipo es compatible.
                        if ( tiposEquivalentes( $1, $3 ) ) {
                            $$ = T_LOGICO;
                        } else {
                            $$ = T_ERROR;
                        }
                    };

relationalExpression: additiveExpression |
                    relationalExpression relationalOperator additiveExpression {
                        // Todas las variables deben declararse antes de ser
                        // utilizadas.
                        // Comprobar que el tipo es compatible.
                        if (
                            tiposEquivalentes( $1, T_ENTERO ) &&
                            tiposEquivalentes( $3, T_ENTERO )
                        ) {
                            $$ = T_LOGICO;
                        } else {
                            $$ = T_ERROR;
                        }
                    };

additiveExpression: multiplicativeExpression |
                    additiveExpression additiveOperator multiplicativeExpression {
                         // Todas las variables deben declararse antes de ser
                         // utilizadas.
                         // Comprobar que el tipo es compatible.
                         if (
                            tiposEquivalentes( $1, T_ENTERO ) &&
                            tiposEquivalentes( $3, T_ENTERO )
                        ) {
                            $$ = T_ENTERO;
                        } else {
                            $$ = T_ERROR;
                        }
                    };

multiplicativeExpression: unaryExpression |
                          multiplicativeExpression multiplicativeOperator unaryExpression {
                            // Todas las variables deben declararse antes de ser
                            // utilizadas.
                            // Comprobar que el tipo es compatible.
                            if (
                                tiposEquivalentes( $1, T_ENTERO ) &&
                                tiposEquivalentes( $3, T_ENTERO )
                            ) {
                                $$ = T_ENTERO;
                            } else {
                                $$ = T_ERROR;
                            }
                         };

unaryExpression: suffixedExpression |
                 unaryOperator unaryExpression {
                        // Todas las variables deben declararse antes de ser
                        // utilizadas.
                        // Comprobar que el tipo es compatible.
                        if ( $1 ) {
                            if ( tiposEquivalentes( $2, T_LOGICO ) ) {
                                $$ = T_LOGICO;
                            } else {
                                $$ = T_ERROR;
                            }
                        } else {
                            if ( tiposEquivalentes( $2, T_ENTERO ) ) {
                                $$ = T_ENTERO;
                            } else {
                                $$ = T_ERROR;
                            }
                        }
                 } |
                 incrementOperator ID_ {
                        // Todas las variables deben declararse antes de ser
                        // utilizadas.
                        // Comprobar que el tipo es compatible.
                        if ( comprobarTipo( $2, T_ENTERO ) ) {
                            $$ = T_ENTERO;
                        } else {
                            $$ = T_ERROR;
                        }
                 };

suffixedExpression: ID_ SQBROP_ expression SQBRCL_ {
                        // Todas las variables deben declararse antes de ser
                        // utilizadas.
                        // Comprobar que el tipo es compatible.
                        if (
                            comprobarTipo( $1, T_ARRAY ) &&
                            tiposEquivalentes( $3, T_ENTERO )
                        ) {
                            SIMB s = obtenerTDS( $1 );
                            $$ = s.telem;
                        } else {
                            $$ = T_ERROR;
                        }
                    } |
                    PAOP_ expression PACL_ { $$ = $2; } |
                    ID_ {
                        // Todas las variables deben declararse antes de ser
                        // utilizadas.
                        // Comprobar que el tipo es compatible.
                        if ( existeTDS( $1 ) ) {
                            SIMB s = obtenerTDS( $1 );
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
                    CTE_ { $$ = T_ENTERO; } |
                    TRUE_ { $$ = T_LOGICO; } |
                    FALSE_ { $$ = T_LOGICO; };

logicalOperator:        AND_  | OR_;
equalityOperator:       EQ_   | NEQ_;
relationalOperator:     GT_   | LT_ | GEQ_ | LEQ_;
additiveOperator:       ADD_  | SUB_;
multiplicativeOperator: MUL_  | DIV_;
unaryOperator:          ADD_  | SUB_ | NOT_;
incrementOperator:      INC_  | DEC_;

%%
