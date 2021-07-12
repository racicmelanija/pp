//OPIS: Pogresan broj argumenata u pozivu funckija
void o(){
	return;
}

int func(int f, int k, int jo){
	return;
}


int foo(int g, int b, int c, int h, int hh){

	return 2;
}


int main(){
	
	int poziv;
	int novi;

	o();
	novi = func(3, 5);               //func prima 3 arg
	novi = func(1, 2 + 4);
	novi = foo();
	poziv = foo(2, 3 + 3, 4, 5, 8);
	poziv = func(1, 2, 4);
	return 2 + 3;
}
