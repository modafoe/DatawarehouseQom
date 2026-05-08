# import json
# import csv
# import urllib.request
# import re

# # Program to read the entire file (absolute path) using read() function
# file = open("C:/Users/Alire/OneDrive/Desktop/New Text Document (4).txt", "r", encoding='utf-8')
# content = file.read()
# file.close()
# class Payload(object):
#     def __init__(self, j):
#         self.__dict__ = json.loads(j)
# p = Payload(content)
# titles = []
# etitles= []
# images = []
def to_fa_letter(string):
    old_letters = ['ي', 'ك', 'ؤ', 'ۀ', 'ء', 'أ', 'إ', 'آ', 'ة', 'ى', '۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹','‌','&nbsp;', '&amp;', '&quot;', '&lt;', '&gt;','\xa0']
    new_letters = ['ی', 'ک', 'و', 'ه', '', 'ا', 'ا', 'آ', 'ه', 'ی', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',' ',' ', '&', '"', '<', '>',' ']
    for i in range(len(new_letters)):
        string = string.replace(old_letters[i], new_letters[i])
    return string
def pretty(string):
    if(len(string)==0):
        print('null\n')
        return string
    for _ in range(5):
        if(string[0]==' '):
            string=string[1:]
        if(string[-1]==' '):
            string=string[:-1]
        if(string[0]=='‌'):
            string=string[1:]
        if(string[-1]=='‌'):
            string=string[:-1]
    return string
import csv
import os
import shutil
# فانکشن برای تغییر کدک فایل CSV
def change_file_encoding_with_cleanup(input_file, output_file, new_encoding='utf-8-sig'):
    """
    تغییر کدگذاری فایل CSV با استفاده از to_fa_letter و pretty برای پردازش متن‌ها.
    
    :param input_file: مسیر فایل ورودی (فایل فعلی)
    :param output_file: مسیر فایل خروجی (فایل با کدگذاری جدید)
    :param new_encoding: کدگذاری جدید (پیش‌فرض: 'utf-8-sig')
    """
    try:
        # خواندن محتوای فایل اصلی
        with open(input_file, mode='r', encoding='utf-8') as file:
            reader = csv.reader(file)
            rows = []
            
            # پردازش هر ردیف
            for row in reader:
                processed_row = [pretty(to_fa_letter(cell)) for cell in row]
                rows.append(processed_row)
        
        # بازنویسی فایل با کدگذاری جدید
        with open(output_file, mode='w', encoding=new_encoding, newline='') as file:
            writer = csv.writer(file)
            writer.writerows(rows)
        
        print(f"کدگذاری فایل به '{new_encoding}' تغییر یافت و در {output_file} ذخیره شد.")


        destination_path = r'C:\Users\Alire\OneDrive\Desktop\database\\' + output_file
        # حذف فایل
        try:
            os.remove(input_file)
            print(f"فایل {input_file} با موفقیت حذف شد.")
        except FileNotFoundError:
            print(f"فایل {input_file} یافت نشد.")
        except Exception as e:
            print(f"خطا در حذف فایل: {e}")

        # کپی فایل
        try:
            shutil.copy(output_file, destination_path)
            print(f"فایل {output_file} با موفقیت به {destination_path} کپی شد.")
        except FileNotFoundError:
            print(f"فایل {output_file} یا مسیر مقصد یافت نشد.")
        except Exception as e:
            print(f"خطا در کپی کردن فایل: {e}")
    except Exception as e:
        print(f"خطا در تغییر کدگذاری فایل: {e}")
# for i in range(len(p.data)):
#     titles.append(pretty(to_fa_letter(p.data[i]['title'])))
#     etitles.append(pretty(p.data[i]['etitle']))
#     images.append('http://imp.ac.ir'+pretty(p.data[i]['plant'].split(sep='<img src=\"')[1].split(sep='\"')[0]))
# with open("C:/Users/Alire/OneDrive/Desktop/New Text Document (4).csv", 'w', newline='', encoding='utf-8') as myfile:
#     wr = csv.writer(myfile)
#     for i in range(len(titles)):
#         wr.writerow([titles[i],etitles[i],images[i]])

# opener = urllib.request.urlopen({})
# url = "https://honarfardi.com/public-skills/medicinal-plants-training/herbal-medicines-list/"
# response = urllib.request.urlopen(url)
# # f = opener.open(url)
# content = response.read().decode(response.headers.get_content_charset())
# response.close()
# rows = content.split(sep='table>')[1].split('<tr>')[2:]
# tosif = []
# faname = []
# enname =[]
# image = []
# for row in rows:
#     temp = row.split('<td>')
#     tosif.append(pretty(to_fa_letter(temp[1].split('<')[0].replace("\"", ""))))
#     faname.append(pretty(to_fa_letter(temp[2].split('<')[0].replace("\"", ""))))
#     enname.append(pretty(temp[3].split('<')[0].replace("\"", "")))
#     image.append(temp[3].split('data-src="')[1].split('\"')[0])
# if(len(tosif)!=len(faname)or len(tosif)!= len(enname)or len(tosif)!= len(image)):
#     print('\nlen is not ok!\n')
# with open("C:/Users/Alire/OneDrive/Desktop/New Text Document (4).csv", 'w', newline='', encoding='utf-8') as myfile:
#     wr = csv.writer(myfile)
#     for i in range(len(tosif)):
#         wr.writerow([faname[i],enname[i],image[i],tosif[i]])
# from bs4 import BeautifulSoup
# url = "http://manoushgroup.ir/%D9%85%D8%B9%D8%B1%D9%81%DB%8C-%DA%AF%DB%8C%D8%A7%D9%87%D8%A7%D9%86-%D8%AF%D8%A7%D8%B1%D9%88%DB%8C%DB%8C.html?start="
# i=0
# faname = []
# enname =[]
# image = []
# while(i<581):
#     response = urllib.request.urlopen(url+str(i))
#     soup = BeautifulSoup(response.read().decode(response.headers.get_content_charset()))
#     for table in soup('table')[1:]:
#         faname.append(pretty(to_fa_letter(table('td')[1].string.replace("\"", ""))))
#         enname.append(pretty(table('td')[3].string.replace("\"", "")))
#     for imgs in soup('img',{'class':'img-polaroid'}):
#         image.append(imgs['src'])
#     if(len(faname)!=len(enname) or len(faname)!=len(image)):
#         print('=========================================================================================================',i)
#         break
#     i+=10
# with open("C:/Users/Alire/OneDrive/Desktop/3.csv", 'w', newline='', encoding='utf-8') as myfile:
#     wr = csv.writer(myfile)
#     for i in range(len(faname)):
#         wr.writerow([faname[i],enname[i],image[i]])
# file = open("C:/Users/Alire/OneDrive/Desktop/4.txt", "r", encoding='utf-8')
# content = file.read()
# file.close()
# etitles= []
# gones = []
# country = []
# location = []
# part = []
# for line in content.split('\n'):
#     if(len(line.split('-'))!=2):
#         print('line = '+line)
#         etitles.append(line)
#         gones.append('xxxxxxxxxxxxxxxxxxxxxxxxx')
#         location.append('xxxxxxxxxxxxxxxxxxxxxxxxx')
#         country.append('xxxxxxxxxxxxxxxxxxxxxxxxx')
#         part.append('xxxxxxxxxxxxxxxxxxxxxxxxx')
#         continue
#     enname , gone = line.split('-')
#     triple = gone.split(',')
#     etitles.append(pretty(enname))
#     if(len(triple)==3):
#         gones.append(pretty(triple[0]))
#         location.append(pretty(triple[1]))
#         country.append(pretty(triple[2].split('(')[0]))
#         part.append(pretty(triple[2].split('(')[1].split(')')[0]))
#     else:
#         print(enname)
#         gones.append('xxxxxxxxxxxxxxxxxxxxxxxxx')
#         location.append('xxxxxxxxxxxxxxxxxxxxxxxxx')
#         country.append('xxxxxxxxxxxxxxxxxxxxxxxxx')
#         part.append('xxxxxxxxxxxxxxxxxxxxxxxxx')
# with open("C:/Users/Alire/OneDrive/Desktop/4.csv", 'w', newline='', encoding='utf-8') as myfile:
#     wr = csv.writer(myfile)
#     for i in range(len(etitles)):
#         wr.writerow([etitles[i],gones[i],part[i],country[i],location[i]])
# file = open("C:/Users/Alire/OneDrive/Desktop/4.txt", "r", encoding='utf-8')
# content = file.read()
# file.close()
# title= []
# tosif = {}
# for line in content.split('\n'):
#     if(len(line.split('-'))!=2 or len(line.split('-')[1].split(':'))!=2):
#         print('line = '+line)
#         title.append(line)
#         tosif[line] = 'xxxxxxxxxxxxxxxxxxxxxxxxx'
#         continue
#     faname , fatosif = line.split('-')[1].split(':')
#     fatosif = fatosif.split('،')
#     # for i in len(tosif):
#     #     fatosif[i]= pretty(to_fa_letter(fatosif[i]))
#     fatosif = list(map(pretty,list(map(to_fa_letter,fatosif))))
#     faname = pretty(to_fa_letter(faname))
#     title.append(faname)
#     fatosif.insert(0, faname)
#     tosif[faname] = fatosif
# with open("C:/Users/Alire/OneDrive/Desktop/4.csv", 'w', newline='', encoding='utf-8') as myfile:
#     wr = csv.writer(myfile)
#     for i in range(len(title)):
#         wr.writerow(tosif[title[i]])
# =================================================================================================================================================================================================================
# import re
# file = open("C:/Users/Alire/OneDrive/Desktop/6.txt", "r", encoding='utf-8')
# text = file.read()
# file.close()
# sections = re.split(r'\n\d+-', text) 
# sections = [section.strip() for section in sections if section.strip()]

# # pattern = re.compile(r"(\d+- )?(.*)\((.*)\):(.*)\n\n\((.*)\)\n\n(.*)")
# # pattern = re.compile(r"(\d+- )?([^:()]+)\(([^()]+)\):([^()]+)\n\n\(([^()]+)\)\n\n(.*?)(?=(\d+-|\Z))", re.DOTALL)
# pattern = re.compile(r"(\d+- )?([^()]+)\(([^)]+)\):([^()]+)\n\n\(([^)]+)\)\n\n(.*?)(?=\n\n\d+-|\n*$)", re.DOTALL)
# matches = pattern.findall(text)

# data = []
# for match in matches:
#     plant_name = match[1].strip()
#     alternative_name = match[2].strip()
#     english_name = match[3].strip()
#     property_temperature = match[4].strip()
#     additional_properties = match[5].split('–')
#     additional_properties = [prop.strip() for prop in additional_properties]
#     row = [plant_name, alternative_name, english_name, property_temperature] + additional_properties
#     data.append(row)
# ==========================================================================================================6=======================================================================================================
# url = "https://attar.blogsky.com/590"
# response = urllib.request.urlopen(url)
# content = response.read().decode(response.headers.get_content_charset())
# response.close()
# rows = content.split(sep='<div class="postbody">')[1].split('</div>')[0].split('<br />')
# # حذف فضای خالی از اول و آخر خط و موارد خالی
# rows = list(filter(None, [row.strip() for row in rows]))
# # حذف اولین مورد آرایه و خطوطی که شامل "گروه" هستند
# rows = [line for line in rows[1:] if 'گروه' not in line]

# # ایجاد یک لیست خالی برای ذخیره اطلاعات پردازش شده
# processed_data = []

# # الگوی Regex برای تشخیص خطوطی که با عدد شروع می‌شوند
# record_pattern = re.compile(r'^\d+\s*[\-–]\s*(.*)$')
# # پردازش داده‌ها
# persian_name, english_name, properties, benefits = '', '', '', ''
# current_record = []

# for line in rows:
#     line = pretty(to_fa_letter(line))
#     if record_pattern.match(line):  # خط‌هایی که با عدد شروع می‌شوند
#         if current_record:  # اگر رکورد جاری وجود دارد، به لیست پردازش شده اضافه شود
#             processed_data.append(current_record)
#         match = record_pattern.match(line)
#         parts = match.group(1).split(':')
#         persian_name = parts[0].strip()
#         english_name = parts[1].strip() if len(parts) > 1 else ''
#         properties, benefits = '', ''
#         current_record = [persian_name, english_name, properties, benefits]
#     elif '(' in line and ')' in line:  # خط‌هایی که شامل خواص هستند
#         current_record[2] = line.strip()
#     else:  # خط‌هایی که شامل فواید هستند
#         if current_record[3]:
#             current_record[3] += ' - ' + line.strip()
#         else:
#             current_record[3] = line.strip()

# # ذخیره داده‌های پردازش شده در فایل CSV
# with open('6.csv', mode='w', newline='', encoding='utf-8-sig') as file:
#     writer = csv.writer(file)
#     writer.writerow(['Persian Name', 'English Name', 'Properties', 'Benefits'])
#     writer.writerows(processed_data)
# ==========================================================================================================7=======================================================================================================
# import re
# import csv
# import requests
# from bs4 import BeautifulSoup

# # URL صفحه وب
# url = 'https://attar.blogsky.com/701'  

# text = open("C:/Users/Alire/OneDrive/Desktop/html2.txt", "r", encoding='utf-8')
# text = text.replace('WWW.021DR.COM', '')

# soup = BeautifulSoup(text, 'html.parser')

# html_content = requests.get(url)

# # ایجاد دوباره شیء BeautifulSoup با HTML به روز شده
# soup = BeautifulSoup(html_content.text, 'html.parser')

# # # پیدا کردن تگ با کلاس 'content-wrapper'
# content_div = soup.find('div', class_='content-wrapper')


# # لیست برای ذخیره عناوین
# titles = []

# # پیمایش همه تگ‌های <hr> با ویژگی‌های مشخص
# for hr_tag in soup.find_all('hr', size="2", width="100%"):
#     next_tag = hr_tag.find_next_sibling()
#     if next_tag:
#         if next_tag.name == 'strong':  # بررسی ساختار اول
#             titles.append(next_tag.text)
#         elif next_tag.name == 'p':  # بررسی ساختار دوم
#             strong_tag = next_tag.find('strong')
#             if strong_tag:
#                 titles.append(strong_tag.text)

# # چاپ عناوین استخراج شده
# print(titles)


# titles = [item for item in titles if item != '']
# # ذخیره متن‌های متناظر در یک آرایه
# sections = []

# # پیدا کردن بخش‌های مرتبط با هر عنوان
# for i, title in enumerate(titles):
#     start_index = text.find(title)  # پیدا کردن موقعیت شروع عنوان
#     if start_index != -1:  # اگر عنوان پیدا شد
#         end_index = text.find(titles[i + 1], start_index) if i + 1 < len(titles) else len(text)  # موقعیت شروع عنوان بعدی
#         section = text[start_index:end_index].strip()  # متن بین دو عنوان
#         sections.append(section)

# # اطمینان از برابر بودن طول عناوین و بخش‌ها
# if len(titles) == len(sections):
#     data = list(zip(titles, sections))  # ترکیب عناوین و متن‌های مرتبط

#     # ذخیره در فایل CSV
#     with open('output.csv', mode='w', newline='', encoding='utf-8-sig') as file:
#         writer = csv.writer(file)
#         writer.writerow(['Title', 'Text'])  # نوشتن سرستون‌ها
#         writer.writerows(data)  # نوشتن داده‌ها
#     print("فایل CSV با موفقیت ذخیره شد!")
# else:
#     print("تعداد عناوین و بخش‌های مرتبط برابر نیست.")

# input_file = "output.csv"  # فایل اصلی
# output_file = "7.csv"  # فایل جدید با کدگذاری جدید
# change_file_encoding_with_cleanup(input_file, output_file)
# ==========================================================================================================8=======================================================================================================
# import re
# import csv
# import requests
# from bs4 import BeautifulSoup

# # URL صفحه وب
# url = 'https://attarineshat.com/product-category/plant-medicine/?per_page=143&_pjax=.main-page-wrapper'  

# # درخواست به صفحه وب
# # html_content = requests.get(url)

# # فرض کنید این محتوای HTML شما است
# html_content = open("C:/Users/Alire/OneDrive/Desktop/html1.txt", "r", encoding='utf-8')


# # پردازش محتوای HTML
# soup = BeautifulSoup(html_content, 'html.parser')

# # پیدا کردن تمامی تگ‌هایی که کلاس "product-wrapper" دارند
# product_wrappers = soup.find_all(class_="product-wrapper")

# # استخراج اطلاعات مورد نظر از تگ‌ها
# products = []
# for product in product_wrappers:
#     name = product.find("h3", class_="wd-entities-title").text.strip() if product.find("h3", class_="wd-entities-title") else "ناموجود"
#     price = product.find("span", class_="price").text.strip() if product.find("span", class_="price") else "ناموجود"
#     link = product.find("a", class_="product-image-link")["href"] if product.find("a", class_="product-image-link") else "ناموجود"
#     image = product.find("img")["src"] if product.find("img") else "ناموجود"
#     products.append({"name": name, "price": price, "link": link, "image": image})

# # تابعی برای اضافه کردن ویژگی‌های جدید از جدول مشخصات
# def add_new_columns(product, attributes):
#     for key, value in attributes.items():
#         if key not in product:
#             product[key] = value

# # اسکرپ اطلاعات اضافی از صفحات محصولات
# for product in products:
#     try:
#         # ارسال درخواست به لینک محصول
#         response = requests.get(product["link"])
#         product_page = BeautifulSoup(response.text, 'html.parser')
        
#         # استخراج توضیحات از بخش خاص (اگر موجود باشد)
#         description_section = product_page.find("div", class_="wd-single-content")
#         if description_section:
#             product["description"] = description_section.get_text(separator="\n").strip()
        
#         # استخراج اطلاعات از جدول مشخصات (Additional Info Table)
#         additional_info_section = product_page.find("div", class_="wd-single-attrs")
#         attributes = {}
#         if additional_info_section:
#             rows = additional_info_section.find_all("tr")
#             for row in rows:
#                 key = row.find("th").get_text(strip=True)  # عنوان
#                 value = row.find("td").get_text(strip=True)  # مقدار
#                 attributes[key] = value
        
#         # اضافه کردن اطلاعات جدول مشخصات به محصول
#         add_new_columns(product, attributes)
#     except Exception as e:
#         print(f"خطا در دریافت اطلاعات از لینک {product['link']}: {e}")


# # ذخیره اطلاعات کامل در فایل CSV
# csv_file_name = "products_with_full_info.csv"
# with open(csv_file_name, mode="w", encoding="utf-8", newline="") as file:
#     # ایجاد هدرها (ستون‌ها) به‌صورت دینامیک
#     all_keys = set()
#     for product in products:
#         all_keys.update(product.keys())
#     writer = csv.DictWriter(file, fieldnames=list(all_keys))
    
#     writer.writeheader()
#     writer.writerows(products)

# print(f"اطلاعات محصولات کامل در فایل {csv_file_name} ذخیره شد!")
# input_file = "products_with_full_info.csv"  # فایل اصلی
# output_file = "products_with_new_encoding.csv"  # فایل جدید با کدگذاری جدید
# change_file_encoding_with_cleanup(input_file, output_file)
# ==========================================================================================================9=======================================================================================================
# import re
# import csv
# import requests
# from bs4 import BeautifulSoup

# # URL صفحه وب
# url = 'https://attar.blogsky.com/703'  

# text = open("C:/Users/Alire/OneDrive/Desktop/html3.txt", "r", encoding='utf-8').read()
# text = text.replace('WWW.021DR.COM', '')

# soup = BeautifulSoup(text, 'html.parser')

# html_content = requests.get(url)

# # ایجاد دوباره شیء BeautifulSoup با HTML به روز شده
# soup = BeautifulSoup(html_content.text, 'html.parser')

# # # پیدا کردن تگ با کلاس 'content-wrapper'
# content_div = soup.find('div', class_='content-wrapper')


# # لیست برای ذخیره عناوین
# titles = []

# # پیمایش همه تگ‌های <hr> با ویژگی‌های مشخص
# for hr_tag in soup.find_all('hr', size="2", width="100%"):
#     next_tag = hr_tag.find_next_sibling()
#     if next_tag:
#         if next_tag.name == 'strong':  # بررسی ساختار اول
#             titles.append(next_tag.text)
#         elif next_tag.name == 'p':  # بررسی ساختار دوم
#             strong_tag = next_tag.find('strong')
#             if strong_tag:
#                 titles.append(strong_tag.text)

# # چاپ عناوین استخراج شده
# # titles = titles[2:]
# titles = [item for item in titles if item != '']
# titles = [item for item in titles if len(item) > 1]
# titles = [item for item in titles if "»" not in item]
# print(titles)

# # ذخیره متن‌های متناظر در یک آرایه
# sections = []

# # پیدا کردن بخش‌های مرتبط با هر عنوان
# for i, title in enumerate(titles):
#     start_index = text.find(title)  # پیدا کردن موقعیت شروع عنوان
#     if start_index != -1:  # اگر عنوان پیدا شد
#         end_index = text.find(titles[i + 1], start_index) if i + 1 < len(titles) else len(text)  # موقعیت شروع عنوان بعدی
#         section = text[start_index:end_index].strip()  # متن بین دو عنوان
#         sections.append(section)

# # اطمینان از برابر بودن طول عناوین و بخش‌ها
# if len(titles) == len(sections):
#     data = list(zip(titles, sections))  # ترکیب عناوین و متن‌های مرتبط

#     # ذخیره در فایل CSV
#     with open('output.csv', mode='w', newline='', encoding='utf-8-sig') as file:
#         writer = csv.writer(file)
#         writer.writerow(['Title', 'Text'])  # نوشتن سرستون‌ها
#         writer.writerows(data)  # نوشتن داده‌ها
#     print("فایل CSV با موفقیت ذخیره شد!")
# else:
#     print("تعداد عناوین و بخش‌های مرتبط برابر نیست.")

# input_file = "output.csv"  # فایل اصلی
# output_file = "9.csv"  # فایل جدید با کدگذاری جدید
# change_file_encoding_with_cleanup(input_file, output_file)
# ==========================================================================================================10=======================================================================================================
# import re
# import csv
# import requests
# from bs4 import BeautifulSoup

# # URL صفحه وب
# url = 'https://attar.blogsky.com/704'  

# text = open("C:/Users/Alire/OneDrive/Desktop/html4.txt", "r", encoding='utf-8').read()
# text = text.replace('WWW.021DR.COM', '')

# soup = BeautifulSoup(text, 'html.parser')

# html_content = requests.get(url)

# # ایجاد دوباره شیء BeautifulSoup با HTML به روز شده
# soup = BeautifulSoup(html_content.text, 'html.parser')

# # # پیدا کردن تگ با کلاس 'content-wrapper'
# content_div = soup.find('div', class_='content-wrapper')


# # لیست برای ذخیره عناوین
# titles = []

# # پیمایش همه تگ‌های <hr> با ویژگی‌های مشخص
# for hr_tag in soup.find_all('hr', size="2", width="100%"):
#     next_tag = hr_tag.find_next_sibling()
#     if next_tag:
#         if next_tag.name == 'strong':  # بررسی ساختار اول
#             titles.append(next_tag.text)
#         elif next_tag.name == 'p':  # بررسی ساختار دوم
#             strong_tag = next_tag.find('strong')
#             if strong_tag:
#                 titles.append(strong_tag.text)

# # چاپ عناوین استخراج شده
# # titles = titles[2:]
# titles = [item for item in titles if item != '']
# titles = [item for item in titles if len(item) > 1]
# titles = [item for item in titles if "021dr" not in item.lower()]
# titles = [item for item in titles if "»" not in item]
# print(titles)

# # ذخیره متن‌های متناظر در یک آرایه
# sections = []

# # # پیدا کردن بخش‌های مرتبط با هر عنوان
# # for i, title in enumerate(titles):
# #     start_index = text.find(title)  # پیدا کردن موقعیت شروع عنوان
# #     if start_index != -1:  # اگر عنوان پیدا شد
# #         end_index = text.find(titles[i + 1], start_index) if i + 1 < len(titles) else len(text)  # موقعیت شروع عنوان بعدی
# #         section = text[start_index:end_index].strip()  # متن بین دو عنوان
# #         sections.append(section)

# current_index = 0  # شاخص جاری در متن

# for i, title in enumerate(titles):
#     # پیدا کردن موقعیت شروع عنوان از شاخص جاری
#     start_index = text.find(title,current_index)
#     if start_index != -1:  # اگر عنوان پیدا شد
#         # پیدا کردن موقعیت عنوان بعدی یا انتهای متن
#         end_index = text.find(titles[i + 1], start_index) if i + 1 < len(titles) else len(text)
#         # استخراج و ذخیره سکشن
#         section = text[start_index:end_index].strip()
#         sections.append(section)
#         # حذف سکشن از متن
#         # text = text[end_index:]
#         # به‌روزرسانی شاخص جاری
#         current_index = start_index

# print("سکشن‌ها:", sections)
# print("متن به‌روز شده:", text)



# # اطمینان از برابر بودن طول عناوین و بخش‌ها
# if len(titles) == len(sections):
#     data = list(zip(titles, sections))  # ترکیب عناوین و متن‌های مرتبط

#     # ذخیره در فایل CSV
#     with open('output.csv', mode='w', newline='', encoding='utf-8-sig') as file:
#         writer = csv.writer(file)
#         writer.writerow(['Title', 'Text'])  # نوشتن سرستون‌ها
#         writer.writerows(data)  # نوشتن داده‌ها
#     print("فایل CSV با موفقیت ذخیره شد!")
# else:
#     print("تعداد عناوین و بخش‌های مرتبط برابر نیست.")

# input_file = "output.csv"  # فایل اصلی
# output_file = "10.csv"  # فایل جدید با کدگذاری جدید
# change_file_encoding_with_cleanup(input_file, output_file)
# ==========================================================================================================11=======================================================================================================
# import re
# import csv
# import requests
# from bs4 import BeautifulSoup

# # URL صفحه وب
# url = 'https://attar.blogsky.com/705'  

# text = open("C:/Users/Alire/OneDrive/Desktop/html5.txt", "r", encoding='utf-8').read()
# text = text.replace('WWW.021DR.COM', '')

# soup = BeautifulSoup(text, 'html.parser')

# html_content = requests.get(url)

# # ایجاد دوباره شیء BeautifulSoup با HTML به روز شده
# soup = BeautifulSoup(html_content.text, 'html.parser')

# # # پیدا کردن تگ با کلاس 'content-wrapper'
# content_div = soup.find('div', class_='content-wrapper')


# # لیست برای ذخیره عناوین
# titles = []

# # پیمایش همه تگ‌های <hr> با ویژگی‌های مشخص
# for hr_tag in soup.find_all('hr', size="2", width="100%"):
#     next_tag = hr_tag.find_next_sibling()
#     if next_tag:
#         if next_tag.name == 'strong':  # بررسی ساختار اول
#             titles.append(next_tag.text)
#         elif next_tag.name == 'p':  # بررسی ساختار دوم
#             strong_tag = next_tag.find('strong')
#             if strong_tag:
#                 titles.append(strong_tag.text)

# # چاپ عناوین استخراج شده
# # titles = titles[2:]
# titles = [item for item in titles if item != '']
# titles = [item for item in titles if len(item) > 1]
# titles = [item for item in titles if "021dr" not in item.lower()]
# titles = [item for item in titles if "»" not in item]
# print(titles)

# # ذخیره متن‌های متناظر در یک آرایه
# sections = []

# # # پیدا کردن بخش‌های مرتبط با هر عنوان
# # for i, title in enumerate(titles):
# #     start_index = text.find(title)  # پیدا کردن موقعیت شروع عنوان
# #     if start_index != -1:  # اگر عنوان پیدا شد
# #         end_index = text.find(titles[i + 1], start_index) if i + 1 < len(titles) else len(text)  # موقعیت شروع عنوان بعدی
# #         section = text[start_index:end_index].strip()  # متن بین دو عنوان
# #         sections.append(section)

# current_index = 0  # شاخص جاری در متن

# for i, title in enumerate(titles):
#     # پیدا کردن موقعیت شروع عنوان از شاخص جاری
#     start_index = text.find(title,current_index)
#     if start_index != -1:  # اگر عنوان پیدا شد
#         # پیدا کردن موقعیت عنوان بعدی یا انتهای متن
#         end_index = text.find(titles[i + 1], start_index+2) if i + 1 < len(titles) else len(text)
#         # استخراج و ذخیره سکشن
#         section = text[start_index:end_index].strip()
#         sections.append(section)
#         # حذف سکشن از متن
#         # text = text[end_index:]
#         # به‌روزرسانی شاخص جاری
#         current_index = start_index

# # اطمینان از برابر بودن طول عناوین و بخش‌ها
# if len(titles) == len(sections):
#     data = list(zip(titles, sections))  # ترکیب عناوین و متن‌های مرتبط

#     # ذخیره در فایل CSV
#     with open('output.csv', mode='w', newline='', encoding='utf-8-sig') as file:
#         writer = csv.writer(file)
#         writer.writerow(['Title', 'Text'])  # نوشتن سرستون‌ها
#         writer.writerows(data)  # نوشتن داده‌ها
#     print("فایل CSV با موفقیت ذخیره شد!")
# else:
#     print("تعداد عناوین و بخش‌های مرتبط برابر نیست.")

# input_file = "output.csv"  # فایل اصلی
# output_file = "11.csv"  # فایل جدید با کدگذاری جدید
# change_file_encoding_with_cleanup(input_file, output_file)
# ==========================================================================================================12=======================================================================================================
# import re
# import csv
# import requests
# from bs4 import BeautifulSoup

# # URL صفحه وب
# url = 'https://attar.blogsky.com/707'  

# text = open("C:/Users/Alire/OneDrive/Desktop/html6.txt", "r", encoding='utf-8').read()
# text = text.replace('WWW.021DR.COM', '')

# soup = BeautifulSoup(text, 'html.parser')

# html_content = requests.get(url)

# # ایجاد دوباره شیء BeautifulSoup با HTML به روز شده
# soup = BeautifulSoup(html_content.text, 'html.parser')

# # # پیدا کردن تگ با کلاس 'content-wrapper'
# content_div = soup.find('div', class_='content-wrapper')


# # لیست برای ذخیره عناوین
# titles = []

# # پیمایش همه تگ‌های <hr> با ویژگی‌های مشخص
# for hr_tag in soup.find_all('hr', size="2", width="100%"):
#     next_tag = hr_tag.find_next_sibling()
#     if next_tag:
#         if next_tag.name == 'strong':  # بررسی ساختار اول
#             titles.append(next_tag.text)
#         elif next_tag.name == 'p':  # بررسی ساختار دوم
#             strong_tag = next_tag.find('strong')
#             if strong_tag:
#                 titles.append(strong_tag.text)

# # چاپ عناوین استخراج شده
# # titles = titles[2:]
# titles = [item for item in titles if item != '']
# titles = [item for item in titles if len(item) > 1]
# titles = [item for item in titles if "021dr" not in item.lower()]
# titles = [item for item in titles if "»" not in item]
# print(titles)

# # ذخیره متن‌های متناظر در یک آرایه
# sections = []

# # # پیدا کردن بخش‌های مرتبط با هر عنوان
# # for i, title in enumerate(titles):
# #     start_index = text.find(title)  # پیدا کردن موقعیت شروع عنوان
# #     if start_index != -1:  # اگر عنوان پیدا شد
# #         end_index = text.find(titles[i + 1], start_index) if i + 1 < len(titles) else len(text)  # موقعیت شروع عنوان بعدی
# #         section = text[start_index:end_index].strip()  # متن بین دو عنوان
# #         sections.append(section)

# current_index = 0  # شاخص جاری در متن

# for i, title in enumerate(titles):
#     # پیدا کردن موقعیت شروع عنوان از شاخص جاری
#     start_index = text.find(title,current_index)
#     if start_index != -1:  # اگر عنوان پیدا شد
#         # پیدا کردن موقعیت عنوان بعدی یا انتهای متن
#         end_index = text.find(titles[i + 1], start_index+2) if i + 1 < len(titles) else len(text)
#         # استخراج و ذخیره سکشن
#         section = text[start_index:end_index].strip()
#         sections.append(section)
#         # حذف سکشن از متن
#         # text = text[end_index:]
#         # به‌روزرسانی شاخص جاری
#         current_index = start_index

# # اطمینان از برابر بودن طول عناوین و بخش‌ها
# if len(titles) == len(sections):
#     data = list(zip(titles, sections))  # ترکیب عناوین و متن‌های مرتبط

#     # ذخیره در فایل CSV
#     with open('output.csv', mode='w', newline='', encoding='utf-8-sig') as file:
#         writer = csv.writer(file)
#         writer.writerow(['Title', 'Text'])  # نوشتن سرستون‌ها
#         writer.writerows(data)  # نوشتن داده‌ها
#     print("فایل CSV با موفقیت ذخیره شد!")
# else:
#     print("تعداد عناوین و بخش‌های مرتبط برابر نیست.")

# input_file = "output.csv"  # فایل اصلی
# output_file = "12.csv"  # فایل جدید با کدگذاری جدید
# change_file_encoding_with_cleanup(input_file, output_file)
# ==========================================================================================================13=======================================================================================================

# import re
# import csv
# import requests
# from bs4 import BeautifulSoup

# # URL صفحه وب
# url = 'https://attar.blogsky.com/708'  

# text = open("C:/Users/Alire/OneDrive/Desktop/html7.txt", "r", encoding='utf-8').read()
# text = text.replace('WWW.021DR.COM', '')

# soup = BeautifulSoup(text, 'html.parser')

# html_content = requests.get(url)

# # ایجاد دوباره شیء BeautifulSoup با HTML به روز شده
# soup = BeautifulSoup(html_content.text, 'html.parser')

# # # پیدا کردن تگ با کلاس 'content-wrapper'
# content_div = soup.find('div', class_='content-wrapper')


# # لیست برای ذخیره عناوین
# titles = []

# # پیمایش همه تگ‌های <hr> با ویژگی‌های مشخص
# # for hr_tag in soup.find_all('hr', size="2", width="100%"):
# #     next_tag = hr_tag.find_next_sibling()

# #     if next_tag:
# #         if next_tag.name == 'strong':  # بررسی ساختار اول
# #             titles.append(next_tag.text)
# #         elif next_tag.name == 'p':  # بررسی ساختار دوم
# #             strong_tag = next_tag.find('strong')
# #             if strong_tag:
# #                 titles.append(strong_tag.text)
# for hr_tag in soup.find_all('hr', size="2", width="100%"):
#     next_tags = hr_tag.find_all_next()  # پیدا کردن تمام تگ‌های بعدی
    
#     for next_tag in next_tags:
#         if next_tag.name == 'strong':  # بررسی ساختار اول
#             titles.append(next_tag.text.strip())
#             break  # توقف بعد از یافتن مورد مناسب
#         elif next_tag.name == 'p':  # بررسی ساختار دوم
#             strong_tag = next_tag.find('strong')
#             if strong_tag:
#                 titles.append(strong_tag.text.strip())  # استخراج متن از <strong>
#                 break  # توقف بعد از یافتن مورد مناسب
#             elif next_tag.text.strip():
#                 titles.append(next_tag.text.strip())  # استخراج متن از تگ <p>
#                 break  # توقف بعد از یافتن مورد مناسب
# # چاپ عناوین استخراج شده
# # titles = titles[2:]
# titles = [item for item in titles if item != '']
# titles = [item for item in titles if len(item) > 1]
# titles = [item for item in titles if "021dr" not in item.lower()]
# titles = [item for item in titles if "»" not in item]
# print(titles)

# # ذخیره متن‌های متناظر در یک آرایه
# sections = []

# # # پیدا کردن بخش‌های مرتبط با هر عنوان
# # for i, title in enumerate(titles):
# #     start_index = text.find(title)  # پیدا کردن موقعیت شروع عنوان
# #     if start_index != -1:  # اگر عنوان پیدا شد
# #         end_index = text.find(titles[i + 1], start_index) if i + 1 < len(titles) else len(text)  # موقعیت شروع عنوان بعدی
# #         section = text[start_index:end_index].strip()  # متن بین دو عنوان
# #         sections.append(section)

# current_index = 0  # شاخص جاری در متن

# for i, title in enumerate(titles):
#     # پیدا کردن موقعیت شروع عنوان از شاخص جاری
#     start_index = text.find(title,current_index)
#     if start_index != -1:  # اگر عنوان پیدا شد
#         # پیدا کردن موقعیت عنوان بعدی یا انتهای متن
#         end_index = text.find(titles[i + 1], start_index+2) if i + 1 < len(titles) else len(text)
#         # استخراج و ذخیره سکشن
#         section = text[start_index:end_index].strip()
#         sections.append(section)
#         # حذف سکشن از متن
#         # text = text[end_index:]
#         # به‌روزرسانی شاخص جاری
#         current_index = start_index

# # اطمینان از برابر بودن طول عناوین و بخش‌ها
# if len(titles) == len(sections):
#     data = list(zip(titles, sections))  # ترکیب عناوین و متن‌های مرتبط

#     # ذخیره در فایل CSV
#     with open('output.csv', mode='w', newline='', encoding='utf-8-sig') as file:
#         writer = csv.writer(file)
#         writer.writerow(['Title', 'Text'])  # نوشتن سرستون‌ها
#         writer.writerows(data)  # نوشتن داده‌ها
#     print("فایل CSV با موفقیت ذخیره شد!")
# else:
#     print("تعداد عناوین و بخش‌های مرتبط برابر نیست.")

# input_file = "output.csv"  # فایل اصلی
# output_file = "13.csv"  # فایل جدید با کدگذاری جدید
# change_file_encoding_with_cleanup(input_file, output_file)
# ==========================================================================================================14=======================================================================================================

# import re
# import csv
# import requests
# from bs4 import BeautifulSoup

# # URL صفحه وب
# url = 'https://attar.blogsky.com/709'  

# text = open("C:/Users/Alire/OneDrive/Desktop/html8.txt", "r", encoding='utf-8').read()
# text = text.replace('WWW.021DR.COM', '')

# soup = BeautifulSoup(text, 'html.parser')

# html_content = requests.get(url)

# # ایجاد دوباره شیء BeautifulSoup با HTML به روز شده
# soup = BeautifulSoup(html_content.text, 'html.parser')

# # # پیدا کردن تگ با کلاس 'content-wrapper'
# content_div = soup.find('div', class_='content-wrapper')


# # لیست برای ذخیره عناوین
# titles = []

# # پیمایش همه تگ‌های <hr> با ویژگی‌های مشخص
# # for hr_tag in soup.find_all('hr', size="2", width="100%"):
# #     next_tag = hr_tag.find_next_sibling()

# #     if next_tag:
# #         if next_tag.name == 'strong':  # بررسی ساختار اول
# #             titles.append(next_tag.text)
# #         elif next_tag.name == 'p':  # بررسی ساختار دوم
# #             strong_tag = next_tag.find('strong')
# #             if strong_tag:
# #                 titles.append(strong_tag.text)
# for hr_tag in soup.find_all('hr', size="2", width="100%"):
#     next_tags = hr_tag.find_all_next()  # پیدا کردن تمام تگ‌های بعدی
    
#     for next_tag in next_tags:
#         if next_tag.name == 'strong':  # بررسی ساختار اول
#             titles.append(next_tag.text.strip())
#             break  # توقف بعد از یافتن مورد مناسب
#         elif next_tag.name == 'p':  # بررسی ساختار دوم
#             strong_tag = next_tag.find('strong')
#             if strong_tag:
#                 titles.append(strong_tag.text.strip())  # استخراج متن از <strong>
#                 break  # توقف بعد از یافتن مورد مناسب
#             elif next_tag.text.strip():
#                 titles.append(next_tag.text.strip())  # استخراج متن از تگ <p>
#                 break  # توقف بعد از یافتن مورد مناسب
# # چاپ عناوین استخراج شده
# # titles = titles[2:]
# titles = [item for item in titles if item != '']
# titles = [item for item in titles if len(item) > 1]
# titles = [item for item in titles if "021dr" not in item.lower()]
# titles = [item for item in titles if "»" not in item]
# print(titles)

# # ذخیره متن‌های متناظر در یک آرایه
# sections = []

# # # پیدا کردن بخش‌های مرتبط با هر عنوان
# # for i, title in enumerate(titles):
# #     start_index = text.find(title)  # پیدا کردن موقعیت شروع عنوان
# #     if start_index != -1:  # اگر عنوان پیدا شد
# #         end_index = text.find(titles[i + 1], start_index) if i + 1 < len(titles) else len(text)  # موقعیت شروع عنوان بعدی
# #         section = text[start_index:end_index].strip()  # متن بین دو عنوان
# #         sections.append(section)

# current_index = 0  # شاخص جاری در متن

# for i, title in enumerate(titles):
#     # پیدا کردن موقعیت شروع عنوان از شاخص جاری
#     start_index = text.find(title,current_index)
#     if start_index != -1:  # اگر عنوان پیدا شد
#         # پیدا کردن موقعیت عنوان بعدی یا انتهای متن
#         end_index = text.find(titles[i + 1], start_index+2) if i + 1 < len(titles) else len(text)
#         # استخراج و ذخیره سکشن
#         section = text[start_index:end_index].strip()
#         sections.append(section)
#         # حذف سکشن از متن
#         # text = text[end_index:]
#         # به‌روزرسانی شاخص جاری
#         current_index = start_index

# # اطمینان از برابر بودن طول عناوین و بخش‌ها
# if len(titles) == len(sections):
#     data = list(zip(titles, sections))  # ترکیب عناوین و متن‌های مرتبط

#     # ذخیره در فایل CSV
#     with open('output.csv', mode='w', newline='', encoding='utf-8-sig') as file:
#         writer = csv.writer(file)
#         writer.writerow(['Title', 'Text'])  # نوشتن سرستون‌ها
#         writer.writerows(data)  # نوشتن داده‌ها
#     print("فایل CSV با موفقیت ذخیره شد!")
# else:
#     print("تعداد عناوین و بخش‌های مرتبط برابر نیست.")

# input_file = "output.csv"  # فایل اصلی
# output_file = "14.csv"  # فایل جدید با کدگذاری جدید
# change_file_encoding_with_cleanup(input_file, output_file)

# ==========================================================================================================15=======================================================================================================

# import re
# import csv
# import requests
# from bs4 import BeautifulSoup

# # URL صفحه وب
# url = 'https://attar.blogsky.com/710'  

# text = open("C:/Users/Alire/OneDrive/Desktop/html9.txt", "r", encoding='utf-8').read()
# text = text.replace('WWW.021DR.COM', '')

# soup = BeautifulSoup(text, 'html.parser')

# html_content = requests.get(url)

# # ایجاد دوباره شیء BeautifulSoup با HTML به روز شده
# soup = BeautifulSoup(html_content.text, 'html.parser')

# # # پیدا کردن تگ با کلاس 'content-wrapper'
# content_div = soup.find('div', class_='content-wrapper')


# # لیست برای ذخیره عناوین
# titles = []

# # پیمایش همه تگ‌های <hr> با ویژگی‌های مشخص
# # for hr_tag in soup.find_all('hr', size="2", width="100%"):
# #     next_tag = hr_tag.find_next_sibling()

# #     if next_tag:
# #         if next_tag.name == 'strong':  # بررسی ساختار اول
# #             titles.append(next_tag.text)
# #         elif next_tag.name == 'p':  # بررسی ساختار دوم
# #             strong_tag = next_tag.find('strong')
# #             if strong_tag:
# #                 titles.append(strong_tag.text)
# for hr_tag in soup.find_all('hr', size="2", width="100%"):
#     next_tags = hr_tag.find_all_next()  # پیدا کردن تمام تگ‌های بعدی
    
#     for next_tag in next_tags:
#         if next_tag.name == 'strong':  # بررسی ساختار اول
#             titles.append(next_tag.text.strip())
#             break  # توقف بعد از یافتن مورد مناسب
#         elif next_tag.name == 'p':  # بررسی ساختار دوم
#             strong_tag = next_tag.find('strong')
#             if strong_tag:
#                 titles.append(strong_tag.text.strip())  # استخراج متن از <strong>
#                 break  # توقف بعد از یافتن مورد مناسب
#             elif next_tag.text.strip():
#                 titles.append(next_tag.text.strip())  # استخراج متن از تگ <p>
#                 break  # توقف بعد از یافتن مورد مناسب
# # چاپ عناوین استخراج شده
# # titles = titles[2:]
# titles = [item for item in titles if item != '']
# titles = [item for item in titles if len(item) > 1]
# titles = [item for item in titles if "021dr" not in item.lower()]
# titles = [item for item in titles if "»" not in item]
# print(titles)

# # ذخیره متن‌های متناظر در یک آرایه
# sections = []

# # # پیدا کردن بخش‌های مرتبط با هر عنوان
# # for i, title in enumerate(titles):
# #     start_index = text.find(title)  # پیدا کردن موقعیت شروع عنوان
# #     if start_index != -1:  # اگر عنوان پیدا شد
# #         end_index = text.find(titles[i + 1], start_index) if i + 1 < len(titles) else len(text)  # موقعیت شروع عنوان بعدی
# #         section = text[start_index:end_index].strip()  # متن بین دو عنوان
# #         sections.append(section)

# current_index = 0  # شاخص جاری در متن

# for i, title in enumerate(titles):
#     # پیدا کردن موقعیت شروع عنوان از شاخص جاری
#     start_index = text.find(title,current_index)
#     if start_index != -1:  # اگر عنوان پیدا شد
#         # پیدا کردن موقعیت عنوان بعدی یا انتهای متن
#         end_index = text.find(titles[i + 1], start_index+2) if i + 1 < len(titles) else len(text)
#         # استخراج و ذخیره سکشن
#         section = text[start_index:end_index].strip()
#         sections.append(section)
#         # حذف سکشن از متن
#         # text = text[end_index:]
#         # به‌روزرسانی شاخص جاری
#         current_index = start_index

# # اطمینان از برابر بودن طول عناوین و بخش‌ها
# if len(titles) == len(sections):
#     data = list(zip(titles, sections))  # ترکیب عناوین و متن‌های مرتبط

#     # ذخیره در فایل CSV
#     with open('output.csv', mode='w', newline='', encoding='utf-8-sig') as file:
#         writer = csv.writer(file)
#         writer.writerow(['Title', 'Text'])  # نوشتن سرستون‌ها
#         writer.writerows(data)  # نوشتن داده‌ها
#     print("فایل CSV با موفقیت ذخیره شد!")
# else:
#     print("تعداد عناوین و بخش‌های مرتبط برابر نیست.")

# input_file = "output.csv"  # فایل اصلی
# output_file = "15.csv"  # فایل جدید با کدگذاری جدید
# change_file_encoding_with_cleanup(input_file, output_file)
# ==========================================================================================================16=======================================================================================================
# import re
# import csv
# import requests
# from bs4 import BeautifulSoup

# # URL صفحه وب
# url = 'https://attar.blogsky.com/711'  

# text = open("C:/Users/Alire/OneDrive/Desktop/html10.txt", "r", encoding='utf-8').read()
# text = text.replace('WWW.021DR.COM', '')

# soup = BeautifulSoup(text, 'html.parser')

# html_content = requests.get(url)

# # ایجاد دوباره شیء BeautifulSoup با HTML به روز شده
# soup = BeautifulSoup(html_content.text, 'html.parser')

# # # پیدا کردن تگ با کلاس 'content-wrapper'
# content_div = soup.find('div', class_='content-wrapper')


# # لیست برای ذخیره عناوین
# titles = []

# # پیمایش همه تگ‌های <hr> با ویژگی‌های مشخص
# # for hr_tag in soup.find_all('hr', size="2", width="100%"):
# #     next_tag = hr_tag.find_next_sibling()

# #     if next_tag:
# #         if next_tag.name == 'strong':  # بررسی ساختار اول
# #             titles.append(next_tag.text)
# #         elif next_tag.name == 'p':  # بررسی ساختار دوم
# #             strong_tag = next_tag.find('strong')
# #             if strong_tag:
# #                 titles.append(strong_tag.text)
# for hr_tag in soup.find_all('hr', size="2", width="100%"):
#     next_tags = hr_tag.find_all_next()  # پیدا کردن تمام تگ‌های بعدی
    
#     for next_tag in next_tags:
#         if next_tag.name == 'strong':  # بررسی ساختار اول
#             titles.append(next_tag.text.strip())
#             break  # توقف بعد از یافتن مورد مناسب
#         elif next_tag.name == 'p':  # بررسی ساختار دوم
#             strong_tag = next_tag.find('strong')
#             if strong_tag:
#                 titles.append(strong_tag.text.strip())  # استخراج متن از <strong>
#                 break  # توقف بعد از یافتن مورد مناسب
#             elif next_tag.text.strip():
#                 titles.append(next_tag.text.strip())  # استخراج متن از تگ <p>
#                 break  # توقف بعد از یافتن مورد مناسب
# # چاپ عناوین استخراج شده
# # titles = titles[2:]
# titles = [item for item in titles if item != '']
# titles = [item for item in titles if len(item) > 1]
# titles = [item for item in titles if "021dr" not in item.lower()]
# titles = [item for item in titles if "»" not in item]
# print(titles)

# # ذخیره متن‌های متناظر در یک آرایه
# sections = []

# # # پیدا کردن بخش‌های مرتبط با هر عنوان
# # for i, title in enumerate(titles):
# #     start_index = text.find(title)  # پیدا کردن موقعیت شروع عنوان
# #     if start_index != -1:  # اگر عنوان پیدا شد
# #         end_index = text.find(titles[i + 1], start_index) if i + 1 < len(titles) else len(text)  # موقعیت شروع عنوان بعدی
# #         section = text[start_index:end_index].strip()  # متن بین دو عنوان
# #         sections.append(section)

# current_index = 0  # شاخص جاری در متن

# for i, title in enumerate(titles):
#     # پیدا کردن موقعیت شروع عنوان از شاخص جاری
#     start_index = text.find(title,current_index)
#     if start_index != -1:  # اگر عنوان پیدا شد
#         # پیدا کردن موقعیت عنوان بعدی یا انتهای متن
#         end_index = text.find(titles[i + 1], start_index+2) if i + 1 < len(titles) else len(text)
#         # استخراج و ذخیره سکشن
#         section = text[start_index:end_index].strip()
#         sections.append(section)
#         # حذف سکشن از متن
#         # text = text[end_index:]
#         # به‌روزرسانی شاخص جاری
#         current_index = start_index

# # اطمینان از برابر بودن طول عناوین و بخش‌ها
# if len(titles) == len(sections):
#     data = list(zip(titles, sections))  # ترکیب عناوین و متن‌های مرتبط

#     # ذخیره در فایل CSV
#     with open('output.csv', mode='w', newline='', encoding='utf-8-sig') as file:
#         writer = csv.writer(file)
#         writer.writerow(['Title', 'Text'])  # نوشتن سرستون‌ها
#         writer.writerows(data)  # نوشتن داده‌ها
#     print("فایل CSV با موفقیت ذخیره شد!")
# else:
#     print("تعداد عناوین و بخش‌های مرتبط برابر نیست.")

# input_file = "output.csv"  # فایل اصلی
# output_file = "16.csv"  # فایل جدید با کدگذاری جدید
# change_file_encoding_with_cleanup(input_file, output_file)
# ==========================================================================================================17=======================================================================================================

# import re
# import csv
# import requests
# from bs4 import BeautifulSoup

# # URL صفحه وب
# url = 'https://attar.blogsky.com/712'  

# text = open("C:/Users/Alire/OneDrive/Desktop/html11.txt", "r", encoding='utf-8').read()
# text = text.replace('WWW.021DR.COM', '')

# soup = BeautifulSoup(text, 'html.parser')

# html_content = requests.get(url)

# # ایجاد دوباره شیء BeautifulSoup با HTML به روز شده
# soup = BeautifulSoup(html_content.text, 'html.parser')

# # # پیدا کردن تگ با کلاس 'content-wrapper'
# content_div = soup.find('div', class_='content-wrapper')


# # لیست برای ذخیره عناوین
# titles = []

# # پیمایش همه تگ‌های <hr> با ویژگی‌های مشخص
# # for hr_tag in soup.find_all('hr', size="2", width="100%"):
# #     next_tag = hr_tag.find_next_sibling()

# #     if next_tag:
# #         if next_tag.name == 'strong':  # بررسی ساختار اول
# #             titles.append(next_tag.text)
# #         elif next_tag.name == 'p':  # بررسی ساختار دوم
# #             strong_tag = next_tag.find('strong')
# #             if strong_tag:
# #                 titles.append(strong_tag.text)
# for hr_tag in soup.find_all('hr', size="2", width="100%"):
#     next_tags = hr_tag.find_all_next()  # پیدا کردن تمام تگ‌های بعدی
    
#     for next_tag in next_tags:
#         if next_tag.name == 'strong':  # بررسی ساختار اول
#             titles.append(next_tag.text.strip())
#             break  # توقف بعد از یافتن مورد مناسب
#         elif next_tag.name == 'p':  # بررسی ساختار دوم
#             strong_tag = next_tag.find('strong')
#             if strong_tag:
#                 titles.append(strong_tag.text.strip())  # استخراج متن از <strong>
#                 break  # توقف بعد از یافتن مورد مناسب
#             elif next_tag.text.strip():
#                 titles.append(next_tag.text.strip())  # استخراج متن از تگ <p>
#                 break  # توقف بعد از یافتن مورد مناسب
# # چاپ عناوین استخراج شده
# # titles = titles[2:]
# titles = [item for item in titles if item != '']
# titles = [item for item in titles if len(item) > 1]
# titles = [item for item in titles if "021dr" not in item.lower()]
# titles = [item for item in titles if "»" not in item]
# print(titles)

# # ذخیره متن‌های متناظر در یک آرایه
# sections = []

# # # پیدا کردن بخش‌های مرتبط با هر عنوان
# # for i, title in enumerate(titles):
# #     start_index = text.find(title)  # پیدا کردن موقعیت شروع عنوان
# #     if start_index != -1:  # اگر عنوان پیدا شد
# #         end_index = text.find(titles[i + 1], start_index) if i + 1 < len(titles) else len(text)  # موقعیت شروع عنوان بعدی
# #         section = text[start_index:end_index].strip()  # متن بین دو عنوان
# #         sections.append(section)

# current_index = 0  # شاخص جاری در متن

# for i, title in enumerate(titles):
#     # پیدا کردن موقعیت شروع عنوان از شاخص جاری
#     start_index = text.find(title,current_index)
#     if start_index != -1:  # اگر عنوان پیدا شد
#         # پیدا کردن موقعیت عنوان بعدی یا انتهای متن
#         end_index = text.find(titles[i + 1], start_index+2) if i + 1 < len(titles) else len(text)
#         # استخراج و ذخیره سکشن
#         section = text[start_index:end_index].strip()
#         sections.append(section)
#         # حذف سکشن از متن
#         # text = text[end_index:]
#         # به‌روزرسانی شاخص جاری
#         current_index = start_index

# # اطمینان از برابر بودن طول عناوین و بخش‌ها
# if len(titles) == len(sections):
#     data = list(zip(titles, sections))  # ترکیب عناوین و متن‌های مرتبط

#     # ذخیره در فایل CSV
#     with open('output.csv', mode='w', newline='', encoding='utf-8-sig') as file:
#         writer = csv.writer(file)
#         writer.writerow(['Title', 'Text'])  # نوشتن سرستون‌ها
#         writer.writerows(data)  # نوشتن داده‌ها
#     print("فایل CSV با موفقیت ذخیره شد!")
# else:
#     print("تعداد عناوین و بخش‌های مرتبط برابر نیست.")

# input_file = "output.csv"  # فایل اصلی
# output_file = "17.csv"  # فایل جدید با کدگذاری جدید
# change_file_encoding_with_cleanup(input_file, output_file)
# ==========================================================================================================18=======================================================================================================

# import re
# import csv
# import requests
# from bs4 import BeautifulSoup

# # URL صفحه وب
# url = 'https://attar.blogsky.com/713'  

# text = open("C:/Users/Alire/OneDrive/Desktop/html12.txt", "r", encoding='utf-8').read()
# text = text.replace('WWW.021DR.COM', '')

# soup = BeautifulSoup(text, 'html.parser')

# html_content = requests.get(url)

# # ایجاد دوباره شیء BeautifulSoup با HTML به روز شده
# soup = BeautifulSoup(html_content.text, 'html.parser')

# # # پیدا کردن تگ با کلاس 'content-wrapper'
# content_div = soup.find('div', class_='content-wrapper')


# # لیست برای ذخیره عناوین
# titles = []

# # پیمایش همه تگ‌های <hr> با ویژگی‌های مشخص
# # for hr_tag in soup.find_all('hr', size="2", width="100%"):
# #     next_tag = hr_tag.find_next_sibling()

# #     if next_tag:
# #         if next_tag.name == 'strong':  # بررسی ساختار اول
# #             titles.append(next_tag.text)
# #         elif next_tag.name == 'p':  # بررسی ساختار دوم
# #             strong_tag = next_tag.find('strong')
# #             if strong_tag:
# #                 titles.append(strong_tag.text)
# for hr_tag in soup.find_all('hr', size="2", width="100%"):
#     next_tags = hr_tag.find_all_next()  # پیدا کردن تمام تگ‌های بعدی
    
#     for next_tag in next_tags:
#         if next_tag.name == 'strong':  # بررسی ساختار اول
#             titles.append(next_tag.text.strip())
#             break  # توقف بعد از یافتن مورد مناسب
#         elif next_tag.name == 'p':  # بررسی ساختار دوم
#             strong_tag = next_tag.find('strong')
#             if strong_tag:
#                 titles.append(strong_tag.text.strip())  # استخراج متن از <strong>
#                 break  # توقف بعد از یافتن مورد مناسب
#             elif next_tag.text.strip():
#                 titles.append(next_tag.text.strip())  # استخراج متن از تگ <p>
#                 break  # توقف بعد از یافتن مورد مناسب
# # چاپ عناوین استخراج شده
# # titles = titles[2:]
# titles = [item for item in titles if item != '']
# titles = [item for item in titles if len(item) > 1]
# titles = [item for item in titles if "021dr" not in item.lower()]
# titles = [item for item in titles if "»" not in item]
# print(titles)

# # ذخیره متن‌های متناظر در یک آرایه
# sections = []

# # # پیدا کردن بخش‌های مرتبط با هر عنوان
# # for i, title in enumerate(titles):
# #     start_index = text.find(title)  # پیدا کردن موقعیت شروع عنوان
# #     if start_index != -1:  # اگر عنوان پیدا شد
# #         end_index = text.find(titles[i + 1], start_index) if i + 1 < len(titles) else len(text)  # موقعیت شروع عنوان بعدی
# #         section = text[start_index:end_index].strip()  # متن بین دو عنوان
# #         sections.append(section)

# current_index = 0  # شاخص جاری در متن

# for i, title in enumerate(titles):
#     # پیدا کردن موقعیت شروع عنوان از شاخص جاری
#     start_index = text.find(title,current_index)
#     if start_index != -1:  # اگر عنوان پیدا شد
#         # پیدا کردن موقعیت عنوان بعدی یا انتهای متن
#         end_index = text.find(titles[i + 1], start_index+2) if i + 1 < len(titles) else len(text)
#         # استخراج و ذخیره سکشن
#         section = text[start_index:end_index].strip()
#         sections.append(section)
#         # حذف سکشن از متن
#         # text = text[end_index:]
#         # به‌روزرسانی شاخص جاری
#         current_index = start_index

# # اطمینان از برابر بودن طول عناوین و بخش‌ها
# if len(titles) == len(sections):
#     data = list(zip(titles, sections))  # ترکیب عناوین و متن‌های مرتبط

#     # ذخیره در فایل CSV
#     with open('output.csv', mode='w', newline='', encoding='utf-8-sig') as file:
#         writer = csv.writer(file)
#         writer.writerow(['Title', 'Text'])  # نوشتن سرستون‌ها
#         writer.writerows(data)  # نوشتن داده‌ها
#     print("فایل CSV با موفقیت ذخیره شد!")
# else:
#     print("تعداد عناوین و بخش‌های مرتبط برابر نیست.")

# input_file = "output.csv"  # فایل اصلی
# output_file = "18.csv"  # فایل جدید با کدگذاری جدید
# change_file_encoding_with_cleanup(input_file, output_file)
# ==========================================================================================================19=======================================================================================================

# import re
# import csv
# import requests
# from bs4 import BeautifulSoup

# #  URL صفحه وب
# baseurl = 'https://attary.blogsky.com/'  
# # لیست برای ذخیره عناوین
# titles = []
# sections = []

# for i in range(88):
#     html_content = requests.get(baseurl+str(i+1))

#     # ایجاد دوباره شیء BeautifulSoup با HTML به روز شده
#     soup = BeautifulSoup(html_content.text, 'html.parser')

#     # # پیدا کردن تگ با کلاس 'content-wrapper'
#     content_div = soup.find('div', class_='content-wrapper')
#     titles.append(content_div.text.split('کلیات گیاه شناسی')[0].replace('\r','').replace('\n','').replace('  ','').replace('\r\n',''))
#     sections.append(content_div.text.split('کلیات گیاه شناسی')[1].lower().replace("021dr",'').strip())

# print(titles)
# # تفکیک کلمات فارسی و انگلیسی
# persian_words = []
# english_words = []

# for word in titles:
#     persian_part = " ".join(re.findall(r'[\u0600-\u06FF]+', word))
#     english_part = " ".join(re.findall(r'[a-zA-Z.]+', word))
#     if persian_part:
#         persian_words.append(persian_part)
#     if english_part:
#         english_words.append(english_part)

# # اطمینان از برابر بودن طول عناوین و بخش‌ها
# if len(titles) == len(sections):
#     data = list(zip(persian_words,english_words, sections))  # ترکیب عناوین و متن‌های مرتبط

#     # ذخیره در فایل CSV
#     with open('output.csv', mode='w', newline='', encoding='utf-8-sig') as file:
#         writer = csv.writer(file)
#         writer.writerow(['Fa', 'En','Text'])  # نوشتن سرستون‌ها
#         writer.writerows(data)  # نوشتن داده‌ها
#     print("فایل CSV با موفقیت ذخیره شد!")
# else:
#     print("تعداد عناوین و بخش‌های مرتبط برابر نیست.")

# input_file = "output.csv"  # فایل اصلی
# output_file = "19.csv"  # فایل جدید با کدگذاری جدید
# change_file_encoding_with_cleanup(input_file, output_file)
# ==========================================================================================================20=======================================================================================================
# import re
# import csv
# import requests
# from bs4 import BeautifulSoup

# #  URL صفحه وب
# baseurl = 'https://attar.blogsky.com/101'  

# html_content = requests.get(baseurl)

# # پردازش HTML
# soup = BeautifulSoup(html_content.text, 'html.parser')

# # لیست‌ها برای ذخیره داده‌ها
# persian_names = []
# english_names = []
# scientific_names = []

# # یافتن همه ردیف‌های جدول
# rows = soup.find_all('tr')[2:]  # از ردیف سوم به بعد داده‌ها شروع می‌شوند

# for row in rows:
#     cols = row.find_all('td')
#     if len(cols) == 3:  # اطمینان از اینکه ردیف دارای ۳ ستون است
#         persian_names.append(cols[0].get_text(strip=True))
#         english_names.append(cols[1].get_text(strip=True))
#         scientific_names.append(cols[2].get_text(strip=True))

# # نمایش نتایج
# print("نام فارسی:", persian_names)
# print("English name:", english_names)
# print("نام علمی:", scientific_names)

# # اطمینان از برابر بودن طول عناوین و بخش‌ها
# if len(persian_names) == len(english_names):
#     data = list(zip(persian_names,english_names, scientific_names))  # ترکیب عناوین و متن‌های مرتبط

#     # ذخیره در فایل CSV
#     with open('output.csv', mode='w', newline='', encoding='utf-8-sig') as file:
#         writer = csv.writer(file)
#         writer.writerow(['نام فارسی', 'نام انگلیسی','نام علمی'])  # نوشتن سرستون‌ها
#         writer.writerows(data)  # نوشتن داده‌ها
#     print("فایل CSV با موفقیت ذخیره شد!")
# else:
#     print("تعداد عناوین و بخش‌های مرتبط برابر نیست.")

# input_file = "output.csv"  # فایل اصلی
# output_file = "20.csv"  # فایل جدید با کدگذاری جدید
# change_file_encoding_with_cleanup(input_file, output_file)
# ==========================================================================================================21=======================================================================================================

# import re
# import csv
# import requests
# from bs4 import BeautifulSoup

# #  URL صفحه وب
# baseurl = 'https://attar.blogsky.com/588'  

# html_content = requests.get(baseurl)

# # پردازش HTML
# soup = BeautifulSoup(html_content.text, 'html.parser')

# # لیست برای ذخیره داده‌های هر ستون
# columns = []

# # یافتن همه ردیف‌های جدول
# rows = soup.find_all('tr')[1:]

# # پردازش هر ردیف
# for row in rows:
#     cols = row.find_all('td')
#     column_data = [col.get_text(strip=True) if col.get_text(strip=True) else "" for col in cols]
#     columns.append(column_data)

# # ذخیره در فایل CSV
# with open('output.csv', mode='w', newline='', encoding='utf-8-sig') as file:
#     writer = csv.writer(file)
#     # writer.writerow(['نام فارسی', 'نام انگلیسی','نام علمی'])  # نوشتن سرستون‌ها
#     writer.writerows(columns)  # نوشتن داده‌ها
# print("فایل CSV با موفقیت ذخیره شد!")

# input_file = "output.csv"  # فایل اصلی
# output_file = "21.csv"  # فایل جدید با کدگذاری جدید
# change_file_encoding_with_cleanup(input_file, output_file)
# ==========================================================================================================22=======================================================================================================

# import re
# import csv
# import requests
# from bs4 import BeautifulSoup

# #  URL صفحه وب
# baseurl = 'https://attar.blogsky.com/583'  

# html_content = requests.get(baseurl)

# # پردازش HTML
# soup = BeautifulSoup(html_content.text, 'html.parser')

# # لیست برای ذخیره داده‌های هر ستون
# columns = []

# # یافتن همه ردیف‌های جدول
# rows = soup.find_all('tr')

# # پردازش هر ردیف
# for row in rows:
#     cols = row.find_all('td')
#     column_data = [col.get_text(strip=True) if col.get_text(strip=True) else "" for col in cols]
#     columns.append(column_data)

# # ذخیره در فایل CSV
# with open('output.csv', mode='w', newline='', encoding='utf-8-sig') as file:
#     writer = csv.writer(file)
#     # writer.writerow(['نام فارسی', 'نام انگلیسی','نام علمی'])  # نوشتن سرستون‌ها
#     writer.writerows(columns)  # نوشتن داده‌ها
# print("فایل CSV با موفقیت ذخیره شد!")

# input_file = "output.csv"  # فایل اصلی
# output_file = "22.csv"  # فایل جدید با کدگذاری جدید
# change_file_encoding_with_cleanup(input_file, output_file)
# ==========================================================================================================23=======================================================================================================
# import re
# import csv
# import requests
# from bs4 import BeautifulSoup

# #  URL صفحه وب
# baseurl = 'https://attar.blogsky.com/585'  

# html_content = requests.get(baseurl)

# # پردازش HTML
# soup = BeautifulSoup(html_content.text, 'html.parser')

# # یافتن تمام جداول
# tables = soup.find_all('tbody')[1:]

# # ذخیره داده‌های هر جدول به صورت جداگانه
# for i, table in enumerate(tables):
#     rows = table.find_all('tr')  # یافتن ردیف‌های جدول
#     table_data = []
    
#     for row in rows:
#         cols = row.find_all('td')  # یافتن ستون‌های هر ردیف
#         column_data = [col.get_text(strip=True) if col.get_text(strip=True) else "" for col in cols]
#         table_data.append(column_data)
    
#     # ذخیره در فایل CSV
#     with open('output.csv', mode='w', newline='', encoding='utf-8-sig') as file:
#         writer = csv.writer(file)
#         # writer.writerow(['نام فارسی', 'نام انگلیسی','نام علمی'])  # نوشتن سرستون‌ها
#         writer.writerows(table_data)  # نوشتن داده‌ها
#     print("فایل CSV با موفقیت ذخیره شد!")

#     input_file = "output.csv"  # فایل اصلی
#     output_file = str(i+23)+".csv"  # فایل جدید با کدگذاری جدید
#     change_file_encoding_with_cleanup(input_file, output_file)
# ==========================================================================================================24=======================================================================================================

# import re
# import csv
# import requests
# from bs4 import BeautifulSoup

# #  URL صفحه وب
# baseurl = 'https://attar.blogsky.com/568'  

# html_content = requests.get(baseurl)

# # پردازش HTML
# soup = BeautifulSoup(html_content.text, 'html.parser')

# # لیست‌های جداگانه برای تایتل‌ها و متن‌ها
# titles = []
# texts = []

# # یافتن همه تگ‌های <strong>
# strong_tags = soup.find_all('strong')

# for i, strong_tag in enumerate(strong_tags):
#     # ذخیره تایتل
#     titles.append(strong_tag.get_text(strip=True).replace(':','').strip())
    
#     # یافتن متن مرتبط تا تگ <strong> بعدی
#     content = []
#     sibling = strong_tag.next_sibling
#     while sibling and sibling != strong_tags[i + 1] if i + 1 < len(strong_tags) else None:
#         if sibling.name is None:  # بررسی اینکه تگ نیست بلکه متن است
#             content.append(sibling.strip())
#         sibling = sibling.next_sibling
#     # اگر تایتل آخر باشد، تمام متن باقی‌مانده را به عنوان متن ذخیره کن
#     if i == len(strong_tags) - 1:
#         while sibling:
#             if sibling.name is None:  # بررسی اینکه تگ نیست بلکه متن است
#                 content.append(sibling.strip())
#             sibling = sibling.next_sibling

#     # ذخیره متن
#     texts.append(" ".join(content).strip())


# if len(titles) == len(texts):
#     data = list(zip(titles, texts))  # ترکیب عناوین و متن‌های مرتبط

#     # ذخیره در فایل CSV
#     with open('output.csv', mode='w', newline='', encoding='utf-8-sig') as file:
#         writer = csv.writer(file)
#         writer.writerow(['Title', 'Text'])  # نوشتن سرستون‌ها
#         writer.writerows(data)  # نوشتن داده‌ها
#     print("فایل CSV با موفقیت ذخیره شد!")
# else:
#     print("تعداد عناوین و بخش‌های مرتبط برابر نیست.")

# input_file = "output.csv"  # فایل اصلی
# output_file = "25.csv"  # فایل جدید با کدگذاری جدید
# change_file_encoding_with_cleanup(input_file, output_file)
# =========================================================================================change csv format=======================================================================================================
import pandas as pd

# مسیر فایل CSV اولیه
input_csv_path = '1.csv'

# مسیر فایل خروجی جدید با هدرهای مناسب
output_csv_path = input_csv_path.split('.')[0]+ '_Plants_Formatted.csv'

# خواندن فایل CSV اصلی بدون هدر
df = pd.read_csv(input_csv_path, header=None)

# اضافه کردن هدرهای جدید برای هماهنگی با جدول Plants
df.columns = ['Name', 'ScientificName', 'ImageURL']

# اضافه کردن ستون‌های خالی برای سایر فیلدهای جدول Plants
df['ID'] = None  # ستون ID (می‌توانید بعداً در دیتابیس مقداردهی کنید)
df['Family'] = None  # خانواده گیاه
df['Description'] = None  # توضیحات
df['UsagePart'] = None  # محل مصرف

# جابه‌جایی ترتیب ستون‌ها برای تطابق با ساختار جدول Plants
df = df[['ID', 'Name', 'ScientificName', 'Family', 'ImageURL', 'Description', 'UsagePart']]

# ذخیره فایل CSV جدید
df.to_csv(output_csv_path, index=False, encoding='utf-8-sig')

destination_path = r'C:\\Users\\Alire\\OneDrive\\Desktop\\database\\Formatted\\' + output_csv_path
# کپی فایل
try:
    shutil.copy(output_csv_path, destination_path)
    print(f"200")
except FileNotFoundError:
    print(f"404")
except Exception as e:
    print(f"500: {e}")
# =========================================================================================End change csv format=======================================================================================================
