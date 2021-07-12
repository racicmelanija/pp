//OPIS: funkcije sa vise parametara i njihovo pozivanje
//RETURN: -8

int foo(int f, unsigned g, int h, int j){
	return f + j - h;
}

int foo1(unsigned l, unsigned z, int s, int k){
	return 0;
}

int foo2(int l, unsigned z, unsigned s, int k, unsigned ll){
	int d, f;
	f = 2;
	d = foo(f, 8u, k, -9);
	return d;
}

int foo3(unsigned l, int z, int s, int k){
	return 0;
}

int foo4(unsigned l, unsigned z, int s, int k, int fo, int g){
	return 0;
}

int main(){
	int j, k;
	
	j = foo(1, 2u, 2, 6);
	k = foo1(4u, 5u, 2, 8);
	j = foo2(2, 2u, 3u, 1, 8u);
	k = foo3(2u, 1, 6, -3);
	k = foo4(2u, 9u, 8, -1, 0, 1);

	return j;
}
