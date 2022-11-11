
import std.algorithm;
import std.conv;
//import std.numeric;
import std.range;
import std.stdio;



// basic gates are NOT, OR, NOR, AND, NAND, XOR, XNOR, IMPLY

bool NOT(bool a){ // 1 variable
    return !a;
}

bool OR(bool a, bool b){
    return a|b;
}

bool AND(bool a, bool b){
    return a&b;
}

bool XOR(bool a, bool b){
    return a^b;
}

bool NOR(bool a, bool b){
    return !(a|b);
}

bool NAND(bool a, bool b){
    return !(a&b);
}

bool XNOR(bool a, bool b){
    return !(a^b);
}

bool IMPLY(bool a, bool b){ // noncommutative
    return !(a&!b);
}

// basic functions

bool[8] Int8Add(bool[8] a, bool[8] b){
    
    bool k;
    bool p;
    bool q;
    bool c;
    bool[8] sum;

    foreach(i;0..8){
        
        q = XOR(a[i], b[i]);
        p = AND(a[i], b[i]);
        c = AND(k, q);
        sum[i] = XOR(q, k);
        k = OR(c, p); // XOR also works
    }

    return sum;
}

// main

void main(){

    bool[8] a = [1,1,0,0,0,0,1,0];
    bool[8] b = [1,1,0,1,0,1,0,1];

    writeln(Int8Add(a, b));
}
