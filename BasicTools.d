
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

bool[8] Int8Copy(bool[8] a){
    
    bool[8] b = a.dup;
    return b;
}

bool[8] Int8Add(bool[8] a, bool[8] b){
    
    bool k = false;
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

bool[8] Int8Mul(bool[8] a, bool[8] b){
    
    bool k;
    bool p;
    bool q;
    bool c;
    bool[8] w = Int8Copy(a);
    bool[8] mul = [0, 0, 0, 0, 0, 0, 0, 0];

    foreach(i;0..8){
        
        if(b[i]){
            
            k = false; // initialized to false for every i

            foreach(j;i..8){
                
    
                q = XOR(w[j], mul[j]);
                p = AND(w[j], mul[j]);
                c = AND(k, q);
                mul[j] = XOR(q, k);
                k = OR(c, p); // XOR also works
            }
        }
        
        foreach_reverse(j;i+1..8){
            w[j] = w[j-1];
        }
        
        w[i]=0;
    }

    return mul;
}

// main

void main(){

    // examples

    bool[8] a = [1,0,1,0,0,0,0,0]; // 5
    bool[8] b = [1,0,0,0,1,0,0,0]; // 17
    writeln(Int8Add(a, b)); // 22
    writeln(Int8Mul(a, b)); // 85

    bool[8] c = [1,1,0,0,1,0,0,0]; // 19
    bool[8] d = [0,1,1,0,0,0,0,0]; // 6
    writeln(Int8Add(c, d)); // 25
    writeln(Int8Mul(c, d)); // 114

    bool[8] e = [1,0,1,0,0,1,0,0]; // 37
    bool[8] f = [0,1,0,1,0,0,0,0]; // 10
    writeln(Int8Add(e, f)); // 47
    writeln(Int8Mul(e, f)); // 370 % 256 = 114
}
