#csvformat -T ../kb/symptoms.csv > ../kb/symptoms.tsv
#csvformat -T ../kb/substances.csv > ../kb/substances.tsv

csvstack ../kb/symptoms.tsv ../kb/substances.tsv > ../kb/symptoms_and_substances.tsv
csvcut -c 0,2 -t -l ../kb/symptoms_and_substances.tsv > ../kb/id_symptoms_and_substances.csv

#Add to makefile