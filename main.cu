#include <stdlib.h>
#include <stdio.h>
#include <iostream>
#include <tuple>
#include <vector>
#include <unordered_map>
#include <cuda_runtime.h>
#include <device_launch_parameters.h>
#include <string.h>
#include "sequence.h"
#include "helper_functions.h"


__global__ void matrixMult()
{
 
}

int main()
{
    
    //Generate Matrices
    
    matrix *A1 = new matrix;
    matrix *A2 = new matrix;
    matrix *A3 = new matrix;
    matrix *A4 = new matrix;
    matrix *A5 = new matrix;


    matrix *a1 = new_matrix(4,10,1);
    matrix *a2 = new_matrix(10,3,2);
    matrix *a3 = new_matrix(3,12,3);
    matrix *a4 = new_matrix(12,20,4);
    matrix *a5 = new_matrix(20,7,5);
  
    //For odd number
    A1->dimension = std::make_tuple(4,10);
    A2->dimension = std::make_tuple(10,3);
    A3->dimension = std::make_tuple(3,12);
    A4->dimension = std::make_tuple(12,20);
    A5->dimension = std::make_tuple(20,7);
    


    std::cout << "1st matrix " << std::endl;
    setValues(A1, 1);
    //seq.printMatrix(A1);
    std::cout << "2nd matrix " << std::endl;
    setValues(A2, 2);
    //seq.printMatrix(A2);
    std::cout << "3rd matrix " << std::endl;
    setValues(A3, 3);
    std::cout << "4th matrix " << std::endl;
    setValues(A4, 4);
    std::cout << "5th matrix " << std::endl;
    setValues(A5, 5);
    //For even number 
    /*
    A1->dimension = std::make_tuple(3,2);
    A2->dimension = std::make_tuple(2,4);
    A3->dimension = std::make_tuple(4,2);
    A4->dimension = std::make_tuple(2,5);
    */
    std::unordered_map<char, matrix*> dict;
    dict['1'] = A1;
    dict['2'] = A2;
    dict['3'] = A3;
    dict['4'] = A4;
    dict['5'] = A5;

    std::vector<matrix> list_matrixes;
    list_matrixes.push_back(*A1);
    list_matrixes.push_back(*A2);
    list_matrixes.push_back(*A3);
    list_matrixes.push_back(*A4);
    list_matrixes.push_back(*A5);
    /*
        Create S table and initalize diagonal to zeros
    */
    std::vector<std::vector<int>> s_table;
    int rows = list_matrixes.size();
    int columns = list_matrixes.size();
    for(int i = 0; i < rows; i++)
    {
        std::vector<int> row(columns, 0);
        s_table.push_back(row);
    }
    /*
        Perform DP
    */
    init_dp(&s_table, list_matrixes);
    std::cout << "S TABLE: " << std::endl;
    for(int i = 0; i < s_table.size(); i++)
    {
        for(int j = 0; j < s_table[0].size(); j++)
        {
            std::cout << s_table[i][j] << "\t";
        }
        std::cout << std::endl;
    }
    
    Sequence seq(s_table, dict);

    

   

    Node* root = new Node();
    root = seq.init_sequence(1, list_matrixes.size());
     
    root = seq.init_sequence(1, list_matrixes.size());
    std::cout << "printing " << std::endl;
    std::cout << "(" << " ";
    seq.print_sequence(root);
    std::cout << ")" << " \n";
    
    std::cout << "COMPUTING " << std::endl;
    //matrix* res = seq.compute(root);

    //std::cout << "RES IS " << std::endl;
    //seq.printMatrix(res);
    return 0;
}