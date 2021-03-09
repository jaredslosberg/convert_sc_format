import anndata
import numpy as np

#continuous metadata features
features=snakemake.params[0]

#Establish input and output files
input_h5ad_path=snakemake.input[0]
output_h5ad_path=snakemake.output[0]


#adata
print(input_h5ad_path)
print(output_h5ad_path)

input_h5ad_path=str(input_h5ad_path)
output_h5ad_path=str(output_h5ad_path)
print(input_h5ad_path)

#Read in h5ad
adata=anndata.read_h5ad(input_h5ad_path)
print(adata)

for feature in features:
    print(feature)
    adata.obs[feature] = np.float32(adata.obs[feature])

adata.write_h5ad(output_h5ad_path)

