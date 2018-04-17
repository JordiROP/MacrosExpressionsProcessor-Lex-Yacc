%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

void doJob(char var, char sim ,char str[512]);
void yyerror( char *m );
int yylex();

struct node{
  int data;
  struct node *left;
  struct node *right;
};

char vars[123][512] = {{"\0"}};
%}

%union{
    char s[512];
    struct shape{
      char var;
      char sim;
      char macr[512];
    }exp;
}

%type <exp> expr

%token <s> VAR
%token <s> NUMBER
%token <s> OP
%token <s> OPAR CPAR

%token EQ LAMDA DOT
%token SEMICOLON

%left DOT
%left EQ
%left OP
%%

expr_lst : expr_lst expr SEMICOLON  { doJob($2.var, $2.sim, $2.macr); }
    | expr SEMICOLON                { doJob($1.var, $1.sim, $1.macr); }
    ;

expr :
    VAR EQ expr         { $$.var = $1[0]; $$.sim = '='; strcpy($$.macr, $3.macr); strcat($$.macr,"\0"); }
    | expr OP expr      { strcpy($$.macr, $1.macr); strcat($$.macr, $2); strcat($$.macr, $3.macr); strcat($$.macr, "\0"); }
    | OPAR expr CPAR    { strcpy($$.macr, "$1"); strcat($$.macr, $2.macr); strcat($$.macr, "$3"); strcat($$.macr, "\0"); }
    | VAR               {
                            if(vars[$1[0]][0] != '\0'){
                                strcpy($$.macr, "(\0");
                                strcat($$.macr, vars[$1[0]]);
                                strcat($$.macr, ")\0");
                            }else{ strcpy($$.macr, $1); }
                        }
    | NUMBER            { strcpy($$.macr, $1); }
    | LAMDA idlist DOT expr { }
    ;

idlist: idlist VAR { }
    | VAR { }
%%

void doJob(char var, char sim, char str[512]){
    if(sim == '='){
        strcpy(vars[var], str);
    }else{
        printf("%s\n",str);
    }
}

void yyerror( char *m ) { fprintf( stderr, "%s\n", m ); }

int main() { return yyparse(); }
