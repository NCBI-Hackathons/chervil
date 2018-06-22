# coding: utf-8
import pandas as pd
from sklearn.model_selection import train_test_split
from tpot import TPOTClassifier

# import the ERV expression data as a Pandas dataframe
df = pd.read_csv("ERV_sim_expression_more.csv")
df = df.values[:, 1:]

# create a class vector corresponding to the df being 50/50 split of each class
classes = [0] * int(len(df) / 2)
classes.extend([1] * len(classes))

# create the test and training data
X_train, X_test, y_train, y_test = train_test_split(df, classes, train_size=0.75, test_size=0.25)

# convert them all to floats
X_train, X_test, y_train, y_test = X_train.astype(float), X_test.astype(float), y_train.astype(float), y_test.astype(float)
pipeline_optimizer = TPOTClassifier(generations=5, population_size=20, cv=5, random_state=42, verbosity=2)
pipeline_optimizer.fit(, y_train)
