##############################################################
# Figure 1g: Spearman correlation between signature scores and myeloid bias,
# observed signatures vs 200 random gene sets of the same size.
#
# This is the code that produced the published panel: the final permutation chunk of
# IntegrateDataset_Analysis4.Rmd (JCB32 MetaFate pipeline, 2022-08-25), preceded by the
# barcoded-cell classification steps of IntegrateDataset_Analysis.Rmd.
# Verified 2026-10-31: all 4 observed values and all 4 x 200 permuted values reproduce the
# plotted dots (observed within 0.0001).
#
# Signature definitions used for the panel (differ from the later IntegrateDataset_Analysis.Rmd):
#   DRAG-All genes            FindConservedMarkers M vs (E + diff_inactive), logfc.threshold = 0.001,
#                             combined p <= 0.05 and mean log2FC > 0.1          (307 genes)
#   DRAG-Metabolic (MetaFate) DRAG-All genes in metabolic_signatures$allGenesTested (no KEGG update; 54 genes)
#   DRAG-Transcription factor DRAG-All genes in GO sets named "transcription factor activity" (16 genes)
#   MPP3                      Pia_MPP3 genes present in the RNA assay (279 genes)
#
# Usage: Rscript Fig1g_permutation_test.R <INTEGRATION folder> [output folder]
#   <INTEGRATION folder> = JCB32_MetaFate_final_pipeline/pipeline_scripts/INTEGRATION, which holds
#   Robjects/sobj_integrated.Rda, genesets/ and helper_methods_refactored.R.
#   Outputs (default: the folder of this script): Fig1g_observed_rho.csv, Fig1g_permuted_rho.csv,
#   Fig1g_signature_genes.csv
#
# @Author: Jason Cosgrove (jason.cosgrove@curie.fr)
###############################################################

args <- commandArgs(trailingOnly = TRUE)
integration.dir <- args[1]
script.dir <- dirname(normalizePath(sub("^--file=", "", grep("^--file=", commandArgs(FALSE), value = TRUE))))
output.dir <- if (length(args) > 1) args[2] else script.dir

library(Seurat)
source(file.path(integration.dir, "helper_methods_refactored.R"))
set.seed(12345)

load(file.path(integration.dir, "genesets/metabolic_signatures.Rda"))
load(file.path(integration.dir, "genesets/GO.Rda"))
gene.sets <- read.csv(file.path(integration.dir, "genesets/genesets.csv"))

dataset.integrated <- readRDS(file.path(integration.dir, "Robjects/sobj_integrated.Rda"))
all.barcoded.cells <- colnames(dataset.integrated)[dataset.integrated$barcoded == TRUE]

# published signature scores (gives Pia_MPP31)
dataset.integrated <- geneSignatureScoring(dataset.integrated, gene.sets, colnames(gene.sets), assay = "RNA")


# classify barcoded cells: bias score = Myeloid / (Myeloid + Erythroid), M >= 75th and E <= 25th percentile
diff.active.barcoded.cells <- colnames(dataset.integrated)[rowSums(dataset.integrated@meta.data[, c("Myeloid", "Erythroid")]) > 0]
diff.active <- subset(dataset.integrated, cells = diff.active.barcoded.cells)
diff.active$bias.score <- diff.active@meta.data$Myeloid / (diff.active@meta.data$Myeloid + diff.active@meta.data$Erythroid)

dataset.integrated$bias.score <- 0
dataset.integrated@meta.data[colnames(diff.active), ]$bias.score <- diff.active@meta.data$bias.score
diff.active <- setLineageBias(diff.active, 0.25, 0.75)

bc <- subset(dataset.integrated, cells = all.barcoded.cells)
bc <- setDiffBias(bc)
bc <- SetIdent(bc, value = "bias")
bc@active.assay <- "RNA"


# differential expression, M-biased vs E-biased + differentiation-inactive, conserved across mice.
# min.pct = 0.1 and the log2(mean(expm1(x)) + 1) fold change are the Seurat 4 defaults used originally;
# they are set explicitly so that Seurat 5 gives the same result.
seurat4.mean.fxn <- function(x) log(x = rowMeans(x = expm1(x = x)) + 1, base = 2)

if (requireNamespace("metap", quietly = TRUE)) {
  m <- FindConservedMarkers(bc, ident.1 = "M", ident.2 = c("E", "diff_inactive"), grouping.var = "orig.ident",
                            test.use = "wilcox", logfc.threshold = 0.001, meta.method = metap::sumlog,
                            min.pct = 0.1, mean.fxn = seurat4.mean.fxn)
} else {
  # metap not installed: same steps as Seurat::FindConservedMarkers with Fisher's method (= metap::sumlog)
  sumlog <- function(p) {
    keep <- (p > 0) & (p <= 1)
    chisq <- (-2) * sum(log(p[keep]))
    df <- 2 * sum(keep)
    list(chisq = chisq, df = df, p = pchisq(chisq, df, lower.tail = FALSE))
  }
  bc.split <- SetIdent(bc, cells = colnames(bc), value = paste(Idents(bc), bc$orig.ident, sep = "_"))
  levels.split <- names(sort(table(bc$orig.ident)))
  marker.test <- lapply(levels.split, function(level.use) {
    FindMarkers(bc.split, assay = "RNA", slot = "data", ident.1 = paste("M", level.use, sep = "_"),
                ident.2 = paste(c("E", "diff_inactive"), level.use, sep = "_"), min.cells.group = 3,
                test.use = "wilcox", logfc.threshold = 0.001, min.pct = 0.1, mean.fxn = seurat4.mean.fxn)
  })
  names(marker.test) <- levels.split
  genes.conserved <- Reduce(intersect, lapply(marker.test, rownames))
  m <- Reduce(cbind, lapply(levels.split, function(level.use) {
    x <- marker.test[[level.use]][genes.conserved, ]
    colnames(x) <- paste(level.use, colnames(x), sep = "_")
    x
  }))
  pval.codes <- colnames(m)[grepl("*_p_val$", colnames(m))]
  m$max_pval <- apply(m[, pval.codes, drop = FALSE], 1, max)
  m$minimump_p_val <- apply(m[, pval.codes, drop = FALSE], 1, function(x) sumlog(x[!is.na(x) & !is.nan(x)])$p)
  m <- m[order(m$minimump_p_val), ]
}

m$avg_log2FC <- rowMeans(m[, grepl("log2FC", colnames(m))])

m.filtered <- m[m$minimump_p_val <= 0.05 &
                  rowMeans(m[, grepl("log2FC", colnames(m))]) > 0.1, ]
m.filtered <- m.filtered[order(m.filtered$avg_log2FC, decreasing = TRUE), ]
m.fate <- rownames(m.filtered)

m.metab <- intersect(c(metabolic.signatures$allGenesTested), c(rownames(m.filtered)))

TF.genes <- c(unique(unlist(GO.sets[names(GO.sets)[grepl("transcription factor activity", names(GO.sets))]])))
m.tf <- intersect(TF.genes, rownames(m.filtered))

mpp3 <- intersect(rownames(bc), gene.sets$Pia_MPP3)


# observed correlations
bc <- AddModuleScore(bc, features = list(rownames(m.filtered)), name = "M_fate", replace = TRUE, assay = "RNA")
bc <- AddModuleScore(bc, features = list(m.tf), name = "M_tf", replace = TRUE, assay = "RNA")
bc <- AddModuleScore(bc, features = list(m.metab), name = "m_metab", replace = TRUE, assay = "RNA")
sobj <- bc

observed <- c(cor.test(bc$Pia_MPP31, bc$bias.score, method = "spearman")$estimate[[1]],
              cor.test(bc$M_tf1, bc$bias.score, method = "spearman")$estimate[[1]],
              cor.test(bc$m_metab1, sobj$bias.score, method = "spearman")$estimate[[1]],
              cor.test(bc$M_fate1, bc$bias.score, method = "spearman")$estimate[[1]])


# permutations: permutationTest() from helper_methods_refactored.R, unchanged. Each run is seeded with
# set.seed(1245 * i). Note it draws indices from the RNA genes (nrow(sobj)) but looks the names up in
# rownames(dataset.integrated), the 4,000 features of the default "integrated" assay; indices above 4,000
# give NA and are dropped by AddModuleScore. Kept as is because this is what the published panel shows.
m.perm <- permutationTest(m.fate, sobj, "bias.score", 200)
m.metab.perm <- permutationTest(m.metab, sobj, "bias.score", 200)
m.tf.perm <- permutationTest(m.tf, sobj, "bias.score", 200)
mpp3.perm <- permutationTest(mpp3, sobj, "bias.score", 200)


labels <- c("MPP3", "DRAG-Transcription factor", "DRAG-Metabolic (MetaFate)", "DRAG-All genes")
genes <- list(mpp3, m.tf, m.metab, m.fate)

write.csv(data.frame(signature = labels, n_genes = lengths(genes), spearman_rho = observed),
          file.path(output.dir, "Fig1g_observed_rho.csv"), row.names = FALSE)

permuted <- data.frame(permutation = 1:200, mpp3.perm[, 1], m.tf.perm[, 1], m.metab.perm[, 1], m.perm[, 1])
colnames(permuted) <- c("permutation", labels)
write.csv(permuted, file.path(output.dir, "Fig1g_permuted_rho.csv"), row.names = FALSE)

write.csv(data.frame(signature = rep(labels, lengths(genes)), gene = unlist(genes)),
          file.path(output.dir, "Fig1g_signature_genes.csv"), row.names = FALSE)

print(read.csv(file.path(output.dir, "Fig1g_observed_rho.csv")))
sessionInfo()
