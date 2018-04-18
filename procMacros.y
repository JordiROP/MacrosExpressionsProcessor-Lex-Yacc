%{
#include <stdio.h>
#include <string.h>

struct node* newNode(char data[512]);
void doJob(char var, char sim, struct node *dat);
void printTree(struct node* node);
struct node* newNode(char data[512]);
void yyerror( char *m );
int yylex();


struct node{
        char sim;
        char var;
        char data[512];
        struct node *left;
        struct node *right;
    };
char tmp[512];
struct node *vars[123] = {NULL};
%}

%union{
    char s[512];
    struct node* exp;
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

expr_lst : expr_lst expr SEMICOLON  { doJob($2 -> var, $2 -> sim, $2); }
    | expr SEMICOLON                { doJob($1 -> var, $1 -> sim, $1); }
    ;

expr :
    VAR EQ expr         { $$ = $3; $$ -> var = $1[0]; $$ -> sim = '=';  }
    | expr OP expr      { $$ = newNode($2); $$ -> left = $1; $$ -> right = $3; }
    | OPAR expr CPAR    { strcpy(tmp, "(\0"); strcat(tmp, $2 -> data); strcat(tmp, ")\0"); $$ = newNode(tmp); }
    | VAR               {
                            if(vars[$1[0]] != NULL){
                                strcpy(tmp, "(\0");
                                strcat(tmp, vars[$1[0]] -> left -> data);
                                strcat(tmp, vars[$1[0]] -> data);
                                strcat(tmp, vars[$1[0]] -> right-> data);
                                strcat(tmp, ")\0");
                                $$ = newNode(tmp);
                            }else{ $$ = newNode($1); }
                        }
    | NUMBER            { $$ = newNode($1); printf("%s\n",$1); }
    | LAMDA idlist DOT expr { }
    ;

idlist: idlist VAR { }
    | VAR { }
%%

struct node* newNode(char data[512]){
  struct node* node = (struct node*)malloc(sizeof(struct node));

  strcpy(node -> data, data);
 
  node -> left = NULL;
  node -> right = NULL;
  return(node);
}

void printTree(struct node* node) { 
  if (node == NULL) return;
  printTree(node->left); 
  printf("%s ", node->data); 
  printTree(node->right); 
}
 
void doJob(char var, char sim, struct node* node){
    if(sim == '='){
        vars[var] = node;
    }else{
        printTree(node);
        printf("\n");
    }
}

void yyerror( char *m ) { fprintf( stderr, "%s\n", m ); }

int main() { return yyparse(); }
