/* Infix notation calculator--calc */
/* ����������� ��� �������� � ��������� ������� -- calc */

%{
/*#define YYSTYPE double */
#include <math.h>
#include <stdio.h>
%}

%union {
double db;
char err;

}
/* BISON Declarations */
/* Operator precedence is determined by the line ordering of the declarations;
 the higher the line number of the declaration (lower on the page or screen), 
 the higher the precedence. Hence, exponentiation has the highest precedence,
 unary minus (NEG) is next, followed by `*' and `/', and so on. */
%token <db> NUM
%left '-' '+'
%left '*' '/'
%left NEG     /* negation--unary minus */ /* ��������� -- ������� ����� */
%right '^'    /* exponentiation        */ /* ���������� � �������       */

%type <db> exp
%type <err> error
/* Grammar follows */
/* ����� ������� ���������� */
%%
input:    /* empty string */ /* ������ ������ */
        | input line
;

line:     '\n'
        | exp '\n'  { printf ("\t%f\n", $1); } /* $2 ������ �� �����, ��� �� ����� ��� ������ union(���� �� ���� ������. '\n' �� ������) */
        | error '\n' { yyerrok;  printf ("\terror: %c\n", $1); /* $1 == '\0' */ } /* This addition to the grammar allows for simple error recovery in the event of a parse error. */
;

exp:      NUM                { $$ = $1;         }
        | exp '+' exp        { $$ = $1 + $3;    }
        | exp '-' exp        { $$ = $1 - $3;    }
        | exp '*' exp        { $$ = $1 * $3;    }
        | exp '/' exp        { $$ = $1 / $3;    }
        | '-' exp  %prec NEG { $$ = -$2;        }
        | exp '^' exp        { $$ = pow ($1, $3); }
        | '(' exp ')'        { $$ = $2;         }
;
%%