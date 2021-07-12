//OPIS: globalne promenljive, inkrement
//RETURN: 265

int x;
int y;

int f1(int ha) {
    x = ha + 3;
    x++;
    ha++;
    return ha + x;
}

int f2(int ha) {
    y = ha + x;
    y++;
    return y;
}

int main() {
  int ha;
  int b;
  ha = f1(42);
  b = f2(17);
  ha++;
  y++;
  return ha + b + x + y;
}

