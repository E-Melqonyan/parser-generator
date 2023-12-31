#include "interpreter.hpp"
#include "command.hpp"

#include <sstream>

using namespace ParserGenerator;

Interpreter::Interpreter() :
    m_commands(),
    m_scanner(*this),
    m_parser(m_scanner, *this),
    m_location(0)
{

}

int Interpreter::parse() {
    m_location = 0;
    return m_parser.parse();
}

void Interpreter::clear() {
    m_location = 0;
    m_commands.clear();
}

std::string Interpreter::str() const {
    std::stringstream s;
    s << "Interpreter: " << m_commands.size() << " commands received from command line." << std::endl;
    for(int i = 0; i < m_commands.size(); i++) {
        s << " * " << m_commands[i].str() << std::endl;
    }
    return s.str();
}

void Interpreter::switchInputStream(std::istream *is) {
    m_scanner.switch_streams(is, NULL);
    m_commands.clear();
}

void Interpreter::addCommand(const Command &cmd)
{
    m_commands.push_back(cmd);
}

void Interpreter::increaseLocation(unsigned int loc) {
    m_location += loc;
}

unsigned int Interpreter::location() const {
    return m_location;
}
