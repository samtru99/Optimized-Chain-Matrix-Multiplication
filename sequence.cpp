#include "stdlib.h"
#include "sequence.h"
#include <iostream>
#include <unordered_map>
Sequence::Sequence(
    std::vector<std::vector<int>> temp_table,
    std::unordered_map<char,matrix*> &temp_dict) : s_table(temp_table), str_matrix_dict(temp_dict)
{
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

void Sequence::printMatrix(matrix *m)
{
    for(int i = 0; i < m->row; i++)
    {
        for(int j = 0; j < m->col;j++)
        {
            std::cout << m->ptr[i* m->col + j] << " ";
        }
        std::cout << std::endl;
    }
}


matrix* Sequence::compute(Node* n)
{
    //std::cout << "printing 5 " << std::endl;
    //printMatrix(str_matrix_dict['5']);
    if(n->left == nullptr && n->right == nullptr && n->seq[1] == '\0') 
    { 
        std::cout << "returning " << n->seq << std::endl; 
        return str_matrix_dict[n->seq[0]]; 
    }  
    if(n->left == nullptr && n->right == nullptr && n->seq[2] == '\0')  
    {
        std::cout << "computing pair " << n->seq << std::endl;
        std::cout << "s[0] = " << n->seq[0] << std::endl;   
        std::cout << "s[1] = " << n->seq[1] << std::endl;   
        matrix* matrix_A = str_matrix_dict[n->seq[0]]; 
        matrix* matrix_B = str_matrix_dict[n->seq[1]];  
        matrix* matrix_C = matrix_mult(*matrix_A,*matrix_B);
        return matrix_C; 
    } 
    else 
    { 
        std::cout << "computing " << n->seq << std::endl; 
        matrix* left_res = compute(n->left); 
        matrix* right_res = compute(n->right); 
        matrix* matrix_C = matrix_mult(*left_res,*right_res);
        std::cout << n->seq << " solution: " << std::endl;
        printMatrix(matrix_C);   
        return matrix_C;   
    }  
} 

matrix* Sequence::compute(Node* n,std::unordered_map<char, matrix*>& dict )
{
    if(n->left == nullptr && n->right == nullptr && n->seq[1] == '\0') 
    { 
        return dict[n->seq[0]]; 
    }  
    if(n->left == nullptr && n->right == nullptr && n->seq[2] == '\0')  
    {
        matrix* matrix_A = dict[n->seq[0]]; 
        matrix* matrix_B = dict[n->seq[1]]; 
        matrix* matrix_C = matrix_mult(*matrix_A,*matrix_B); 
        printMatrix(matrix_C); 
        return matrix_C; 
    } 
    else 
    { 
        matrix* left_res = compute(n->left, dict); 
        matrix* right_res = compute(n->right, dict); 
        matrix* matrix_C = matrix_mult(*left_res,*right_res);  
        printMatrix(matrix_C); 
        return matrix_C;   
    }  
} 

matrix* Sequence::matrix_mult(matrix &a, matrix &b)
{
    matrix *c = (matrix*)malloc(sizeof(matrix));
    int row_A,col_A,row_B,col_B;
    row_A = a.row;
    col_A = a.col;

    row_B = b.row; 
    col_B = b.col;
   

    c->row = row_A;
    c->col = col_B;
    c->ptr = (int*)malloc(row_A*col_B*sizeof(int));

    for(int x = 0; x < row_A; x++)
    {
        for(int y = 0; y < col_B; y++)
        {
            int sum = 0;
            for(int k = 0; k < row_B; k++)
            {
                sum += a.ptr[x*col_A+k] * b.ptr[col_B*k+y];
            }
            c->ptr[x * col_B + y] = sum;
        }
    }
    return c;
}