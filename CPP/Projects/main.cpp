#include <iostream>

int func(int data1, int data2){
    int sum = data1+data2;
    return sum;
};

int Program1_Basic_Printing_Data_Declaring_and_Initialising_Function_Declaring_and_Calling() {
    int d1 = 12;
    int d2 = 13;
    int s = d1+d2;
    std::cout << "The sum of two numbers in inline adding are: " << d1+d2 << std::endl;
    std::cout << "The sum of two numbers in pre-adding (stored in s) are: " << s << std::endl;
    std::cout << "The sum of two numbers are: " << func(d1,d2) << std::endl;
    return 0;
    
    return 0;
};

int main(){
    Program1_Basic_Printing_Data_Declaring_and_Initialising_Function_Declaring_and_Calling();
};