%{
	#include <iostream>
	#include <cstdlib>
	#include "scanner.hpp"
	#include "interpreter.hpp"
	#include "parser.hpp"
	#include "location.hh"

	using namespace std;

	#define yyterminate() ParserGenerator::Parser::make_END(ParserGenerator::location());

	#define YY_USER_ACTION m_driver.increaseLocation(yyleng);
%}

%option nodefault
%option noyywrap
%option c++
%option yyclass="Scanner"
%option prefix="ParserGenerator_"

%%


[a-z]+      {
                return ParserGenerator::Parser::make_STRING(yytext, ParserGenerator::location());
            }

\(          {
                return ParserGenerator::Parser::make_LEFTPAR(ParserGenerator::location());
            }

\)          {
                return ParserGenerator::Parser::make_RIGHTPAR(ParserGenerator::location());
            }

;           {
                return ParserGenerator::Parser::make_SEMICOLON(ParserGenerator::location());
            }

,           {
                return ParserGenerator::Parser::make_COMMA(ParserGenerator::location());
            }

[\n\t ]     {
                // ignore whitechar
            }

[1-9][0-9]* {
                uint64_t number = strtoull(yytext, 0, 10);
                return ParserGenerator::Parser::make_NUMBER(number, ParserGenerator::location());
            }

.           {
                std::cout << "Scanner: unknown character [" << yytext << "]" << std::endl;
            }

<<EOF>>     { return yyterminate(); }


%%
