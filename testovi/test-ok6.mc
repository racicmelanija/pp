//OPIS: logicki operatori
int func(){
	unsigned aba;
	unsigned b;
	unsigned c;
	if(aba == 5u and b > 2u and c != 0u){
		aba = 1u;
	}

	if(aba == 5u or b > 2u or c != 0u){
		b = 1u;
	}
	return 0;
}

int main(){
	int al;
	int b;
	int c;

	if(al == b or al > b){
		c = 3;
	}else{
		c = 4;
	}
	return 0;
}
