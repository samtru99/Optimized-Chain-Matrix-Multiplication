#include <stdlib.h>
#include <stdio.h>
#include <iostream>
#include <tuple>
#include <vector>
#include <unordered_map>
#include "sequence_gpu.h"
/*
    Boost Libraries
*/
#include<boost/property_tree/ptree.hpp>
using boost::property_tree::ptree;
#include<boost/property_tree/xml_parser.hpp>
#include<boost/foreach.hpp>



//Could use multiple threads to fill up each matrix
void setValues(matrix *x,int value) 
{
    int row = std::get<0>(x->dimension);
    int col = std::get<1>(x->dimension);
    x->values.resize(row);
    for (int i = 0; i < row; ++i) 
    {
        x->values[i].resize(col);
    }
    for(int i = 0; i < row; i++)
    {
        for(int j = 0; j < col; j++)
        {
            x->values[i][j] = value;
        }
    }
}


int main()
{
    ptree pt;
    read_xml("./config.xml", pt);
    std::vector<matrix> list_matrixes;
    std::unordered_map<char, matrix*> dict;
    int counter = 1;
    
    BOOST_FOREACH(ptree::value_type & child, pt.get_child("matrixList"))
    {
        std::string name = child.second.get<std::string>("<xmlattr>.name");
        int row = child.second.get<int>("<xmlattr>.row");
        int column = child.second.get<int>("<xmlattr>.column");
        int value = child.second.get<int>("<xmlattr>.value");
        
        matrix *temp = new matrix;
        temp->name = name;
        temp->dimension = std::make_tuple(row,column);
        
        setValues(temp, value);
        char charValue = '0' + counter;
        dict[charValue] = temp;
        counter++;
        list_matrixes.push_back(*temp);
    }
    assert(list_matrixes[0].name == "A1");
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

    Sequence seq(s_table, dict);



    /*
        Perform DP
    */
    seq.init_dp(list_matrixes);

    //Print S-Table for debugging
    /*
    std::cout << "S TABLE: " << std::endl;
    for(int i = 0; i < s_table.size(); i++)
    {
        for(int j = 0; j < s_table[0].size(); j++)
        {
            std::cout << s_table[i][j] << "\t";
        }
        std::cout << std::endl;
    }
    */
    //Sequence seq(s_table, dict);

    Node* root = new Node();
    root = seq.init_sequence(1, list_matrixes.size());
     
    root = seq.init_sequence(1, list_matrixes.size());
    std::cout << "printing " << std::endl;
    std::cout << "(" << " ";
    seq.print_sequence(root);
    std::cout << ")" << " \n";
    
    std::cout << "COMPUTING " << std::endl;
    matrix* res = seq.gpu_compute(root);

    std::cout << "RES IS " << std::endl;
    seq.printMatrix(res);
    return 0;
}