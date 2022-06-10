import argparse
import requests

# snag the rss link from the youtube channel
def snag_rss_link(channel_id):
    response = requests.get(f'https://www.youtube.com/channel/{channel_id}')
    # alternatively if you don't want to actually hit youtube and parse the source
    # you can just build the link and template the channel_id in there.
    #return f'https://www.youtube.com/feeds/videos.xml?channel_id={channel_id}'
    return response.text.split('"rssUrl":"')[1].split('"')[0]

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Get the rss link from a youtube channel')
    parser.add_argument('channel_id', help='the channel id')
    channel_id = parser.parse_args().channel_id

    # channel_id = 'UCBJycsmduvYEL83R_U4JriQ'
    print(snag_rss_link(channel_id))
