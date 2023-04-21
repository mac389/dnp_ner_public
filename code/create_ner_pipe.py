import os, spacy, json, random

training_data = json.load(open(os.path.join('..','assets','train-ali.json')))

from spacy.training import Example
from spacy.tokens import Doc
from spacy.vocab import Vocab

nlp = spacy.blank("en")
ner = nlp.create_pipe("ner")
nlp.add_pipe('ner', last=True)
ner = nlp.get_pipe("ner")
for text,entity_dictionary in training_data["annotations"]:
	for entity in entity_dictionary["entities"]:
		start,stop,label = entity
		ner.add_label(label)

for label in training_data["classes"]:
    nlp.get_pipe("ner").add_label(label)

optimizer = nlp.begin_training()

nreps = 50
for _ in range(nreps):
	text_annotations = training_data["annotations"]
	random.shuffle(text_annotations)
	
	for text, annotations in text_annotations:
		if len(text) > 0:
			example = Example.from_dict(nlp.make_doc(text), annotations)
			nlp.update([example])
