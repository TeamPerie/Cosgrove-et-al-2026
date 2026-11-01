# Cosgrove et al. – The pentose phosphate pathway modulates myelo-lymphoid lineage specification

Analysis code for:

> Cosgrove J., Donada A., Lyne A.-M., *et al.* **The pentose phosphate pathway modulates myelo-lymphoid lineage specification.** *Nature Communications* (2026). DOI: [to be added on publication]

Repository: https://github.com/TeamPerie/Cosgrove-et-al-2026 (renamed from `Cosgrove-et-al-2022` in 2026; links to the old name redirect here).

An earlier version of this work was posted as a preprint under the title *"Metabolic priming of multipotent hematopoietic progenitors fuels innate immunity"* (bioRxiv, 2023). This repository was created for that preprint and has been updated for the published article.

> **Folder layout.** Folders are named after the figures of the **published article**. Until 2026 the repository used the numbering of the 2023 preprint (`Figure3/` = today's Fig. 6, `Figure5/` = today's Fig. 2, with duplicate copies); that layout is preserved at the git tag [`preprint-layout`](https://github.com/TeamPerie/Cosgrove-et-al-2026/tree/preprint-layout), so links to the preprint version still work there.

## Repository layout

| Folder | Analysis | Main scripts |
|---|---|---|
| `Figure1/DNA_BC_PREPROCESSING/` | DRAG barcode extraction, clean-up and QC from bulk DNA sequencing of mature myeloid/erythroid cells | `run_analysis_bcmouse.sh`, `bcmouse*.sh`, `tagcleanup.R`, `splitVDJ.R`, `DNA_BC_QC.Rmd` |
| `Figure1/RNA_BC_PREPROCESSING/` | Recovery of DRAG barcodes from 10x scRNA-seq libraries, consensus calling, IGoR generation probabilities | `run_10x_analysis_vdj.sh`, `consensus_per_UMI_and_cell_reads.R`, `splitVDJ.R`, `infer_igor_tags.sh` (see folder README) |
| `Figure1/INTEGRATION/` | MetaFate: scRNA-seq QC and integration, lineage-bias scoring, DEGs, pathway enrichment, signatures, permutation tests, cross-validation, validation on public datasets | `IntegrateDataset_QCandPreprocessing.Rmd`, `IntegrateDataset_Analysis.Rmd`, `IntegrateDataset_Validation.Rmd`, `Fig1g_permutation_test.R`, `helper_methods_refactored.R` |
| `Figure2/CD62L_MPP_barcoding/` | Lentiviral barcoding of CD62L<sup>neg/high</sup> MPPs (3 weeks post-transplant): demultiplexing, QC, clone size and lineage bias | `Demultiplex/`, `QC/lentiviralbarcoding_QC_WT.Rmd`, `Analysis/CD62L_MPP_analysis.Rmd` |
| `Figure2/inflammation_reanalysis/` | Re-analysis of public scRNA-seq: G-CSF (Fast et al. 2022), EPO (Tusi et al. 2018), PyMT (Gerber-Ferder et al. 2023) | one sub-folder per dataset |
| `Figure3/metabolomics/` | Low-input LC-MS/MS metabolomics of HSPC subsets | `metabolomics_anlaysis.R` (+ the per-sample peak tables it reads) |
| `Figure4/PAGA_Dahlin2018/` | PAGA trajectory model of the Dahlin et al. 2018 cKit<sup>+</sup> dataset | `process_paga_dataset_dahlin.py`, `dahlin18.ipynb` |
| `Figure4/pathway_dynamics_Dahlin2018/` | Metabolic pathway signature dynamics along the trajectories | `S6.Rmd` |
| `Figure4/Haemopedia/` | Haemopedia bulk RNA-seq ([Haemopedia-Mouse-RNASeq](https://www.haemosphere.org/datasets/analyse?datasetName=Haemopedia-Mouse-RNASeq)): PCA, lineage DEGs, MIIC input and network heatmap | `Fig4b_PCA_original_2022-05-04.Rmd` (code that made Fig. 4b; its knitted output is `FigureS7.html`), `FigureS7.Rmd`, `MIIC_heatmap.Rmd`, `S7_helpermethods.R` |
| `Figure5/scCHICseq_H3K4me1/` | Single-cell ChIC-seq (H3K4me1) of CD62L<sup>neg/high</sup> MPPs after 6-AN and of WT vs G6PD-Tg MPPs: QC, clustering, differential enrichment, motifs | `ChIC_Analysis_1.Rmd`, `global_var.R` |
| `Figure6/G6PD_barcoding/` | Lentiviral barcoding of WT vs G6PD-Tg MPPs | `Demultiplex/`, `QC/lentiviralbarcoding_QC_{WT,TG}.Rmd`, `Analysis/Analysis.Rmd` |
| `Supplementary_Figures/S1_DRAG_barcode_QC/` | Barcode length / insertion / deletion summaries; RNA barcode recovery | `splitVDJ_analysis.R`, `summarise-RNA-BC-recovery.R` |
| `Supplementary_Figures/S9_S10_SLAM_HSC_barcoding/` | Lentiviral barcoding of SLAM HSCs, 12 months post-transplant | `Demultiplex/newXcalibr.bash`, `QC/step2_QCandPreprocessing.Rmd`, `Analysis/step3_Analysis.Rmd` |
| `Supplementary_Figures/S12_Plasmodium_Haltalli2020/` | Re-analysis of *P. berghei* infection scRNA-seq (Haltalli et al. 2020) | `loCelso.R`, `loCelso2.R`, `loCelso.py` |
| `Supplementary_Figures/S13_HSPC_signatures/` | HSC/MPP signature scoring in the inflammation datasets | `calculate_HSPC_sigs.Rmd` |
| `Figure1/data/` | MetaFate per-cell metadata and expression matrix (= Supplementary Data 5) | `S5a_metafate_seurat_metadata.csv`, `MetaFate_expression_matrices.zip` |

## Where to find the code for each figure

"Flow / Prism" means the panel was quantified in FlowJo and plotted and tested in GraphPad Prism, with no custom code. The numbers behind every plot are in the article's Source Data file.

| Published figure | Panels | Code |
|---|---|---|
| **Fig. 1** | b, c | `Figure1/DNA_BC_PREPROCESSING/DNA_BC_QC.Rmd`; `Figure1/INTEGRATION/IntegrateDataset_Analysis.Rmd` |
| | d | `Figure1/RNA_BC_PREPROCESSING/`; `Figure1/INTEGRATION/IntegrateDataset_QCandPreprocessing.Rmd`, `IntegrateDataset_Analysis.Rmd` (UMAP, density maps) |
| | e, f | `Figure1/INTEGRATION/IntegrateDataset_Analysis.Rmd` (DEGs/volcano, enrichR KEGG) |
| | g | `Figure1/INTEGRATION/Fig1g_permutation_test.R` |
| **Fig. 2** | a | MetaFate Seurat object from `Figure1/INTEGRATION/`; plotted in Prism |
| | b, g | Flow / Prism |
| | d, e | `Figure2/CD62L_MPP_barcoding/` |
| | h, i | `Figure2/inflammation_reanalysis/` |
| **Fig. 3** | a | Prism (protein content values from Hidalgo et al. 2020) |
| | c–f | Flow (SCENITH, SPICE-Met, TMRE) / Prism |
| | h, i | `Figure3/metabolomics/metabolomics_anlaysis.R` |
| **Fig. 4** | a | `Figure4/PAGA_Dahlin2018/`, `Figure4/pathway_dynamics_Dahlin2018/S6.Rmd` |
| | b | `Figure4/Haemopedia/Fig4b_PCA_original_2022-05-04.Rmd` |
| | c, d | `Figure4/Haemopedia/MIIC_heatmap.Rmd`, `S7_helpermethods.R` (input matrix = Supplementary Data 8; network inferred with MIIC, https://miic.curie.fr) |
| **Fig. 5** | a | Flow / Prism |
| | c–e | `Figure5/scCHICseq_H3K4me1/ChIC_Analysis_1.Rmd` (per-cell metadata = Supplementary Data 11) |
| **Fig. 6** | b | Flow / Prism |
| | c–e | `Figure6/G6PD_barcoding/` |
| **Supplementary Fig. 1** | b–g | `Figure1/DNA_BC_PREPROCESSING/splitVDJ.R`, `Figure1/RNA_BC_PREPROCESSING/splitVDJ.R`, `infer_igor_tags.sh`, `Supplementary_Figures/S1_DRAG_barcode_QC/` |
| **Supplementary Fig. 2** | – | Flow (gating) |
| **Supplementary Fig. 3** | a | `Figure1/DNA_BC_PREPROCESSING/DNA_BC_QC.Rmd` |
| | b | `Figure1/INTEGRATION/IntegrateDataset_Analysis.Rmd` |
| **Supplementary Fig. 4** | a–h | `Figure1/INTEGRATION/IntegrateDataset_QCandPreprocessing.Rmd`, `IntegrateDataset_Analysis.Rmd` |
| **Supplementary Fig. 5** | a, b | `Figure1/INTEGRATION/IntegrateDataset_Analysis.Rmd` (a); `IntegrateDataset_Validation.Rmd` (b) |
| **Supplementary Fig. 6** | a–c | Flow / Prism |
| **Supplementary Figs. 7, 8** | b–f | `Figure2/CD62L_MPP_barcoding/` |
| **Supplementary Figs. 9, 10** | all | `Supplementary_Figures/S9_S10_SLAM_HSC_barcoding/` |
| **Supplementary Fig. 11** | a, b | Flow |
| **Supplementary Fig. 12** | a–d | `Figure1/INTEGRATION/IntegrateDataset_Validation.Rmd` (Haltalli et al. section); `Supplementary_Figures/S12_Plasmodium_Haltalli2020/` |
| **Supplementary Fig. 13** | a–d | `Supplementary_Figures/S13_HSPC_signatures/calculate_HSPC_sigs.Rmd` (with the dataset scripts in `Figure2/inflammation_reanalysis/`) |
| **Supplementary Figs. 14, 15, 17, 21** | all | Flow / Prism |
| **Supplementary Fig. 16** | a–d | `Figure3/metabolomics/metabolomics_anlaysis.R` |
| **Supplementary Figs. 18, 23** | all except b (FRiP) | `Figure5/scCHICseq_H3K4me1/ChIC_Analysis_1.Rmd` |
| **Supplementary Fig. 19** | b–e | `Figure6/G6PD_barcoding/QC/` |
| **Supplementary Figs. 20, 22** | 20 all; 22 a, b | `Figure6/G6PD_barcoding/Analysis/Analysis.Rmd` |
| | 22 c–e | Flow / Prism |

Fig. 7 is a schematic.

## Data

| Data | Location |
|---|---|
| MetaFate scRNA-seq and DRAG barcode sequencing | GEO / SRA: [accessions to be added] |
| Lentiviral barcode sequencing | SRA: [accession to be added]; processed count matrices are Supplementary Data 6, 7, 9 and 10 of the article |
| scCHIC-seq | GEO: [accession to be added]; per-cell metadata is Supplementary Data 11 of the article |
| Metabolomics (LC-MS/MS) | [repository / accession to be added]; per-sample peak heights in the article's Source Data |
| MetaFate per-cell metadata and expression matrix | Supplementary Data 5 of the article, also in this repository: `Figure1/data/S5a_metafate_seurat_metadata.csv` (metadata) and `Figure1/data/MetaFate_expression_matrices.zip` (UMI counts of all 4,485 cells + metadata + README with the normalisation). It replaces `S5b_normalised_expression_matrix.zip`, which held only 255 cells. |
| Public datasets re-analysed | Dahlin et al. 2018; Tusi et al. 2018; Weinreb et al. 2020; Fast et al. 2022; Haltalli et al. 2020; Gerber-Ferder et al. 2023; Haemopedia (Choi et al. 2019; https://www.haemosphere.org/datasets/analyse?datasetName=Haemopedia-Mouse-RNASeq). See the article's Data Availability statement for accession codes. |

## Software

The analyses were run in R (≥ 4.0) and Python 3. Key packages:

- **scRNA-seq**: Seurat, SeuratDisk, scran, scater, Rmagic, destiny, monocle3, clustree, enrichR, msigdbr, fgsea, decoupleR
- **Bulk RNA-seq / networks**: limma, edgeR, DESeq2, Glimma, genefilter; MIIC (web server)
- **Barcoding**: stringdist, seqinr, Biostrings; xcalibr and NCBI BLAST 2 (bundled under `*/Demultiplex/xcalibr-master` and `Figure1/DNA_BC_PREPROCESSING/blast2`); IGoR
- **scCHIC-seq**: ChromSCape, Signac, chromVAR, motifmatchr, TFBSTools, JASPAR2020, GenomicRanges, BSgenome.Mmusculus.UCSC.mm10, DropletUtils, irlba
- **Plotting and utilities**: ggplot2, ggpubr, ggrepel, cowplot, gridExtra, pheatmap, gplots, plotgardener, dplyr, tidyr, plyr, reshape2, data.table
- **Python**: scanpy, anndata, numpy, pandas, scipy, matplotlib (PAGA analysis)

## Reproducing the analyses

- Scripts were run interactively on the authors' machines and the Institut Curie cluster. Most contain **absolute paths** (`setwd()`, `read.csv("/Users/...")`). Change these to your local copies of the input data before running.
- Inputs that are not in this repository (raw FASTQ, Cell Ranger outputs, Seurat objects of public datasets, gene-set `.Rda` files) can be obtained from the repositories listed above or regenerated from the raw data.
- The preprint-era layout (with its duplicate folders) is kept at the git tag `preprint-layout`.

## Credits

- **DRAG barcode processing**: adapted from pipelines by Arno Velds and Anne-Marie Lyne.
- **scCHIC-seq analysis**: Grégoire Jouault.
- **All other analyses**: Jason Cosgrove (jason.cosgrove@curie.fr), Team Perié, Institut Curie.

## License

MIT – see `LICENSE`.
