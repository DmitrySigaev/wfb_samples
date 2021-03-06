/* ����������� �������� �������� �������. */
/* Reverse polish notation calculator */

%{
#define YYSTYPE double
#include <math.h>
#include <stdio.h>
  int yylex (void); /* fix warning */
  void yyerror (char const *);
%}

%token NUM

%% /* ����� ������� ������� ���������� � �������� */
/* Grammar rules and actions follow */

input:    /* ����� */    /* empty */
        | input line     /* A complete input is either an empty string, or a complete input followed by an input line. */
;

line:     '\n'
        | exp '\n'  { printf ("\t%.10g\n", $1); }
;

exp:      NUM             { $$ = $1;         }
        | exp exp '+'     { $$ = $1 + $2;    }
        | exp exp '-'     { $$ = $1 - $2;    }
        | exp exp '*'     { $$ = $1 * $2;    }
        | exp exp '/'     { $$ = $1 / $2;    }
      /* ���������� � ������� */ /* Exponentiation */
        | exp exp '^'     { $$ = pow ($1, $2); }
      /* ������� �����        */ /* Unary minus    */
        | exp 'n'         { $$ = -$1;        }
;
%%
