import typer, json, os


def main(prelim_jsonl_path:str, jsonl_save_path:str):
	not_fully_formatted = json.load(open(prelim_jsonl_path))
	fully_formatted = [{"label":item["label"],"pattern":[{"lower":word.lower()} 
						for word in item["TEXTUAL MENTION"].split()]}
						for item in not_fully_formatted]
	json.dump(fully_formatted,open(jsonl_save_path,'w'))

if __name__ == "__main__":
    typer.run(main)
