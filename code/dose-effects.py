import os, string, typer 

import pandas as pd
import numpy as np 
import seaborn as sns
import matplotlib.pyplot as plt 

from collections import Counter, OrderedDict

palette = sns.color_palette("PuRd",4)
#f1eef6
#d7b5d8
#df65b0
#ce1256
app = typer.Typer()

@app.command()
def main(input_file:str, output_path:str, numeffects:int=typer.Argument(10)):
    column_names = {"index": "Symptoms","class":"Class",
        "Q1":"$\leq$150 mg","Q2": "150-300 mg","Q3":"300-450"}

    df = pd.read_csv(input_file)
    fig = plt.figure()
    ax = fig.add_subplot(111)
    sns.barplot(y='Symptoms',x='No. of Mentions',hue='Dosage',data=df, 
        ax=ax, ci=None, palette = palette,
        hue_order=["None"] + [column_names[label] for label in ["Q1","Q2","Q3"]])
    ax.set_ylabel('')
    ax.legend(frameon=False)
    sns.despine(offset=10,ax=ax)
    plt.savefig(os.path.join(output_path,f'top-{numeffects}-symptoms.png'),
                dpi=400,bbox_inches="tight")

if __name__ == "__main__":
    app()
    
