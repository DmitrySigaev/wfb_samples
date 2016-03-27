%{
#include <math.h>  /* �������������� �������: cos(), sin() � �.�. */
#include "calc.h"  /* �������� ����������� `symrec'               */
%}


%token <val>  NUM        /* ������� ����� ������� ��������   */
%token <tptr> VAR FNCT   /* ���������� � �������             */
%type  <val>  exp

%union {
    double     val;  /* ����� ���������� �����.                     */
    symrec_t  *tptr;   /* ����� ���������� ��������� ������� �������� */
}

%right '='
%left '-' '+'
%left '*' '/'
%left NEG     /* ��������� -- ������� ����� */
%right '^'    /* ���������� � �������       */

/* ����� ������� ���������� */

%%

input:   /* ����� */
        | input line
;

line:
          '\n'
        | exp '\n'   { printf ("\t%.10g\n", $1); }
        | error '\n' { yyerrok;                  }
;

exp:      NUM                { $$ = $1;                         }
        | VAR                { $$ = $1->value.var;              }
        | VAR '=' exp        { $$ = $3; $1->value.var = $3;     }
        | FNCT '(' exp ')'   { $$ = (*($1->value.fnctptr))($3); }
        | exp '+' exp        { $$ = $1 + $3;                    }
        | exp '-' exp        { $$ = $1 - $3;                    }
        | exp '*' exp        { $$ = $1 * $3;                    }
        | exp '/' exp        { $$ = $1 / $3;                    }
        | '-' exp  %prec NEG { $$ = -$2;                        }
        | exp '^' exp        { $$ = pow ($1, $3);               }
        | '(' exp ')'        { $$ = $2;                         }
;
/* End of grammar */
%%