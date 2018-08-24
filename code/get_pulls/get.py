import sys
import time
import requests

def get(url):
    while True:
        try:
            response = requests.get(url)
            if response.status_code is 200:
                return response
            print("Not 200: {}".format(url))
        except:
            print("Except: {}".format(url))

        sys.stdout.flush()
        time.sleep(3)