//OPIS: razliciti tipovi u izrazu
unsigned foo1(){
	int q, r, s;
	unsigned z, x, c;

	q = z++ + 2u - (r + c);
	return q;
}

int main(){
	unsigned c;
	c = foo1();
	return 0;
}
