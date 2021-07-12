//OPIS: jiro iskaz
//RETURN: 4

int main(){
	int t, w;
	w = 3;
	t = 7;

	jiro(t){
		tranga 1 =>
			w = 1;
			finish;
		tranga 2 =>
		{
			w = 11;
		}
		tranga 3 =>
		{
			w = 2 + 3;
		}
		tranga 4 =>
		{
			w = t++ + 3;
		}
		tranga 5 =>
			w = w + 2;
		toerana =>
			w++;
	}
	
	return w;
}
