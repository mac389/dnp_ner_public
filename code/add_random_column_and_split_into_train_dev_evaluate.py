import os, typer, random
import pandas as pd 
import numpy as np 

from pathlib import Path

def main(path_to_unified_corpus:str, train_percentage:int = typer.Argument(60), 
									 dev_percentage:int = typer.Argument(20), 
									 evaluate_percentage:int = typer.Argument(20)):

	print(f'Dividing corpus into {train_percentage}% for training, {dev_percentage}% for model development\n and {evaluate_percentage} for evaluation.')
	basepath = Path(path_to_unified_corpus)
	#Could add default values and check that all three sum to 100
	df = pd.read_csv(path_to_unified_corpus, sep='\n', header=None, names=['text'])
	df['randint'] = np.random.randint(1,100,df.shape[0])
	df.to_csv(basepath.with_suffix('.csv'), index=False)

	#Train
	df[df['randint']<=train_percentage].to_csv(basepath.with_suffix('.train.csv'),index=False)

	#Test (aka dev)
	df[(df['randint']>train_percentage)&(df['randint']<=(train_percentage+dev_percentage))].to_csv(basepath.with_suffix('.dev.csv'),index=False)

	#Validate
	df[df['randint']>(100-evaluate_percentage)].to_csv(basepath.with_suffix('.evaluate.csv'),index=False)

if __name__ == "__main__":
	np.random.seed(42)
	typer.run(main)
