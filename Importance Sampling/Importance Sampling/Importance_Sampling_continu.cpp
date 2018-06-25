#include <Rcpp.h>
#include <iostream>
#include <cmath>
using namespace Rcpp;

void compute_p(NumericVector p, double d1, double d2, LogicalVector taken, double t) {
  double S = 0;
  int n = p.size();
  for(int i = 0; i < n; i++) {
    if(taken[i]) 
      p[i] = 0;
    else
      S += p[i] = exp(t*(d1-d2)/(d1+d2)*((double) i/(double) n));
  }
  for(int i = 0; i < n; i++)
    p[i] /= S;
}


int sample_int(NumericVector p) {
  double r = unif_rand();
  double S = 0;
  for(int i = 0; i < p.size(); i++) {
    S += p[i]; 
    if(S >= r) 
      return i;
  }
  // to avoid warning
  return 0;
}


// Prend une matrice n_points x n_points de distance
// et met L à jour : labels de 1 à n_points
//
// DIST = une matrice n_points x n_points , donnant la distance entre tous les points
// L = les labels attribués
// renvoie le poids de la permutation
// [[Rcpp::export]]
double IS_c(NumericMatrix DIST, IntegerVector L, double t) {
  int n_points = DIST.ncol();
  if( DIST.nrow() != n_points || L.size() != n_points)
    stop("Dimensions mismatch");
  // l'ordre dans lequel on va prendre les points
  IntegerVector J( sugar::EmpiricalSample(n_points, n_points, false, false) );
  // les 2 points d'attraction des extremites
  IntegerVector cols( sugar::EmpiricalSample(n_points, 2, false, false) );

  LogicalVector taken( n_points );
  NumericVector p( n_points );
  double w = 1;
  for(int i = 0; i < n_points; i++) {
    int j = J[i];
    double d1 = DIST( cols[0], j );
    double d2 = DIST( cols[1], j );
    compute_p(p, d1, d2, taken, t);
    int label = sample_int(p);
    L[j] = 1+label;
    w /= p[label] * ((double) (n_points - i));  // // on pourrait omettre la fin mais on risque un underflow
    taken[label] = true;
  }
  return w;
}

