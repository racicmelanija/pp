//OPIS: poziv funckija sa vise parametara 
//RETURN: 8

int f1(int a1, int a2, unsigned a3){
	unsigned k;
	int kk;

	kk = a1 + a2;

	return 2 + kk;	
}

int f2(int b1, int b2){
	unsigned q;
	unsigned w;
	int ww;

	ww = f1(1, 2, w);
	if(ww > 0 and ww < 3){
		return 3;
	}else{
		return ww;
	}
}

int main(){
	int poziv1;
	int poziv2;

	poziv1 = f1(3, 3, 3u);
	poziv2 = f1(poziv1, 2 + -3, 6u);

	return poziv1;
}
