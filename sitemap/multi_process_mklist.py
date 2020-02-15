# coding=utf-8
import re
from urllib.request import urlopen
from bs4 import BeautifulSoup
import time
from multiprocessing import Process, JoinableQueue, cpu_count
import csv

##### 多线程程序来自 https://www.cnblogs.com/mahailuo/p/11460739.html 
##### 爬虫程序用的是 https://github.com/apavelchuk/sitemap-crawler

input_flag = "abc"

def get_title(url):
    r1 = '[a-zA-Z0-9’!"#$%&\'()*+,-./:;<=>?@，。?★、…【】《》？“”‘’！[\\]^_`{|}~]+'
    content = urlopen(url).read().decode('utf-8')
    pat = r'<title>(.*?)</title>'
    title = re.findall(pat,content)
    # 标志位-字母-数字-名称
    tmp = re.split("[-_]",title[0])
    if (bool(re.search(r'[A-Za-z]', tmp[0]))): # 字母开头
        if (len(tmp[1])<=3):
            d = dict(flag=True, alphabet = tmp[0], num=tmp[1], name = tmp[2],site = url)
            # print("情况1")
        else:
            cn_name = re.sub(r1,'',title[0])
            # cn_name = ''.join(re.findall('[\u4e00-\u9fa5]',tmp[0]))
            cn_num = re.findall(r'\d+',tmp[1])
            d = dict(flag=False, alphabet = 'Null', num= cn_num, name = cn_name,site = url)
            # print("情况2")
        # print(d)
    else:
        d = dict(flag=False, alphabet = 'Null', num= 'Null', name = tmp[0],site = url)
        # print("情况3")
        # print(d)
    return title[0],d


####处理一条数据的方法
def deal_line(line, writer, csv_file):
    pat = r'<url><loc>(.*?)</loc></url>'
    line = re.findall(pat,line)
    # fileheader = ["flag", "alphabet","num","name","site"]
    try:
        tmp = re.split("[/]",line[0])
    except:
        pass
    else:
        try:
            flag = tmp[4]
        except:
            pass
        else:
            if(flag == input_flag):
                title,dictionary = get_title(line[0])
                print("dictionary")
                writer.writerow([dictionary])
                # dict_writer = csv.DictWriter(csvFile, fileheader)
    csv_file.flush()#重点,在多进程中写文件需要尽快刷新,否则可能会导致数据丢失
 
####消费者模型
def consumer(queue, writer, csv_file):
    while True:
        line = queue.get()
        deal_line(line, writer, csv_file)
        queue.task_done()
####生产者模型
def producer(queue):
    with open("sitemap_test.xml", 'r') as f:
        for line in f:
            queue.put(line)
 
####启动N个生产者N个消费者模型
def main():
    with open('test.csv', 'w+') as csv_file:
        writer = csv.writer(csv_file)
        queue = JoinableQueue(8)#可限制队列长度
        pc = Process(target=producer, args=(queue,))
        pc.start()
 
        #多消费者
        for _ in range(cpu_count()):
            c1 = Process(target=consumer, args=(queue, writer, csv_file))
            c1.daemon = True
            c1.start()
        pc.join()#等待生产者进程全部生成完毕
        queue.join()# 等待所有数据全部处理完毕
 
        # 当某些些进程是死循环时可强制终止
        # pc.terminate()
 
if __name__ == '__main__':
 
    now = lambda: time.time()
    start = now()
    main()
    print("Time:", now() - start)