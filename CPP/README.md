**If you're using windows, make sure to configure all three compilers (GCC, Clang and MSVC)**

# Commands for compiling in each language:

1. g++ -std=c++20 -Wall -Wextra -g [compilable].cpp -o [executable].exe

2. clang++ -std=c++20 -Wall -Wextra -g [compilable].cpp -o [executable].exe

3. cl /std:c++20 /EHsc /W4 /Zi main.cpp

# There are three types of errors in CPP:

1. Compiletime Error: This happens before your program even starts. The compiler (the translator) looks at your code and says, "I don't understand what you wrote."
If you have a compile-time error, no .exe file is created. You cannot run the program.
Common Causes: Missing semicolons, misspelling variables, trying to put text into an integer variable.
The Experience: You see red squiggly lines in VS Code, or the terminal says "Build failed.".

2. Runtime Error: This happens while the program is running. The compiler thought your code looked perfect (grammatically correct), so it created the .exe. However, when the computer tried to actually do what you asked, it resulted in an impossible or illegal operation.
Common Causes: Dividing by zero, accessing memory that isn't yours (segmentation fault), or running out of memory.
The Experience: The program starts, opens a window, and then suddenly closes, freezes, or Windows shows a "Program has stopped working" dialog.

3. Warning: Think of a Warning as the compiler saying: "I will build this for you, but it looks suspicious and it might crash later."
Unlike an Error, a Warning does not stop the build. You still get your .exe file, and you can run it. However, warnings usually point to logic errors or sloppy coding that will cause bugs down the road.

The "Check Engine Light" Analogy
Error: Your car has no tires. You cannot drive.
Warning: Your "Check Engine" light is on. You can drive, but the car might explode in 5 miles.

Common Examples of Warnings
Here are two classic C++ scenarios that cause warnings.

The "Unused Variable" (Harmless but Messy)
You declared a variable but never did anything with it.

int main() {
    int x = 10; // Warning: variable 'x' is unused
    std::cout << "Hello";
    return 0;
}
Why it warns: "Why did you waste memory creating x if you aren't using it? Did you forget to finish your code?"


The "Data Loss" (Dangerous)
You try to shove a precise decimal number into a simple integer.
int main() {
    double pi = 3.14159;
    int number = pi; // Warning: conversion from 'double' to 'int', possible loss of data
    
    // 'number' will be 3. The .14159 is gone forever.
    return 0;
}


