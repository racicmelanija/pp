//OPIS: dve globalne promenljive
//RETURN: 202

int x;
int y;

int f1(int ha) {
    x = ha;
    return x;
}

int f2(int ha) {
    y = ha + x;
    return y;
}

int main() {
    int ha;
    int b;
    ha = f1(42);
    b = f2(17);
    return ha + b + x + y;
}

