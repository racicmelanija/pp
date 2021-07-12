//opis: lokalne promenljive i povratna vrednost
//RETURN: 11

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
		i = 10;
	}

	para(int i = 1 a 3){
		e = 0;
		i = 15;
	}

	i = 11;

	return i;
}
