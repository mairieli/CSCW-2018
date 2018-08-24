import csv
import iocsv
import pulls


if __name__ == "__main__":
    pull_out = open('data/merged_pulls.csv', 'w')
    w_pull_out = csv.writer(pull_out)

    repos = iocsv.read_csv_repos("first_bot_interaction.csv")
    for r in repos:
        for merged_pull in pulls.get_all(r['owner'], r['repo']):
            w_pull_out.writerow(merged_pull)
        pull_out.flush()

    pull_out.close()
