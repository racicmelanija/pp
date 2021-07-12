//OPIS: jiro iskaz
//RETURN: 8
int main(){
	int t, w;
	t = 3;

	jiro(t){
		tranga 1 =>
			t = 1;
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
