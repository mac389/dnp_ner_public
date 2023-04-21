#Convert CSV listing of substances and symptoms into pattern rules for NER

NOT_SPACY_FORMATTED="../assets/raw/substance_symptom.not_spacy_formatted.jsonl"
csvstack ../assets/raw/*.tsv -t -g 'substance,symptom' -n 'label' | csvcut -c label,"TEXTUAL MENTION" | csvjson > ${NOT_SPACY_FORMATTED}
cat substance_symptom.not_spacy_formatted.jsonl | head -n 4 | jq
python3 format_substance_symptoms_jsonl_for_spacy_ner.py ${NOT_SPACY_FORMATTED}

awk 'NF>=10' file # I used 10
