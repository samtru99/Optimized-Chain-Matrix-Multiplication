#ifndef _SEQUENCE_H
#include <string.h>
#include "stdlib.h"
#include <iostream>



class Node
{
    private:
        char* seq;
        Node* left;
        Node* right;
    public:
        Node();
        void sequence();
};

#endif