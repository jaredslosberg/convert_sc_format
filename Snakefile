configfile: "config.yaml"

rule convert_dataset:
	input: 
	  data="dataset_in/{dataset}.rds"
	output: 
	  "dataset_out/{dataset}.h5ad"
	params: 
	  features=expand(config["metadata_features"])
	conda:
	  "envs/sceasy.yml"
	script:
	  "scripts/cds_to_h5ad.R"

rule fix_up_h5ad:
	input:
	  "dataset_out/{dataset}.h5ad"
	output:
	  "dataset_out/{dataset}_final.h5ad"
	params:
	  features=expand(config["continuous_features_to_fix"])
	conda:
	  "envs/sceasy.yml"
	script:
          "scripts/fix_h5ad_for_cellxgene.py"
