/* YACC Specification for MINI C PARSER */
%{
#include <stdio.h>
#include <stdlib.h>
extern FILE *fp;
int err=0;
%}

%token INT FLOAT CHAR DOUBLE VOID
%token FOR WHILE DO 
%token IF ELSE PRINTF RETURN BREAK CONTINUE DEFINE CASE SWITCH DEFAULT MAIN REAL
%token STRUCT UNION
%token NUM ID
%token INCLUDE
%token DOT
%token SPACE HASH

%right '='
%right '+'
%left AND OR
%left '<' '>' LE GE EQ NE LT GT
%%

/* c program structure */
start:   multi_Declaration  MainFunction 
	| include multi_Declaration  MainFunction
	| include MainFunction
	| MainFunction
	;

/* Multi declaration */
multi_Declaration:Declaration 
		 |multi_Declaration Declaration 
		 ;

/* Declaration block */
Declaration: Type Assignment ';' 
	| Assignment ';'  	
	| FunctionCall ';' 	
	| ArrayUsage ';'	
	| Type ArrayUsage ';'   
	| StructStmt 
	| unionStmt	
	| error	
	;

/* Assignment block */
Assignment: ID '=' Assignment
	| ID '=' FunctionCall
	| ID '=' ArrayUsage
	| ID '+''+'',' Assignment
	| ID '-''-' ',' Assignment
	| '+''+' ID ',' Assignment
	| '-''-' ID  ','Assignment
	| ArrayUsage '=' Assignment
	| ID ',' Assignment
	| NUM ',' Assignment
	| ID '+' Assignment
	| ID '-' Assignment
	| ID '*' Assignment
	| ID '/' Assignment	
	| NUM '+' Assignment
	| NUM '-' Assignment
	| NUM '*' Assignment
	| NUM '/' Assignment
	| '\'' Assignment '\''	
	| '(' Assignment ')'
	| '-' '(' Assignment ')'
	| '-' NUM
	| '-' ID
	|ID '+''+'
	|ID '-''-'
	|'+''+' ID
	|'-''-' ID
	|NUM
	|REAL
	|ID
	;

/* Macro or Preprocessor block */
include:'#' INCLUDE LT ID DOT ID GT 
	|'#' DEFINE ID NUM
	|'#' DEFINE ID ID
	|include '#' INCLUDE LT ID DOT ID GT
	|include '#' DEFINE ID NUM
	|include '#' DEFINE ID ID
	;

/* Function Call Block */
FunctionCall : ID'('')'
	| ID'('Assignment')'
	;

/* Array Usage */
ArrayUsage : ID'['NUM']'
	   | ID'['NUM']''['NUM']'
	;

/* Function block */
MainFunction: Type MAIN '(' ArgListOpt ')' CompoundStmt 
	;
	
/* Multi_Function */
ArgListOpt: ArgList
	|
	;
	
/* Argument List */
ArgList:  ArgList ',' Arg
	| Arg
	;
	
/* Argument type */
Arg:	Type ID
	;
	
/* Compound statements */
CompoundStmt:	'{' StmtList '}'
	;
	
/* Statement List */
StmtList:	StmtList Stmt
	|
	;
	
/* Statements */
Stmt:	WhileStmt
	| doWhileStmt
	| multi_Declaration
	| ForStmt
	| IfStmt
	| retStmt
	| SwitchStmt
	| PrintFunc
	| ';'
	;
	
/* Return Statement */
retStmt:RETURN '(' ID ')' ';'
	|RETURN '(' NUM ')' ';'
	;
	
loopStmt: Stmt
	  |breakStmt
	  |contStmt
	;
	
/*loop Compound statements */
loopCompoundStmt:	'{' loopStmtList '}'
	;
	
/*loop Statement List */
loopStmtList:	loopStmtList loopStmt
	|
	;
	
/* Break Statement */	
breakStmt:BREAK ';';

/* Continue Statement */
contStmt:CONTINUE ';';

/* Type Identifier block */
Type:	INT 
	| FLOAT
	| CHAR
	| DOUBLE
	| VOID 
	;

/*  While Loop Block */ 
WhileStmt: WHILE '(' Expr ')' loopStmt  
	| WHILE '(' Expr ')' loopCompoundStmt 
	;

/*  Do While Loop Block */ 
doWhileStmt: DO loopStmt WHILE '(' Expr ')' ';' 
	| DO loopCompoundStmt WHILE  '(' Expr ')' ';'
	;

/* For Block */
ForStmt: FOR '(' Expr ';' Expr ';' Expr ')' loopStmt 
       | FOR '(' Expr ';' Expr ';' Expr ')' loopCompoundStmt 
       | FOR '(' Expr ')' loopStmt 
       | FOR '(' Expr ')' loopCompoundStmt 
	;

/* IfStmt Block */
IfStmt : IF '(' Expr ')' 
	 	Stmt 
	|IF '(' Expr ')' CompoundStmt
	|IF '(' Expr ')' CompoundStmt ELSE CompoundStmt
	|IF '(' Expr ')' CompoundStmt ELSE Stmt
	;
/* Switch Statement */
SwitchStmt:SWITCH '(' ID ')' '{' CaseBlock '}' 
	  |SWITCH '(' ID ')' '{' CaseBlock   DEFAULT ':'  loopCompoundStmt '}'
	  |SWITCH '(' ID ')' '{' CaseBlock   DEFAULT ':'  loopStmt '}'
	  ;
/* Case Block */
CaseBlock:CASE NUM ':'  loopCompoundStmt 
	 |CASE NUM ':'  loopStmt 
	 |CaseBlock CASE NUM ':'  loopCompoundStmt 
	 |CaseBlock CASE NUM ':'  loopStmt
	 ;
	 

/* Struct Statement */
StructStmt : STRUCT ID '{' multi_Declaration '}' ';'
	   | STRUCT ID '{' multi_Declaration '}'  ID ';'
	   | STRUCT ID '{' multi_Declaration '}'  ID '['NUM']' ';'
	;
	
/* Union Statement */
unionStmt:  UNION ID '{' multi_Declaration '}'
	 |  UNION ID '{' multi_Declaration '}'  ID ';'
	 |  UNION ID '{' multi_Declaration '}'  ID '['NUM']' ';'
	 ;

/* Print Function */
PrintFunc : PRINTF '(' '"' print '"'   ')' ';'
	  |PRINTF '(' '"' print '"'  ',' print ')' ';'
	;
print	:ID print
	|ID
	;
	
/* Expression Block */
Expr:	
	| Expr LE Expr 
	| Expr GE Expr
	| Expr NE Expr
	| Expr EQ Expr
	| Expr GT Expr
	| Expr LT Expr
	| Assignment
	| ArrayUsage
	;
%%
#include "lex.yy.c"
#include <ctype.h>
int count=0;
int main(int argc, char *argv[])
{
	yyin = fopen(argv[1], "r");
	
	if(!yyparse() && err==0)
		printf("\nParsing Completed,no errors!\n");
	else
		printf("\nParsing Failed!!!\n");
	
	fclose(yyin);
    	return 0;
}
         
yyerror(char *s) {
	printf("%d : %s %s\n", yylineno, s, yytext );
	err++;
}         

