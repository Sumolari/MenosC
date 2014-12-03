%{
    #include <stdio.h>
    #include "header.h"
    #include "libtds.h"
    #include "libgci.h"

    /**
     * Comprueba que un identificador válido se corresponde con un símbolo de un
     * tipo dado.
     * @param  *nom          Nombre del símbolo a comprobar.
     * @param  tipo_esperado Tipo esperado para el símbolo.
     * @return               1 si tienen el mismo tipo. 0 de lo contrario.
     */
    int comprobarTipo( char *nom, int tipo_esperado );

    /**
     * Comprueba que ambos tipos son equivalantes, esto es, ambos son del mismo
     * tipo y NO son de tipo T_ERROR.
     * @param  tipo_1 Uno de los tipos a comprobar.
     * @param  tipo_2 Uno de los tipos a comprobar.
     * @return        1 si tienen el mismo tipo. 0 de lo contrario.
     */
    int tiposEquivalentes( int tipo_1, int tipo_2 );

    /**
     * Devuelve 1 si existe el símbolo en la tabla de símbolos ó 0 en caso
     * contrario.
     * @param  *nom Nombre del símbolo a comprobar.
     * @return      1 si el símbolo existe. 0 de lo contrario.
     */
    int existeTDS(char *nom);

    typedef struct {
        int tipo;
        int pos;
    } tipoYPos;
%}

%union
{
    char *ident;        /* Nombre del identificador         */
    int cent;           /* Valor de la cte numerica entera  */
    int unType;         /* Tipo de operador unario          */
    int tipo;           /* Tipo de la expresion             */
    int isInc;          /* Cantidad a incrementar           */
    tipoYPos tipoYPos;  /* Tipo y posicion de una expresion */
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
%token <unType> ADD_
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
%token <unType> NOT_
%token OR_
%token <unType> SUB_
%token <cent> TRUE_
%token <cent> FALSE_
%token CMNT_

%type <tipoYPos> simpleType
%type <tipoYPos> expression
%type <tipoYPos> equalityExpression
%type <tipoYPos> relationalExpression
%type <tipoYPos> additiveExpression
%type <tipoYPos> multiplicativeExpression
%type <tipoYPos> unaryExpression
%type <tipoYPos> suffixedExpression
%type <unType> unaryOperator

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
                    // En los identificadores solo los 14 primeros caracteres
                    // son significativos.
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
                       ID_ SQBROP_ expression SQBRCL_ ASSIGN_ expression
                                                                    SEMICOLON_ {
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

iterationInstruction: FOR_ PAOP_ optionalExpression SEMICOLON_ expression
                               SEMICOLON_ optionalExpression PACL_ instruction {
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
                    additiveExpression additiveOperator
                                                      multiplicativeExpression {
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
                          multiplicativeExpression multiplicativeOperator
                                                               unaryExpression {
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
                            if ( tiposEquivalentes( $2.tipo, T_LOGICO ) ) {
                                $$.tipo = T_LOGICO;
                                $$.pos = creaVarTemp();
                                // !id: inviertes el valor booleano.
                                emite(
                                    EDIF,
                                    crArgEnt( 1 ),
                                    crArgPos( $2.pos ),
                                    crArgPos( $$.pos )
                                );
                            } else {
                                $$.tipo = T_ERROR;
                            }
                        } else {
                            if ( tiposEquivalentes( $2, T_ENTERO ) ) {
                                $$.tipo = T_ENTERO;
                                $$.pos = creaVarTemp();
                                if ( $1 == NOP ) {
                                    // +expresion: no haces nada.
                                    emite(
                                        EASIG,
                                        crArgPos( $2.pos ),
                                        crArgNul(),
                                        crArgPos( $$.pos )
                                    );
                                } else {
                                    // -exp: cambias el signo.
                                    emite(
                                        ESIG,
                                        crArgPos( $2.pos ),
                                        crArgNul(),
                                        crArgPos( $$.pos )
                                    );
                                }
                            } else {
                                $$.tipo = T_ERROR;
                            }
                        }
                 } |
                 incrementOperator ID_ {
                        // Todas las variables deben declararse antes de ser
                        // utilizadas.
                        // Comprobar que el tipo es compatible.
                        if ( comprobarTipo( $2, T_ENTERO ) ) {
                            SIMB id = obtenerTDS( $2 );
                            $$.tipo = T_ENTERO;
                            $$.pos = creaVarTemp();
                            emite(
                                ESUM,
                                crArgPos( id.desp ),
                                crArgEnt( $1 ),
                                crArgPos( id.desp )
                            );
                            emite(
                                EASIG,
                                crArgPos( id.desp ),
                                crArgNul(),
                                crArgPos( $$.pos )
                            );
                        } else {
                            $$.tipo = T_ERROR;
                        }
                 };

suffixedExpression: ID_ SQBROP_ expression SQBRCL_ {
                        // Todas las variables deben declararse antes de ser
                        // utilizadas.
                        // Comprobar que el tipo es compatible.
                        if (
                            comprobarTipo( $1, T_ARRAY ) &&
                            tiposEquivalentes( $3.tipo, T_ENTERO )
                        ) {
                            SIMB id = obtenerTDS( $1 );
                            $$.tipo = id.telem;
                            $$.pos = creaVarTemp();
                            emite(
                                EAV,
                                crArgPos( id.desp ),
                                crArgPos( expresion.pos ),
                                crArgPos( $$.pos )
                            );
                        } else {
                            $$.tipo = T_ERROR;
                        }
                    } |
                    PAOP_ expression PACL_ {
                        $$.tipo = $2.tipo;
                        $$.pos  = $2.pos;
                    } |
                    ID_ {
                        // Todas las variables deben declararse antes de ser
                        // utilizadas.
                        // Comprobar que el tipo es compatible.
                        if ( existeTDS( $1 ) ) {
                            SIMB id = obtenerTDS( $1 );
                            $$.tipo = id.tipo;
                            $$.pos = creaVarTemp();
                            emite(
                                EASIG,
                                crArgPos( id.desp ),
                                crArgNul(),
                                crArgPos( $$.pos )
                            );
                        } else {
                            $$.tipo = T_ERROR;
                        }
                    } |
                    ID_ incrementOperator {
                        // TODO: ¿La semántica de esto es EXPRESION = ID++ ?
                        // Todas las variables deben declararse antes de ser
                        // utilizadas.
                        // Comprobar que el tipo es compatible.
                        if ( comprobarTipo( $1, T_ENTERO ) ) {
                            SIMB id = obtenerTDS ( ID_ );
                            $$.tipo = T_ENTERO;
                            $$.pos = creaVarTemp();
                            emite(
                                EASIG,
                                crArgPos( id.desp ),
                                crArgNul(),
                                crArgPos( $$.pos )
                            );
                            emite(
                                ESUM,
                                crArgPos( id.desp ),
                                crArgEnt( $2 ),
                                crArgPos( id.desp )
                            );
                        } else {
                            $$.tipo = T_ERROR;
                        }
                    } |
                    CTE_ {
                        $$.tipo = T_ENTERO;
                        $$.pos = creaVarTemp();
                        emite(
                            EASIG,
                            crArgEnt( CTE_ ),
                            crArgNul(),
                            crArgPos( $$.pos )
                        );
                    } |
                    TRUE_ { $$.tipo = T_LOGICO; } |
                    FALSE_ { $$.tipo = T_LOGICO; };

logicalOperator:        AND_  | OR_;
equalityOperator:       EQ_   | NEQ_;
relationalOperator:     GT_   | LT_ | GEQ_ | LEQ_;
additiveOperator:       ADD_  | SUB_;
multiplicativeOperator: MUL_  | DIV_;
unaryOperator:          ADD_ { $$ = NOP; } |
                        SUB_ { $$ = ESIG; } |
                        NOT_ { $$ = NOT; };
incrementOperator:      INC_ { $$ = 1; } | DEC_ { $$ = -1; };

%%

int tiposEquivalentes( int tipo_1, int tipo_2 ) {
    if ( tipo_1 == T_ERROR || tipo_2 == T_ERROR ) {
        return 0;
    } if ( tipo_1 == tipo_2 ) {
        return 1;
    } else {
        if ( verbosidad == TRUE ) {
            printf(
                "Tipo incompatible: se esperaba %d pero se ha encontrado %d\n",
                tipo_2,
                tipo_1
            );
        }
        yyerror( "Tipo incompatible" );
        return 0;
    }
}
/*****************************************************************************/
int existeTDS(char *nom) {
    SIMB s = obtenerTDS(nom);
    return s.tipo != T_ERROR;
}
/*****************************************************************************/
int comprobarTipo( char *nom, int tipo_esperado ) {

    if ( !existeTDS( nom ) ) {
        yyerror( "Variable no declarada" );
        return 0;
    }

    // Comprobar que el tipo no sea un error.
    if ( obtenerTDS( nom ).tipo == T_ERROR || tipo_esperado == T_ERROR ) {
        return 0;
    }

    // Comprobar que el tipo es compatible.
    if ( obtenerTDS( nom ).tipo != tipo_esperado ) {
        if ( verbosidad == TRUE ) {
            printf(
                "Tipo incompatible: se esperaba %d pero %s es %d\n",
                tipo_esperado,
                nom,
                obtenerTDS( nom ).tipo
            );
        }
        yyerror( "Tipo incompatible" );
        return 0;
    }
    return 1;
}
/*****************************************************************************/