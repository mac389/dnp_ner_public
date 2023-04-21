DATA_PATH=./data
IMG_PATH=./imgs
DOSENAME=dnp-dose.csv
HISTOGRAMNAME=dnp-dose_histogram.png
COMENTIONS=comentions.csv
SUBSTANCE_MENTIONS=substance-mentions.png
N_EFFECTS=10
EFFECTS_DATA=mention-count-by-class.csv


all: figure-1 figure-2 figure-3
figure-2:
	mkdir -p ${IMG_PATH}
	python3 ./code/dose-histogram.py ${DATA_PATH}/${DOSENAME} ${IMG_PATH}/${HISTOGRAMNAME} 

figure-3:
	mkdir -p ${IMG_PATH}
	python3 ./code/dose-effects.py ${DATA_PATH}/${EFFECTS_DATA} ${IMG_PATH} ${N_EFFECTS}

figure-4:
	mkdir -p ${IMG_PATH}
	python3 ./code/substance-mentions.py ${DATA_PATH}/${COMENTIONS} ${IMG_PATH}/${SUBSTANCE_MENTIONS}

figure-5:
	mkdir -p ${IMG_PATH}
