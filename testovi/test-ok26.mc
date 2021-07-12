//OPIS: jiro iskaz
//RETURN: 1

int main(){
	int t, w;
	t = 1;

	jiro(t){
		tranga 1 =>
			w = 1;
			finish;
		tranga 2 =>
		{
			w = 1;
		}
		tranga 3 =>
		{
			w = 2 + 3;
		}
		tranga 5 =>
			w = w + 2;
		toerana =>
			w++;
	}
	
	return w;
}
