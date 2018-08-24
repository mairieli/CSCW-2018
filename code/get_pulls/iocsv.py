import csv


def read_csv_repos(file):
    input_csv = open('data/{}'.format(file), 'r')
    reader_csv = csv.reader(input_csv, delimiter=';')

    repos = [{'owner': r[0], 'repo': r[1]} for r in reader_csv]
    input_csv.close()
    return repos