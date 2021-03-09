#Script to generate .h5ad file from monocle cell data set for compatibility with cellxgene viewer
#resources: https://cellgeni.readthedocs.io/en/latest/visualisations.html
#https://github.com/cellgeni/sceasy
#Run within Snakemake


# #dependencies for sceasy that had issues installing
# BiocManager::install("LoomExperiment")
# BiocManager::install("SingleCellExperiment")
# install.packages("reticulate")
# devtools::install_github("cellgeni/sceasy")

library(assertthat)
library(monocle3)
library(sceasy)
library(reticulate)


print(snakemake@params[[1]])
print(snakemake@params[[2]])

input_cds_path <- snakemake@input[[1]]
out_file <- snakemake@output[[1]]
features <- snakemake@params[[1]]


#use_condaenv('cellxgeneviewer')
loompy <- reticulate::import('loompy')

#Load in cds to convert and establish file to generate
cds_object <- readRDS(input_cds_path)

#Check for nonexistent annotations
for(feature in features){
  assertthat::assert_that(!is.null(pData(cds_object)[,feature]), msg = paste0(feature," is not a valid feature"))
}

#Manipulate annotations
pData(cds_object) <- pData(cds_object)[,features]

#write.csv(pData(cds_object), out_file)

#Continuous variables must be turned into float for cellxgene compatibility
#eg within python: adata.obs['metadata_name'] = np.float32(adata.obs['metadata_name'])

rownames(cds_object) <- fData(cds_object)$gene_short_name



#Do conversion
sceasy::convertFormat(cds_object, from="sce", to="anndata",
                    outFile= out_file)
