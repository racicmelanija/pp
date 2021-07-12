//OPIS: jedna globalna promenljiva
//RETURN: 25

int x;

void f(){
	return;
}

int main() {
  int ha;
  f();
  ha = 11;
  x = 13;
  x = x + 1;
  return ha + x;
}

