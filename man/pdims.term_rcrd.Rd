% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/pdims.R
\name{pdims.term_rcrd}
\alias{pdims.term_rcrd}
\title{Parameter Dimensions}
\usage{
\method{pdims}{term_rcrd}(x, ...)
}
\arguments{
\item{x}{An object.}

\item{...}{Other arguments passed to methods.}
}
\value{
A named list of integer vectors of the dimensions of each parameter.
}
\description{
Gets the dimensions of each parameter of an object.
}
\details{
Errors if the parameter dimensions are inconsistent.
}
\examples{
pdims(as_term_rcrd(term("alpha[1]", "alpha[3]", "beta[1,1]", "beta[2,1]")))
}
\seealso{
Other dimensions: 
\code{\link[universals]{dims}()},
\code{\link[universals]{ndims}()},
\code{\link[universals]{npdims}()}
}
