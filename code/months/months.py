# owner
# name
# pull_id
# created_at
# merged_at
# closed_at
# year
# week_of_year
# username_contributor
# username_integrator
# num_comments
# num_review_comments
# num_commits
# num_add
# num_del
# num_changed_files
# close_time_seconds
# is_merged
# is_before
import sys
import csv
import datetime
from dateutil import parser


def add_days(date, add):
    return date + datetime.timedelta(days=add)


def sub_days(date, sub):
    return date - datetime.timedelta(days=sub)


def is_between(date, start, end):
    return date >= start and date <= end


def empty_month():
    return [0] * 7


def string_to_date(s):
    return parser.parse(s).date()


def get_months(interaction_date, qtd=6, period=30):
    m = []
    for i in range(1, period * qtd, period):
        b_last_day = sub_days(interaction_date, i)
        b_first_day = sub_days(b_last_day, period - 1)
        m.insert(0, {(b_first_day, b_last_day): empty_month()})
        a_first_day = add_days(interaction_date, i)
        a_last_day = add_days(a_first_day, period - 1)
        m.append({(a_first_day, a_last_day): empty_month()})
    return m


def summarize(months, pulls, selected):
    for pull in pulls:
        date_of_pull = string_to_date(pull[3])
        for i, month in enumerate(months):
            first, last = list(month.keys())[0]
            if is_between(date_of_pull, first, last):
                pull.append(pull[4] is not "")
                pull.append(i < 6)
                selected.append(pull)


def write_months(selected):
    o_months = open('data/selected.csv', 'a')
    w_months = csv.writer(o_months)

    for pull in selected:
        w_months.writerow(pull)



def first_bot_interaction():
    repos = {}

    input_csv = open('data/first_bot_interaction.csv', 'r')
    reader_csv = csv.reader(input_csv, delimiter=';')
    for r in reader_csv:
        repos[(r[0], r[1])] = string_to_date(r[6])

    input_csv.close()
    return repos


if __name__ == "__main__":
    f_interaction = first_bot_interaction()
    closed_prs_in = open('data/closed_pulls.csv', 'r')
    r_pulls = csv.reader(closed_prs_in, delimiter=',')

    pulls = {}
    for p in r_pulls:
        key = (p[0], p[1])
        if key not in pulls:
            pulls[key] = []

        pulls[key].append(p)

    selected = []
    for key in pulls:
        summarize(get_months(f_interaction[key]), pulls[key], selected)

    write_months(selected)
    closed_prs_in.close()
