//opis: ugnjezdeni para iskazi
//RETURN: 30

int main(){
	int e;
	int i;
	int f;
	f = 0;

	para(int i = 1 a 3){
		para(int k = 1 a 5){
			para(int j = 1 a 2){
				f++;
			}
			e = 1;	
		}
	}

	para(int i = 1 a 3){
		e = 0;
	}

	

	return f;
}
