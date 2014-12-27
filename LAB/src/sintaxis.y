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
     * @param  onlyCheck     0 (por defecto) para que imprima y cuente los
     *                       errores, 1 para que no imprima ni cuente errores.
     * @return               1 si tienen el mismo tipo. 0 de lo contrario.
     */
    int comprobarTipoExtended( char *nom, int tipo_esperado, int onlyCheck );

    /**
     * Comprueba que un identificador válido se corresponde con un símbolo de un
     * tipo dado. Imprime siempre mensaje de error.
     * @param  *nom          Nombre del símbolo a comprobar.
     * @param  tipo_esperado Tipo esperado para el símbolo.
     * @return               1 si tienen el mismo tipo. 0 de lo contrario.
     */
    int comprobarTipo( char *nom, int tipo_esperado );

    /**
     * Comprueba que un identificador válido se corresponde con un símbolo de un
     * tipo dado. No imprime nunca mensaje de error.
     * @param  *nom          Nombre del símbolo a comprobar.
     * @param  tipo_esperado Tipo esperado para el símbolo.
     * @return               1 si tienen el mismo tipo. 0 de lo contrario.
     */
    int comprobarTipoSilent( char *nom, int tipo_esperado );

    /**
     * Comprueba que ambos tipos son equivalantes, esto es, ambos son del mismo
     * tipo y NO son de tipo T_ERROR.
     * @param  tipo_1 Uno de los tipos a comprobar.
     * @param  tipo_2 Uno de los tipos a comprobar.
     * @param  onlyCheck     0 (por defecto) para que imprima y cuente los
     *                       errores, 1 para que no imprima ni cuente errores.
     * @return        1 si tienen el mismo tipo. 0 de lo contrario.
     */
    int tiposEquivalentesExtended( int tipo_1, int tipo_2, int onlyCheck );

    /**
     * Comprueba que ambos tipos son equivalantes, esto es, ambos son del mismo
     * tipo y NO son de tipo T_ERROR. Imprime siempre mensaje de error.
     * @param  tipo_1 Uno de los tipos a comprobar.
     * @param  tipo_2 Uno de los tipos a comprobar.
     * @return        1 si tienen el mismo tipo. 0 de lo contrario.
     */
    int tiposEquivalentes( int tipo_1, int tipo_2 );

    /**
     * Comprueba que ambos tipos son equivalantes, esto es, ambos son del mismo
     * tipo y NO son de tipo T_ERROR. No imprime nunca mensaje de error.
     * @param  tipo_1 Uno de los tipos a comprobar.
     * @param  tipo_2 Uno de los tipos a comprobar.
     * @return        1 si tienen el mismo tipo. 0 de lo contrario.
     */
    int tiposEquivalentesSilent( int tipo_1, int tipo_2 );

    /**
     * Devuelve 1 si existe el símbolo en la tabla de símbolos ó 0 en caso
     * contrario.
     * @param  *nom Nombre del símbolo a comprobar.
     * @return      1 si el símbolo existe. 0 de lo contrario.
     */
    int existeTDS( char *nom );

%}

%union
{
    char *ident;   /* Nombre del identificador          */
    int cent;      /* Valor de la cte numerica entera   */
    int unType;    /* Tipo de operador unario           */
    int tipo;      /* Tipo de la expresion              */
    int isInc;     /* Cantidad a incrementar            */
    int codOp;     /* Codigo de operacion a ejecutar    */
    struct {
        int tipo;
        int pos;
        int aux;
        int ini;
        int fin;
        int lv;
        int lf;
    } tipoYPos;  /* Tipo y posicion de una expresion  */
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

%type <tipoYPos> expression
%type <tipoYPos> optionalExpression
%type <tipoYPos> iterationInstruction
%type <tipoYPos> equalityExpression
%type <tipoYPos> relationalExpression
%type <tipoYPos> additiveExpression
%type <tipoYPos> multiplicativeExpression
%type <tipoYPos> unaryExpression
%type <tipoYPos> suffixedExpression
%type <unType> unaryOperator
%type <codOp> additiveOperator
%type <codOp> multiplicativeOperator
%type <codOp> equalityOperator
%type <codOp> relationalOperator
%type <cent> simpleType
%type <cent> incrementOperator
%type <cent> logicalOperator

%%

program: BROP_ statementsSequence BRCL_ {
            emite( FIN, crArgNul(), crArgNul(), crArgNul() );
        };

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
                            if ( comprobarTipo( $1, $3.tipo ) ) {
                                SIMB s = obtenerTDS( $1 );
                                emite(
                                    EASIG,
                                    crArgPos( $3.pos ),
                                    crArgNul(),
                                    crArgPos( s.desp )
                                );
                            }
                       } |
                       ID_ SQBROP_ expression SQBRCL_ ASSIGN_ expression
                                                                    SEMICOLON_ {
                            // Todas las variables deben declararse antes de ser
                            // utilizadas.
                            // Comprobar que el tipo es compatible.
                            if (
                                comprobarTipo( $1, T_ARRAY ) &&
                                tiposEquivalentes( $3.tipo, T_ENTERO )
                            ) {
                                SIMB s = obtenerTDS( $1 );
                                tiposEquivalentes( $6.tipo, s.telem );
                            }
                       };

inputOutputInstruction: READ_ PAOP_ ID_ PACL_ SEMICOLON_ {
                            // Todas las variables deben declararse antes de ser
                            // utilizadas.
                            // Comprobar que el tipo es compatible.
                            if ( comprobarTipo( $3, T_ENTERO ) ) {
                                SIMB s = obtenerTDS( $3 );
                                emite(
                                    EREAD,
                                    crArgNul(),
                                    crArgNul(),
                                    crArgPos( s.desp )
                                );
                            }
                        } |
                        PRINT_ PAOP_ expression PACL_ SEMICOLON_ {
                            // Todas las variables deben declararse antes de ser
                            // utilizadas.
                            // Comprobar que el tipo es compatible.
                            if ( tiposEquivalentes( $3.tipo, T_ENTERO ) ) {
                                emite(
                                    EWRITE,
                                    crArgNul(),
                                    crArgNul(),
                                    crArgPos( $3.pos )
                                );
                            }
                        };

selectionInstruction:   IF_ PAOP_ expression PACL_ {
                            // Todas las variables deben declararse antes de ser
                            // utilizadas.
                            // Comprobar que el tipo es compatible.
                            if ( tiposEquivalentes( $3.tipo, T_LOGICO ) ) {
                                $<tipoYPos>$.lf = creaLans( si );
                                emite(
                                    EIGUAL,
                                    crArgPos( $3.pos ),
                                    crArgEnt( 0 ),
                                    crArgEnt( $<tipoYPos>$.lf )
                                );
                            }
                        } instruction {
                            // Todas las variables deben declararse antes de ser
                            // utilizadas.
                            // Comprobar que el tipo es compatible.
                            if ( tiposEquivalentesSilent( $3.tipo, T_LOGICO ) )
                            {
                                $<tipoYPos>$.fin = creaLans( si );
                                emite(
                                    GOTOS,
                                    crArgNul(),
                                    crArgNul(),
                                    crArgEnt( $<tipoYPos>$.fin )
                                );
                                completaLans( $<tipoYPos>5.lf, crArgEtq( si ) );
                            }
                        } ELSE_ instruction {
                            // Todas las variables deben declararse antes de ser
                            // utilizadas.
                            // Comprobar que el tipo es compatible.
                            if ( tiposEquivalentesSilent( $3.tipo, T_LOGICO ) )
                            {
                                completaLans( $<tipoYPos>7.fin, crArgEtq( si) );
                            }
                       };

iterationInstruction:   FOR_ PAOP_ optionalExpression SEMICOLON_ {
                            $<tipoYPos>$.ini = si;
                        } expression SEMICOLON_ {
                            // Todas las variables deben declararse antes de ser
                            // utilizadas.
                            // Comprobar que el tipo es compatible.
                            if ( tiposEquivalentes( $6.tipo, T_LOGICO ) ) {
                                $<tipoYPos>$.lv = creaLans( si );
                                emite(
                                    EIGUAL,
                                    crArgPos( $6.pos ),
                                    crArgEnt( 1 ),
                                    crArgEtq( $<tipoYPos>$.lv )
                                );
                                $<tipoYPos>$.lf = creaLans( si );
                                emite(
                                    GOTOS,
                                    crArgNul(),
                                    crArgNul(),
                                    crArgEtq( $<tipoYPos>$.lf )
                                );
                                $<tipoYPos>$.aux = si;
                                $<tipoYPos>$.ini = $<tipoYPos>5.ini;
                            }
                        } optionalExpression PACL_ {
                            // Todas las variables deben declararse antes de ser
                            // utilizadas.
                            // Comprobar que el tipo es compatible.
                            if ( tiposEquivalentesSilent( $6.tipo, T_LOGICO ) )
                            {
                                emite(
                                    GOTOS,
                                    crArgNul(),
                                    crArgNul(),
                                    crArgEnt( $<tipoYPos>8.ini )
                                );
                                completaLans( $<tipoYPos>8.lv, crArgEtq( si ) );
                                $<tipoYPos>$.ini = $<tipoYPos>8.ini;
                                $<tipoYPos>$.aux = $<tipoYPos>8.aux;
                                $<tipoYPos>$.lv  = $<tipoYPos>8.lv;
                                $<tipoYPos>$.lf  = $<tipoYPos>8.lf;
                            }
                        } instruction {
                            // Todas las variables deben declararse antes de ser
                            // utilizadas.
                            // Comprobar que el tipo es compatible.
                            if ( tiposEquivalentesSilent( $6.tipo, T_LOGICO ) )
                            {
                                emite(
                                    GOTOS,
                                    crArgNul(),
                                    crArgNul(),
                                    crArgEnt(  $<tipoYPos>11.aux )
                                );
                                completaLans( $<tipoYPos>11.lf, crArgEtq( si) );
                            }
                        };

optionalExpression: | expression {
                        $$.tipo = $1.tipo;
                        $$.pos  = $1.pos;
                    } | ID_ ASSIGN_ expression {
                        // Todas las variables deben declararse antes de ser
                        // utilizadas.
                        // Comprobar que el tipo es compatible.
                        if ( comprobarTipo( $1, $3.tipo ) ) {
                            SIMB id = obtenerTDS( $1 );
                            emite(
                                EASIG,
                                crArgPos( $3.pos ),
                                crArgNul(),
                                crArgPos( id.desp )
                            );
                        }
                    };

expression: equalityExpression {
                $$.tipo = $1.tipo;
                $$.pos  = $1.pos;
            } |
            expression logicalOperator equalityExpression {
                // Todas las variables deben declararse antes de ser
                // utilizadas.
                // Comprobar que el tipo es compatible.
                if (
                   tiposEquivalentes( $1.tipo, T_LOGICO ) &&
                   tiposEquivalentes( $3.tipo, T_LOGICO )
                ) {
                    $$.tipo = T_LOGICO;
                    $$.pos  = creaVarTemp();
                    $$.aux  = creaLans( si );

                    emite(
                        EASIG,
                        crArgEnt( $2 ),
                        crArgNul(),
                        crArgPos( $$.pos )
                    );

                    emite(
                        EIGUAL,
                        crArgPos( $1.pos ),
                        crArgEnt( $2 ),
                        crArgEtq( $$.aux )
                    );

                    emite(
                        EIGUAL,
                        crArgPos( $3.pos ),
                        crArgEnt( $2 ),
                        crArgEtq( $$.aux )
                    );

                    emite(
                        EASIG,
                        crArgEnt( 1 - $2 ),
                        crArgNul(),
                        crArgPos( $$.pos )
                    );

                    completaLans( $$.aux, crArgEtq( si ) );
                } else {
                    $$.tipo = T_ERROR;
                }
            };

equalityExpression: relationalExpression {
                        $$.tipo = $1.tipo;
                        $$.pos  = $1.pos;
                    } |
                    equalityExpression equalityOperator relationalExpression {
                        // Todas las variables deben declararse antes de ser
                        // utilizadas.
                        // Comprobar que el tipo es compatible.
                        if ( tiposEquivalentes( $1.tipo, $3.tipo ) ) {
                            $$.tipo = T_LOGICO;
                            $$.pos  = creaVarTemp();

                            // Por defecto asumimos que SON iguales...
                            emite(
                                EASIG,
                                crArgEnt( 1 ),
                                crArgNul(),
                                crArgPos( $$.pos )
                            );

                            $$.aux  = creaLans( si );
                            // Si son iguales, salto...
                            emite(
                                $2,
                                crArgPos( $1.pos ),
                                crArgPos( $3.pos ),
                                crArgEtq( $$.aux )
                            );

                            // Si NO son iguales NO habré saltado y lo pongo 0.
                            emite(
                                EASIG,
                                crArgEnt( 0 ),
                                crArgNul(),
                                crArgPos( $$.pos )
                            );

                            completaLans( $$.aux, crArgEtq( si ) );

                        } else {
                            $$.tipo = T_ERROR;
                        }
                    };

relationalExpression:   additiveExpression {
                            $$.tipo = $1.tipo;
                            $$.pos  = $1.pos;
                        } |
                        relationalExpression relationalOperator
                                                            additiveExpression {
                            // Todas las variables deben declararse antes de ser
                            // utilizadas.
                            // Comprobar que el tipo es compatible.
                            if (
                                tiposEquivalentes( $1.tipo, T_ENTERO ) &&
                                tiposEquivalentes( $3.tipo, T_ENTERO )
                            ) {
                                $$.tipo = T_LOGICO;
                                $$.pos = creaVarTemp();

                                emite(
                                    EASIG,
                                    crArgEnt( 0 ),
                                    crArgNul(),
                                    crArgPos( $$.pos )
                                );

                                $$.aux = creaLans( si );

                                // Si la condicion no se cumple, salto despues.
                                emite(
                                    $2,
                                    crArgPos( $1.pos ),
                                    crArgPos( $3.pos ),
                                    crArgEtq( $$.aux )
                                );

                                // Si la condicion SI se cumple, actualizo valor
                                emite(
                                    EASIG,
                                    crArgEnt( 1 ),
                                    crArgNul(),
                                    crArgPos( $$.pos )
                                );

                                completaLans( $$.aux, crArgEtq( si ) );
                            } else {
                                $$.tipo = T_ERROR;
                            }
                        };

additiveExpression: multiplicativeExpression {
                        $$.tipo = $1.tipo;
                        $$.pos  = $1.pos;
                    } |
                    additiveExpression additiveOperator
                                                      multiplicativeExpression {
                        // Todas las variables deben declararse antes de ser
                        // utilizadas.
                        // Comprobar que el tipo es compatible.
                        if (
                            tiposEquivalentes( $1.tipo, T_ENTERO ) &&
                            tiposEquivalentes( $3.tipo, T_ENTERO )
                        ) {
                            $$.tipo = T_ENTERO;
                            $$.pos = creaVarTemp();
                            emite(
                                $2,
                                crArgPos( $1.pos ),
                                crArgPos( $3.pos ),
                                crArgPos( $$.pos )
                            );
                        } else {
                            $$.tipo = T_ERROR;
                        }
                    };

multiplicativeExpression:   unaryExpression {
                              $$.tipo = $1.tipo;
                              $$.pos  = $1.pos;
                            } |
                            multiplicativeExpression multiplicativeOperator
                                                               unaryExpression {
                                // Todas las variables deben declararse antes de
                                // ser utilizadas.
                                // Comprobar que el tipo es compatible.
                                if (
                                    tiposEquivalentes( $1.tipo, T_ENTERO ) &&
                                    tiposEquivalentes( $3.tipo, T_ENTERO )
                                ) {
                                    $$.tipo = T_ENTERO;
                                    $$.pos  = creaVarTemp();
                                    emite(
                                        $2,
                                        crArgPos( $1.pos ),
                                        crArgPos( $3.pos ),
                                        crArgPos( $$.pos )
                                    );
                                } else {
                                    $$.tipo = T_ERROR;
                                }
                            };

unaryExpression:    suffixedExpression {
                        $$.tipo = $1.tipo;
                        $$.pos  = $1.pos;
                    } |
                    unaryOperator unaryExpression {
                        // Todas las variables deben declararse antes de ser
                        // utilizadas.
                        // Comprobar que el tipo es compatible.
                        if ( $1 == NOT ) {
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
                            if ( tiposEquivalentes( $2.tipo, T_ENTERO ) ) {
                                $$.tipo = T_ENTERO;
                                $$.pos  = creaVarTemp();
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
                                crArgPos( $3.pos ),
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
                            SIMB id = obtenerTDS ( $1 );
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
                            crArgEnt( $1 ),
                            crArgNul(),
                            crArgPos( $$.pos )
                        );
                    } |
                    TRUE_ { $$.tipo = T_LOGICO; } |
                    FALSE_ { $$.tipo = T_LOGICO; };

logicalOperator:        AND_ { $$ = 0; }      | OR_  { $$ = 1; } ; // Jarcode xd
equalityOperator:       EQ_  { $$ = EIGUAL; } | NEQ_ { $$ = EDIST; };
relationalOperator:     GT_  { $$ = EMENEQ; } | LT_  { $$ = EMAYEQ; }  |
                        GEQ_ { $$ = EMEN; }   | LEQ_ { $$ = EMAY; };
additiveOperator:       ADD_ { $$ = ESUM; }   | SUB_ { $$ = EDIF; };
multiplicativeOperator: MUL_ { $$ = EMULT; }  | DIV_ { $$ = EDIVI; };
unaryOperator:          ADD_ { $$ = NOP; }    | SUB_ { $$ = ESIG; } |
                        NOT_ { $$ = NOT; };
incrementOperator:      INC_ { $$ = 1; }      | DEC_ { $$ = -1; };

%%

/*****************************************************************************/
int tiposEquivalentes( int tipo_1, int tipo_2 ) {
    tiposEquivalentesExtended( tipo_1, tipo_2, 0 );
}

int tiposEquivalentesSilent( int tipo_1, int tipo_2 ) {
    tiposEquivalentesExtended( tipo_1, tipo_2, 1 );
}

int tiposEquivalentesExtended( int tipo_1, int tipo_2, int onlyCheck ) {
    if ( tipo_1 == T_ERROR || tipo_2 == T_ERROR ) {
        return 0;
    } if ( tipo_1 == tipo_2 ) {
        return 1;
    } else {
        if ( onlyCheck ) return 0;

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
int existeTDS( char *nom ) {
    SIMB s = obtenerTDS(nom);
    return s.tipo != T_ERROR;
}
/*****************************************************************************/
int comprobarTipo( char *nom, int tipo_esperado ) {
    comprobarTipoExtended( nom, tipo_esperado, 0 );
}

int comprobarTipoSilent( char *nom, int tipo_esperado ) {
    comprobarTipoExtended( nom, tipo_esperado, 1 );
}

int comprobarTipoExtended( char *nom, int tipo_esperado, int onlyCheck ) {

    if ( !existeTDS( nom ) ) {
        if ( onlyCheck ) return 0;
        yyerror( "Variable no declarada" );
        return 0;
    }

    // Comprobar que el tipo no sea un error.
    if ( obtenerTDS( nom ).tipo == T_ERROR || tipo_esperado == T_ERROR ) {
        return 0;
    }

    // Comprobar que el tipo es compatible.
    if ( obtenerTDS( nom ).tipo != tipo_esperado ) {
        if ( onlyCheck ) return 0;

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