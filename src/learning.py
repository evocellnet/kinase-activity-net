import scipy
import numpy as np
import sklearn
from sklearn import svm, linear_model
import sys
from sklearn.naive_bayes import GaussianNB
from sklearn.neighbors.nearest_centroid import NearestCentroid
from random import *
from sklearn.ensemble import RandomForestClassifier

def traindata(file1,file2,data,threshold):
# Creates matrix (list of list) containing true pos and true negatives
# for training and predictions, f1 is true positives and f2 true negatives
    # x is predictive variables (ppsm, string,cor) and y outcomes
    x = {}
    y=[]
    ppairs = []
    datadict = prediction_matrix(data)[0]
    with open(file2,"r") as f2:
        first_line = f2.readline()
        for line in f2:
            if 'NA' not in line:
                line.replace("\n","")
                line = line.split("\t")
                line[1] = line[1].replace('\n','')
                if (line[0],line[1]) in datadict:
                    y.append(0)
                    x[line[0],line[1]] = datadict[line[0],line[1]]
                    ppairs.append([line[0],line[1]])

    with open(file1,"r") as f1:
        first_line = f1.readline()
        for line in f1:
            if 'NA' not in line:
                n = len(y)
                m = len(x)
                line = line.split("\t")
                line[1] = line[1].replace("\n","")
                if (line[0],line[1]) in datadict:
                    y.append(1)
                    x[line[0],line[1]] = datadict[line[0],line[1]]
                    ppairs.append([line[0],line[1]])
                if (len(x) -m) != (len(y) - n):
                    print('error 3')

    k = list(x.keys())
    for i in k:
        rand = random()
        if rand > threshold:
            if (i[1],i[0]) not in x:
                x[i[1],i[0]] = datadict[i[1],i[0]]
                y.append(0)
                ppairs.append([i[0],i[1]])
    print(len(y))
    print(len(x))
    return x,y,ppairs


def prediction_matrix(data):
    #makes matrix with pssm values string score and corr
    ppairs = []
    v = {}
    with open(data,"r") as d:
        first_line = d.readline()
        for line in d:
            if 'NA' not in line:
                line = line.split("\t")

                ppairs.append([line[0],line[1]])
                v[line[0],line[1]] = [float(x) for x in line[2:]]
    return v, ppairs

def SuppVectMach(train,outcomes,test):
# uses Support Vector Machines to classify data into 1 (interaction) and 0 (no interaction) and #returns probabilities

    clf = svm.SVC(probability = True)
    clf.fit(train, outcomes)

    results = clf.predict(test)
    probability = clf.predict_proba(test)
    return results,probability

def find_centers(test,results):
#works with nearestneighbour this function finds the centers of
#the two clusters
    center1 = [[],[],[],[]]
    center2 = [[],[],[],[]]

    for i in range(0,len(test)):
        if results[i] == 0:
            center1[0].append(test[i][0])
            center1[1].append(test[i][1])
            center1[2].append(test[i][2])
            center1[3].append(test[i][3])
        else:
            center2[0].append(test[i][0])
            center2[1].append(test[i][1])
            center2[2].append(test[i][2])
            center2[3].append(test[i][3])
    if len(center1[0]) == 0 or len(center2[0]) == 0:
        return [[],[]]
    c1 = [np.mean(center1[0]),np.mean(center1[1]),np.mean(center1[2]),np.mean(center1[3])]
    c2 = [np.mean(center2[0]),np.mean(center2[1]),np.mean(center2[2]),np.mean(center2[3])]

    return [c1,c2]

def dist(t,c):
#calculates eucledian distance between point x and y
    dist = float(abs(t[0]-c[0])**2+abs(t[1]-c[1])**2+abs(t[2]-c[2])**2 + abs(t[3]-c[3])**2)**0.5

    return dist

def probability(c1,c2,test,results):
#lukewarm function that calculates the probability that given value is in 
#cluster x rather than y        
    probability = []
    for i in range(0,len(results)):
        if results[i] == 0:
            p = dist(test[i],c2)/(dist(test[i],c2)+dist(test[i],c1))
            probability.append([p,1-p])
        else:
            p = dist(test[i],c1)/(dist(test[i],c2)+dist(test[i],c1))
            probability.append([p,1-p])
    return probability

def nearestneighbour(train,outcomes,test):
# clusters test data into 2 clusters (0 and 1)
    clf = NearestCentroid()
    clf.fit(train, outcomes)
    results = clf.predict(test)

    centers = find_centers(test,results)
    c1 = centers[0]
    c2 = centers[1]

    if len(c1) > 0 and len(c2) > 0:

        probs = probability(c1,c2,test,results)

        return results,probs
    else:
        return results

def naive_bayes(train,outcomes,test):
# calculates naive bayes 
    model = GaussianNB()

    prediction = model.fit(train,outcomes).predict(test)
    probability = model.fit(train,outcomes).predict_proba(test)

    return prediction,probability

def log_reg(train,outcomes,test):
    model = linear_model.LogisticRegression()
    prediction = model.fit(train,outcomes).predict(test)
    probability = model.fit(train,outcomes).predict_proba(test)

    return prediction,probability

def randfor(train,outcomes,test):
    forest = RandomForestClassifier()

    forest.fit(train,outcomes)
    prediction = forest.predict(test)
    probability = forest.predict_proba(test)

    return prediction,probability

if __name__ == "__main__":

    truePos = sys.argv[1]
    trueNeg = sys.argv[2]
    data = sys.argv[3]
    method = sys.argv[4]
    threshold = float(sys.argv[5])

    testdict,ppairs = prediction_matrix(data)
    test = list(testdict.values())
  
    traindict,outcomes,ppairs_train = traindata(truePos,trueNeg,data,threshold)
    train = list(traindict.values())
    
    if method == "NB":
        prediction = naive_bayes(train,outcomes,test)

    if method == "SVM":
        prediction = SuppVectMach(train,outcomes,test)

    if method == "kmeans":
        prediction = nearestneighbour(train,outcomes,test)

    if method == "logreg":
        prediction = log_reg(train,outcomes,test)

    if method == "randfor":
        prediction = randfor(train,outcomes,test)

    if len(prediction) > 1:
        prob = prediction[1]
        prediction = prediction[0]

    with open(sys.argv[6],"w") as output:
        for i in range(len(testdict.keys())):
            s = str.join("\t",[str(x) for x in list(testdict.keys())[i]])
            s = s + "\t"+ str(prediction[i]) +"\t"+ str(prob[i][1])

            output.write(s+"\n")
                                                                      
                                                                                                                                                                                          1,1           Top
