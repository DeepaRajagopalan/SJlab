more hg38_tss_raw.bed |awk -F"\t" '{
    if($5=="+"){print $1"\t"$2-1"\t"$2"\t"$4"\t"999"\t"$5} \
    if($5=="-"){print $1"\t"$3"\t"$3+1"\t"$4"\t"999"\t"$5} \
    }'|grep -E -v  "_random|17_ctg5|chrUn_gl|6_ssto_hap|6_mann_hap|ctg9_hap1|qbl_hap|mcf_hap|dbb_hap|cox_hap|_hap|_alt|KI270774|chrUn_" \
    > hg38_tss.bed
    
more ~/references/hg38_tss.bed |grep -w -f DownGenes_siC_vs_siK.txt |grep -v "\-AS" > DownReg_siC_siK_tss.bed
more ~/references/hg38_tss.bed |grep -w -f UpGenes_siC_vs_siK.txt |grep -v "\-AS" > UpReg_siC_siK_tss.bed

cut -f 1,2,3 UpReg_siC_siK_tss.bed > siC_siK_tss.bed
echo "# Up Regulated genes (siControl)" >> siC_siK_tss.bed
cut -f 1,2,3 DownReg_siC_siK_tss.bed >> siC_siK_tss.bed
echo "# Down Regulated genes (siTIP60)" >> siC_siK_tss.bed

computeMatrix reference-point \
-S \
/home/roberto/deepa/h3k9me3/bw/C_H3.bw \
/home/roberto/deepa/h3k9me3/bw/K_H3.bw \
/home/roberto/deepa/h3k9me3/bw/C_k9me3.bw \
/home/roberto/deepa/h3k9me3/bw/K_k9me3.bw \
-R /home/roberto/deepa/novogene/deseq2/siC_siK_tss.bed --referencePoint center \
--sortRegions descend -bs 20 -a 2000 -b 2000 -p 40 -out tss_siC_vs_siK_h3k9me3_h3.mat

plotHeatmap --xAxisLabel "" --refPointLabel "TSS" --colorMap Greens Greens Reds Reds \
-m tss_siC_vs_siK_h3k9me3_h3.mat \
--samplesLabel "siControl H3" "siTIP60 H3" "siControl H3K9me3" "siTIP60 H3K9me3" \
--regionsLabel "Up-Reg Genes" "Down-Reg Genes" --zMax 30 \
-out tss_siC_vs_siK_h3k9me3_h3.pdf

computeMatrix reference-point \
-S \
/home/roberto/deepa/h3k9me3/bw/C_k9me3.bw \
/home/roberto/deepa/h3k9me3/bw/K_k9me3.bw \
-R /home/roberto/deepa/novogene/deseq2/siC_siK_tss.bed --referencePoint center \
--sortRegions descend -bs 20 -a 2000 -b 2000 -p 40 -out tss_siC_vs_siK_h3k9me3.mat

computeMatrix reference-point \
-S \
/home/roberto/deepa/h3k9me3/bw/C_H3.bw \
/home/roberto/deepa/h3k9me3/bw/K_H3.bw \
-R /home/roberto/deepa/novogene/deseq2/siC_siK_tss.bed --referencePoint center \
--sortRegions descend -bs 20 -a 2000 -b 2000 -p 40 -out tss_siC_vs_siK_h3.mat


plotHeatmap --xAxisLabel "" --refPointLabel "TSS" --colorMap Greens -m tss_siC_vs_siK_h3.mat \
--samplesLabel "siControl H3" "siTIP60 H3" --zMax 30 \
--regionsLabel "Up-Reg Genes" "Down-Reg Genes" \
-out tss_siC_vs_siK_h3.pdf

plotHeatmap --xAxisLabel "" --refPointLabel "TSS" --colorMap Reds -m tss_siC_vs_siK_h3k9me3.mat \
--samplesLabel "siControl H3K9me3" "siTIP60 H3K9me3" --zMax 30 \
--regionsLabel "Up-Reg Genes" "Down-Reg Genes" \
-out tss_siC_vs_siK_h3k9me3.pdf

###############################
###############################
cut -f 1,2,3 H3_up.bed > H3_control.bed
echo "# Peaks in siTIP60" >> H3_control.bed
cut -f 1,2,3 H3_down.bed >> H3_control.bed
echo "# Peaks in siControl" >> H3_control.bed

cut -f 1,2,3 k9me3_up.bed > k9me3_control.bed
echo "# Peaks in siTIP60" >> k9me3_control.bed
cut -f 1,2,3 k9me3_down.bed >> k9me3_control.bed
echo "# Peaks in siControl" >> k9me3_control.bed
##################################################
computeMatrix reference-point \
-S \
/home/roberto/deepa/h3k9me3/bw/C_k9me3.bw \
/home/roberto/deepa/h3k9me3/bw/K_k9me3.bw \
-R /home/roberto/deepa/h3k9me3/bed/k9me3_control.bed --referencePoint center \
--sortRegions descend -bs 20 -a 2000 -b 2000 -p 40 -out /home/roberto/deepa/h3k9me3/heatmap/k9me3_control.mat

computeMatrix reference-point \
-S \
/home/roberto/deepa/h3k9me3/bw/C_H3.bw \
/home/roberto/deepa/h3k9me3/bw/K_H3.bw \
-R /home/roberto/deepa/h3k9me3/bed/H3_control.bed --referencePoint center \
--sortRegions descend -bs 20 -a 2000 -b 2000 -p 40 -out /home/roberto/deepa/h3k9me3/heatmap/H3_control.mat


plotHeatmap --xAxisLabel "" --refPointLabel "TSS" --colorMap Greens -m /home/roberto/deepa/h3k9me3/heatmap/H3_control.mat \
--samplesLabel "siControl H3" "siTIP60 H3" --zMax 85 \
-out /home/roberto/deepa/h3k9me3/heatmap/H3_control.pdf

plotHeatmap --xAxisLabel "" --refPointLabel "TSS" --colorMap Reds -m /home/roberto/deepa/h3k9me3/heatmap/k9me3_control.mat \
--samplesLabel "siControl H3K9me3" "siTIP60 H3K9me3" --zMax 130 \
-out /home/roberto/deepa/h3k9me3/heatmap/k9me3_control.pdf

