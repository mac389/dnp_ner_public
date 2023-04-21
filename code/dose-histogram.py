import typer 

import pandas as pd
import numpy as np 
import seaborn as sns
import matplotlib.pyplot as plt 

app = typer.Typer()

@app.command()
def main(input_file:str, output_file:str):
    df = pd.read_csv(input_file)

    fig = plt.figure()
    ax = fig.add_subplot(111)

    df.hist(ax=ax, color='k', grid=False)
    sns.despine(ax=ax, offset=10)
    ax.set_title("")
    ax.set_xlabel("DNP Dose Reported (mg)")
    ax.set_ylabel("No. of Reports")

    plt.savefig(output_file, dpi=400, bbox_inches="tight")

if __name__ == "__main__":
    app()
