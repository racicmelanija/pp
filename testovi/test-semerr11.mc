//OPIS: ponovljena konstanta u tranga naredbama (jiro iskaz)
unsigned f(){
	unsigned h;
	return h++ + 2u; 
}

int main(){
	int c, v, b;
	unsigned f, g;

	jiro(f){
		tranga 1u =>
			c = 2 + 3;
		tranga 2u =>
			c = v++ + -1;
		tranga 2u =>
		{
			v++;
		}
		tranga 1u =>
			g = f();
			finish;	
	}
	return 0;
}

