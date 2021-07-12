//OPIS: pogresni tipovi argumenata
int foo1(int a1, int a2, unsigned a3, unsigned a4, int a5){
	return 0;
}

unsigned foo2(unsigned a1, int a2, unsigned a3, int a4, int a5){
	return 0u;
}

int foo3(int a1, int a2, int a3, unsigned a4){
	unsigned f;
	f = foo2(2u, 1, 3u, 1, 2); //nije greska
	return 0;
}

int foo4(int a1, int a2, unsigned a3, int a4, int a5, int a6){
	return 0;
}

int foo5(int a1){
	int f;
	f = foo4(1 + -1, 9, 2u, 3u, 4u, 6);
	return 0;
}

int main(){
	int p;
	unsigned o;
	int a1, a2, a3, a4;
	a1 = 2;
	a2 = 3;
	a3 = 4;
	a4 = 0;

	o = foo2(a1, a2, a3, a4 + -3, 1);
	p = foo1(1, 2, 3u, 3, 0);
	p = foo3(1, 1u, a2, 2u + o++);
	p = foo5(o);

	return 0;
}
