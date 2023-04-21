TRAINING_ANNOTATION="dnp_ner"
NAME="mike"

LANG_MODEL = "en_core_web_lg"
PATTERN_FILE = "./data/pattern_rules.substance_symptom.spacy_formatted.jsonl"


CORPUS_DEV_NER=./data/bb.corpus.deduplicated.cleaned.reconciled.phase1.jsonl
CORPUS_TRAIN_NER=./data/bb.corpus.deduplicated.cleaned.reconciled.phase2.jsonl
CORPUS_VALIDATE_NER=./data/bb.corpus.deduplicated.cleaned.reconciled.phase3.jsonl
LABELS=./data/labels

NER_DEV_OUTPUT_DIR=./models/ner_dev
NER_TRAIN_OUTPUT_DIR=./models/ner_validated

annotate:
	  python3 -m prodigy ner.manual ${TRAINING_ANNOTATION}_${NAME} ${LANG_MODEL} ./data/bb.corpus.deduplicated.cleaned.train.csv --label symptom,substance --patterns ${PATTERN_FILE}

#haven't made train, develop, evaluate dependencies yet because I can't get the sed RegEx to work. 

print:
	echo ${TRAINING_ANNOTATION}_${NAME}

#This script assumes that corpus.*.dataset are already reconciles and annotated. 

#annotation: 
#   python3 -m prodigy ner.manual corpus.development.dataset blank:en ${CORPUS_DEV} --labels ${LABELS}

#should use string formating to abstract filename patter

#Excluded 7 tweets from CORPUTS_TRAIN because they were not in English (were in Dutch)
DATASET_NER_DEV=ner.canonical.development
DATASET_NER_TRAIN=ner.canonical.training
DATASET_NER_VALIDATE=ner.canonical.validate
#corpus.training.dataset
#Could check if data set already in db to avoid reloading, might unintentionally overwire changes?

ENTITIES_LOC=./data/kb/dnp.entities.with_descriptions.txt
KB_LOC=./data/kb/dnp_ner
VECTORS_MODEL=en_core_web_lg
PATTERNS_LOC=./data/pattern_rules.substance_symptom.spacy_formatted.jsonl

DATASET_NEL_DEV=nel.canonical.development
DATASET_NEL_TRAIN=nel.canonical.training
DATASET_NEL_VALIDATE=nel.canonical.validate

CORPUS_DEV_NEL=./data/bb.corpus.deduplicated.cleaned.nel.dev.csv
CORPUS_TRAIN_NEL=./data/bb.corpus.deduplicated.cleaned.nel.train.csv
CORPUS_VALIDATE_NEL=./data/bb.corpus.deduplicated.cleaned.nel.validate.csv

preprocess-%-corpus:
	deduplicate-$*-corpus
	clean-$*-corpus
	split-$*-corpus

FILENAME=./data/bb.corpus.deduplicated.cleaned.txt

#-----BERT SECTION--------
#Vaguely named file
$(basename ${FILENAME}).bert_formatted.txt: ${FILENAME} 

bert-develop:
	#Taking advantage of SpaCy v3's wrapper to BERT.
	#python3 -m prodigy db-in ${DATASET_NER_DEV} ${CORPUS_DEV_NER}
	#python3 -m prodigy db-in ${DATASET_NER_TRAIN} ${CORPUS_TRAIN_NER}
	python3 -m prodigy train ${NER_DEV_OUTPUT_DIR}/bert --ner ${DATASET_NER_DEV},eval:${DATASET_NER_TRAIN} --base-model en_core_web_trf --label-stats

#-----BERT SECTION--------


split-%-corpus:	
	cat $*.corpus.deduplicated.cleaned.txt | shuf -o $*.corpus.deduplicated.cleaned.txt
	python3 add_random_column_and_split_into_train_dev_evaluate.py ./data/$*.corpus.deduplicated.cleaned.txt	

develop-ner:
	mkdir -p ${NER_DEV_OUTPUT_DIR}
	#python3 -m prodigy db-in ${DATASET_NER_DEV} ${CORPUS_DEV_NER}
	#python3 -m prodigy db-in ${DATASET_NER_TRAIN} ${CORPUS_TRAIN_NER}
	#python3 -m prodigy train ${NER_DEV_OUTPUT_DIR} --ner ${DATASET_NER_DEV},eval:${DATASET_NER_TRAIN} --label-stats
	python3 -m prodigy train-curve --ner ${DATASET_NER_DEV},eval:${DATASET_NER_TRAIN} --n-samples 10 -P
	

train-ner:
	python3 -m prodigy ner.correct ${DATASET_NER_TRAIN} ${NER_DEV_OUTPUT_DIR}/model-best ${CORPUS_TRAIN_NER} --label ${LABELS} --update

validate-ner:
	python3 -m prodigy db-in ${DATASET_NER_VALIDATE} ${CORPUS_VALIDATE_NER}
	python3 -m prodigy train ${NER_TRAIN_OUTPUT_DIR} --ner ${DATASET_NER_TRAIN},eval:${DATASET_NER_VALIDATE} --label-stats

create-kb:
	python3 ./code/create_kb.py ${ENTITIES_LOC} ${VECTORS_MODEL} ${KB_LOC} ${NER_TRAIN_OUTPUT_DIR}/model-best ${PATTERNS_LOC}

develop-nel:
	python3 -m prodigy entity_linker.manual ${DATASET_NEL_DEV} ${CORPUS_DEV_NEL} ${NER_TRAIN_OUTPUT_DIR}/model-best ${KB_LOC} ${ENTITIES_LOC} -F ./code/el_recette.py

