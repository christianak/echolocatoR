% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/extract_snp_subset.R
\name{extract_snp_subset}
\alias{extract_snp_subset}
\title{Extract a subset of the summary stats}
\usage{
extract_snp_subset(
  subset_path,
  locus = NULL,
  colmap = echodata::construct_colmap(),
  fullSS_path,
  topSNPs,
  LD_reference,
  force_new_subset = FALSE,
  force_new_maf = FALSE,
  bp_distance = 5e+05,
  superpopulation = "EUR",
  compute_n = "ldsc",
  query_by = "tabix",
  download_method = "axel",
  nThread = 1,
  conda_env = "echoR_mini",
  verbose = TRUE
)
}
\arguments{
\item{subset_path}{Path where the \code{query} should be 
saved after standardization.}

\item{locus}{Locus name to fine-map (e.g. \code{"BIN1"}).
Can be named to indicate a specific gene within a QTL locus
(e.g. \code{c(ENSG00000136731="BIN1")}).}

\item{colmap}{Column name mappings in in \code{fullSS_path}. Must be a named
list. Can use \link[echodata]{construct_colmap} to assist with this. This
function can be used in two different ways:
\itemize{
\item{\code{munged=FALSE} : }{When \code{munged=FALSE},
 you will need to provide the necessary column names to the
 \code{colmap} argument (\emph{default}).}
 \item{\code{munged=TRUE} : }{ Alternatively, instead of filling out
 each argument in
\link[echodata]{construct_colmap}, you can simply set \code{munged=TRUE}
 if  \code{fullSS_path} has already been munged with
 \link[MungeSumstats]{format_sumstats}.
 }
}}

\item{fullSS_path}{Path to the full summary statistics file (GWAS or QTL)
that you want to fine-map.
It is usually best to provide the absolute path rather
than the relative path.}

\item{topSNPs}{A data.frame with the genomic coordinates of the lead SNP
for each locus.
The lead SNP will be used as the center of the window when extracting
subset from the full GWAS/QTL summary statistics file.
Only one SNP per \strong{Locus} should be included.
At minimum, \code{topSNPs} should include the following columns:
\describe{
\item{\emph{Locus}}{A unique name for each locus. Often,
 loci are named after a relevant gene (e.g. LRRK2) or based on
  the name/coordinates of the lead SNP (e.g. locus_chr12_40734202) }
\item{\emph{CHR}}{The chromosome that the SNP is on.
 Can be "chr12" or "12" format.}
\item{\emph{POS}}{The genomic position of the SNP (in basepairs)}
}}

\item{LD_reference}{LD reference to use:
\itemize{
\item{"1KGphase1" : }{1000 Genomes Project Phase 1 (genome build: hg19).}
\item{"1KGphase3" : }{1000 Genomes Project Phase 3 (genome build: hg19).}
\item{"UKB" : }{Pre-computed LD from a British
European-decent subset of UK Biobank.
\emph{Genome build} : hg19}
\item{"<vcf_path>" : }{User-supplied path to a custom VCF file 
to compute LD matrix from.\cr
\emph{Accepted formats}: \emph{.vcf} / \emph{.vcf.gz} / \emph{.vcf.bgz}\cr
\emph{Genome build} : defined by user with \code{target_genome}.}
\item{"<matrix_path>" : }{User-supplied path to a pre-computed LD matrix   
\emph{Accepted formats}:  \emph{.rds} / \emph{.rda} / \emph{.csv} / 
\emph{.tsv} / \emph{.txt}\cr
\emph{Genome build} : defined by user with \code{target_genome}.}
}}

\item{force_new_subset}{By default, if a subset of the full
 summary stats file for a given locus is already present,
then \pkg{echolocatoR} will just use the pre-existing file.
Set \code{force_new_subset=T} to override this and extract a new subset.
Subsets are saved in the following path structure:
\emph{Data/\<dataset_type\>/\<dataset_name\>/\<locus\>/Multi-finemap/
\<locus\>_\<dataset_name\>_Multi-finemap.tsv.gz}}

\item{force_new_maf}{Download UKB_MAF file again.}

\item{bp_distance}{Distance around the lead SNP to include.}

\item{superpopulation}{Superpopulation to subset LD panel by
(used only if \code{LD_reference} is "1KGphase1" or "1KGphase3").
See \link[echoLD]{popDat_1KGphase1} and \link[echoLD]{popDat_1KGphase3}
for full tables of their respective samples.}

\item{compute_n}{How to compute per-SNP sample size (new column "N").\cr
If the column "N" is already present in \code{dat}, this column 
will be used to extract per-SNP sample sizes
and the argument \code{compute_n} will be ignored.\cr
If the column "N" is \emph{not} present in \code{dat}, one of the following 
options can be supplied to \code{compute_n}: 
\itemize{
\item{\code{0}: }{N will not be computed.}
\item{\code{>0}: }{If any number >0 is provided,
that value will be set as N for every row.
**Note**: Computing N this way is incorrect and should be avoided
if at all possible.}
\item{\code{"sum"}: }{N will be computed as:
cases (N_CAS) + controls (N_CON), so long as both columns are present}.
\item{\code{"ldsc"}: }{N will be computed as effective sample size:
Neff =(N_CAS+N_CON)*(N_CAS/(N_CAS+N_CON)) / mean((N_CAS/(N_CAS+N_CON))(N_CAS+N_CON)==max(N_CAS+N_CON))}.
\item{\code{"giant"}: }{N will be computed as effective sample size:
Neff = 2 / (1/N_CAS + 1/N_CON)}.
\item{\code{"metal"}: }{N will be computed as effective sample size:
Neff = 4 / (1/N_CAS + 1/N_CON)}.
}}

\item{query_by}{Choose which method you want to use to extract
 locus subsets from the full summary stats file.
Methods include:
\describe{
\item{"tabix"}{Convert the full summary stats file in an indexed tabix file.
 Makes querying lightning fast after the initial conversion is done.
  (\emph{default})}
\item{"coordinates"}{Extract locus subsets using min/max genomic
coordinates with \emph{awk}.}
}}

\item{download_method}{\itemize{
\item{\code{"axel"} : }{Multi-threaded}
\item{\code{"wget"} : }{Single-threaded}
\item{\code{"download.file"} : }{Single-threaded}
\item{\code{"internal"} : }{Single-threaded 
(passed to \link[utils]{download.file})}
\item{\code{"wininet"} : }{Single-threaded 
(passed to \link[utils]{download.file})}
\item{\code{"libcurl"} : }{Single-threaded 
(passed to \link[utils]{download.file})}
\item{\code{"curl"} : }{Single-threaded 
(passed to \link[utils]{download.file})}
}}

\item{nThread}{Number of threads to parallelise saving across.}

\item{conda_env}{Conda environment to use.}

\item{verbose}{Print messages.}
}
\description{
Use \emph{tabix} to extract a locus subset
 from the full summary statistics file.
}
\seealso{
Other query functions: 
\code{\link{query_handler}()}
}
\concept{query functions}
\keyword{internal}
