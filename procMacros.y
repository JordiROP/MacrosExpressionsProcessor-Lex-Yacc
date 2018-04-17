%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

void doJob(char str[512]);
void yyerror( char *m );
int yylex();

char vars[123][512] = {{"\0"}};
%}

%union{
    char s[512];
}

%type <s> expr

%token <s> VAR
%token <s> NUMBER
%token <s> OP
%token <s> OPAR CPAR

%token EQ
%token SEMICOLON
%left EQ
%left OP
%%

expr_lst : expr_lst expr SEMICOLON  { doJob($2); }
    | expr SEMICOLON                { doJob($1); }
    ;

expr :
    VAR EQ expr         { strcpy($$, $1); strcat($$,"="); strcat($$, $3); strcat($$,"\0"); }
    | expr OP expr      { strcpy($$, $1); strcat($$, $2); strcat($$, $3); strcat($$, "\0"); }
    | OPAR expr CPAR    { strcpy($$, $1); strcat($$, $2); strcat($$, $3); strcat($$, "\0"); }
    | VAR               { 
                            if(vars[$1[0]][0] != '\0'){ 
                                strcpy($$, "(\0");                                
                                strcat($$, vars[$1[0]]); 
                                strcat($$, ")\0"); 
                            }else{ strcpy($$, $1); }
                        }
    | NUMBER            { strcpy($$, $1); }
    ;
%%

char *getValue(char str[512]){
    int i = 2;
    static char value[512];

    for(; str[i] != '\0'; i++){
        value[i-2] = str[i];
    }
    value[i-2] = '\0';

    return value;
}

void doJob(char str[512]){
    if(str[1] == '='){
        char var = str[0];
        strcpy(vars[var], getValue(str));
    }else{
        printf("%s\n",str);
    }
}

void yyerror( char *m ) { fprintf( stderr, "%s\n", m ); }

int main() { return yyparse(); }
