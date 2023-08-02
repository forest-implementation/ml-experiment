from sklearn.svm import OneClassSVM
import csv
from random import sample

with open('../data/anomalies/shuttle.csv', newline='') as csvfile:
    spamreader = csv.reader(csvfile, delimiter=',')
    next(spamreader)
    next(spamreader)
    next(spamreader)
    for row in spamreader:
       data.append(list(map(float, row)))
        
print(data)
regular = list(map(lambda x: x[:-1], filter(lambda x: x[-1] == 0.0, data)))
abnormal = list(map(lambda x: x[:-1], filter(lambda x: x[-1] != 0.0, data)))


regulars = sample(regular, 10000)
regulars2 = sample(regular, 10000)
# print(regular)
clf = OneClassSVM(gamma='auto', nu=0.01).fit(regulars)

# -1 for outliers, 1 for inliers
prediction = clf.predict(regulars)
abnormalT = len(list(filter(lambda x: x == -1, prediction)))
regularT = len(list(filter(lambda x: x == 1, prediction)))

print(len(abnormal))
print(abnormalT)
print(regularT)