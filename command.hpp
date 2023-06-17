#ifndef EM_COMMAND_HPP
#define EM_COMMAND_HPP

#include <string>
#include <vector>
#include <stdint.h>

namespace ParserGenerator {

class Command
{
public:
    Command(const std::string &name, const std::vector<uint64_t> arguments);
    Command(const std::string &name);
    Command();
    ~Command();

    std::string str() const;
    std::string name() const;

private:
    std::string m_name;
    std::vector<uint64_t> m_args;
};

}

#endif // EM_COMMAND_HPP
