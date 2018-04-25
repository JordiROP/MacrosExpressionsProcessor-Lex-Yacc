%{
#include <stdio.h>
#include <string.h>
#include <ctype.h>

struct node* newNode(char data[512]);

void doJob(char var, char sim, struct node *dat);
void printTree(struct node* node);
void printLamda(struct node* node,char* idlistNode, char *idlistlamda);
int isMacro(struct node* node);
int isLamda(struct node* node);
void yyerror( char *m );
int yylex();


struct node{
        char sim;
        char var;
        int isLamda;
        char idlist[512];
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
%type <s> idlist
%token <s> VAR
%token <s> NUMBER
%token <s> OP
%token <s> OPAR CPAR
%token EQ LAMDA DOT COMMA
%token SEMICOLON

%left DOT
%left EQ
%left OP
%left VAR
%left COMMA
%%

expr_lst : expr_lst expr SEMICOLON  { doJob($2 -> var, $2 -> sim, $2); }
    | expr SEMICOLON                { doJob($1 -> var, $1 -> sim, $1); }
    ;

expr :
    VAR EQ expr         { $$ = $3; $$ -> var = $1[0]; $$ -> sim = '=';  }
    | expr OP expr      { $$ = newNode($2); $$ -> left = $1; $$ -> right = $3; }
    | OPAR expr CPAR    { strcpy(tmp, $1); strcat(tmp, $2 -> data); strcat(tmp, $3); $$ = newNode(tmp); }
    | VAR               { $$ = newNode($1);}
    | expr idlist       { $$ = $1; strcat($$->idlist, $2);}
    | NUMBER            { $$ = newNode($1);}
    | LAMDA idlist DOT expr { $$ = $4; $$->isLamda = 1; strcpy($$->idlist, $2);}
    ;

idlist: idlist COMMA VAR {strcpy($$, $1); strcat($$, $3); }
    | VAR { strcpy($$, $1); }
    ;
%%

struct node* newNode(char data[512]){
  struct node* node = (struct node*)malloc(sizeof(struct node));

  strcpy(node -> data, data);

  node -> left = NULL;
  node -> right = NULL;
  return(node);
}

void printLamda(struct node* node,char* idlistNode, char *idlistlamda){
  int i;
  if (node == NULL) return;
  printLamda(node->left, idlistNode, idlistlamda);
  for(i=0; idlistNode[i] != '\0'; i++){
    if(idlistNode[i] == node->data[0]){
      idlistNode[i] = idlistlamda[i];
      node->data[0] = idlistlamda[i];
    }
  }
  if(isMacro(node)){
    printf("(");
    printTree(vars[node->data[0]]);
    printf(")");
  }else{
    printf("%s", node->data);
  }
  printLamda(node->right, idlistNode, idlistlamda);
}

void printTree(struct node* node) {
  if (node == NULL) return;
  if(isMacro(node) && isLamda(node)){
    printLamda(vars[node->data[0]],vars[node->data[0]]->idlist, node->idlist);
  }else{
    printTree(node->left);
    if(isMacro(node)){
      printf("(");
      printTree(vars[node->data[0]]);
      printf(")");
    }else{
      printf("%s", node->data);
    }
    printTree(node->right);
  }
}

int isMacro(struct node* node){
  return (isalpha(node->data[0]) && vars[node->data[0]] != NULL);
}

int isLamda(struct node* node){
  return vars[node->data[0]]->isLamda == 1;
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
