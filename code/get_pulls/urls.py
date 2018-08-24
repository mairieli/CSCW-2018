import os
GITHUB_API_TOKEN = os.environ['GITHUB_API_TOKEN']


def add_token_to_url(url):
    return url + "?access_token={}".format(GITHUB_API_TOKEN)


def url_all_pulls(owner, repo, page=1):
    params = ["state=closed", "sort=created", "direction=asc", "page={}".format(page)]

    url = "https://api.github.com/repos/{}/{}/pulls".format(owner, repo)
    url = add_token_to_url(url)

    for p in params:
        url = url + "&" + p

    return url


def url_single_pull(owner, repo, pull_id):
    url = "https://api.github.com/repos/{}/{}/pulls/{}".format(owner, repo, pull_id)
    return add_token_to_url(url)
