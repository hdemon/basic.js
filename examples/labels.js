var nextLine = 10;
var a = 0;
loop: for (;;) {
    switch(nextLine) {
        case 10:
            nextLine = 20
            continue loop;
        case 20:
            console.log(a)
            nextLine = 30
            continue loop;
        case 30:
            a = a + 1;
            nextLine = 40
            continue loop;
        case 40:
            if (a <= 10) {
                nextLine = 20
            } else {
                nextLine = 50
            }
            continue loop;
        case 50:
            break loop;
    }
}
