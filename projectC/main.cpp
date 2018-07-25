
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <iostream>



using namespace std;

int sommeTab(int tab[], int taille);
double moyTab(int tab[], int taille);
int minTab(int tab[], int taille);
int indMinTab(int tab[], int taille);
int maxTab(int tab[], int taille);
void ordonner(int tab[],int taille);


int main()
{
    int tab[] = {10,20,3,4};
    for (int i = 0; i < 4; i++)
        cout << tab[i] <<endl;

    cout << "Tri" << endl;
    ordonner(tab,4);
    for (int i = 0; i < 4; i++)
        cout << tab[i] <<endl;


    return 0;
}

int sommeTab(int tab[], int taille)
{
    int res = 0;
    for (int i = 0; i < taille; ++i)
    {
        res += tab[i];
    }
    return res;
}

double moyTab(int tab[], int taille)
{
    double res = sommeTab(tab,taille);
    res /= taille;
    return res;
}

int minTab(int tab[], int taille)
{
    int res = tab[0];
    for(int i = 0; i < taille; ++i)
    {
        if (res > tab[i])
            res = tab[i];
    }
    return res;
}

int maxTab(int tab[], int taille)
{
    int res = tab[0];
    for(int i = 0; i < taille; ++i)
    {
        if (res < tab[i])
            res = tab[i];
    }
    return res;
}
int indMinTab(int tab[], int taille)
{
    int res = tab[0];
    int ind = 0;
    for(int i = 0; i < taille; ++i)
    {
        if (res > tab[i])
        {
            res = tab[i];
            ind = i;
        }

    }
    return ind;
}


void ordonner(int tab[],int taille)
{
    int res[taille] = {0};
    int i = 0;
    int minT = 0;
    int indMin = 0;
    int maxT = maxTab(tab,taille);
    while (i < taille)
    {
        minT = minTab(tab,taille);
        indMin = indMinTab(tab,taille);
        res[i] = minT;
        tab[indMin] = maxT;
        i++;
    }

    for (int j = 0; j < taille; j++)
        tab[j] = res[j];
}
