#ifndef EM_INTERPRETER_HPP
#define EM_INTERPRETER_HPP

#include <vector>

#include "scanner.hpp"
#include "parser.hpp"

namespace ParserGenerator {

class Command;

class Interpreter
{
public:
    Interpreter();

    /**
     * Run parser. Results are stored inside.
     * \returns 0 on success, 1 on failure
     */
    int parse();

    void clear();

    std::string str() const;

    /**
     * Switch scanner input stream. Default is standard input (std::cin).
     */
    void switchInputStream(std::istream *is);

    /**
     * This is needed so that Scanner and Parser can call some
     * methods that we want to keep hidden from the end user.
     */
    friend class Parser;
    friend class Scanner;

private:
    void addCommand(const Command &cmd);

    void increaseLocation(unsigned int loc);

    unsigned int location() const;

private:
    Scanner m_scanner;
    Parser m_parser;
    std::vector<Command> m_commands;  // Example AST
    unsigned int m_location;          // Used by scanner
};

}

#endif // EM_INTERPRETER_HPP
