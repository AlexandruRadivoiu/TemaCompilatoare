%{
	#include "y.tab.h"

	int lineNo = 1;
	int colNo = 1;
%}

%%
"+"				{ colNo++; return TOK_PLUS; }
"-"				{ colNo++; return TOK_MINUS; }
"*"				{ colNo++; return TOK_MULTIPLY; }
"("				{ colNo++; return TOK_LEFT; }
")"				{ colNo++; return TOK_RIGHT; }
"PROGRAM"			{ colNo++; return TOK_PROGRAM; }
"VAR"				{ colNo++; return TOK_VAR; }
"BEGIN"				{ colNo++; return TOK_BEGIN; }
"END"				{ colNo++; return TOK_END; }
"INTEGER"			{ colNo++; return TOK_INTEGER; }
"DIV"				{ colNo++; return TOK_DIVIDE; }
"READ"				{ colNo++; return TOK_READ; }
"WRITE"				{ colNo++; return TOK_WRITE; }
"FOR"				{ colNo++; return TOK_FOR; }
"DO"				{ colNo++; return TOK_DO; }
"TO"				{ colNo++; return TOK_TO; }
";"				{ colNo++; return ';'; }
":"				{ colNo++; return ':'; }
":="				{ colNo++; return TOK_ATRIBUIE; }
"="				{ colNo++; return '='; }
","				{ colNo++; return ','; }
0|[1-9][0-9]*	{ yylloc.first_line = lineNo; yylloc.first_column = colNo; colNo+=strlen(yytext); yylval.val = atoi(yytext); return TOK_NUMBER; }
[a-zA-Z][a-zA-Z0-9]* { yylloc.first_line = lineNo; yylloc.first_column = colNo; colNo+=strlen(yytext); yylval.sir = new char[strlen(yytext)+1]; strcpy(yylval.sir,yytext); return TOK_ID;}
[ ]				{ colNo++; }
\r\n			{ lineNo++; colNo=1; }
\n				{ lineNo++; colNo=1; }
.				{ colNo++; return TOK_ERROR; }
%%
