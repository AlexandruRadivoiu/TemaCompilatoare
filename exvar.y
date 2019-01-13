%{
	#include <stdio.h>
     #include <string.h>

	int yylex();
	int yyerror(const char *msg);

     int EsteCorecta = 1;
	char msg[500];

	class TVAR
	{
	     char* nume;
	     int valoare;
	     TVAR* next;
	  
	  public:
	     static TVAR* head;
	     static TVAR* tail;

	     TVAR(char* n, int v = -1);
	     TVAR();
	     int exists(char* n);
             void add(char* n, int v = -1);
             int getValue(char* n);
	     void setValue(char* n, int v);
	};

	TVAR* TVAR::head;
	TVAR* TVAR::tail;

	TVAR::TVAR(char* n, int v)
	{
	 this->nume = new char[strlen(n)+1];
	 strcpy(this->nume,n);
	 this->valoare = v;
	 this->next = NULL;
	}

	TVAR::TVAR()
	{
	  TVAR::head = NULL;
	  TVAR::tail = NULL;
	}

	int TVAR::exists(char* n)
	{
	  TVAR* tmp = TVAR::head;
	  while(tmp != NULL)
	  {
	    if(strcmp(tmp->nume,n) == 0)
	      return 1;
            tmp = tmp->next;
	  }
	  return 0;
	 }

         void TVAR::add(char* n, int v)
	 {
	   TVAR* elem = new TVAR(n, v);
	   if(head == NULL)
	   {
	     TVAR::head = TVAR::tail = elem;
	   }
	   else
	   {
	     TVAR::tail->next = elem;
	     TVAR::tail = elem;
	   }
	 }

         int TVAR::getValue(char* n)
	 {
	   TVAR* tmp = TVAR::head;
	   while(tmp != NULL)
	   {
	     if(strcmp(tmp->nume,n) == 0)
	      return tmp->valoare;
	     tmp = tmp->next;
	   }
	   return -1;
	  }

	  void TVAR::setValue(char* n, int v)
	  {
	    TVAR* tmp = TVAR::head;
	    while(tmp != NULL)
	    {
	      if(strcmp(tmp->nume,n) == 0)
	      {
		tmp->valoare = v;
	      }
	      tmp = tmp->next;
	    }
	  }

	TVAR* ts = NULL;
%}

%code requires {
typedef struct punct { int x,y,z; } PUNCT;
}

%union { char* sir; int val; PUNCT p; }

%token TOK_PLUS TOK_MINUS TOK_MULTIPLY TOK_DIVIDE TOK_LEFT TOK_RIGHT TOK_DECLARE TOK_PRINT TOK_PROGRAM TOK_VAR TOK_BEGIN TOK_END TOK_INTEGER TOK_READ TOK_WRITE TOK_FOR TOK_DO TOK_TO TOK_ATRIBUIE
%token <val> TOK_NUMBER
%token <sir> TOK_ID TOK_ERROR

%type <sir> id_list

%start prog

%left TOK_PLUS TOK_MINUS
%left TOK_MULTIPLY TOK_DIVIDE

%locations 

%%


prog : 
	TOK_PROGRAM prog_name TOK_VAR dec_list TOK_BEGIN stmt_list TOK_END
	|
	TOK_ERROR prog_name TOK_VAR dec_list TOK_BEGIN stmt_list TOK_END
		{ EsteCorecta = 0; }
	;
prog_name :
	TOK_ID
	;
dec_list :
	dec
	|
	dec_list ';' dec
	;
dec :
	id_list ':' type
/*	{
	char *pch = strtok($1,", ");
	while(!pch)
	{
		if(ts!=NULL)
		{
			if(ts->exists(pch))
			{
				sprintf(msg,"Variabila %s exista in tabela de simboli!",pch);
				yyerror(msg);
			}
			else ts->add(pch);
		}
		else 
		{
			ts = new TVAR();
			ts->add(pch);
		}
		pch = strtok(NULL,", ");
	}
	} */ 
	;
type :
	TOK_INTEGER
	;
id_list :
	TOK_ID
	|
	id_list 
	',' TOK_ID
	;
stmt_list :
	stmt
	|
	stmt_list ';' stmt
	;
stmt :
	assign
	|
	read
	|
	write
	|
	for
	
	;
assign :
	TOK_ID TOK_ATRIBUIE exp
	;
exp : 
	term
	|
	exp TOK_PLUS term
	//{ $$ = $1 + $3; }
	|
	exp TOK_MINUS term
	//{ $$ = $1 - $3; }
	;
term : 
	factor 
     //   {
	// $$ = $1 ;		   	 
     //   }
	|
	term TOK_MULTIPLY factor
	//{
	//		  	$$ = $1 * $3 ;
      //  }
	|
	term TOK_DIVIDE factor
	/*{
	{ 
	  if($3 == 0) 
	  { 
	      sprintf(msg,"%d:%d Eroare semantica: Impartire la zero!", @1.first_line, @1.first_column);
	      yyerror(msg);
	      YYERROR;
	  } 
	  else { $$ = $1 / $3; } 
	}
	}*/
	;
factor : 
	TOK_ID
	
	|
	TOK_NUMBER
	//{ $$ = $1; }
	|
	TOK_LEFT exp TOK_RIGHT
	/*{
	$$ = $2;
     	 }*/
	;
read :
	TOK_READ TOK_LEFT id_list TOK_RIGHT
	;
write :
	TOK_WRITE TOK_LEFT id_list TOK_RIGHT
	;
for :
	TOK_FOR index_exp TOK_DO body
	;
index_exp :
	TOK_ID TOK_ATRIBUIE exp TOK_TO exp
	;
body :
	stmt 
	|
	TOK_BEGIN stmt_list TOK_END
	;



%%

int main()
{
	yyparse();
	
	if(EsteCorecta == 1)
	{
		printf("CORECTA\n");		
	}	

       return 0;
}

int yyerror(const char *msg)
{
	printf("Error: %s\n", msg);
	return 1;
}
