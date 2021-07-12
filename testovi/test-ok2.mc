//OPIS: jedna deklaracija sa tri promenljive + postinkrement
//RETURN: 3
unsigned main() {
    unsigned a1,b,c;
    a1 = 2u;
    b = 3u - a1++ + 2u;
    c = 4u;
    return b;
}
