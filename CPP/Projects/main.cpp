#include <iostream>
#include <string>

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


int in_out_err(){
    
    // Standard output flows
    std::cout<<"I'm a print message"<<std::endl;
    std::cerr<<"I'm a error message"<<std::endl;
    std::clog<<"I'm a log message!"<<std::endl;
    int age = 57;
    std::cout<<"Write your name: ";
    std::string name;
    
    //Input Flows
    std::cin>>name;
    std::cout<<"Hello "<< name << " How are you doing? I heard you're " <<age<< " years old!"<<std::endl;
    std::string mom_name, pops_name;
    std::cout<<"Write your mom and dad's first name separated by space: ";
    std::cin>> mom_name >> pops_name;
    std::cout<<"Hello "<<name<<" I heard you'r mom's name is "<<mom_name<<" and dad's name is "<<pops_name<<"."<<std::endl;
    
    // What if the user writes his full name ?

    std::string full_name;
    std::cout<<"Write your full name: "<<std::endl;
    std::cin.ignore(std::numeric_limits<std::streamsize>::max(), '\n');

    std::getline(std::cin,full_name);
    std::cout<<"Hello, "<<full_name<<std::endl;
    return 0;

};


int main(){
    //Program1_Basic_Printing_Data_Declaring_and_Initialising_Function_Declaring_and_Calling();
    //in_out_err();
    in_out_err();
};