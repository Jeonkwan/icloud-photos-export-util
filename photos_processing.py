from PIL import Image
from PIL.ExifTags import TAGS
import os

# path to the image or video
target_dir = "/Users/jeonkwan/Downloads/before2013"
image_name = "before2013 - 1001.jpeg"
image_full_path = os.path.join(target_dir, image_name)

# read the image data using PIL
image = Image.open(image_full_path)
exifdata = image.getexif()
print(exifdata)
# iterating over all EXIF data fields
for tag_id in exifdata:
    # get the tag name, instead of human unreadable tag id
    tag = TAGS.get(tag_id, tag_id)
    data = exifdata.get(tag_id)
    # decode bytes
    if isinstance(data, bytes):
        data = data.decode()
    print(f"{tag:25}: {data}")

import ffmpeg
import sys
from pprint import pprint # for printing Python dictionaries in a human-readable way

print("==================")
video_file_name = "before2013 - 256.mov"
video_file_full_path = os.path.join(target_dir, video_file_name)
pprint(ffmpeg.probe(video_file_full_path)["streams"])
