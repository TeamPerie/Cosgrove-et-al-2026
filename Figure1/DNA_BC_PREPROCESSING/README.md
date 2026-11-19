# DRAG barcode extraction from bulk DNA sequencing

Code used to extract DRAG barcodes from the amplicon sequencing of sorted mature cells (dataset 3 of the article).

1. `bcmouse.sh` (or `run_analysis_bcmouse.sh` / `bcmouse_CLUSTER.sh` on a cluster) is run on the FASTQ files. It needs
   [xcalibr](https://github.com/NKI-GCF/xcalibr); the helper files are `count2fasta.pl`, `cuttagslong.pl`, `perfect.pl`,
   `template2.fa` and the bundled `blast2/` folder.
2. The output of `bcmouse.sh` is cleaned with `tagcleanup.R` (`tagcleanup_run_locally.R` for a local run) and summarised
   in `DNA_BC_QC.Rmd`.
3. `splitVDJ.R` splits each barcode into its V, D and J segments, N-insertions and deletions (used for Supplementary
   Fig. 1; the summary plots are made by `Supplementary_Figures/S01_DRAG_barcode_QC/splitVDJ_analysis.R`).

`recombined_VDJ_elements_for_deepseq.dna` is the sequence map of the recombined DRAG cassette.
(This file replaces the earlier `read me.rtf`.)
