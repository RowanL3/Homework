#!/usr/bin/python

# Rowan Lochrin
# Comp3308
# Assignment 2

from operator import mul
from functools import reduce
from math import sqrt, pi, exp
from sys import argv


def avg(xs):
    return sum(xs)/len(xs)


def standard_deviation(xs):
    mean = avg(xs)
    variance = sum((x - mean)**2 for x in xs)
    return sqrt(variance/((len(xs)-1)))


def norm_prob(x, dist):
    mean, std_dev = dist
    var = float(std_dev) ** 2
    num = exp(-(float(x) - float(mean)) ** 2/(2 * var))
    return num / (2 * pi * var) ** .5



def distance(xs,ys = None):
    if ys is None:
        return lambda zs: distance(xs,zs)
    else:
        return sqrt(sum([(x-y)**2 for x,y in zip(xs,ys)]))


def read_file(filename, is_training = True):
    data = list()
    classes = list()
    with open(filename) as file:
        for row in file.readlines():
            if row.strip() != "" and row[0] != '#':
                entry = row.split(",")
                data.append([float(att) for att in entry[:8]])
                if is_training:
                    classes.append(entry[8].strip())

    if is_training:
        return data, classes
    else:
        return data


def nearest_neighbor(k, training_data, training_classes, testing_data):
    predictions = list()

    for row in testing_data:
        neighbors = sorted(training_data, key = distance(row))[:k]
        neighbors_classes = list(map(lambda n:training_classes[training_data.index(n)], neighbors))
        if neighbors_classes.count("yes") >= neighbors_classes.count("no"):
            predictions.append("yes")
        else:
            predictions.append("no")

    return predictions


def naive_bayes(training_data, training_classes, testing_data):
    attribute_count = len(training_data[0])
    class_distributions = list()

    for c in ("yes","no"):
        training = [row for i,row in enumerate(training_data) if training_classes[i] == c]

        attributes = [[row[i] for row in training] for i in range(attribute_count)]

        mean = map(avg, attributes)
        std_dev= map(standard_deviation, attributes)

        distributions = list(zip(mean,std_dev))

        class_distributions.append(distributions)

    p_yes = training_classes.count("yes") / float(len(training_classes))
    p_no = training_classes.count("no") / float(len(training_classes))

    results = list()
    for row in testing_data:
        classification = list()
        for distributions, p in zip(class_distributions,(p_yes,p_no)):
            probs = [norm_prob(row[i],distributions[i]) for i in range(attribute_count)]
            prob = reduce(mul,probs,p)
            classification.append(prob)

        if classification[0] >= classification[1]:
            results.append("yes")
        else:
            results.append("no")
    return results


def main():
    training_file = argv[1]
    testing_file = argv[2]
    classifier = argv[3][-2:]

    training_data, training_classes = read_file(training_file, is_training= True)
    testing_data = read_file(testing_file, is_training = False)

    results = list()

    if classifier == "NN":
        k = int(argv[3][:-2])
        results = nearest_neighbor(k, training_data, training_classes, testing_data)
    elif classifier == "NB":
        results = naive_bayes(training_data, training_classes, testing_data)
    else:
        print("No valid classifier specified. Enter 'NN' for Nearest Neighbor or 'NB' for Naive Bayes")


    for result in results:
        print(result)

if __name__ == '__main__':
    main()
