%{
  #include <stdio.h>
  #include <stdlib.h>
  #include "defs.h"
  #include "symtab.h"
  #include "codegen.h"

  int yylex(void);
  int yyparse(void);
  int yyerror(char *);
  void warning(char *s);

  extern int yylineno;
  int out_lin = 0;
  char char_buffer[CHAR_BUFFER_LENGTH];
  int error_count = 0;
  int warning_count = 0;
  int var_num = 0;
  int fun_idx = -1;
  int fcall_idx = -1;
  unsigned param_types[60][20];
  unsigned type = 0;
  int return_count = 0;
  int param_count = 0;
  int arg_count = 0;
  int para_idx = 0;
  bool first_para = 0;
  int nested_idx[10];
  int i = 0;    
  int tranga_count = 0;
  int tranga_arr[100];
  int tranga_arr_lit[100];
  int lab_num = -1;
  FILE *output;
  int inc_in_exp[10];
  int inc_counter = 0;
  int inc_finder = 0;
  int args[20];
%}

%union {
	int i;
	char *s;
}

%token _IF
%token _ELSE
%token _RETURN
%token <i> _TYPE
%token <i> _LOGOP
%token _PARA
%token _A
%token _JIRO
%token _TRANGA
%token _TOERANA
%token _FINISH
%token _IMPL
%token _INC
%token <i> _AROP
%token _ASSIGN
%token <i> _RELOP
%token _SEMICOLON
%token _LPAREN
%token _RPAREN
%token _LBRACKET
%token _RBRACKET
%token _COMMA
%token _QMARK
%token _COLON
%token <s>_ID
%token <s> _INT_NUMBER
%token <s> _UINT_NUMBER 

%type <i> expressions expression literal function_call arg arg_list rel_exp rel_exp_list increment if cond_exp cond_constant toerana

%nonassoc ONLY_IF
%nonassoc _ELSE


%%

program
	: global_list function_list
		{
			if(lookup_symbol("main", FUN) == NO_INDEX){
				err("undefined refrence to 'main'");
			}
		}
	;

global_list
	:
	| global_list global_var
	;

global_var
	: _TYPE _ID _SEMICOLON
		{
			int idx = lookup_symbol($2, GVAR);
			if(idx != NO_INDEX){
				err("redefinition of '%s'", $2);
			}else{
				insert_symbol($2, GVAR, $1, NO_ATR, NO_ATR);
				code("\n%s:\n\t\tWORD\t1", $2);
			}
		}
	;


function_list
	: function
	| function_list function
	;

function 
	: _TYPE _ID 
		{
			fun_idx = lookup_symbol($2, FUN);
			if(fun_idx == NO_INDEX){
				fun_idx = insert_symbol($2, FUN, $1, NO_ATR, NO_ATR);
			}else{
				err("redefinition of function '%s'", $2);
			}
			
			code("\n%s:", $2);
			code("\n\t\tPUSH\t%%14");
			code("\n\t\tMOV \t%%15,%%14");
		}
	_LPAREN param_list _RPAREN body
		{
			if(get_type(fun_idx) == INT || get_type(fun_idx) == UINT){
				if(return_count == 0){
					warn("expected return statement");
				}			
			}
			return_count = 0;
			var_num = 0;
			param_count = 0;

			clear_symbols(fun_idx+1);
			
			code("\n@%s_exit:", $2);
			code("\n\t\tMOV \t%%14,%%15");
			code("\n\t\tPOP \t%%14");
			code("\n\t\tRET");
		}
	;		

param_list
	: 
		{
			set_atr1(fun_idx, 0);
		}
	| param
	;

param
	: _TYPE _ID
		{
			if($1 == VOID){
				err("invalid type of param");
			}else {
				insert_symbol($2, PAR, $1, ++param_count, NO_ATR);
				set_atr1(fun_idx, param_count);
				set_atr2(fun_idx, $1);
				param_types[fun_idx][param_count] = $1;
			}
		}
	| param _COMMA _TYPE _ID
		{
			if($3 == VOID){
				err("invalid type of param");
			}else if(lookup_symbol($4, VAR|PAR|GVAR) == NO_INDEX){
				insert_symbol($4, PAR, $3, ++param_count, NO_ATR);
				set_atr1(fun_idx, param_count);
				param_types[fun_idx][param_count] = $3;			
			}else {
				err("redefinition of '%s'", $4);				
			}

		}	
	;

body
	: _LBRACKET variable_list 
		{
			if(var_num){
				code("\n\t\tSUBS\t%%15,$%d,%%15", 4*var_num);
			}
			code("\n@%s_body:", get_name(fun_idx));
		}	
	statements _RBRACKET
	;

variable_list
	:
	| variable_list variable
	;

variable
	: vars _SEMICOLON
	;

vars
	: _TYPE _ID
		{
			if($1 == VOID){
				err("invalid type of variables");
			}else {
				if(lookup_symbol($2, VAR|PAR|GVAR) == NO_INDEX){
					insert_symbol($2, VAR, $1, ++var_num, NO_ATR);
				}
				else{
					err("redefinition of '%s'", $2);
				}
				type = $1;
			}
		}
	| vars _COMMA _ID
		{
			if(lookup_symbol($3, VAR|PAR|GVAR) == NO_INDEX){
				insert_symbol($3, VAR, type, ++var_num, NO_ATR);
			}
			else{
				err("redefinition of '%s'", $3);
			}
		}
	;

statements
	:
	| statements statement
	;

statement
	: compound_statement	
	| assignment
	| if_stmt
	| return_stmt
	| increment _SEMICOLON
		{
			code("\n\t\tADDS\t");
			gen_sym_name($1);
			code(",$%d,", 1);
			gen_sym_name($1);
		}
	| function_call _SEMICOLON
	| para
	| jiro
	;

compound_statement
	: _LBRACKET statements _RBRACKET
	;

assignment
	: _ID _ASSIGN expressions _SEMICOLON
		{
        	int idx = lookup_symbol($1, VAR|PAR|GVAR);
        	if(idx == NO_INDEX){							
          		err("invalid lvalue '%s' in assignment", $1);
			} else {
          		if(get_type(idx) != get_type($3)){
            		err("incompatible types in assignment");
				}
			}
			gen_mov($3, idx);
			if(inc_counter != 0){
				while(inc_finder != inc_counter){
					code("\n\t\tADDS\t");
					gen_sym_name(inc_in_exp[inc_finder]);
					code(",$%d,", 1);
					gen_sym_name(inc_in_exp[inc_finder]);
					inc_finder++;
				}
				inc_counter = 0;
				inc_finder = 0;
			}
      	}
	;

expressions
	: expression
	| expressions _AROP expression
		{
        	if(get_type($1) != get_type($3)){
          		err("invalid operands: arithmetic operation");
			}
			
			int t1 = get_type($1);    
			if(t1 != NO_TYPE){
				code("\n\t\t%s\t", ar_instructions[$2 + (t1 - 1) * AROP_NUMBER]);
			}
			gen_sym_name($1);
			code(",");
			gen_sym_name($3);
			code(",");
			free_if_reg($3);
			free_if_reg($1);
			$$ = take_reg();
			gen_sym_name($$);
			set_type($$, t1);
			if(inc_counter != 0){
				while(inc_finder != inc_counter){
					code("\n\t\tADDS\t");
					gen_sym_name(inc_in_exp[inc_finder]);
					code(",$%d,", 1);
					gen_sym_name(inc_in_exp[inc_finder]);
					inc_finder++;
				}
				inc_counter = 0;
				inc_finder = 0;
			}
      	} 
	;

expression
	: literal
	| _LPAREN expressions _RPAREN
		{
			$$ = $2;
		}
	| _ID
		{
			$$ = lookup_symbol($1, VAR|PAR|GVAR);
			if($$ == NO_INDEX){
				err("'%s' is not declared", $1);
			}
		}
	| function_call
		{
			$$ = take_reg();
        	gen_mov(FUN_REG, $$);
		}
	| increment
		{
			inc_in_exp[inc_counter] = $1;
			inc_counter++;
			$$ = $1;
		}
	| cond_exp
	;

literal 
	: _INT_NUMBER
		{
			$$ = insert_literal($1, INT);
		}
	| _UINT_NUMBER
		{
			$$ = insert_literal($1, UINT);
		}
	;

function_call
	: _ID 
		{
			fcall_idx = lookup_symbol($1, FUN);
			if(fcall_idx == NO_INDEX){
				err("'%s' is not a function", $1);
			}
		}
	  _LPAREN arg_list _RPAREN
      	{
        	if(get_atr1(fcall_idx) != $4){
          		err("wrong number of args to function '%s'", get_name(fcall_idx));
			}
			code("\n\t\tCALL\t%s", get_name(fcall_idx));
			if($4 > 0){
				code("\n\t\tADDS\t%%15,$%d,%%15", $4 * 4);
			}
			arg_count = 0;
        	set_type(FUN_REG, get_type(fcall_idx));
        	$$ = FUN_REG;
      	}
	;

arg_list
	:
		{
			$$ = arg_count;
		}
	| arg
		{
			while(arg_count >= 1){
				free_if_reg(args[arg_count]);
				code("\n\t\tPUSH\t");
      		    gen_sym_name(args[arg_count]);
      		    arg_count--;
			}
			if(inc_counter != 0){
				while(inc_finder != inc_counter){
					code("\n\t\tADDS\t");
					gen_sym_name(inc_in_exp[inc_finder]);
					code(",$%d,", 1);
					gen_sym_name(inc_in_exp[inc_finder]);
					inc_finder++;
				}
				inc_counter = 0;
				inc_finder = 0;
			}
		}
	;

arg
	: expressions
		{
			++arg_count;
			if(param_types[fcall_idx][arg_count] != get_type($1)){
				err("incompatible type for argument in '%s'", get_name(fcall_idx));
			}
			args[arg_count] = $1;
			$$ = arg_count;
			
		}
	| arg _COMMA expressions
		{
			++arg_count;			
			if(param_types[fcall_idx][arg_count] != get_type($3)){
				err("invalid type of argument");
			}
			args[arg_count] = $3;
			$$ = arg_count;
		}
	;

increment
	: _ID _INC
		{
			int i = lookup_symbol($1, VAR|PAR|GVAR);
			if(i == NO_INDEX){
				err("undefined lvalue '%s' in increment", $1);
			}
			$$ = i;
		}
	;

cond_exp
	: _LPAREN rel_exp _RPAREN _QMARK cond_constant _COLON cond_constant
		{
			$$ = take_reg();
			if(get_type($5) != get_type($7)){
				err("incompatible types of conditional constants");
			}
			$<i>$ = ++lab_num;
        	code("\n@conditonal%d:", lab_num);
			code("\n\t\t%s\t@false%d", opp_jumps[$2], $<i>$); 
        	code("\n@true%d:", $<i>$);
			gen_mov($5, $$);
			code("\n\t\tJMP \t@exit%d", $<i>$);
        	code("\n@false%d:", $<i>$);
        	gen_mov($7, $$);
			code("\n@exit%d:", $<i>$);
		}
	;

cond_constant
	: _ID
		{
			$$ = lookup_symbol($1, VAR|PAR|GVAR);
			if($$ == NO_INDEX){
				err("'%s' is not declared", $1);
			}
		}
	| literal
	;

para
	: _PARA _LPAREN _TYPE _ID
		{	
			if(get_atr2(para_idx) == NO_ATR){
				para_idx = insert_symbol($4, VAR, $3, ++var_num, LOCAL);
				first_para = 1;
			}else if(get_atr2(para_idx) == LOCAL){
				nested_idx[i] = insert_symbol($4, VAR, $3, ++var_num, NESTED);
				i++;
			}
			$<i>$ = ++lab_num;
		}
	 _ASSIGN literal _A literal
		{
			if($3 != get_type($7) || $3 != get_type($9)){
				err("incompatible literal types");
			}else if(atoi(get_name($7)) > atoi(get_name($9))){
				err("second literal must be greater");
			}
			int t1 = get_type($7);
			if(first_para){
				code("\n@para_%d:", $<i>5);
				gen_mov($7, para_idx);
				code("\n@para_body_%d:", $<i>5);
				gen_cmp(para_idx, $9);
				first_para = 0;
			}else{
				code("\n@para_%d:", $<i>5);
				gen_mov($7, nested_idx[i - 1]);
				code("\n@para_body_%d:", $<i>5);
				gen_cmp(nested_idx[i - 1], $9);
			}
			code("\n\t\t%s\t@para_exit_%d", jumps[1 + (t1 - 1) * 6], $<i>5);
			
		}
	 _RPAREN statement
		{
			int index = lookup_symbol($4, VAR);
			if(get_atr2(index) == NESTED){
				code("\n\t\tADDS\t");
				gen_sym_name(index);
				code(",$%d,", 1);
				gen_sym_name(index);
				code("\n\t\tJMP \t@para_body_%d", $<i>5);
				code("\n@para_exit_%d:", $<i>5);
				
				clear_symbols(index);
			}else{
				code("\n\t\tADDS\t");
				gen_sym_name(index);
				code(",$%d,", 1);
				gen_sym_name(index);
				code("\n\t\tJMP \t@para_body_%d", $<i>5);
				code("\n@para_exit_%d:", $<i>5);
				
				clear_symbols(para_idx);
				para_idx = 0;
				first_para = 0;
				i = 0;
			}
		}
	;


jiro
	: _JIRO _LPAREN _ID 
		{
			int idx = lookup_symbol($3, VAR|PAR|GVAR);
			if(idx == NO_INDEX){
				err("%s not declared", $3);
			}else{
				type = get_type(idx);
			}
			lab_num++;
			code("\n@jiro_%d:", lab_num);
			code("\n\t\tJMP \t@jiro_check_%d", lab_num);
			
		}
		_RPAREN _LBRACKET tranga_statements toerana _RBRACKET
		{
			code("\n\t\tJMP \t@jiro_exit_%d", lab_num);
			int idx = lookup_symbol($3, VAR|PAR|GVAR);
			int i = 0;
			code("\n@jiro_check_%d:", lab_num);
			while(i != tranga_count){
				gen_cmp(tranga_arr_lit[i], idx);
				code("\n\t\tJEQ\t@tranga_%d_%d", lab_num, i);
				i++;
			}
			if($8 == 1){
				code("\n\t\tJMP \t@toerana_%d", lab_num);
			}
			code("\n@jiro_exit_%d:", lab_num);
			tranga_count = 0;
		}
	;

tranga_statements
	: tranga
	| tranga_statements tranga
	;

tranga
	: _TRANGA literal _IMPL
		{
			int i = 0;
			while(i < tranga_count){
				if(atoi(get_name($2)) == tranga_arr[i]){
					err("constant in tranga command already exists");
					break;
				}
				i++;
			}
			if(i == tranga_count){
				code("\n@tranga_%d_%d:", lab_num, tranga_count);
				tranga_arr[tranga_count] = atoi(get_name($2));
				tranga_arr_lit[tranga_count] = $2;
				tranga_count++;
			}
			if(type != get_type($2)){
				err("incompatible type of constant in tranga command");
			}
		}
	statement finish
	;

finish
	:	
	| _FINISH _SEMICOLON
		{ code("\n\t\tJMP \t@jiro_exit_%d", lab_num); }
	;

toerana
	: 	{ $$ = 0; }
	| _TOERANA _IMPL 
		{ code("\n@toerana_%d:", lab_num); }
	statement
		{ $$ = 1; }
	;

if_stmt
	: if %prec ONLY_IF
		{
			code("\n@exit%d:", $1);
		}
	| if _ELSE statement
		{
			code("\n@exit%d:", $1);
		}
	;

if
	: _IF _LPAREN 
		{
			$<i>$ = ++lab_num;
        	code("\n@if%d:", lab_num);
		}
	rel_exp_list 
		{
        	code("\n\t\t%s\t@false%d", opp_jumps[$4], $<i>3); 
        	code("\n@true%d:", $<i>3);
		}
	_RPAREN statement
	 	{
	 		code("\n\t\tJMP \t@exit%d", $<i>3);
        	code("\n@false%d:", $<i>3);
        	$$ = $<i>3;
	 	}
	;
//TODO generisanje za and i or 
	
rel_exp_list
	: rel_exp
	| rel_exp_list _LOGOP rel_exp
	;


rel_exp
	: expressions _RELOP expressions
		{
			if(get_type($1) != get_type($3)){
				err("invalid operands: relational operator");
			}
			$$ = $2 + ((get_type($1) - 1) * RELOP_NUMBER);
        	gen_cmp($1, $3);
			if(inc_counter != 0){
				while(inc_finder != inc_counter){
					code("\n\t\tADDS\t");
					gen_sym_name(inc_in_exp[inc_finder]);
					code(",$%d,", 1);
					gen_sym_name(inc_in_exp[inc_finder]);
					inc_finder++;
				}
				inc_counter = 0;
				inc_finder = 0;
			}
      	}
	;

return_stmt
	: _RETURN _SEMICOLON
		{
			if(get_type(fun_idx) == INT || get_type(fun_idx) == UINT){
				warn("expression expected in return statement");			
			}
			code("\n\t\tJMP \t@%s_exit", get_name(fun_idx));
			return_count++;
		}
	| _RETURN expressions _SEMICOLON
		{
			if(get_type(fun_idx) == VOID){
				err("invalid return statement");
			}else if(get_type(fun_idx) != get_type($2)){
				err("incompatible types in return");
			}
			gen_mov($2, FUN_REG);
			if(inc_counter != 0){
				while(inc_finder != inc_counter){
					code("\n\t\tADDS\t");
					gen_sym_name(inc_in_exp[inc_finder]);
					code(",$%d,", 1);
					gen_sym_name(inc_in_exp[inc_finder]);
					inc_finder++;
				}
				inc_counter = 0;
				inc_finder = 0;
			}
        	code("\n\t\tJMP \t@%s_exit", get_name(fun_idx));
			return_count++;
      	}
	;
	

%%

int yyerror(char *s) {
	fprintf(stderr, "\nline %d: ERROR: %s", yylineno, s);
	error_count++;
	return 0;
}

void warning(char *s) {
	fprintf(stderr, "\nline %d: WARNING: %s", yylineno, s);
	warning_count++;
}

int main() {
	int synerr;
	init_symtab();
	output = fopen("output.asm", "w+");

	synerr = yyparse();

	clear_symtab();
	fclose(output);
	  
	if(warning_count)
		printf("\n%d warning(s).\n", warning_count);

	if(error_count)
		printf("\n%d error(s).\n", error_count);

	if(synerr)
		return -1; //syntax error
	else if(error_count)
		return error_count & 127; //semantic errors
	else if(warning_count)
		return (warning_count & 127) + 127; //warnings
	else
		return 0;  //OK
}

