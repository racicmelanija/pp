//opis: poziv funkcije sa vise parametara
//RETURN: 1
int f(int x, unsigned y, int z, int k, unsigned kk){
	return x + z - k;
}

int main(){
	int c;
	c = f(3, 1u, 4, 6, 7u);
	return c;
}
