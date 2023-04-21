`add_random_column_and_split_into_train_dev_evaluate_updated.py` is the update of `add_random_column_and_split_into_train_dev_evaluate.py`.
It takes `bb.corpus.deduplicated.cleaned.csv` (the full data set) as input
and outputs `bb.corpus.deduplicated.cleaned.train_updated.csv`, `bb.corpus.deduplicated.cleaned.dev_updated.csv`, and `bb.corpus.deduplicated.cleaned.evaluate_updated.csv` by splitting based on random integers 1-100.
The split is 60% train, 20% development, and 20% test.

`subtract_annotated_from_unannotated_ner.py` takes and `bb.corpus.deduplicated.cleaned.csv` (the full data set) and `annotations.ner.train.merged.jsonl` (what has already been annotated) as inputs
and outputs `bb.corpus.deduplicated.cleaned.after_ner_train_merged_subtracted_dev.csv` and `bb.corpus.deduplicated.cleaned.after_ner_train_merged_subtracted_validate.csv`
based on splitting based on even and odd indices the remainder of subtracting `annotations.ner.train.merged.jsonl` from `bb.corpus.deduplicated.cleaned.csv`.
The split of the remainder is 50%-50% development and test.
