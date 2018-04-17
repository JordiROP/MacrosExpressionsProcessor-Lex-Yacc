
%option noyywrap

%{
#include "procMacros.tab.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
%}

%%

":=" {return EQ; }

";" { return SEMICOLON; }

"(" { strcpy(yylval.s, yytext); return OPAR; }

")" { strcpy(yylval.s, yytext); return CPAR; }

"+"|"-"|"*"|"/" { strcpy(yylval.s, yytext); return OP; }

"." { return DOT; }

"lamda" { return LAMDA; }

[0-9]+ { strcpy(yylval.s, yytext); return NUMBER; }

[a-zA-Z] { strcpy(yylval.s, yytext); return VAR; }

[ \t\r\n\f] { /* ignorar espais en blanc. */ }

. { printf("Illegal character: %s", yytext); }
