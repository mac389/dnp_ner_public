import os, typer 

import pandas as pd
import numpy as np 
import seaborn as sns
import matplotlib.pyplot as plt 

sns.set_context('paper', font_scale=1.4)
app = typer.Typer()

@app.command()
def main(input_file:str, output_path:str):
    df = pd.read_csv(input_file,delimiter='\t', index_col=0, header=0)
    fig = plt.figure()
    ax = fig.add_subplot(111)

    marginalized_fs = pd.Series(np.diag(df), index=df.index)
    marginalized_fs = marginalized_fs.sort_values(ascending=False).head(25)
    sns.barplot(ax=ax,y=marginalized_fs.index, x=marginalized_fs.values, color='k')

    sns.despine(offset=10)
    ax.set_xlabel("No. of Posts Mentioning Substance")
    ax.axvline(x=40,lw=2,ls='--',color='k')
    ax.set_xscale("log")

    ax.set_xlim(1,1000)
    plt.tight_layout()
    plt.savefig(output_path, dpi=400, bbox_inches="tight")

if __name__ == "__main__":
    app()
