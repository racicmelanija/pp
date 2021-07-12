//opis: postinkrement u pozivu funkcije
//RETURN: 3
int y;

int func(int b, int c){
	y = 1 + c;
	return y++;
}

int main(){
	int f, g;
	g = 1;
	f = func(0, g++);
	return y;
}
