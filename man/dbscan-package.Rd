% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/AAA_dbscan-package.R
\docType{package}
\name{dbscan-package}
\alias{dbscan-package}
\title{dbscan: Density-Based Spatial Clustering of Applications with Noise (DBSCAN)
and Related Algorithms}
\description{
A fast reimplementation of several density-based algorithms of
the DBSCAN family. Includes the clustering algorithms DBSCAN (density-based
spatial clustering of applications with noise) and HDBSCAN (hierarchical
DBSCAN), the ordering algorithm OPTICS (ordering points to identify the
clustering structure), shared nearest neighbor clustering, and the outlier
detection algorithms LOF (local outlier factor) and GLOSH (global-local
outlier score from hierarchies). The implementations use the kd-tree data
structure (from library ANN) for faster k-nearest neighbor search. An R
interface to fast kNN and fixed-radius NN search is also provided.
Hahsler, Piekenbrock and Doran (2019) \url{doi:10.18637/jss.v091.i01}.
}
\section{Key functions}{

\itemize{
\item Clustering: \code{\link[=dbscan]{dbscan()}}, \code{\link[=hdbscan]{hdbscan()}}, \code{\link[=optics]{optics()}}, \code{\link[=jpclust]{jpclust()}}, \code{\link[=sNNclust]{sNNclust()}}
\item Outliers: \code{\link[=lof]{lof()}}, \code{\link[=glosh]{glosh()}}, \code{\link[=pointdensity]{pointdensity()}}
\item Nearest Neighbors: \code{\link[=kNN]{kNN()}}, \code{\link[=frNN]{frNN()}}, \code{\link[=sNN]{sNN()}}
}
}

\author{
Michael Hahsler and Matthew Piekenbrock
}