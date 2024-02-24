#include "stdlib.h"
#include "sequence.h"
#include <iostream>
#include <unordered_map>
Sequence::Sequence(
    std::vector<std::vector<int>> temp_table,
    std::unordered_map<std::string,matrix*> &temp_dict) : s_table(temp_table), str_matrix_dict(temp_dict)
{
    std::cout << "Constructor executed. \n";
}   


Node* Sequence::init_sequence(int i, int j)
{
    /*
        Base cases
    */
    if(i > j)
    {
        return nullptr;
    }
    Node* n = new Node();
    if(i == j-1)
    {
        n->left = nullptr;
        n->right = nullptr;
        n->seq = static_cast<char*>(malloc(3 * sizeof(char)));
        n->seq[0] = '0' + i;
        n->seq[1] = '0' + j;
        n->seq[2] = '\0';
        return n;
    }
    if(i == j)
    {
        //Node n;
        n->left = nullptr;
        n->right = nullptr;
        n->seq = static_cast<char*>(malloc(2 * sizeof(char)));
        n->seq[0] = '0' + i;
        n->seq[1] = '\0';
        return n;
    }
    int sub_sequence = s_table[i-1][j-1];
    n->seq = static_cast<char*>(malloc((j-i+1) * sizeof(char)));
    for(int x = 0; x <= (j-i); x++)
    {
        n->seq[x] = '0' + (x + i);
    }
    n->seq[j-i+1] = '\0';
    n->left = init_sequence(i, sub_sequence);
    n->right = init_sequence(sub_sequence+1, j);
    return n;
}

void Sequence::print_sequence(Node* n)
{
    if(n == nullptr)
    {
        return;
    }
    if(n->left == nullptr && n->right == nullptr)
    {
        std::cout << n->seq << " ";
    }
    
    if(n->left)
    {
        std::cout << "(" << " ";
        print_sequence(n->left);
        std::cout << ")" << " ";
    }
    if(n->right)
    {
        std::cout << "(" << " ";
        print_sequence(n->right);
        std::cout << ")" << " ";
    }
}

void Sequence::setvalues(matrix *m, int value)
{
    int rows, cols;
    std::tie(rows, cols) = m->dimension;

    m->values.resize(rows);
    for (int i = 0; i < rows; ++i) 
    {
        m->values[i].resize(cols);
    }

    for(int i = 0; i < rows; i++)
    {
        for(int j = 0; j < cols; j++)
        {
            m->values[i][j] = value;
        }
    }

}

void Sequence::printMatrix(matrix *m)
{
    int rows, cols;
    std::tie(rows, cols) = m->dimension;
    std::cout << rows << " " << cols << std::endl;
    for(int i = 0; i < rows; i++)
    {
        for(int j = 0; j < cols; j++)
        {
            std::cout << m->values[i][j] << " ";
        }
        std::cout << std::endl;
    }
}


matrix* Sequence::compute(Node* n)
{
    std::cout << "in the function" << std::endl;
    /*
        Solo
    */
    if(n->left == nullptr && n->right == nullptr && n->seq[2] != '\0') 
    {
        return str_matrix_dict[std::to_string(n->seq[0])];
    }
    /*
        Two pairs
    */
    if(n->left == nullptr && n->right == nullptr && n->seq[2] == '\0')
    {
        matrix* matrix_A = str_matrix_dict[std::to_string(n->seq[0])];
        matrix* matrix_B = str_matrix_dict[std::to_string(n->seq[1])];
        
    }     
}