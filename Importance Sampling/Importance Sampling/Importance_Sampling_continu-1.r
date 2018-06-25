Sys.setenv("PKG_CXXFLAGS"="-std=c++11")
Rcpp::sourceCpp("Importance_Sampling_continu.cpp")

# exemple
set.seed(1)
x <- rnorm(400)
y <- rnorm(400) + 0.2*x


obs <- cor(x,y);
cor.test(x,y) # p = 3e-5

# permutations "classiques"
perm0 <- replicate(10000, { y1 <- sample(y); cor(x,y1) } )

mean( abs(perm0) > abs(obs) )  # oups 0

# importance sampling (avec theta qui augmente à chaque itération)
DIST <- outer(x, x, function(a,b) abs(a-b) )
L <- integer(length(x))
B <- 10000
w <- numeric(B)
perm <- numeric(B)
theta <- seq(0,2.5,length=B)
y1 <- sort(y)
for(i in 1:B) {
  w[i] <- IS_c(DIST, L, theta[i])
  perm[i] <- cor(x, y1[L])
}

sum( w*(abs(perm) > abs(obs)) )/sum(w) # 4e-6 ... (très variable)
