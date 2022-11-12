
import std.algorithm;
import std.conv;
//import std.numeric;
import std.range;
import std.stdio;



// basic gates are NOT, OR, NOR, AND, NAND, XOR, XNOR, IMPLY, NIMPLY

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

bool IMPLY(bool a, bool b){ // noncommutative, make sure torch signal does not backflow
    return !(a&!b);
}

bool NIMPLY(bool a, bool b){ // noncommutative, make sure torch signal does not backflow
    return a&!b;
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

bool[8] Int8Sub(bool[8] a, bool[8] b){
    
    bool k = false;
    bool p;
    bool q;
    bool c;
    bool[8] sub;

    foreach(i;0..8){
        
        q = XOR(k, b[i]);
        p = AND(k, b[i]);
        c = NIMPLY(q, a[i]);
        sub[i] = XOR(a[i], q);
        k = OR(c, p);
    }

    return sub;
}

bool[8] Int8Mul(bool[8] a, bool[8] b){
    
    bool k;
    bool p;
    bool q;
    bool c;
    bool[8] w = Int8Copy(a);
    bool[8] mul = [false, false, false, false, false, false, false, false];

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

// functions for readability, not implemented in game

int Int8ToNum(bool[8] a){
    
    int sum = 0;
    foreach(i;0..8){
        
        if(a[i]){
            sum += 2^^i;
        }
    }

    return sum;
}

bool[8] NumToInt8(int n){
    
    bool[8] i8 = [false, false, false, false, false, false, false, false];
    int k;

    foreach_reverse(i;0..8){
        
        k = 2^^i;
        if(n >= k){
            
            i8[i] = true;
            n -= k;
        }
    }

    return i8;
}

int[8] BoolTo01(bool[8] a){
    
    int[8] eight;

    foreach(i;0..8){
        eight[i] = (a[i]?1:0);
    }

    return eight;
}

// main

void main(){

    // examples

    bool[8] a = NumToInt8(5);
    bool[8] b = NumToInt8(17);
    bool[8] p = Int8Add(a, b);
    bool[8] q = Int8Sub(a, b);
    bool[8] r = Int8Mul(a, b);
    writeln(Int8ToNum(p), BoolTo01(p)); // 22
    writeln(Int8ToNum(q), BoolTo01(q)); // -12 % 256 = 244
    writeln(Int8ToNum(r), BoolTo01(r)); // 85

    bool[8] c = NumToInt8(171);
    bool[8] d = NumToInt8(166);
    bool[8] P = Int8Add(c, d);
    bool[8] Q = Int8Sub(c, d);
    bool[8] R = Int8Mul(c, d);
    writeln(Int8ToNum(P), BoolTo01(R)); // 337 % 256 = 81
    writeln(Int8ToNum(Q), BoolTo01(Q)); // 5
    writeln(Int8ToNum(R), BoolTo01(R)); // 28386 % 256 = 226
}

// for python:  f=lambda x:bin(x%256)[2:].zfill(8)[::-1]
