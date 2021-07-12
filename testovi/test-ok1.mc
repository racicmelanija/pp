//OPIS: jedna deklaracija sa dve promenljive + postinkrement
//RETURN: 8

int main() {
    int a1,b;
    a1 = 2;
    b = 3 + a1++;
    return b + a1;
}
