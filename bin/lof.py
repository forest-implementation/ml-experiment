from sklearn.neighbors import LocalOutlierFactor
import csv
from random import sample


data = []
# with open('../data/anomalies/http.csv', newline='') as csvfile:
with open('../data/donors/donors_norm.csv', newline='') as csvfile:
    spamreader = csv.reader(csvfile, delimiter=',')
    next(spamreader)
    next(spamreader)
    next(spamreader)
    for row in spamreader:
       data.append(list(map(float, row)))
        
regular = list(map(lambda x: x[:-1], filter(lambda x: x[-1] == 0.0, data)))
abnormal = list(map(lambda x: x[:-1], filter(lambda x: x[-1] != 0.0, data)))


regulars = sample(regular, 10000)
regulars2 = sample(regular, 10000)
# print(regular)
clf = LocalOutlierFactor(novelty=True).fit(regulars)

# -1 for outliers, 1 for inliers
prediction = clf.predict(regulars2)
abnormalT = len(list(filter(lambda x: x == -1, prediction)))
regularT = len(list(filter(lambda x: x == 1, prediction)))

print(len(abnormal))
print(abnormalT)
print(regularT)