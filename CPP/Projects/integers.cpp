#include<iostream>

int INT(){

    int a; //Contains garbage value. (Just initialised)
    int b{}; //Contains 0
    int c{12}; // contsains 12
    int d{15};
    int e = c+d;
    int f = 2.9; //Has 2

    std::cout<<a<<std::endl<<b<<std::endl<<d<<std::endl<<e<<std::endl<<f<<std::endl;
    return 0;
};

int INT_Modifiers(){
    int a{2};
    //int a2{2.3}; -------------------> Not Allowed int a2=2.3 has 2
    int b{-10}; //Signed by default
    unsigned int c=-12; //Number gets really large
    // unsigned int a{-5} will tthrow a compiler error
    // int takes 4 bytes
    // short takes 2 bytes
    // long takes 4 to 8 bytes

    // sizeof(); --> Returns the size of the value
    short d{17};
    short e{2521};
    long f{12131415};
    //std::cout<<a2<<std::endl;
    std::cout<<b<<std::endl<<c<<std::endl<<d<<std::endl<<e<<std::endl<<f<<std::endl;

    return 0;
};

int main(){
    //INT();
    INT_Modifiers();
};