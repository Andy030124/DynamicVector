#include <iostream>
#include "./vector/vector.hpp"
#include <string>

int main(int argc, char const *argv[])
{
    nstd::Vector vecnums{2};

    vecnums.push_back(5);
    vecnums.push_back("Hola Mundo");
    vecnums.push_back(3);
    vecnums.emplace_back<int>(15);

    auto printResults = [](auto dato)
    { std::cout << "Element: " << dato << "\n"; };

    vecnums.foreach<int>(printResults);
    vecnums.foreach<std::string>(printResults);

    auto* ptr = vecnums[0];
    std::cout << ptr->get<int>();

    return 0;
}
