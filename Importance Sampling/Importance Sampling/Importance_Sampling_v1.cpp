#include <Rcpp.h>
#include <iostream>
#include <cmath>
using namespace Rcpp;

// variante pour une matrice DIST de taille n xn
// le vecteur cols donne les indices des lignes à considérer
void compute_p(NumericVector p, NumericMatrix DIST, IntegerVector cols, int j, IntegerVector k, double t) {
  double S = 0;
  for(int i = 0; i < p.size(); i++) {
    S += p[i] = ((double) k[i])*exp(-t*DIST( cols[i], j));
  }
  for(int i = 0; i < p.size(); i++)
    p[i] /= S;
}


// [[Rcpp::export]]
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


// Cette version prend une matrice n_points x n_points de distance
// et tire n_labels nouveaux points d'attraction à chaque itération
//
// k = longueur = #labels n_labels, les valeurs sont les effectifs à attribuer à chaque label
// DIST = une matrice n_points x n_points , donnant la distance entre tous les points
// L = les labels attribués
// renvoie le poids de la permutation
// [[Rcpp::export]]
double IS(IntegerVector k, NumericMatrix DIST, IntegerVector L, double t) {
  int n_labels = k.size();
  int n_points = DIST.ncol();
  if( DIST.nrow() != n_points || L.size() != n_points)
    stop("Dimensions mismatch");
  // l'ordre dans lequel on va prendre les points
  IntegerVector J( sugar::EmpiricalSample(n_points, n_points, false, false) );
  // les n_labels lignes de DIST qui vont donner les distances aux points d'attraction
  IntegerVector cols( sugar::EmpiricalSample(n_points, n_labels, false, false) );

  IntegerVector K( clone(k) );
  NumericVector p( n_labels );
  double w = 1;
  for(int i = 0; i < n_points; i++) {
    int j = J[i];
    compute_p(p, DIST, cols, j, K, t);
    int label = sample_int(p);
    L[j] = 1+label;
    w /= p[label] / ((double) K[label]) * ((double) (n_points - i));  // // on pourrait omettre la fin mais on risque un underflow
    K[label]--;
  }
  return w;
}


// [[Rcpp::export]]
double t_test(NumericVector x, IntegerVector L) {
  int n = x.size();
  if( L.size() != n)
    stop("Dimensions mismatch");
  double S1 = 0, S2 = 0, SS1 = 0, SS2 = 0;
  double n1 = 0, n2 = 0; // ça va éviter des cast de compter en double
  for(int i = 0; i < n; i++) {
    if(L[i] == 1) {
      S1  += x[i];
      SS1 += x[i]*x[i];
      n1++;
      continue;
    }
    if(L[i] == 2) {
      S2  += x[i];
      SS2 += x[i]*x[i];
      n2++;
      continue;
    }
    stop("More than two levels in t-test");
  }
  double SC1 = (SS1 - S1*S1/n1);
  double SC2 = (SS2 - S2*S2/n2);
  double var = (SC1 + SC2)/(n1+n2-2);  
  return (S2/n2-S1/n1)/sqrt( var*(1/n1+1/n2) );
}

IntegerVector my_table(IntegerVector x) {
  std::vector<int> R;
  for(int a : x) {
     if(a > R.size())  
       R.resize(a);
     R[a-1]++;
  }
  return wrap(R);
}

// [[Rcpp::export]]
List Run_IS(Function Stat, SEXP D, IntegerVector L0, NumericMatrix DIST, int B, double t_start, double t_end) {
  int n_points = DIST.nrow();
  if( DIST.ncol() != n_points )
    stop("Dimensions mismatch\n");

  IntegerVector L( clone(L0) );
  double stat_obs = as<double>(Stat(D, L));
  IntegerVector k = my_table(L);  // effectifs des différents labels
  int n_labels = k.size();

  double t = t_start;
  double t_step = (t_end - t_start)/B;
  double sum_wI = 0, sum_wI2 = 0, sum_w = 0;
  int n_greater = 0;
  for(int b = 0; b < B; b++) {
    double w = IS(k, DIST, L, t);
    double stat_perm = as<double>(Stat(D, L));
    if(stat_perm > stat_obs) {
      sum_wI += w;
      sum_wI2 += w*w;
      n_greater++;
    }
    sum_w += w;
    t += t_step;
  }
  List R;
  R["stat.obs"] = stat_obs;
  R["p"] = sum_wI/sum_w;
  R["sd.p"] = sqrt(sum_wI2/sum_w/sum_w);
  R["n.greater"] = n_greater;
  R["sum.w"] = sum_w;
  R["sum.wI"] = sum_wI;
  R["sum.wI2"] = sum_wI2;
  return R;
}

//[[Rcpp::export]]
List Run_IS_t_test(NumericVector x, IntegerVector L0, NumericMatrix DIST, int B, double t_start, double t_end) {
  int n_points = DIST.nrow();
  if( DIST.ncol() != n_points )
    stop("Dimensions mismatch\n");

  IntegerVector L( clone(L0) );
  double stat_obs = std::abs(t_test(x, L));
  IntegerVector k = my_table(L);  // effectifs des différents labels
  int n_labels = k.size();

  double t = t_start;
  double t_step = (t_end - t_start)/B;
  double sum_wI = 0, sum_wI2 = 0, sum_w = 0;
  int n_greater = 0;
  for(int b = 0; b < B; b++) {
    double w = IS(k, DIST, L, t);
    double stat_perm = std::abs(t_test(x, L));
    if(stat_perm > stat_obs) {
      sum_wI += w;
      sum_wI2 += w*w;
      n_greater++;
    }
    sum_w += w;
    t += t_step;
  }
  List R;
  R["stat.obs"] = stat_obs;
  R["p"] = sum_wI/sum_w;
  R["sd.p"] = sqrt(sum_wI2/sum_w/sum_w);
  R["n.greater"] = n_greater;
  R["sum.w"] = sum_w;
  R["sum.wI"] = sum_wI;
  R["sum.wI2"] = sum_wI2;
  return R;
}

