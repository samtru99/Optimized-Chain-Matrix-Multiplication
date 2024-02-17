#include "stdlib.h"
#include "sequence.h"

Node::Node()
{
    seq = nullptr;
    left = nullptr;
    right = nullptr;
}   

void Node::sequence()
{
    std::cout << "in the function NOW " << std::endl;
    int x = 4;
    std:: cout << x << std::endl;
}