#!/usr/bin/env python

# coding: utf-8
import pandas as pd
from sklearn.model_selection import train_test_split
from tpot import TPOTClassifier
import click
from pycm import *

@click.command()
@click.argument("erv_data", type=click.Path(exists=True, dir_okay=False))
def cli(erv_data):
    # import the ERV expression data as a Pandas dataframe
    df = pd.read_csv(erv_data)
    class_codes = dict(enumerate(df['class'].astype("category").cat.categories))
    df["class"] = df["class"].astype("category").cat.codes

    # create the test and training data
    X_train, X_test, y_train, y_test = train_test_split(df.values[:, 2:], df.values[:, 1], train_size=0.75, test_size=0.25)

    # convert them all to floats
    X_train, X_test, y_train, y_test = X_train.astype(float), X_test.astype(float), y_train.astype(float), y_test.astype(float)

    # create a pipeline
    pipeline_optimizer = TPOTClassifier(generations=1, population_size=1, cv=5, verbosity=2)
    pipeline_optimizer.fit(X_train, y_train)
    pipeline_optimizer.export('tpot_exported_pipeline.py')

    print(f"Validation Accuracy: {pipeline_optimizer.score(X_test, y_test)}")
    cm = ConfusionMatrix([class_codes[y] for y in y_test], [class_codes[y] for y in [pipeline_optimizer.predict(x.reshape(1, -1))[0] for x in X_test]])
    cm.save_html("report")


if __name__ == '__main__':
    cli()
