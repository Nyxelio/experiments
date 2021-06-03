import urllib
import json


def get(url):
    response = urllib.urlopen(url)
    html = response.read().decode("utf-8")
    return json.loads(html)


channels = get("http://mafreebox.freebox.fr/api/v3/tv/channels")["result"]
print(channels)
obj = get("http://mafreebox.freebox.fr/api/v3/tv/bouquets/49/channels")
if obj["success"]:
    for r in sorted(obj["result"], key=lambda x: x['number']):
        uuid = r["uuid"]
        print(r["number"], channels[uuid]["name"])
else:
    print("Error")



# http://mafreebox.freebox.fr/api/v3/tv/bouquets/freeboxtv/channels