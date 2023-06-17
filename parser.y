%skeleton "lalr1.cc" /* -*- C++ -*- */
%require "3.0"
%defines
%define api.parser.class { Parser }

%define api.token.constructor
%define api.value.type variant
%define parse.assert
%define api.namespace { ParserGenerator }
%code requires
{
    #include <iostream>
    #include <string>
    #include <vector>
    #include <stdint.h>
    #include "command.hpp"

    using namespace std;

    namespace ParserGenerator {
        class Scanner;
        class Interpreter;
    }
}

%code top
{
    #include <iostream>
    #include "scanner.hpp"
    #include "parser.hpp"
    #include "interpreter.hpp"
    #include "location.hh"

    static ParserGenerator::Parser::symbol_type yylex(ParserGenerator::Scanner &scanner, ParserGenerator::Interpreter &driver) {
        return scanner.get_next_token();
    }

    using namespace ParserGenerator;
}

%lex-param { ParserGenerator::Scanner &scanner }
%lex-param { ParserGenerator::Interpreter &driver }
%parse-param { ParserGenerator::Scanner &scanner }
%parse-param { ParserGenerator::Interpreter &driver }
%locations
%define parse.trace
%define parse.error verbose

%define api.token.prefix {TOKEN_}

%token END 0 "end of file"
%token <std::string> STRING  "string";
%token <uint64_t> NUMBER "number";
%token LEFTPAR "leftpar";
%token RIGHTPAR "rightpar";
%token SEMICOLON "semicolon";
%token COMMA "comma";

%type< ParserGenerator::Command > command;
%type< std::vector<uint64_t> > arguments;

%start program

%%

program :   {
                std::cout << "*** RUN ***\n Terminate parser with Ctrl-D" << std::endl;
                driver.clear();
            }
        | program command
            {
                const Command &cmd = $2;
                driver.addCommand(cmd);
            }
        | program SEMICOLON
            {
                std::cout << "*** STOP RUN ***" << std::endl;
                std::cout << driver.str() << std::endl;
            }
        ;


command : STRING LEFTPAR RIGHTPAR
        {
            string &id = $1;
            std::cout << "ID: " << id << std::endl;
            $$ = Command(id);
        }
    | STRING LEFTPAR arguments RIGHTPAR
        {
            string &id = $1;
            const std::vector<uint64_t> &args = $3;
            std::cout << "function: " << id << ", " << args.size() << std::endl;
            $$ = Command(id, args);
        }
    ;

arguments : NUMBER
        {
            uint64_t number = $1;
            $$ = std::vector<uint64_t>();
            $$.push_back(number);
            std::cout << "first argument: " << number << std::endl;
        }
    | arguments COMMA NUMBER
        {
            uint64_t number = $3;
            std::vector<uint64_t> &args = $1;
            args.push_back(number);
            $$ = args;
            std::cout << "next argument: " << number << ", arg list size = " << args.size() << std::endl;
        }
    ;

%%

// Bison expects us to provide implementation - otherwise linker complains
void ParserGenerator::Parser::error(const location &loc , const std::string &message) {

        // Location should be initialized inside scanner action, but is not in this example.
        // Let's grab location directly from driver class.
	// std::cout << "Error: " << message << std::endl << "Location: " << loc << std::endl;

        std::cout << "Error: " << message << std::endl << "Error location: " << driver.location() << std::endl;
}
