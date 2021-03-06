#################
### Variables ###
#################

##############
## Directories

SRCDIR = src
DATADIR = data
EXT_DATADIR = $(DATADIR)/external
KEGGDIR = $(EXT_DATADIR)/kegg-relationships
OUTDIR = out
IMGDIR = img
TMPDIR = tmp
CACHEDIR = cache
ifeq ($(KSEA_USE_AUTOPHOS),FALSE)
	KSEA_TMPDIR = $(TMPDIR)/ksea
else
	KSEA_TMPDIR = $(TMPDIR)/ksea-autophos
endif
ifeq ($(KS_USE_AUTOPHOS),FALSE)
	KS_TMPDIR = $(TMPDIR)/ks
else
	KS_TMPDIR = $(TMPDIR)/ks-autophos
endif
BINDIR = /nfs/research1/beltrao/software-rh7/bin

#############
## Parameters

KINACT_PREDS = $(KS_DATA)
KSEA_NUM_CONDS = 588
KSEA_USE_AUTOPHOS ?= TRUE
KS_NUM_CONDS = $(KSEA_NUM_CONDS)
KSEA_USE_AUTOPHOS ?= $(KSEA_USE_AUTOPHOS)
TABLE_STRATEGIES = max-rows max-cols balanced
TABLE_STRATEGY ?= max-rows
KSEA_MIN_SITES ?= 3
ENTROPY_FILTER ?= 0.1 			# Only keep rows/columns with at least 0.X*(max row/col entropy)
NA_THRESHOLD ?= 0.3333
ASSOC_METHODS = pcor pcor-filter scor scor-filter nfchisq mut_info	\
	fnn_mut_info partcor all fvalue paircor
ASSOC_METHOD ?= scor
DISCR_METHOD ?= trunc 	# mclust.whole mclust.by.row manual trunc
ASSOCNET_FILTER_METHOD ?= deconvolution
ASSOCNET_FILTER_PRESCALE_METHOD ?= standard
ASSOCNET_FILTER_POSTSCALE_METHOD ?= standard
# Network density post-deconvolution
DECONVOLUTION_A ?= 0.5
# Eigenvalue Scaling parameter
DECONVOLUTION_B ?= 0.99
PRED_METHOD = log_reg
USE_RAND_NEGS = TRUE
DIRECTED = FALSE

KEGG_VALSET ?= $(KEGG_ACT_VALSET)
VAL_SET = $(OMNIPATH_VALSET) ## $(KEGG_VALSET) $(PSITE_PLUS_VALSET)
# A list of protein annotations used to group proteins so that during
# validation we don't randomly select two kinases that are known to be
# functionally related (e.g. in the same pathway) for a true negative.
PROTEIN_GROUPING =  $(COMBINED_GROUPING) # $(COMBINED_GROUPING) $(KEGG_PATH_REFERENCE) $(GO_CELL_LOCATION)

MERGED_PRED_SOURCES = $(REG_SITE_ASSOC) $(PSSM)

MERGED_SIGN_PRED_SOURCES = $(KINACT_FULL_ASSOC_SIGN)	\
	$(REG_SITE_ASSOC_SIGN) $(SIGNED_PSSM)

#####################
## External data sets

# Ext phosphosite data
PSITE_DATA = $(EXT_DATADIR)/esetNR.Rdata
# specifies kinases perturbed in each condition
KIN_COND_PAIRS = $(EXT_DATADIR)/kinase-condition-pairs.tsv
# tries to calculate which kinases are perturbed in each condition
KIN_INVIVO_CONDS = $(EXT_DATADIR)/kinase_invivoconditions.csv 
# PhosphositePlus data
PHOSPHOSITE_PLUS_VERSION = 2018-05-01 # 2017-09-08
FULL_KIN_SUBSTR_TABLE = $(EXT_DATADIR)/Kinase_Substrate_Dataset_$(PHOSPHOSITE_PLUS_VERSION)
FULL_REG_SITES_TABLE = $(EXT_DATADIR)/Regulatory_sites_$(PHOSPHOSITE_PLUS_VERSION)
FULL_PHOS_SITES_TABLE = $(EXT_DATADIR)/Phosphorylation_site_dataset_$(PHOSPHOSITE_PLUS_VERSION)
# Kegg data
KEGG_RELATIONSHIPS = $(wildcard $(KEGGDIR)/*.ppip)
# Uniprot data
HUMAN_PROTEOME = $(EXT_DATADIR)/UP000005640_9606-2017-10-25.fasta
FULL_UNIPROT_ID_MAPPING = $(EXT_DATADIR)/HUMAN_9606_idmapping.dat
# Gene Ontology
GO_OBO_VERSION = 2017-10-04
GO_OBO = $(EXT_DATADIR)/go-basic-$(GO_OBO_VERSION).obo
HUMAN_GO_VERSION = 2017-09-26
FULL_GO_ASSOC_TABLE = $(EXT_DATADIR)/goa_human-$(HUMAN_GO_VERSION).gaf
STRING_VERSION = 10.5
HUMAN_STRING_RAW = $(EXT_DATADIR)/9606.protein.links.detailed.v$(STRING_VERSION).txt
# Kinase beads
KINASE_BEADS_RAW = $(EXT_DATADIR)/kinase-beads-activities.tsv
# Kinome
KINOME_RAW = $(EXT_DATADIR)/pkinfam.txt
# Kinase domain phosphorylation hot-spots from Marta
HOTSPOTS_RAW = $(EXT_DATADIR)/kinase-phospho-hotspots.tsv
TYR_HOTSPOTS_RAW = $(EXT_DATADIR)/tyr-kinase-phospho-hotspots.tsv
# PhosFun predictions
PHOSFUN_FEATS_RAW = $(EXT_DATADIR)/phosphoproteome_annotated
PHOSFUN_ST_RAW = $(EXT_DATADIR)/phosfun-predictions-ST.tsv
PHOSFUN_Y_RAW = $(EXT_DATADIR)/phosfun-predictions-Y.tsv
# Cancer datasets
RNAI_DRIVE_ATARIS_DATA_RAW = $(EXT_DATADIR)/DRIVE_ATARiS_data.rds
RNAI_DRIVE_RSA_DATA_RAW = $(EXT_DATADIR)/DRIVE_RSA_data.rds
RNAI_ACHILLES_DATA_RAW = $(EXT_DATADIR)/Achilles_v2.20.2_GeneSolutions.gct
CRISPR_DATA_RAW = $(EXT_DATADIR)/ceres-gene-effects.csv
CELLLINE_EXPR_DATA_RAW = $(EXT_DATADIR)/data_expression_median.txt
CELLLINE_RNASEQ_DATA_RAW = $(EXT_DATADIR)/CCLE_RNA-seq_tpm_matrix.csv
TUMOR_EXPR_DATA_RAW = $(EXT_DATADIR)/GSM1536837_06_01_15_TCGA_24.tumor_Rsubread_TPM.txt
# Pfam predictions
PFAM_DATA_RAW = $(EXT_DATADIR)/Pfam-9606.31.0.tsv
# KinHub kinase families
KINHUB_DATA_RAW = $(EXT_DATADIR)/kinhub-families.tsv
KINBASE_SEQS = $(EXT_DATADIR)/kinbase-sequences.fasta

######################
## Generated data sets

# Kinase activity predictions
KSEA_TMP_DATA = $(foreach COND_NUM,$(shell seq 1 $(KSEA_NUM_CONDS)),$(KSEA_TMPDIR)/cond-$(COND_NUM).tsv)
KSEA_DATA = $(DATADIR)/log.wKSEA.kinase_condition.clean.Rdata
KS_TMP_DATA = $(foreach COND_NUM,$(shell seq 1 $(KS_NUM_CONDS)),$(KS_TMPDIR)/cond-$(COND_NUM).tsv)
KS_DATA = $(DATADIR)/ks-kinact.Rdata
# Initial kinase-activity tables, trying to
# maximize #rows, #cols or both.  Raw and imputed datasets
KINACT_DATA = $(DATADIR)/kinact-$(TABLE_STRATEGY).tsv
IMP_KINACT_DATA = $(DATADIR)/kinact-$(TABLE_STRATEGY)-imp.tsv
DISCR_KINACT_DATA = $(DATADIR)/kinact-$(TABLE_STRATEGY)-discr.tsv
# EGF-signaling-related kinase activity
EGF_KINACT_DATA = $(DATADIR)/kinact-egf-pert.tsv
IMP_EGF_KINACT_DATA = $(DATADIR)/kinact-egf-pert-imp.tsv
# Association table output
KINACT_ASSOC = $(OUTDIR)/kinact-$(TABLE_STRATEGY)-$(ASSOC_METHOD).tsv
KINACT_ASSOC2 = $(OUTDIR)/kinact-$(TABLE_STRATEGY)-$(ASSOC_METHOD)2.tsv
KINACT_FULL_ASSOC = $(OUTDIR)/kinact-full-cor.tsv
KINACT_FULL_ASSOC2 = $(OUTDIR)/kinact-full-cor2.tsv
KINACT_FULL_ASSOC_SIGN = $(OUTDIR)/kinact-full-cor-sign.tsv
# Activity perturbation under inhibition
INHIB_FX = $(OUTDIR)/kinase-inhib-fx.tsv
# Regulatory site-based activity correlations
REG_SITE_ASSOC = $(OUTDIR)/reg-site-cor.tsv
REG_SITE_ASSOC2 = $(OUTDIR)/reg-site-cor2.tsv
REG_SITE_ASSOC_SIGN = $(OUTDIR)/reg-site-cor-sign.tsv
# Human amino acid frequencies
AA_FREQS = $(DATADIR)/aa-freqs.tsv
# PSSM files
PSSM = $(OUTDIR)/kinase-pssm.tsv
KIN_SCORE_DIST = $(OUTDIR)/kinase-pssm-dists.tsv
# PhosphositePlus derived files
KIN_SUBSTR_TABLE = $(DATADIR)/psiteplus-kinase-substrates.tsv
PSP_PHOSPHOSITES = $(DATADIR)/psiteplus-phosphosites.tsv
REG_SITES = $(DATADIR)/psiteplus-reg-sites.tsv
KIN_SUB_OVERLAP = $(DATADIR)/psiteplus-kinase-substrate-overlap.tsv
# Kegg-derived files
KEGG_ACT = $(DATADIR)/kegg-act-rels.tsv
KEGG_PHOS_ACT = $(DATADIR)/kegg-phos-act-rels.tsv
KEGG_PHOS = $(DATADIR)/kegg-phos-rels.tsv
KEGG_PATH_REFERENCE = $(DATADIR)/kegg-path-ref.tsv
# Uniprot-derived files
UNIPROT_ID_MAPPING = $(DATADIR)/uniprot-id-map.tsv
UNIPROT_ID_MAPPING_SMALL = $(DATADIR)/uniprot-id-map-small.tsv
ENSEMBL_ID_MAPPING = $(DATADIR)/ensembl-id-map.tsv
# GO-derived files
GO_ASSOC = $(DATADIR)/go-assoc.tsv
GO_CELL_LOCATION = $(DATADIR)/go-cell-location.tsv
# STRING (in the output directory for convenience of using it as a
# predictor)
STRING_ID_MAPPING = $(DATADIR)/string-id-map.tsv
HUMAN_STRING_COEXP = $(OUTDIR)/kinase-string-coexp.tsv
HUMAN_STRING_COEXP2 = $(OUTDIR)/kinase-string-coexp2.tsv
HUMAN_STRING_COEXP2_FULL = $(OUTDIR)/string-coexp2-full.tsv
HUMAN_STRING_COOCC = $(OUTDIR)/kinase-string-coocc.tsv
HUMAN_STRING_COOCC2 = $(OUTDIR)/kinase-string-coocc2.tsv
HUMAN_STRING_COOCC2_FULL = $(OUTDIR)/string-coocc2-full.tsv
HUMAN_STRING_EXPER = $(OUTDIR)/kinase-string-exper.tsv
# Protein groupings
COMBINED_GROUPING = $(DATADIR)/protein-groups.tsv
# Human kinome
HUMAN_KINOME = $(DATADIR)/human-kinome.txt
# KINS_TO_USE = $(DATADIR)/kinases-to-use.txt
KINS_TO_USE = $(HUMAN_KINOME)
# KINS_TO_USE_DESCR = kinact-$TABLE_STRATEGY)
# Kinase-domain phosphorylation hot spots
HOTSPOTS = $(DATADIR)/kinase-phospho-hotspots.tsv
# PhosFun predictions
PHOSFUN_FEATS = $(DATADIR)/phosfun-features.tsv
PHOSFUN = $(DATADIR)/phosfun.tsv
PHOSFUN_ST = $(DATADIR)/phosfun-ST.tsv
PHOSFUN_Y = $(DATADIR)/phosfun-Y.tsv
PRIDE_PHOSPHOSITES = $(DATADIR)/pride-phosphosites.tsv
PRIDE_PHOSPHOSITES_KINOME = $(DATADIR)/pride-phosphosites-kinome.tsv
PHOSPHOSITES = $(PRIDE_PHOSPHOSITES)
# Omnipath
OMNIPATH_CACHE = $(CACHEDIR)/default_network.pickle
OMNIPATH_PATH_REFERENCE = $(DATADIR)/omnipath-path-ref.tsv
# Validation sets
PSITE_PLUS_VALSET = $(DATADIR)/validation-set-psiteplus.tsv
KEGG_ACT_VALSET = $(DATADIR)/validation-set-kegg-act.tsv
KEGG_PHOS_ACT_VALSET = $(DATADIR)/validation-set-kegg-phos-act.tsv
KEGG_PHOS_VALSET = $(DATADIR)/validation-set-kegg-phos.tsv
NEG_VALSET = $(DATADIR)/validation-set-negative.tsv
OMNIPATH_VALSET = $(DATADIR)/validation-set-omnipath.tsv
# Kinase beads activities
KINASE_BEADS = $(DATADIR)/kinase-beads-activities.tsv
# Merged predictor data
MERGED_PRED = $(OUTDIR)/kinase-merged-pred.tsv
# Cancer datasets
RNAI_DRIVE_ATARIS_DATA = $(DATADIR)/rnai-drive-ataris.tsv
RNAI_DRIVE_RSA_DATA = $(DATADIR)/rnai-drive-rsa.tsv
RNAI_ACHILLES_DATA = $(DATADIR)/rnai-achilles.tsv
CRISPR_DATA = $(DATADIR)/ceres-gene-effects.tsv
CELLLINE_EXPR_DATA = $(DATADIR)/cell-line-expr.tsv
CELLLINE_RNASEQ_DATA = $(DATADIR)/cell-line-rnaseq.tsv
TUMOR_EXPR_DATA = $(DATADIR)/tumor-expr.tsv
# Pfam data
PFAM_DATA = $(DATADIR)/human-pfam.tsv
# Sign predction
SIGN_GUESS = $(OUTDIR)/kinase-reg-sign-guess.tsv
SIGNED_PSSM = $(OUTDIR)/kinase-pssm-signed.tsv
REGSITE_SIGN_PREDS = $(OUTDIR)/reg-site-bart-sign-preds.tsv
MERGED_SIGN_PRED = $(OUTDIR)/sign-merged-pred.tsv
# Kinase families
KINBASE_ID_MAP = $(DATADIR)/kinbase-id-map.tsv
KINASE_FAMILIES = $(DATADIR)/kinase-families.tsv

#########
## Images

# Validation
ifeq ($(USE_RAND_NEGS),TRUE)
val_set = -val-rand-negs
else
ifeq ($(DIRECTED),TRUE)
val_set = -val-direct
else
val_set = -val
endif
endif
ASSOC_VAL_IMG = $(IMGDIR)/kinact-$(TABLE_STRATEGY)-$(ASSOC_METHOD)$(val_set).pdf
ASSOC2_VAL_IMG = $(IMGDIR)/kinact-$(TABLE_STRATEGY)-$(ASSOC_METHOD)2$(val_set).pdf
FULL_ASSOC_VAL_IMG = $(IMGDIR)/kinact-full-cor$(val_set).pdf
FULL_ASSOC2_VAL_IMG = $(IMGDIR)/kinact-full-cor2$(val_set).pdf
PSSM_VAL_IMG = $(IMGDIR)/kinase-pssm$(val_set).pdf
REG_SITE_ASSOC_VAL_IMG = $(IMGDIR)/reg-site-cor$(val_set).pdf
REG_SITE_ASSOC2_VAL_IMG = $(IMGDIR)/reg-site-cor2$(val_set).pdf
INHIB_FX_VAL_IMG = $(IMGDIR)/kinase-inhib-fx$(val_set).pdf
STRING_COEXP_VAL_IMG = $(IMGDIR)/kinase-string-coexp$(val_set).pdf
STRING_COEXP2_VAL_IMG = $(IMGDIR)/kinase-string-coexp2$(val_set).pdf
STRING_COOCC_VAL_IMG = $(IMGDIR)/kinase-string-coocc$(val_set).pdf
STRING_COOCC2_VAL_IMG = $(IMGDIR)/kinase-string-coocc2$(val_set).pdf
STRING_EXPER_VAL_IMG = $(IMGDIR)/kinase-string-exper$(val_set).pdf
VAL_IMGS = $(ASSOC_VAL_IMG) $(PSSM_VAL_IMG) $(FULL_ASSOC_VAL_IMG)	\
	$(STRING_COEXP_VAL_IMG) $(STRING_COOCC_VAL_IMG)					\
	$(STRING_EXPER_VAL_IMG) $(REG_SITE_ASSOC_VAL_IMG)				\
	$(INHIB_FX_VAL_IMG)

##################
## Program Options

ASSOCNET_PARAMS = --unbiased-correlation --p-method=none
ASSOCNET_FILTER_PARAMS = --method=$(ASSOCNET_FILTER_METHOD) \
	 		--pre-scale-method=$(ASSOCNET_FILTER_PRESCALE_METHOD) \
			--post-scale-method=$(ASSOCNET_FILTER_POSTSCALE_METHOD) \
			--header-in --observed-only
ifeq ($(ASSOCNET_FILTER_METHOD),deconvolution)
ASSOCNET_FILTER_PARAMS += --deconvolution-a=$(DECONVOLUTION_A)	\
			  --deconvolution-b=$(DECONVOLUTION_B)
endif

###########
## Programs

BASH = /bin/bash
SHELL = $(BASH)
PYTHON3 ?= $(BINDIR)/python3
PYTHON2 ?= $(BINDIR)/python2
PYTHON ?= $(PYTHON3)
RSCRIPT ?= $(BINDIR)/Rscript
ASSOCNET ?= $(BINDIR)/assocnet $(ASSOCNET_PARAMS)
ASSOCNET_FILTER ?= $(BINDIR)/assocnet-filter $(ASSOCNET_FILTER_PARAMS)

##########
## Scripts

MELT_SCRIPT = $(SRCDIR)/melt.r
KSEA_POST_SCRIPT = $(SRCDIR)/ksea-post.r
OPTIMIZE_KINACT_TBL_SCRIPT = $(SRCDIR)/optimize-activity-table.r
GEN_KINACT_TBL_SCRIPT = $(SRCDIR)/gen-activity-table.r
GEN_EGF_KINACT_TBL_SCRIPT = $(SRCDIR)/gen-egf-activity-table.r
FINAL_PREDICTOR_SCRIPT = $(SRCDIR)/final-predictor.r
DISCRETIZE_SCRIPT = $(SRCDIR)/discretize.r
NFCHISQ_SCRIPT = $(SRCDIR)/nfchisq.r
ASSOC_SCRIPT = $(SRCDIR)/assoc_methods.r
LM_PRED_SCRIPT = $(SRCDIR)/lm-pred.r
PAIR_COR_SCRIPT = $(SRCDIR)/pairwise-cor.r
PSSM_SCRIPT = $(SRCDIR)/pssm.py
PSSM_DIST_SCRIPT = $(SRCDIR)/pssm-dist.py
PSSM_LIB = $(SRCDIR)/pssms/__init__.py
AA_FREQS_SCRIPT = $(SRCDIR)/aa-freqs.py
FILTER_PSITE_PLUS_SCRIPT = $(SRCDIR)/filter-psite-plus-tbl.r
KIN_SUB_OVERLAP_SCRIPT = $(SRCDIR)/kinase-overlap.r
PSITE_PLUS_VAL_SCRIPT = $(SRCDIR)/make-psiteplus-valset.r
FILTER_KEGG_RELS_SCRIPT = $(SRCDIR)/filter-kegg-tbl.r
KEGG_PATH_REF_SCRIPT = $(SRCDIR)/gen-kegg-pathway-ref.py
KEGG_VAL_SCRIPT = $(SRCDIR)/make-kegg-valset.r
NEG_VAL_SCRIPT = $(SRCDIR)/make-negative-valset.r
REFORMAT_GO_ASSOC_SCRIPT = $(SRCDIR)/reformat-go-assoc.awk
GO_CELL_LOC_SCRIPT = $(SRCDIR)/get-go-cell-component.py
FORMAT_STRING_SCRIPT = $(SRCDIR)/format-string.py
VAL_SCRIPT = $(SRCDIR)/validation.r
MERGE_SCRIPT = $(SRCDIR)/merge.r
FILTER_BY_PROTLIST_SCRIPT = $(SRCDIR)/filter-by-protein-list.r
REG_SITE_COR_SCRIPT = $(SRCDIR)/reg-site-cor.r
KINACT_FULL_COR_SCRIPT = $(SRCDIR)/kinact-full-cor.r
INHIB_FX_SCRIPT = $(SRCDIR)/inhib-fx.r
FORMAT_DRIVE_DATA_SCRIPT = $(SRCDIR)/format-drive-data.r
INIT_OMNIPATH_SCRIPT = $(SRCDIR)/init-omnipath.py
OMNIPATH_VAL_SCRIPT = $(SRCDIR)/gen-omnipath-valset.py
OMNIPATH_PATH_REF_SCRIPT = $(SRCDIR)/make-omnipath-path-ref.py
GUESS_REG_SIGN_SCRIPT = $(SRCDIR)/guess-reg-sign.r
SIGNED_PSSM_SCRIPT = $(SRCDIR)/pssm-signed.py
PHOSFUN_FEATS_SCRIPT = $(SRCDIR)/compile-phosfun-features.r
TRANSFORM_PHOSFUN_SCRIPT = $(SRCDIR)/transform-phosfun.r
PRIDE_PSITES_SCRIPT = $(SRCDIR)/get-pride-phosphosites.py
KINBASE_ID_MAP_SCRIPT = $(SRCDIR)/gen-kinbase-id-map.py

# Don't delete intermediate files
.SECONDARY:

#####################
### Phony targets ###
#####################

# Everything needed to get started with KSEA
.PHONY: prelim
prelim: $(KIN_SUBSTR_TABLE) $(PRIDE_PHOSPHOSITES)

.PHONY: edge-predictors
edge-predictors: $(KINACT_ASSOC) $(KINACT_ASSOC2) $(REG_SITE_ASSOC)	\
	$(PSSM) $(KINACT_FULL_ASSOC) $(INHIB_FX)

.PHONY: merge-predictors
merge-predictors: $(MERGED_PRED)

.PHONY: assoc-results
assoc-results: $(KINACT_ASSOC) $(KINACT_ASSOC2)

.PHONY: pssm
pssm: $(PSSM) $(KIN_KNOWN_PSITE_SCORES) $(KIN_SCORE_DIST)

.PHONY: data
data: $(KINACT_PREDS) $(KINACT_DATA) $(IMP_KINACT_DATA) $(EGF_KINACT_DATA)

.PHONY: validation
validation: $(VAL_IMGS)

.PHONY: merge-validation
merge-validation: $(IMGDIR)/validation.pdf

.PHONY: clean-data
clean-data:
	-rm -v $(KINACT_DATA) $(IMP_KINACT_DATA)

.PHONY: clean-assoc
clean-assoc:
	-rm -v $(KINACT_ASSOC)

.PHONY: clean-final-predictor
clean-final-predictor:
	-rm -v $(PREDICTOR)

.PHONY: clean-validation
clean-validation:
	-rm -v $(VAL_IMGS)

.PHONY: clean-results
clean-results: clean-assoc clean-final-predictor clean-validation

.PHONY: clean-logs
clean-logs:
	-rm -v log/*

.PHONY: clean
clean: clean-data clean-results

# For debugging purposes
expand-var-%:
	@echo $($*)

.PHONY: info
info:
	@printf "\033[1mTable strategy:\033[0m\t"
	@case "$(TABLE_STRATEGY)" in \
		"max-rows" ) printf "max. kinases\n" ;; \
		"max-cols" ) printf "max. conditions\n" ;; \
		"balanced" ) printf "balanced\n" ;; \
	esac
	@printf "\033[1mTable dim.:\033[0m\t"
	@printf "%s x %s\n" `sed '1d' $(KINACT_DATA) | cut -f1 | sort | uniq | wc -l` \
		`sed '1d' $(KINACT_DATA) | cut -f2 | sort | uniq | wc -l`
	@printf "\033[1m%% missing:\033[0m\t"
	@awk 'BEGIN{na=0}{if ($$3=="NA"){na=na+1}}END{printf("%f\n", na/(NR-1))}' $(KINACT_DATA)


#############
### Rules ###
#############

##############
## Directories

$(DATADIR):
	mkdir -p $(DATADIR)

$(OUTDIR):
	mkdir -p $(OUTDIR)

$(IMGDIR):
	mkdir -p $(IMGDIR)

########################
## Processed data tables

# KSEA results
# The KSEA temporary files are created outside of this Makefile using
# the do-ksea.sh script
$(KSEA_DATA): $(KSEA_TMP_DATA)
	cat $^ >$@.tmp
	$(RSCRIPT) $(KSEA_POST_SCRIPT) $@.tmp $@
	rm $@.tmp

$(KS_DATA): $(KS_TMP_DATA)
	cat $^ >$@.tmp
	$(RSCRIPT) $(KSEA_POST_SCRIPT) $@.tmp $@
	rm $@.tmp

# Kinase activity tables
$(KINACT_DATA) \
$(IMP_KINACT_DATA): $(GEN_KINACT_TBL_SCRIPT) $(OPTIMIZE_KINACT_TBL_SCRIPT) \
					$(KINACT_PREDS) $(KIN_COND_PAIRS) $(KIN_SUB_OVERLAP)
	$(RSCRIPT) $(GEN_KINACT_TBL_SCRIPT) $(KINACT_PREDS)			\
		$(TABLE_STRATEGY) $(KSEA_MIN_SITES) $(ENTROPY_FILTER)	\
		$(NA_THRESHOLD)

# EGF-specific kinase activity tables
$(EGF_KINACT_DATA): $(GEN_EGF_KINACT_TBL_SCRIPT) $(OPTIMIZE_KINACT_TBL_SCRIPT) \
					$(KINACT_PREDS) $(KIN_COND_PAIRS) $(KIN_SUB_OVERLAP)
	$(RSCRIPT) $(GEN_EGF_KINACT_TBL_SCRIPT) $(TABLE_STRATEGY) $(KSEA_MIN_SITES) \
		$(ENTROPY_FILTER) $(NA_THRESHOLD)

# Discretized kinase activity
$(DATADIR)/%-discr.tsv: $(DATADIR)/%-imp.tsv $(DISCRETIZE_SCRIPT)
	$(RSCRIPT) $(DISCRETIZE_SCRIPT) $(DISCR_METHOD) $< $@

# Filter the human kinase-substrates to just those for which we have
# enough evidence
$(KIN_SUBSTR_TABLE): $(FULL_KIN_SUBSTR_TABLE) $(FILTER_PSITE_PLUS_SCRIPT) \
		$(PRIDE_PHOSPHOSITES) $(HUMAN_KINOME)
	sed '1,3d;4s|+/-|...|' $< | \
		awk -F"\t" '{if (NR==1 || ($$4=="human" && $$9=="human")){print}}' >$@.tmp
	$(RSCRIPT) $(FILTER_PSITE_PLUS_SCRIPT) $@.tmp $@ TRUE
	rm $@.tmp

# Filter the PhosphoSitePlus site list to just those on kinases for
# which we have kinase activities
$(PSP_PHOSPHOSITES): $(FULL_PHOS_SITES_TABLE) $(FILTER_PSITE_PLUS_SCRIPT) $(KINACT_PREDS)
	sed '1,3d' $< | \
		awk -F"\t" -vOFS="\t" '{if ((NR == 1 || ($$7 == "human" && $$2 !~ / iso/)) && $$5 !~ /^G/){print}}' >$@.tmp
	$(RSCRIPT) $(FILTER_PSITE_PLUS_SCRIPT) $@.tmp $@.tmp2 FALSE
	rm $@.tmp
	awk -vOFS="\t" -F"\t" '{if (NR > 1){print $$1, $$6, $$5, toupper($$11)}}' $@.tmp2 | sort | uniq >$@
	rm $@.tmp2

# Further filter to just include reg sites on kinases for which we
# have kinase activities
$(REG_SITES): $(FULL_REG_SITES_TABLE) $(FILTER_PSITE_PLUS_SCRIPT) \
		$(HUMAN_KINOME)
	sed '1,3d' $< | \
		awk -F"\t" 'BEGIN{OFS="\t"}{if (NR==1 || $$7=="human" && $$8~/-p$$/){print}}' | \
		sed 's/-p//' >$@.tmp
	$(RSCRIPT) $(FILTER_PSITE_PLUS_SCRIPT) $@.tmp $@ TRUE
	rm $@.tmp

# Kinase-substrate overlap
$(KIN_SUB_OVERLAP): $(KIN_SUBSTR_TABLE) $(KIN_SUB_OVERLAP_SCRIPT) $(HUMAN_KINOME)
	$(RSCRIPT) $(KIN_SUB_OVERLAP_SCRIPT)

# Combine PhosphositePlus kinase-substrate and regulatory sites tables
# to generate a set of true-positive relationships
$(PSITE_PLUS_VALSET): $(KIN_SUBSTR_TABLE) $(REG_SITES)
	$(RSCRIPT) $(PSITE_PLUS_VAL_SCRIPT) $^

# Get all activation relationships from Kegg
$(KEGG_ACT): $(KEGG_RELATIONSHIPS)
	cat $^ | sed -E -n '/activation|inhibition|repression/p' | \
		awk 'BEGIN{OFS="\t"}{if ($$1!=$$2){print $$1, $$2}}' | \
		sort | uniq >$@

# Get all activation relationships from Kegg
$(KEGG_PHOS_ACT): $(KEGG_RELATIONSHIPS)
	cat $^ | sed -E -n '/activation|inhibition|repression/p' | \
		sed -n '/phosphorylation/p' | \
		awk 'BEGIN{OFS="\t"}{if ($$1!=$$2){print $$1, $$2}}' | \
		sort | uniq >$@

# Get all phospho activation relationships from Kegg
$(KEGG_PHOS): $(KEGG_RELATIONSHIPS)
	cat $^ | sed -n '/phosphorylation/p' | \
		awk 'BEGIN{OFS="\t"}{if ($$1!=$$2){print $$1, $$2}}' | \
		sort | uniq >$@

# Create the Uniprot ID map
$(UNIPROT_ID_MAPPING): $(FULL_UNIPROT_ID_MAPPING)
	awk 'BEGIN{OFS="\t"}{if ($$2=="Gene_Name"){print $$1, $$3}}' $< | sort >$@

$(UNIPROT_ID_MAPPING_SMALL): $(HUMAN_PROTEOME)
	sed -n '/^>sp.*GN=/{s/>sp|\([A-Z0-9-][A-Z0-9-]*\)|.*GN=\([[:alnum:]][[:alnum:]]*\).*/\1\t\2/;p}' $< >$@

$(ENSEMBL_ID_MAPPING): $(FULL_UNIPROT_ID_MAPPING) $(UNIPROT_ID_MAPPING)
	awk 'BEGIN{OFS="\t"}{if ($$2=="Ensembl_PRO"){print $$1, $$3}}' $< | \
		sort -d -k1 | sed 's/-[0-9][0-9]*\t/\t/' >$@.tmp
	join -t'	' $@.tmp $(UNIPROT_ID_MAPPING) | cut -f2,3 | sort | uniq >$@
	rm $@.tmp

# GO associations (formatted for GOATOOLS)
$(GO_ASSOC): $(FULL_GO_ASSOC_TABLE) $(UNIPROT_ID_MAPPING) $(REFORMAT_GO_ASSOC_SCRIPT)
	sed '/^!/d' $< | cut -f2,5,7 | sort | uniq | awk -f $(REFORMAT_GO_ASSOC_SCRIPT) | sort -k1 >$@.tmp
	join -t'	' $(UNIPROT_ID_MAPPING) $@.tmp | cut -f2,3 >$@
	rm $@.tmp

# Parse protein cellular locations
# GO:0005634 = Nucleus
# GO:0005737 = Cytoplasm
# GO:0005886 = Plasma Membrane
$(GO_CELL_LOCATION): $(GO_ASSOC) $(GO_OBO) $(GO_CELL_LOC_SCRIPT)
	$(PYTHON) $(GO_CELL_LOC_SCRIPT) $(GO_ASSOC) $(GO_OBO) | sed '1,2d' | sort | uniq >$@

# Kinome
$(HUMAN_KINOME): $(KINOME_RAW) $(UNIPROT_ID_MAPPING)
	sed -n '/HUMAN/{s/  */\t/g;p}' $< | cut -f3 | sed 's/(//' | \
		grep -f - $(UNIPROT_ID_MAPPING) | cut -f2 | sort >$@

# $(KINS_TO_USE): $(KINACT_FULL_ASSOC2) $(REG_SITE_ASSOC2)
# 	cat <(sed '1d' $(KINACT_FULL_ASSOC2) | cut -f1 | sort | uniq) \
# 		<(sed '1d' $(KINACT_FULL_ASSOC2) | cut -f2 | sort | uniq) \
# 		<(sed '1d' $(REG_SITE_ASSOC2) | cut -f1 | sort | uniq) \
# 		<(sed '1d' $(REG_SITE_ASSOC2) | cut -f2 | sort | uniq) | sort | uniq >$@

# STRING
# Create the STRING ID map
$(STRING_ID_MAPPING): $(FULL_UNIPROT_ID_MAPPING) $(UNIPROT_ID_MAPPING)
	awk 'BEGIN{OFS="\t"}{if ($$2=="STRING" && $$1 !~ /.-[0-9]/){print $$1, $$3}}' $< | sort -d -k1 >$@.tmp
	join -t'	' $@.tmp $(UNIPROT_ID_MAPPING) | cut -f2,3 >$@
	rm $@.tmp

# Pfam data
$(PFAM_DATA): $(PFAM_DATA_RAW) $(UNIPROT_ID_MAPPING_SMALL)
	sed '/^#/d;s/  */\t/g;s/\(ENSP[0-9][0-9]*\)\.[0-9][0-9]*/\1/' $< | \
	 	cut -f1,4,5,7 | sort -k1 >$@.tmp
	join -t'	' $@.tmp $(UNIPROT_ID_MAPPING_SMALL) | \
	 	awk -vOFS="\t" '{print $$5, $$4, $$2, $$3}' | sort -k1 >$@.tmp2
	cat <(printf "%s\t%s\t%s\t%s\n" protein domain start end) $@.tmp2 >$@
	rm $@.tmp $@.tmp2

# STRING coexpression
$(HUMAN_STRING_COEXP): $(HUMAN_STRING_RAW) $(STRING_ID_MAPPING) $(KINS_TO_USE) \
		$(FORMAT_STRING_SCRIPT)
	$(PYTHON) $(FORMAT_STRING_SCRIPT) $(HUMAN_STRING_RAW) $(STRING_ID_MAPPING) \
		$(KINS_TO_USE) 6 >$@.tmp
	cat <(sed -n '1p' $@.tmp) <(sed '1d' $@.tmp | sort -k 1d,1 -k 2d,2) >$@
	rm $@.tmp

$(HUMAN_STRING_COEXP2_FULL): $(HUMAN_STRING_RAW) $(STRING_ID_MAPPING) $(KINS_TO_USE)
	$(PYTHON) $(FORMAT_STRING_SCRIPT) $(HUMAN_STRING_RAW) $(STRING_ID_MAPPING) \
		$(KINS_TO_USE) 6 --all >$@.tmp
	cat <(sed -n '1p' $@.tmp) <(sed '1d' $@.tmp | sort -k 1d,1 -k 2d,2) >$@
	rm $@.tmp

$(HUMAN_STRING_COEXP2): $(HUMAN_STRING_COEXP2_FULL) $(KINS_TO_USE)
	$(ASSOCNET) --header-in --method=spearman $< | sed '1s/assoc/string.coexp.cor/' >$@.tmp
	$(RSCRIPT) $(FILTER_BY_PROTLIST_SCRIPT) $@.tmp $(KINS_TO_USE) $@
	rm $@.tmp
	rm tmp/kinact-prots.txt

# STRING cooccurrence
$(HUMAN_STRING_COOCC): $(HUMAN_STRING_RAW) $(STRING_ID_MAPPING) $(KINS_TO_USE) \
		$(FORMAT_STRING_SCRIPT)
	$(PYTHON) $(FORMAT_STRING_SCRIPT) $(HUMAN_STRING_RAW) $(STRING_ID_MAPPING) \
		$(KINS_TO_USE) 5 >$@.tmp
	cat <(sed -n '1p' $@.tmp) <(sed '1d' $@.tmp | sort -k 1d,1 -k 2d,2) >$@
	rm $@.tmp

$(HUMAN_STRING_COOCC2_FULL): $(HUMAN_STRING_RAW) $(STRING_ID_MAPPING) $(KINS_TO_USE)
	$(PYTHON) $(FORMAT_STRING_SCRIPT) $(HUMAN_STRING_RAW) $(STRING_ID_MAPPING) \
		$(KINS_TO_USE) 5 --all >$@.tmp
	cat <(sed -n '1p' $@.tmp) <(sed '1d' $@.tmp | sort -k 1d,1 -k 2d,2) >$@
	rm $@.tmp

$(HUMAN_STRING_COOCC2): $(HUMAN_STRING_COOCC2_FULL) $(KINS_TO_USE)
	# $(ASSOCNET) --header-in --method=spearman $< | sed '1s/assoc/string.coocc.cor/' >$@.tmp
	$(RSCRIPT) $(FILTER_BY_PROTLIST_SCRIPT) $@.tmp $(KINS_TO_USE) $@
	# rm $@.tmp
	# rm tmp/kinact-prots.txt 

# STRING experimental
$(HUMAN_STRING_EXPER): $(HUMAN_STRING_RAW) $(STRING_ID_MAPPING) $(KINS_TO_USE) \
		$(FORMAT_STRING_SCRIPT)
	$(PYTHON) $(FORMAT_STRING_SCRIPT) $(HUMAN_STRING_RAW) $(STRING_ID_MAPPING) \
		$(KINS_TO_USE) 7 >$@.tmp
	cat <(sed -n '1p' $@.tmp) <(sed '1d' $@.tmp | sort -k 1d,1 -k 2d,2) >$@
	rm $@.tmp

# Kegg pathway reference
$(KEGG_PATH_REFERENCE): $(KEGG_RELATIONSHIPS) $(UNIPROT_ID_MAPPING) \
		$(KEGG_PATH_REF_SCRIPT)
	$(PYTHON) $(KEGG_PATH_REF_SCRIPT) | sort | uniq >$@

# Combined protein group set
$(COMBINED_GROUPING): $(GO_CELL_LOCATION) $(OMNIPATH_PATH_REFERENCE)
	cat $^ >$@

# Kegg-based validation sets
$(DATADIR)/validation-set-kegg-%.tsv: $(DATADIR)/kegg-%-rels.tsv \
			$(UNIPROT_ID_MAPPING) $(KEGG_VAL_SCRIPT) $(KINACT_PREDS)
	$(RSCRIPT) $(KEGG_VAL_SCRIPT) $(wordlist 1,2,$^) $@

# Negative validation set
$(NEG_VALSET): $(NEG_VAL_SCRIPT) $(VAL_SET) $(PROTEIN_GROUPING)
	$(RSCRIPT) $^ $@

# Omnipath cache
$(OMNIPATH_CACHE): $(INIT_OMNIPATH_SCRIPT)
	$(PYTHON2) $(INIT_OMNIPATH_SCRIPT)

$(OMNIPATH_PATH_REFERENCE): $(OMNIPATH_CACHE) $(HUMAN_KINOME) $(OMNIPATH_PATH_REF_SCRIPT)
	$(PYTHON2) $(OMNIPATH_PATH_REF_SCRIPT) $(HUMAN_KINOME)

$(OMNIPATH_VALSET): $(OMNIPATH_CACHE) $(HUMAN_KINOME) $(OMNIPATH_VAL_SCRIPT)
	$(PYTHON2) $(OMNIPATH_VAL_SCRIPT) $(HUMAN_KINOME)

# Calculate human proteome amino-acid frequencies
$(AA_FREQS): $(AA_FREQS_SCRIPT)
	$(PYTHON) $(AA_FREQS_SCRIPT) >$@

# Kinase beads activities https://doi.org/10.1101/158295
$(KINASE_BEADS): $(KINASE_BEADS_RAW) $(MELT_SCRIPT)
	awk -F"\t" 'BEGIN{OFS="\t"}{for (i=1; i<=NF; i++){if ($$i==""){$$i="NA"}}; print}' $< \
		| cut -f2,`seq 4 3 61 | tr '\n' ',' | sed 's/,$$//'` \
		| sed '1{s/ log2 Fold-Change//g;s/ /./g;s/\(.*\)/\L\1/g}' >$@.tmp
	$(RSCRIPT) $(MELT_SCRIPT) $@.tmp $@.tmp2
	rm $@.tmp
	sort -k1 $@.tmp2 >$@
	rm $@.tmp2
	$(RSCRIPT) src/impute.r $@ $(DATADIR)/kinase-beads-activities-imp.tsv

# Hotspots
$(HOTSPOTS): $(HOTSPOTS_RAW) $(TYR_HOTSPOTS_RAW) $(ENSEMBL_ID_MAPPING)
	cat $(wordlist 1,2,$^) | sed 's/, /\t/g' | cut -f2,4,6,7 | \
		sort -k1 | join -t'	' $(ENSEMBL_ID_MAPPING) - | cut -f2-5 >$@

# PhosFun predictions
$(PHOSFUN): $(PHOSFUN_ST_RAW) $(PHOSFUN_Y_RAW) $(UNIPROT_ID_MAPPING) \
		$(HUMAN_KINOME) $(PRIDE_PHOSPHOSITES_KINOME) $(TRANSFORM_PHOSFUN_SCRIPT)
	cat <(sed '1d;s/[_,]/\t/g' $(PHOSFUN_ST_RAW)) \
		<(sed '1d;s/[_,]/\t/g' $(PHOSFUN_Y_RAW)) | sort >$@.tmp
	join -t'	' $@.tmp $(UNIPROT_ID_MAPPING) | \
		awk -vOFS="\t" '{print $$4, $$2, $$3}' >$@.tmp2
	rm $@.tmp
	grep -f $(HUMAN_KINOME) $@.tmp2 | sort >$@.tmp3
	rm $@.tmp2
	$(RSCRIPT) $(TRANSFORM_PHOSFUN_SCRIPT) $@.tmp3 $@
	rm $@.tmp3

$(PHOSFUN_ST): $(PHOSFUN_ST_RAW) $(UNIPROT_ID_MAPPING) $(HUMAN_KINOME) \
		$(PRIDE_PHOSPHOSITES_KINOME) $(TRANSFORM_PHOSFUN_SCRIPT)
	sed '1d;s/[_,]/\t/g' $< | sort >$@.tmp
	join -t'	' $@.tmp $(UNIPROT_ID_MAPPING) | \
		awk -vOFS="\t" '{print $$4, $$2, $$3}' >$@.tmp2
	rm $@.tmp
	grep -f $(HUMAN_KINOME) $@.tmp2 | sort >$@.tmp3
	rm $@.tmp2
	$(RSCRIPT) $(TRANSFORM_PHOSFUN_SCRIPT) $@.tmp3 $@
	rm $@.tmp3

$(PHOSFUN_Y): $(PHOSFUN_Y_RAW) $(UNIPROT_ID_MAPPING) $(HUMAN_KINOME) \
		$(PRIDE_PHOSPHOSITES_KINOME) $(TRANSFORM_PHOSFUN_SCRIPT)
	sed '1d;s/[_,]/\t/g' $< | sort >$@.tmp
	join -t'	' $@.tmp $(UNIPROT_ID_MAPPING) | \
		awk -vOFS="\t" '{print $$4, $$2, $$3}' >$@.tmp2
	rm $@.tmp
	grep -f $(HUMAN_KINOME) $@.tmp2 | sort >$@.tmp3
	rm $@.tmp2
	$(RSCRIPT) $(TRANSFORM_PHOSFUN_SCRIPT) $@.tmp3 $@
	rm $@.tmp3

$(PHOSFUN_FEATS): $(PHOSFUN_FEATS_RAW) $(PHOSFUN_FEATS_SCRIPT) $(PHOSPHOSITES) \
		$(PFAM_DATA)
	$(RSCRIPT) $(PHOSFUN_FEATS_SCRIPT)

$(PRIDE_PHOSPHOSITES): $(PHOSFUN_FEATS_RAW) $(HUMAN_PROTEOME) \
		$(PRIDE_PSITES_SCRIPT)
	$(PYTHON) $(PRIDE_PSITES_SCRIPT) $(HUMAN_PROTEOME) $(PHOSFUN_FEATS_RAW) | \
		sort >$@

$(PRIDE_PHOSPHOSITES_KINOME): $(PHOSFUN_FEATS_RAW) $(HUMAN_PROTEOME) $(HUMAN_KINOME) \
		$(PRIDE_PSITES_SCRIPT)
	$(PYTHON) $(PRIDE_PSITES_SCRIPT) $(HUMAN_PROTEOME) $(PHOSFUN_FEATS_RAW) \
		$(HUMAN_KINOME) | sort >$@

# RNAi data
$(RNAI_DRIVE_ATARIS_DATA): $(RNAI_DRIVE_ATARIS_DATA_RAW) $(HUMAN_KINOME) \
		$(FORMAT_DRIVE_DATA_SCRIPT)
	$(RSCRIPT) $(FORMAT_DRIVE_DATA_SCRIPT) $< $(HUMAN_KINOME) $@

$(RNAI_DRIVE_RSA_DATA): $(RNAI_DRIVE_RSA_DATA_RAW) $(HUMAN_KINOME) \
		$(FORMAT_DRIVE_DATA_SCRIPT)
	$(RSCRIPT) $(FORMAT_DRIVE_DATA_SCRIPT) $< $(HUMAN_KINOME) $@

$(RNAI_ACHILLES_DATA): $(RNAI_ACHILLES_DATA_RAW) $(HUMAN_KINOME) $(MELT_SCRIPT)
	sed '1,2d' $< | cut -f1,3-503 >$@.tmp
	grep -a -f $(HUMAN_KINOME) $@.tmp >$@.tmp2
	rm $@.tmp
	$(RSCRIPT) $(MELT_SCRIPT) $@.tmp2 $@.tmp3 TRUE
	rm $@.tmp2
	sort -k1,1 -k2,2 $@.tmp3 >$@
	rm $@.tmp3

$(CRISPR_DATA): $(CRISPR_DATA_RAW) $(HUMAN_KINOME) $(MELT_SCRIPT)
	sed 's/,/\t/g' $< >$@.tmp
	grep -a -f $(HUMAN_KINOME) <(sed '1d' $@.tmp) >$@.tmp2
	cat <(sed -n '1p' $@.tmp) $@.tmp2 >$@.tmp3
	rm $@.tmp
	$(RSCRIPT) $(MELT_SCRIPT) $@.tmp3 $@.tmp4 TRUE
	rm $@.tmp2
	sort -k1,1 -k2,2 $@.tmp4 >$@
	rm $@.tmp3

$(CELLLINE_EXPR_DATA): $(CELLLINE_EXPR_DATA_RAW) $(HUMAN_KINOME) $(MELT_SCRIPT)
	cut -f1,3-503 $< >$@.tmp
	grep -a -f $(HUMAN_KINOME) $@.tmp >$@.tmp2
	rm $@.tmp
	$(RSCRIPT) $(MELT_SCRIPT) $@.tmp2 $@.tmp3 TRUE
	rm $@.tmp2
	sort -k1,1 -k2,2 $@.tmp3 >$@
	rm $@.tmp3

$(TUMOR_EXPR_DATA): $(TUMOR_EXPR_DATA_RAW) $(HUMAN_KINOME) $(MELT_SCRIPT)
	grep -a -f $(HUMAN_KINOME) $< > $@.tmp
	$(RSCRIPT) $(MELT_SCRIPT) $@.tmp $@.tmp2 TRUE
	rm $@.tmp
	sort -k1,1 -k2,2 $@.tmp2 >$@
	rm $@.tmp2

$(CELLLINE_RNASEQ_DATA): $(CELLLINE_RNASEQ_DATA_RAW) $(HUMAN_KINOME) $(MELT_SCRIPT)
	grep -f $(HUMAN_KINOME) $(ENSEMBL_ID_MAPPING) | cut -f1 | grep -f - $< >$@.tmp
	$(RSCRIPT) $(MELT_SCRIPT) $@.tmp $@.tmp2 TRUE
	rm $@.tmp
	join -t'	' $@.tmp2 $(ENSEMBL_ID_MAPPING) | cut -f2,3 >$@.tmp3
	rm $@.tmp2
	grep -f $(HUMAN_KINOME) $@.tmp3 >$@.tmp4
	rm $@.tmp3
	sort -k1,1 -k2,2 $@.tmp4 >$@
	rm $@.tmp4

$(KINBASE_ID_MAP): $(FULL_UNIPROT_ID_MAPPING) $(KINHUB_DATA_RAW) $(KINBASE_SEQS) \
		$(KINBASE_ID_MAP_SCRIPT)
	$(PYTHON) $(KINBASE_ID_MAP_SCRIPT) | sort -k1,1d >$@

$(KINASE_FAMILIES): $(KINBASE_SEQS) $(KINBASE_ID_MAP)
	sed -n '/^>/{s/.*class=.*:\(.*\):.* gene=\(.*\) species.*/\2\t\1/g;p}' $(KINBASE_SEQS) \
		| sort -k1,1d >$@.tmp
	join -t'	' $(KINBASE_ID_MAP) $@.tmp | cut -f2,3 | sort -k1,1d >$@
	rm $@.tmp

###########################
## Association score tables

# Pearson's correlation
$(OUTDIR)/%-pcor.tsv: $(DATADIR)/%-imp.tsv $(OUTDIR)
	$(ASSOCNET) --method=pearson $< >$@

# Spearman's correlation
$(OUTDIR)/%-scor.tsv: $(DATADIR)/%-imp.tsv $(OUTDIR)
	$(ASSOCNET) --method=spearman $< >$@

# Correlation of correlation
$(OUTDIR)/%-pcor2.tsv: $(OUTDIR)/%-pcor.tsv $(OUTDIR)
	$(ASSOCNET) --header-in --method=pearson $< >$@

$(OUTDIR)/%-scor2.tsv: $(OUTDIR)/%-scor.tsv $(OUTDIR)
	$(ASSOCNET) --header-in --method=spearman $< >$@

# Normalized FunChisq
$(OUTDIR)/%-nfchisq.tsv: $(DATADIR)/%-discr.tsv $(NFCHISQ_SCRIPT) $(OUTDIR)
	$(RSCRIPT) $(NFCHISQ_SCRIPT) $< $@
# Here I create three different correlation tables with the same script assoc_methods.r
# Funchisq, partcor and FNN_mutinfo
$(OUTDIR)/%-all.tsv: $(DATADIR)/%-imp.tsv $(ASSOC_SCRIPT) $(OUTDIR)
	$(RSCRIPT) $(ASSOC_SCRIPT) $< $@ all

# Partial correlation
$(OUTDIR)/%-partcor.tsv: $(DATADIR)/%-imp.tsv $(ASSOC_SCRIPT) $(OUTDIR)
	$(RSCRIPT) $(ASSOC_SCRIPT) $< $@ partcor

# Mutual information
$(OUTDIR)/%-mut_info.tsv: $(DATADIR)/%-discr.tsv $(ASSOC_SCRIPT) $(OUTDIR)
	$(RSCRIPT) $(ASSOC_SCRIPT) $< $@ mut_info

# Fast-nearest-neighbors (FNN) mutual information
$(OUTDIR)/%-fnn_mut_info.tsv: $(DATADIR)/%-imp.tsv $(ASSOC_SCRIPT) $(OUTDIR)
	$(RSCRIPT) $(ASSOC_SCRIPT) $< $@ fnn_mut_info

# Linear model based predictions (poor man's MRA)
$(OUTDIR)/%-lmpred.tsv: $(DATADIR)/%-imp.tsv $(OUTDIR)/%-pssm.tsv $(LM_PRED_SCRIPT) \
		$(KIN_INVIVO_CONDS) $(OUTDIR)
	$(RSCRIPT) $(LM_PRED_SCRIPT) $(wordlist 1,2,$^) $@

# Pairwise correlations, taking into account perturbations
$(OUTDIR)/%-paircor.tsv: $(DATADIR)/%-imp.tsv $(PAIR_COR_SCRIPT) \
		$(KIN_INVIVO_CONDS) $(OUTDIR) $(OPTIMIZE_KINACT_TBL_SCRIPT)
	$(RSCRIPT) $(PAIR_COR_SCRIPT) $< $@

# Filter out indirect associations
$(OUTDIR)/%-filter.tsv: $(OUTDIR)/%.tsv
	$(ASSOCNET_FILTER) --header-in $< >$@

# Regulatory site-based activity predictions
$(REG_SITE_ASSOC) \
$(REG_SITE_ASSOC2) \
$(REG_SITE_ASSOC_SIGN): $(REG_SITE_COR_SCRIPT) $(ENSEMBL_ID_MAPPING)\
		$(HUMAN_KINOME) $(PSITE_DATA) $(PHOSFUN) $(KIN_COND_PAIRS)
	$(RSCRIPT) $(REG_SITE_COR_SCRIPT)

# Full kinase-activity pairwise correlations
$(KINACT_FULL_ASSOC) \
$(KINACT_FULL_ASSOC2) \
$(KINACT_FULL_ASSOC_SIGN): $(KINACT_PREDS) $(KINACT_FULL_COR_SCRIPT) $(PSITE_DATA) \
		$(KIN_SUBSTR_TABLE) $(KIN_SUB_OVERLAP) $(OPTIMIZE_KINACT_TBL_SCRIPT) \
		$(KIN_COND_PAIRS)
	$(RSCRIPT) $(KINACT_FULL_COR_SCRIPT) $(KINACT_PREDS)

# Inhibitory effects
$(INHIB_FX): $(KINACT_PREDS) $(KINS_TO_USE) $(KIN_COND_PAIRS) $(KIN_SUB_OVERLAP) \
		$(INHIB_FX_SCRIPT) $(OPTIMIZE_KINACT_TBL_SCRIPT) $(KINACT_PREDS)
	$(RSCRIPT) $(INHIB_FX_SCRIPT) $(KINACT_PREDS) $(KINS_TO_USE) $(KSEA_MIN_SITES) $@

# todo: make this more flexible
out/rna-tissue-cor-filter.tsv: out/rna-tissue-cor.tsv
	assocnet-filter --header-in --scale-diagonal -b 0.45 $< >$@

###############################
## Kinase-substrate predictions

# Calculate kinase-substrate PSSM scores
$(OUTDIR)/%-pssm.tsv: $(AA_FREQS) $(PSSM_SCRIPT) $(KIN_SUBSTR_TABLE)	\
					$(PHOSPHOSITES) $(KINS_TO_USE) $(PSSM_LIB)			\
					$(PHOSFUN_ST) $(PHOSFUN_Y)
	$(PYTHON) $(PSSM_SCRIPT) $(KINS_TO_USE) $@

$(KIN_SCORE_DIST): $(AA_FREQS) $(PSSM_DIST_SCRIPT)					\
					 $(KIN_SUBSTR_TABLE) $(KINACT_DATA) $(PSSM_LIB)
	$(PYTHON) $(PSSM_DIST_SCRIPT) $(KINACT_DATA)

###################
## Merged predictor

$(MERGED_PRED): $(MERGED_PRED_SOURCES) $(MERGE_SCRIPT)
	$(RSCRIPT) $(MERGE_SCRIPT) $@.tmp $(filter-out $(MERGE_SCRIPT),$^)
	awk -vOFS="\t" '{if ($$3 == "NA"){next}else{print}}' $@.tmp >$@

$(DIRECT_PRED): $(DIRECT_PRED_SOURCES) $(MERGE_SCRIPT)
	$(RSCRIPT) $(MERGE_SCRIPT) $@.tmp $(filter-out $(MERGE_SCRIPT),$^)
	awk -vOFS="\t" '{if ($$3 == "NA" && $$4 == "NA"){next}else{print}}' $@.tmp >$@
	rm $@.tmp

##################
## Sign prediction

$(SIGN_GUESS): $(REG_SITES) $(KIN_SUBSTR_TABLE) $(KIN_SUB_OVERLAP)	\
				$(HUMAN_KINOME) $(ENSEMBL_ID_MAPPING) $(PHOSFUN)	\
				$(KIN_COND_PAIRS) $(PSITE_DATA) $(KINACT_PREDS)		\
				$(OPTIMIZE_KINACT_TBL_SCRIPT) $(GUESS_REG_SIGN_SCRIPT)
	$(RSCRIPT) $(GUESS_REG_SIGN_SCRIPT) $(KINACT_PREDS)

$(SIGNED_PSSM): $(REGSITE_SIGN_PREDS) $(KIN_SUBSTR_TABLE) $(AA_FREQS) \
				$(PHOSPHOSITES) $(KINS_TO_USE) $(PHOSFUN) $(REG_SITES) \
				$(SIGNED_PSSM_SCRIPT)
	$(PYTHON) $(SIGNED_PSSM_SCRIPT) $(KINS_TO_USE) $@

$(MERGED_SIGN_PRED): $(MERGED_SIGN_PRED_SOURCES) $(MERGE_SCRIPT)
	$(RSCRIPT) $(MERGE_SCRIPT) $@.tmp $(filter-out $(MERGE_SCRIPT),$^)
	awk -vOFS="\t" '{if ($$3 == "NA"){next}else{print}}' $@.tmp >$@

#############
## Validation

$(IMGDIR)/%-val.pdf: $(OUTDIR)/%.tsv $(VAL_SET) $(NEG_VALSET) $(IMGDIR) \
		$(VAL_SCRIPT)
	$(RSCRIPT) $(VAL_SCRIPT) $(wordlist 1,3,$^) FALSE FALSE

$(IMGDIR)/%-val-rand-negs.pdf: $(OUTDIR)/%.tsv $(VAL_SET) \
		$(NEG_VALSET) $(IMGDIR) $(VAL_SCRIPT)
	$(RSCRIPT) $(VAL_SCRIPT) $(wordlist 1,3,$^) TRUE FALSE

$(IMGDIR)/%-val-direct.pdf: $(OUTDIR)/%.tsv $(VAL_SET) \
		$(NEG_VALSET) $(IMGDIR) $(VAL_SCRIPT)
	$(RSCRIPT) $(VAL_SCRIPT) $(wordlist 1,3,$^) FALSE TRUE

$(IMGDIR)/validation.pdf:
	gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile=$@ $(IMGDIR)/*-val.pdf
