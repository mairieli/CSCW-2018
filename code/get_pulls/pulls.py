import urls
import get
from dateutil import parser


LIMIT_DATE = parser.parse("2017-11-07T00:00:00Z")


def contains_next_page(response):
    return 'Link' in response.headers and 'rel="next"' in response.headers['Link']


def get_data_single(owner, repo, pull_id):
    url = urls.url_single_pull(owner, repo, pull_id)
    response = get.get(url)
    p = response.json()

    username_integrator = ""
    if p['merged_by']:
        username_integrator = p['merged_by']['login']

    return username_integrator, p['comments'], p['review_comments'], p['commits'], p['additions'], p['deletions'], p['changed_files']


def get_data(response, pulls):
    for p in response.json():
        if parser.parse(p['created_at']) > LIMIT_DATE:
            return True

        if p['closed_at'] and parser.parse(p['closed_at']) < LIMIT_DATE:
            owner = p['base']['repo']['owner']['login']
            repo = p['base']['repo']['name']
            merged_at = ""
            if p['merged_at']:
                merged_at = p['merged_at']

            year, week_of_year, _ = parser.parse(p['created_at']).isocalendar()

            pull = [owner, repo, p['number'], p['created_at'], merged_at, p['closed_at'], year, week_of_year,
                    p['user']['login'], *get_data_single(owner, repo, p['number']),
                    (parser.parse(p['closed_at']) - parser.parse(p['created_at'])).total_seconds()]

            pulls.append(pull)

    return False



def get_all(owner, repo):
    pulls = []
    page = 1
    after_limit_date = False
    url = urls.url_all_pulls(owner, repo, page)

    while True:
        response = get.get(url)
        after_limit_date = get_data(response, pulls)

        if after_limit_date or not contains_next_page(response):
            break
        else:
            page = page + 1
            url = urls.url_all_pulls(owner, repo, page)

    return pulls
