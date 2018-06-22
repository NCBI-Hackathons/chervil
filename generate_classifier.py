# coding: utf-8
import pandas as pd
df = pd.read_csv("ERV_sim_expression_more.csv")
df = df.values[:,1:]
classes = [0] * int(len(df)/ 2)
classes.extend([1] * len(classes))
from sklearn.model_selection import train_test_split
X_train, X_test, y_train, y_test = train_test_split(df, classes)
from tpot import TPOTClassifier
pipeline_optimizer = TPOTClassifier(generations=5, population_size=20, cv=5, random_state=42, verbosity=2)
pipeline_optimizer.fit(X_train.astype(float), y_train)
