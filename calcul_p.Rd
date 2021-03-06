\name{calcul_p}
\alias{calcul_p}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Estimation of the p-value with Pareto's function or Box-Cox function used on distribution's tail.
%%  ~~function to do ... ~~
}
\description{ Estimates the p-value of a given data set zsim with the test statistics Zobs thanks to Pareto's method or Box-Cox method with their different estimated parameters.
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
calcul_p(zsim,Ntail=500,estim=c("PWM","EMV"),Zobs,param,method=c("BC","GPD"))
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{zsim}{ Data set -  list of real numbers
%%     ~~Describe \code{x} here~~
}
\item{Ntail}{ Length of the tail of the data set taken - integer
%%     ~~Describe \code{x} here~~
}
\item{estim}{ Method to estimate the parameters of Pareto's function - String: estim takes either a string that matches "PWM" ("P","PW",...) for the method of probability weighted moments or a string that matches "EMV" ("EM","V",...) for the method of maximum likelihood. Default value is "PWM".
%%     ~~Describe \code{x} here~~
}
\item{Zobs}{ Test statistic of the data set  - real number
%%     ~~Describe \code{x} here~~
}
\item{param}{ Box-cox parameter lambda - real number: if param is missing, the parameter will be estimated with least squares; if it is a real number, this value will be used for lambda without performing any estimation
%%     ~~Describe \code{x} here~~
}
\item{method}{ Method chosen to estimate the p-value  - String: either a string that matches "GDP" ("G", "GP", "PD",...) for Pareto's method or a string that matches "BC" ("BC", "B", ...) for Box-Cox's method. Default value is "BC".
%%     ~~Describe \code{x} here~~
}
}
\details{ Both methods are applied on the distribution's tail of the data set.
%%  ~~ If necessary, more details than the description above ~~
}
\value{ Returns a list composed of the estimated p-value and the parameter(s) of the selected method of estimation.
If the selected method is "BC", it returns a list composed of:
 \item{Pbc_z }{The estimated p-value with Box-Cox function -  real number}
 \item{lambda }{The estimated parameter lambda (or the lambda given if not estimated) - real number}

If the selected method is "GPD", it returns a list composed of:
  \item{Pgpd}{The estimated p-value with Pareto's function -  real number}
  \item{k }{The estimated parameter k of Pareto's cumulative distribution function - real number}
  \item{a }{The estimated parameter a of Pareto's cumulative distribution function - real number}

%% ...
}
\references{Theo A. Knijnenburg, Lodewyk F. A. Wessels, Marcel J. T. Reinders
and Ilya Shmulevich, Fewer permutations, more accurate P-values, Bioinformatics.
%% ~put references to the literature/web site here ~
}
\author{ Marion
%%  ~~who you are~~
}

\examples{
calcul_p(zsim=rnorm(1e6),Zobs=5,method="BC")

## The function is currently defined as
function (zsim,Ntail=500,estim=NA,Zobs,param=NA,method)
{
# les Ntail + 1 plus grandes valeurs (les dernieres)
  z1 <- tail( sort(zsim) , Ntail + 1 )
  #seuil pour la GDP
  t<-(z1[1] + z1[2])/2
  #calcul des excedents de la GDP, ceux qui lui sont superieurs
  z1<-z1[-1]
  zgpd<-z1-t
  zgpd<-zgpd[zgpd>0] #uniquement ceux superieurs au seuil

  method<-match.arg(method)
  if (method == "BC") {
    result<-PBC_Z(z1,length(zsim),Ntail,param,Zobs)
    return(list(Pbc_z = result$p,
                lbda = result$lbda))
    }

  if (method =="GPD"){
    estim<-match.arg(estim)
    result<-PGPD(Zobs,zgpd,zsim,t,estim)
    return(list(Pgpd=result$p,
                  a=result$a,
                  k=result$k))
  }
}
}

