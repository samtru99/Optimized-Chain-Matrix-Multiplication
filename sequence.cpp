#include "stdlib.h"
#include "sequence.h"

Sequence::Sequence(std::vector<std::vector<int>> s_table,std::vector<int> matrix_sequence)
{
    s_table = s_table;
    matrix_sequence = matrix_sequence;
}   

Node Sequence::init_sequence(int i, int j)
{
    /*
        Base cases
    */
    if(i > j)
    {
        return;
    }
    if(i == j-1)
    {
        Node n;
        n.left = nullptr;
        n.right = nullptr;
        n.seq = static_cast<char*>(malloc(3 * sizeof(char)));
        n.seq[0] = '0' + i;
        n.seq[1] = '0' + j;
        n.seq[2] = '\0';
    }
    if(i == j)
    {
        Node n;
        n.left = nullptr;
        n.right = nullptr;
        n.seq = static_cast<char*>(malloc(2 * sizeof(char)));
        n.seq[0] = '0' + i + '\0';
    }
    int sub_sequence = s_table[i][j];
    Node n;
    n.left = init_sequence(i, sub_sequence);
    n.right = init_sequence(sub_sequence+1, j);
    return n;

}

