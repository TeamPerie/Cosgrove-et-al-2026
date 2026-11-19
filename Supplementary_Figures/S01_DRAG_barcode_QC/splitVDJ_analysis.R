# Supplementary Fig. 1b-d: DRAG barcode length, N-insertions and deletions, DNA vs RNA barcodes.
#
# Inputs (outputs of the splitVDJ step, see Figure1/DNA_BC_PREPROCESSING/splitVDJ.R and
# Figure1/RNA_BC_PREPROCESSING/splitVDJ.R):
#   - DNA barcodes: splitbcs_<library>.txt, tab-separated, one file per DNA library (run D1037, libraries R05-R14)
#   - RNA barcodes: Split_VDJs_expts_merged.csv (comma-separated, all RNA barcodes)
#   - DNA-RNA barcode pairs: all_dna_rna_bc_pairs.csv (barcode length, panel b)
# Each data row of the split files is: full barcode, V, insVD, D, insDJ, J, delV, delDl, delDr, delJ, D.fwdorinv,
# errV, errD, errJ (the header line has no name for the first column).
#   insertions = nchar(insVD) + nchar(insDJ)                                 (N-additions)
#   deletions  = nchar(delV) + nchar(delDl) + nchar(delDr) + nchar(delJ)     (nucleotides removed from V, D and J)
#
# Correction (November 2026): the first version of this script read the DNA files with read.table() (whitespace
# separator), which drops empty fields and shifts the columns, and used column indices that, with the barcode in
# column 1, picked the V and D segments instead of the two insertions. Its DNA deletion values were also a copy of the
# RNA ones. The files are now split on their real separator, keeping empty fields. The corrected values are the ones in
# Supplementary Fig. 1c, d and in the Source Data file (DNA n = 374, RNA n = 174 barcodes).

# ---- set these to your local copies of the input files ----
dna_dir   <- "path/to/Step3_DNA_BC_processing/outputs/threshold_1"
rna_file  <- "path/to/Step4_RNA_BC_processing/split_VDJs/Split_VDJs_expts_merged.csv"
pair_file <- "path/to/Step6_10X_Data_integration/DNA_RNA_BC_PAIRS/all_dna_rna_bc_pairs.csv"
dna_files <- file.path(dna_dir, sprintf("splitbcs_D1037R%02d.txt", 5:14))

# read a split-barcode file keeping empty fields; returns one character vector of 14 fields per barcode
read_split <- function(f, sep) {
  lines <- readLines(f, warn = FALSE)[-1]
  lines <- lines[nzchar(lines)]
  lapply(strsplit(lines, sep, fixed = TRUE), function(x) c(x, rep("", 14 - length(x))))
}
indels <- function(rows, source) data.frame(
  source     = source,
  barcode    = sapply(rows, `[`, 1),
  insertions = sapply(rows, function(x) nchar(x[3]) + nchar(x[5])),
  deletions  = sapply(rows, function(x) sum(nchar(x[7:10]))))

dna <- do.call(rbind, lapply(dna_files, function(f) indels(read_split(f, "\t"), "DNA barcodes")))
rna <- indels(read_split(rna_file, ","), "RNA barcodes")
vdj <- rbind(dna, rna)
write.csv(vdj, "S1cd_insertions_deletions.csv", row.names = FALSE)

# panel b: barcode length
bc.pairs <- read.csv(pair_file)
hist(nchar(bc.pairs$Con.seq), main = "length of DRAG barcodes", xlab = "barcode length (bases)")

# panels c, d (plotted in Prism as box plots: quartiles, whiskers 5th-95th percentile)
boxplot(insertions ~ source, data = vdj, ylab = "number of insertions")
boxplot(deletions ~ source, data = vdj, ylab = "number of deletions")
print(aggregate(cbind(insertions, deletions) ~ source, data = vdj, FUN = median))
