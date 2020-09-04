%lex

%%

\s+                                         /* skip whitespace */
"//".*                                      //'.*      /* skip comment */
[/][*][^*]*[*]+([^/*][^*]*[*]+)*[/]         /* IGNORE */

//RESERVADAS
"string"            return 'RSTRING';
"number"            return 'RNUMBER';
"boolean"           return 'RBOOLEAN';
"void"              return 'RVOID';
"type"              return 'RTYPE';
"push"              return 'RPUSH';
"pop"               return 'RPOP';
"length"            return 'RLENGTH';
"let"               return 'RLET';
"const"             return 'RCONST';
"if"                return 'RIF';
"else"              return 'RELSE';
"switch"            return 'RSWITCH';
"case"              return 'RCASE';
"default"           return 'RDEFAULT';
"while"             return 'RWHILE';
"do"                return 'RDO';
"for"               return 'RFOR';
"of"                return 'ROF';
"in"                return 'RIN';
"break"             return 'RBREAK';
"continue"          return 'RCONTINUE';
"null"              return 'RNULL';
"function"          return 'RFUNCTION';
"return"            return 'RRETURN';
"console"           return 'RCONSOLE';
"log"               return 'RLOG';
"graficar_ts"       return 'RGRAFICAR';

":"                 return ':';
"."                 return '.';
","                 return ',';
";"                 return ';';
"`"                 return '`';
"{"                 return '{';
"}"                 return '}';
"("                 return '(';
")"                 return ')';
"["                 return '[';
"]"                 return ']';

"+="                return '+=';
"-="                return '-=';
"*="                return '*=';
"/="                return '/=';
"%="                return '%='

"%"                 return '%';
"**"                return '**';
"++"                return '++';
"--"                return '--';
"+"                 return '+';
"-"                 return '-';
"*"                 return '*';
"/"                 return '/';

"<="                return '<=';
">="                return '>=';
"=="                return '==';
"!="                return '!=';
"<"                 return '<';
">"                 return '>';

"&&"                return '&&';
"||"                return '||';
"!"                 return '!';

"="                 return '=';

"?"                 return '?';
"$"                 return '$';

"\n"                return '\n';
"\t"                return '\t';


\"[^\"]*\"                  { yytext = yytext.substr(1,yyleng-2); return 'CADENA'; }
\'[^\'']*\'                 { yytext = yytext.substr(1,yyleng-2); return 'CADENA'; }

[0-9]+("."[0-9]+)?\b        return 'DECIMAL';
[0-9]+\b                    return 'ENTERO';
"false"|"true"              return 'BOOLEANO';
([a-zA-Z])[a-zA-Z0-9_]*     return 'ID';


<<EOF>>                     return 'EOF';

/lex

%right '+=' '-=' '*=' '/=' '%=' 
%left '||'
%left '&&'
%left '==' '!='
%left '<' '<=' '>' '>='
%left '+' '-'
%left '*' '/'
%left '%' '**'
%left UMENOS
%right '!'
%right '++' '--'

%start ini

%% /* Definición de la gramática */

ini 
    : instrucciones EOF
;

instrucciones
    : instrucciones instruccion
    | instruccion
;

instruccion
    : declaracion
    | declaracion_lista
    | asignacion
    | tipo
    | ternario
    | sent_if
    | sent_switch
    | bucle_while
    | bucle_dowhile
    | bucle_for
    | incremento ';'
    | decremento ';'
    | sent_break_continue
    | funcion
    | llamada_funcion ';'
    | sent_return
    | func_consolelog
    | func_graficar
    | arreglo_propiedades ';'
;

tipo_dato
    : RSTRING
    | RBOOLEAN
    | RNUMBER
    | RVOID
    | RTYPE
    | ID
;

tipo
    : RTYPE ID '=' '{' lista_tipos '}' 
;

acceso_type
    : acceso_type '.' ID
    | ID '.' ID
;

lista_tipos
    : lista_tipos ',' ID ':' ID
    | lista_tipos ',' ID ':' tipo_dato
    | lista_tipos ',' ID ':' dato
    | ID ':' ID
    | ID ':' tipo_dato
    | ID ':' dato
;

funcion
    : RFUNCTION ID '(' lista_params')' ':' tipo_dato '{' instrucciones '}'
    | RFUNCTION ID '(' lista_params')' ':' ID '{' instrucciones '}'
    | RFUNCTION ID '(' ')' ':' tipo_dato '{' instrucciones '}'
    | RFUNCTION ID '(' ')' ':' ID '{' instrucciones '}'
;

lista_params
    : lista_params ',' param
    | param
;

param
    : ID ':' ID dimensiones
    | ID ':' tipo_dato dimensiones
    | ID ':' ID
    | ID ':' tipo_dato
;

llamada_funcion
    : ID '(' list_operandos')'
    | ID '(' ')'
;

declaracion
    : RTYPE ID '=' '{' lista_tipos '}' 
    | RTYPE ID '=' '{' lista_tipos '}' ';'
    | RLET ID ':' tipo_dato '=' '{' lista_tipos '}'
    | RLET ID ':' tipo_dato '=' '{' lista_tipos '}' ';'
    | RLET ID ':' tipo_dato ';'
    | RLET ID ':' tipo_dato oper_asig expresion ';'
    | RLET ID ':' tipo_dato dimensiones ';'
    | RLET ID ':' tipo_dato dimensiones oper_asig '[' list_operandos']' ';'
    | RLET ID ':' tipo_dato dimensiones oper_asig '[' ']' ';'

    | RLET ID ';'
    | RLET ID oper_asig expresion ';'
    | RLET ID dimensiones ';'
    | RLET ID dimensiones oper_asig '[' list_operandos']' ';'
    | RLET ID dimensiones oper_asig '[' ']' ';'

    | RCONST ID ':' tipo_dato '=' expresion ';'
    | RCONST ID ':' tipo_dato '[' ']' '=' '[' list_operandos']' ';'
    | RCONST ID ':' tipo_dato dimensiones '=' '[' ']' ';'

    | RCONST ID '=' expresion ';'
    | RCONST ID '[' ']' '=' '[' list_operandos']' ';'
    | RCONST ID dimensiones '=' '[' ']' ';'
;

declaracion_lista
    : RLET lista_dec ';'
    | RCONST lista_dec ';'
;

lista_dec
    : lista_dec ',' ID '=' expresion
    | ID '=' expresion
;

acceso_arreglo
    : ID acceso_dimensiones
;

acceso_dimensiones
    : acceso_dimensiones '[' dato ']' 
    | '[' dato ']' 
;

dimensiones
    : dimensiones '[' ']'
    | '[' ']'
;

arreglo_propiedades
    : ID '.' RPOP '(' ')' 
    | ID '.' RPUSH '(' dato ')'
    | ID '.' RLENGTH

    | acceso_arreglo '.' RPOP '(' ')' 
    | acceso_arreglo '.' RPUSH '(' dato ')'
    | acceso_arreglo '.' RLENGTH
;

list_operandos
    : list_operandos ',' dato
    | dato
;

asignacion
    : ID oper_asig '{' lista_tipos2 '}'
    | ID oper_asig expresion ';'
    | acceso_arreglo oper_asig '[' ']' ';'
    | acceso_arreglo oper_asig expresion ';'
    | acceso_type oper_asig expresion ';'
;

oper_asig
    : '='
    | '+='
    | '-='
    | '*='
    | '/='
    | '%='
;

lista_tipos2
    : lista_tipos2 ',' ID ':' dato
    | ID ':' dato
;

ternario
    : expresion '?' expresion ':' expresion
;

sent_if
: RIF '(' expresion ')' '{' instrucciones '}' sent_else
| RIF '(' expresion ')' '{' instrucciones '}'
;

sent_else
    : RELSE sent_if
    | RELSE '{' instrucciones '}'
;

sent_switch
    : RSWITCH '(' expresion ')' '{' lista_cases '}'
;

lista_cases
    : lista_cases caso
    | caso
;

caso
    : RCASE expresion ':' instrucciones
    | RDEFAULT ':' instrucciones
    | RCASE expresion ':'
;

bucle_while
    : RWHILE '(' expresion ')' '{' instrucciones '}'
;

sent_break_continue
    : RBREAK ';'
    | RCONTINUE ';'
;

bucle_dowhile
    : RDO '{' instrucciones '}' RWHILE '(' expresion ')' ';'
;

bucle_for
    : RFOR '(' for_inicio ';' expresion ';'  incremento ')' '{' instrucciones '}'
    | RFOR '(' for_inicio ';' expresion ';'  decremento ')' '{' instrucciones '}'
;

for_inicio
    : RLET ID '=' expresion
    | ID '=' expresion
;

sent_return
    : RRETURN expresion ';'
    | RRETURN ';'
;

incremento
    : expresion '++'
;

decremento
    : expresion '--'
;

func_consolelog
    : RCONSOLE '.' RLOG '(' lista_params_console ')' ';'
;

lista_params_console
    : lista_params_console ',' expresion
    | expresion
;

func_graficar
    : RGRAFICAR '(' ')' ';'
;

expresion 
    : expresion '+' expresion
    | expresion '-' expresion
    | expresion '*' expresion
    | expresion '/' expresion
    | expresion '%' expresion
    | expresion '**' expresion
    | '-' expresion %prec UMENOS
    | incremento
    | decremento
    | expresion '+=' expresion
    | expresion '-=' expresion
    | expresion '*=' expresion
    | expresion '/=' expresion
    | expresion '%=' expresion
    | expresion '==' expresion
    | expresion '!=' expresion
    | expresion '>' expresion
    | expresion '<' expresion
    | expresion '>=' expresion
    | expresion '<=' expresion
    | expresion '&&' expresion
    | expresion '||' expresion
    | '!' expresion
    | '(' expresion ')'
    | dato
;

dato
    : llamada_funcion
    | acceso_arreglo
    | acceso_type
    | arreglo_propiedades
    | plantilla_cadena
    | ternario
    | escapes
    | ENTERO
    | DECIMAL
    | BOOLEANO
    | ID
    | CADENA
    | RNULL
;

plantilla_cadena
    : '`' lista_args_plantilla '`'
;

lista_args_plantilla
    : lista_args_plantilla marcador
    | lista_args_plantilla escapes
    | lista_args_plantilla ID
    | lista_args_plantilla simbolos
    | marcador
    | escapes
    | ID
    | simbolos
;

marcador
    : '$' '{' expresion '}'
;

escapes
    : '\n'
    | '\t'
;

simbolos
:':'
|','
|';'
|'('
|')'
|'['
|']'
|'+='
|'-='
|'*='
|'/='
|'%='
|'%'
|'**'
|'++'
|'--'
|'+'
|'-'
|'*'
|'/'
|'<='
|'>='
|'=='
|'!='
|'.'
|'<'
|'>'
|'&&'
|'||'
|'!'
|'='
|'?'
;