import os, spacy

nlp = spacy.load(os.path.join('..','models','ner_validated','model-best'))

text= "Sweating from all the DNP, gummy bears and cocaine. No hallucinating though."

#Only recognizes sweating, not noun forms, doesn't recognize hallucinating or hallucinates. 
doc = nlp(text)

#Why does the model never recognize symptoms?
for ent in doc.ents:
    print(f"Named Entity '{ent.text}' with label '{ent.label_}'")
