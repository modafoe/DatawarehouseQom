import os
import time
import concurrent.futures
from openai import OpenAI
import datetime

# اتصال به سرویس OpenRouter با کلید API مشخص
client = OpenAI(
    base_url="https://openrouter.ai/api/v1",
    api_key="API-Key",
)

# مسیر فایل‌ها
plant_file = "plants.txt"                # فایل حاوی نام گیاهان (یک نام در هر خط)
state_file = "state.txt"                 # فایل ذخیره آخرین ایندکس پردازش شده
request_count_file = "request_count.txt" # فایل شمارش درخواست‌های روزانه

# تنظیمات
DAILY_REQUEST_LIMIT = 50   # سقف درخواست‌های روزانه (برای تمامی مدل‌های رایگان)
BATCH_SIZE = 3             # تعداد گیاهان در هر درخواست
PARALLEL_REQUESTS = 4     # تعداد درخواست‌های موازی
REQUEST_INTERVAL = 30      # فاصله بین ارسال هر گروه (به ثانیه)

# تابع کمکی برای به‌دست آوردن نام فایل امن
def safe_name(name):
    # تنها حروف و اعداد نگه داشته شوند؛ بقیه با "-" جایگزین می‌شوند.
    return "".join(c if c.isalnum() else "-" for c in name).strip("-")

# بررسی وجود فایل
if os.path.exists(request_count_file):
    try:
        # دریافت زمان آخرین تغییر فایل
        last_modified_timestamp = os.path.getmtime(request_count_file)
        last_modified_date = datetime.datetime.utcfromtimestamp(last_modified_timestamp).date()
        current_date_utc = datetime.datetime.utcnow().date()

        # اگر فایل مربوط به روز قبل UTC است، آن را حذف کنیم
        if last_modified_date < current_date_utc:
            os.remove(request_count_file)
            request_count = 0
        else:
            with open(request_count_file, "r", encoding="utf-8") as f:
                request_count = int(f.read().strip())
    except:
        request_count = 0
else:
    request_count = 0

if request_count >= DAILY_REQUEST_LIMIT:
    print("🚫 به سقف درخواست‌های روزانه رسیده‌ایم، پردازش متوقف می‌شود!")
    exit()

# خواندن آخرین ایندکس پردازش شده
last_index = 0
if os.path.exists(state_file):
    with open(state_file, "r", encoding="utf-8") as f:
        content = f.read().strip()
        if content.isdigit():
            last_index = int(content)

# خواندن نام گیاهان از فایل و حذف \u200c (جایگزینی با فاصله)
with open(plant_file, "r", encoding="utf-8") as f:
    plants = [line.strip().replace('\u200c', ' ') for line in f if line.strip()]

# تقسیم گیاهان به دسته‌های BATCH_SIZE از آخرین اندیس پردازش شده
batches = []
for i in range(last_index, len(plants), BATCH_SIZE):
    batch_plants = plants[i: i + BATCH_SIZE]
    batches.append((i, batch_plants))

# تابعی برای پردازش یک دسته (batch) از گیاهان
def process_batch(batch_index, batch_plants):
    # ساخت نام فایل خروجی: ترکیب نام گیاهان (با جداکننده "-" )
    safe_file_name = "-".join([safe_name(p) for p in batch_plants]) + ".txt"
    
    # ساخت رشته نام‌ها (برای درج در پرامپت)
    plant_names_str = ", ".join([f'"{p}"' for p in batch_plants])
    
    # ساخت پرس‌وجویی با توضیحات تکمیلی – تأکید بر گیاهان دارویی بومی ایران – به همراه درخواست خروجی CSV برای هر گیاه
    query = f"""لطفاً اطلاعات جامع و ساختار یافته درباره گیاهان زیر را ارائه بده:
{plant_names_str}.
توجه داشته باش که این گیاهان از گیاهان دارویی بومی ایران هستند.
مطمئن شو که تمامی داده‌های مرتبط با خصوصیات دارویی، ترکیبات شیمیایی، مناطق رشد (به ویژه مناطقی با شرایط آب‌وهوای ایران) و روش‌های مصرف مرتبط با سنت‌های دارویی ایرانی را در پاسخ بگنجانی.
برای هر گیاه، خروجی را به صورت CSV مطابق با ساختار دیتاویرهاوس زیر ارائه کن:

DimPlant  
PlantID,Name,ScientificName,Family,Description,UsagePart  

DimChemicalCompound  
CompoundID,PlantID,CompoundName,Concentration  

DimMedicinalProperty  
PropertyID,PlantID,Property,Details  

DimRegion  
RegionID,PlantID,RegionName,Climate  

FactUsage  
UsageID,PlantID,Method,Dosage,Details  

لطفاً خروجی هر گیاه را با جداکننده "---" از یکدیگر تفکیک کن و تنها خروجی CSV (بدون توضیحات اضافه) ارائه بده.

مثال قالب خروجی (اطلاعات نمونه تنها برای راهنماست):

DimPlant  
PlantID,Name,ScientificName,Family,Description,UsagePart  
1,اسپند,Peganum harmala,Zygophyllaceae,گیاه دارویی بومی ایران با خواص ضدمیکروبی و ضدالتهاب، استفاده در درمان اختلالات گوارشی.,بذرها

DimChemicalCompound  
CompoundID,PlantID,CompoundName,Concentration  
1,1,harmine,2.1%  
2,1,harmaline,1.5%

DimMedicinalProperty  
PropertyID,PlantID,Property,Details  
1,1,ضدباکتری,خصوصیات ضدباکتریایی قوی  
2,1,ضدسرطان,اثر آپوپتوز در سلول‌های سرطانی

DimRegion  
RegionID,PlantID,RegionName,Climate  
1,1,بیرجند,گرم و خشک  
2,1,طبس,کویری

FactUsage  
UsageID,PlantID,Method,Dosage,Details  
1,1,دمنوش,5-10 گرم,برای بهبود عملکرد گوارشی

---  
(خروجی سایر گیاهان به همین شکل و با جداکننده "---")  
"""
    # ارسال درخواست به مدل
    completion = client.chat.completions.create(
        extra_body={},
        model="google/gemini-2.0-flash-exp:free",#qwen/qwen3-235b-a22b:free        deepseek/deepseek-chat-v3-0324:free    google/gemini-2.0-flash-exp:free
        messages=[
            {"role": "user", "content": query}
        ]
    )
    
    result = completion.choices[0].message.content
    # ذخیره نتیجه در فایل
    with open(safe_file_name, "w", encoding="utf-8") as f:
        f.write(result)
    print(f"✅ دسته شامل گیاهان {', '.join(batch_plants)} پردازش شده و در '{safe_file_name}' ذخیره گردید.")
    return batch_index  # بازگرداندن اندیس شروع این دسته

# تقسیم دسته‌ها به گروه‌های موازی (هر گروه شامل PARALLEL_REQUESTS دسته)
total_batches = len(batches)
i = 0  # شاخص دسته‌ها
while i < total_batches and request_count < DAILY_REQUEST_LIMIT:
    # تعیین دسته‌های گروه فعلی (به تعداد حداکثر PARALLEL_REQUESTS)
    group = batches[i : i + PARALLEL_REQUESTS]
    
    # چک کنیم سقف روزانه با تعداد دسته‌های این گروه رعایت شود
    if request_count + len(group) > DAILY_REQUEST_LIMIT:
        group = group[: (DAILY_REQUEST_LIMIT - request_count)]
    
    if not group:
        break
    
    try:
        # اجرای درخواست‌های گروهی به صورت موازی
        with concurrent.futures.ThreadPoolExecutor(max_workers=PARALLEL_REQUESTS) as executor:
            futures = []
            for batch_index, batch_plants in group:
                time.sleep(5)  # ⏳ افزودن تأخیر بین هر درخواست برای جلوگیری از ارور 429
                futures.append(executor.submit(process_batch, batch_index, batch_plants))
            
            batch_indices = []
            for future in concurrent.futures.as_completed(futures):
                try:
                    batch_indices.append(future.result())
                except Exception as e:
                    print(f"❗️ خطا در پردازش یک دسته: {e}")
                    # در صورت بروز خطا در یکی از دسته‌ها، آن دسته را رد می‌کنیم.

    except Exception as group_exception:
        print("❗️ خطا در پردازش گروه موازی: ", group_exception)
        # در صورت بروز خطا در سطح گروه، می‌توانیم ادامه دهیم.
        i += len(group)
        continue  # ادامه به گروه بعدی؛ به هر حال executor از طریق with به درستی بسته شده است.

    # بروزرسانی تعداد درخواست‌های ارسال شده
    request_count += len(group)
    with open(request_count_file, "w", encoding="utf-8") as f:
        f.write(str(request_count))
    
    # به روز رسانی آخرین ایندکس؛ بیشترین batch_index پردازش شده انتخاب می‌شود
    if batch_indices:
        max_batch_index = max(batch_indices)
    else:
        max_batch_index = i * BATCH_SIZE
    new_state = max_batch_index + BATCH_SIZE
    with open(state_file, "w", encoding="utf-8") as f:
        f.write(str(new_state))
    
    print(f"⏳ گروه درخواست با {len(group)} دسته پردازش شد. (مجموع درخواست‌های امروز: {request_count})")
    
    i += len(group)
    
    # اگر هنوز دسته‌ای باقی مانده و سقف روزانه نرسیده، 15 ثانیه صبر می‌کنیم
    if i < total_batches and request_count < DAILY_REQUEST_LIMIT:
        time.sleep(REQUEST_INTERVAL)

print("✅ تمام پردازش‌های ممکن برای امروز به پایان رسید.")

