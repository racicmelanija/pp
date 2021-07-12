%option noyywrap yylineno
%{
  #include <string.h>
  #include "proj.tab.h"
  #include "defs.h"
  extern YYSTYPE yylval;
%}

%%

[ \n\t]+ 						{}
"if"							{return _IF;}
"else"							{return _ELSE;}
"return"						{return _RETURN;}

"int"							{yylval.i = INT; return _TYPE;}
"unsigned"						{yylval.i = UINT; return _TYPE;}
"void"							{yylval.i = VOID; return _TYPE;}

"and"							{yylval.i = AND; return _LOGOP;}
"or"							{yylval.i = OR; return _LOGOP;}

"para"							{return _PARA;}
"a"							{return _A;}
"jiro"							{return _JIRO;}
"tranga"						{return _TRANGA;}
"toerana"						{return _TOERANA;}
"finish"						{return _FINISH;}

"=>"							{return _IMPL;}

"++"							{return _INC;}

"+"							{yylval.i = ADD; return _AROP;}
"-"							{yylval.i = SUB; return _AROP;}

"="							{return _ASSIGN;}

"<"							{yylval.i = LT; return _RELOP;}
">"							{yylval.i = GT; return _RELOP;}
"!="							{yylval.i = NE; return _RELOP;}
"=="							{yylval.i = EQ; return _RELOP;}
">="							{yylval.i = GE; return _RELOP;}
"<="							{yylval.i = LE; return _RELOP;}

";"							{return _SEMICOLON;}
"("							{return _LPAREN;}
")"							{return _RPAREN;}
"{"							{return _LBRACKET;}
"}"							{return _RBRACKET;}
","							{return _COMMA;}
"?"							{return _QMARK;}
":"							{return _COLON;}

[a-z][a-zA-Z0-9]* 					{yylval.s = strdup(yytext); 
							return _ID;}
[-+]?[0-9]+{1,10}					{yylval.s = strdup(yytext); 
							return _INT_NUMBER;}
[0-9]+{1,10}[uU]					{yylval.s = strdup(yytext); 
							yylval.s[yyleng-1] = 0; 
							return _UINT_NUMBER;}
"//".*							{}
\/\*([^*]|"\n"|(\*+([^*/]|"\n")))*\*\/			{}

.                    					{ printf("line %d: LEXICAL ERROR on char %c\n", yylineno, *yytext);}
%%

