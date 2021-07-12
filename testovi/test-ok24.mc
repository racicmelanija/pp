//opis: para iskazi
//RETURN: 11

int main(){
	int e;
	int i;
	int f;
	f = 0;

	para(int i = 1 a 3){
		para(int k = 1 a 5){
			e = k;
		}
		e = e + 1;
	}

	para(int i = 1 a 3){
		e++;
	}
	
	para(int j = 1 a 2){
		f++;
	}
	

	return f + e;
}
