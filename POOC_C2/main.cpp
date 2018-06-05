#include <iostream>
#include "ZFraction.h"
#include <cmath>

using namespace std;

int main()
{
    ZFraction a(1,-2);
    cout << a << endl;     //Déclare une fraction valant 4/5
    cout << a.nombreReel() << endl;

    ZFraction b(puissance(a,-3));
    cout << b << endl;
    cout << a;

    return 0;
}
