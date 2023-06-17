#include <iostream>
#include "scanner.hpp"
#include "parser.hpp"
#include "interpreter.hpp"

using namespace ParserGenerator;

int main(int argc, char **argv) {
    Interpreter i;
    int res = i.parse();
    std::cout << "Parse complete. Result = " << res << std::endl;
    return res;
}
