//OPIS: Sanity check
int glob; 

int f(int x) {
    int y, g, gg, ggg, g0;
    return x + 2 - y;
}

void set(unsigned i, int as, int es, unsigned el){
	int da;
	unsigned li;
	as = (da == as) ? 0 : es; 
	da = f(2);
	return;	
}

unsigned f2() {
    return 2u;
}

int funkcija(int a1, int b){
	return 2;
}

unsigned ff(unsigned x, int xx) {
    unsigned y;
    return x + f2() - y;
}

int main() {
    int a1, f;
    int b;
    int aa;
    int bb;
    int c;
    int d;
    unsigned u;
    unsigned w;
    unsigned uu;

    b = funkcija(3, -2);

    //poziv funkcije
    a1 = f(3);
    
    set(u + 2u, b, (d + 2) + -1, 1u);
    
    u = ff(2u, 1);
	
    para(int i = 1 a 7){
		aa = b++ + 3;
    }

    para(unsigned i = 1u a 7u){
		aa = b++ + 3;
    }
    
    jiro(w){
    	tranga 1u =>
    		a1 = f(3);
    	tranga 2u =>
    		a1++;
    		finish;
    	toerana =>
    		aa = b++ + 3;
    }
    
    jiro(f){
    	tranga 1 =>
    		aa = b++ + 3;
    }

    //if iskaz sa else delom
    if (a1 < b)  //1
        a1 = 1;
    else
        a1 = -2;

    if (a1 + c == b + d - 4) //2
        a1 = 1;
    else
        a1 = 2;

    if (u == w and u > 2u) {   //3
        u = ff(1u, 1);
        a1 = f(11);
    }
    else {
        w = 2u;
    }
    if (a1 + c == b - d - -4) {  //4
        a1 = 1;
    }
    else
        a1 = 2;
    a1 = f(42);

    if (a1 + (aa-c) - d < b + (bb-a1))    //5
        uu = w-u+uu;
    else
        d = aa+bb-c;

    //if iskaz bez else dela
    if (a1 < b)  //6
        a1 = 1;

    if (a1 + c == b - +4 or a1 + c > b - +4)    //7
        a1 = 1;

    return 0;

}

