from docx import Document
from docx.shared import Inches
import string
import os
from PIL import Image, ImageDraw, ImageFont

rootDir = "/mnt/d/OneDrive/"
picFilename = "/mnt/c/Program Files (x86)/Steam/steamapps/workshop/content/431960/1828158529/files/"

def count(doc_path):
    sum = 0
    # print(os.path.abspath(doc_path))
    doc = Document(doc_path)
    for p in doc.paragraphs:
        for s in p.text:
            if '\u4e00' <= s <= '\u9fff':
                sum+=1
    return sum

def tot(rootDir):
    tot = 0
    for dir_or_file in os.listdir(rootDir):
        filePath = os.path.join(rootDir, dir_or_file)
        if dir_or_file.endswith("docx") and dir_or_file[0].isdigit():
            cnt = count(filePath)
            # print("Get cnt = {0} at {1}".format(cnt, dir_or_file))
            tot += cnt
    return tot

# print(tot(rootDir))

def Add_paper_state(FileName,OutName, count):
    with Image.open(FileName).convert('RGBA') as im:
        paper_state = Image.new(im.mode,im.size)
        d = ImageDraw.Draw(paper_state)
        Font =ImageFont.truetype( 'LiberationSans-Regular.ttf',size=150)
        d.text((1075,475),str(count).zfill(5),fill=(255,255,255),font=Font)
        out = Image.alpha_composite(im,paper_state)
        out.save(OutName)
        out.show()

Add_paper_state(picFilename+"Astro 1440P Back bak.png", picFilename+"Astro 1440P Back.png", tot(rootDir))
# Add_paper_state(picFilename+"Astro 1440P Back.png", picFilename+"Astro 1440P Back.png", tot(rootDir))

