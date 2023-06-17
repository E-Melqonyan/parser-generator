#ifndef EM_SCANNER_HPP
#define EM_SCANNER_HPP


/**
 * Generated Flex class name is yyFlexLexer by default. If we want to use more flex-generated
 * classes we should name them differently. See scanner.l prefix option.
 *
 * Unfortunately the implementation relies on this trick with redefining class name
 * with a preprocessor macro. See GNU Flex manual, "Generating C++ Scanners" section
 */
#if ! defined(yyFlexLexerOnce)
#undef yyFlexLexer
#define yyFlexLexer ParserGenerator_FlexLexer
#include <FlexLexer.h>
#endif

#undef YY_DECL
#define YY_DECL ParserGenerator::Parser::symbol_type ParserGenerator::Scanner::get_next_token()

#include "parser.hpp" // this is needed for symbol_type

namespace ParserGenerator {

class Interpreter;

class Scanner : public yyFlexLexer {
public:
    Scanner(Interpreter &driver) : m_driver(driver) {}
	virtual ~Scanner() {}
	virtual ParserGenerator::Parser::symbol_type get_next_token();

private:
    Interpreter &m_driver;
};

}

#endif // EM_SCANNER_HPP