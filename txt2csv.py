import os
import shutil
import csv

# مسیر پوشه‌ها
input_folder = r"C:\\Users\\Alire\\OneDrive\\Desktop\\database\\qwen235b a22b"
invalid_folder = r"C:\\Users\\Alire\\OneDrive\\Desktop\\database\\qwen235b a22b\\3"

# تعریف ستون‌های هر جدول
table_columns = {
    "DimPlant": ["PlantID", "Name", "ScientificName", "Family", "Description", "UsagePart"],
    "DimChemicalCompound": ["CompoundID", "PlantID", "CompoundName", "Concentration"],
    "DimMedicinalProperty": ["PropertyID", "PlantID", "Property", "Details"],
    "DimRegion": ["RegionID", "PlantID", "RegionName", "Climate"],
    "FactUsage": ["UsageID", "PlantID", "Method", "Dosage", "Details"]
}

# اطمینان از وجود پوشه مقصد
os.makedirs(invalid_folder, exist_ok=True)

def check_file(file_path):
    """بررسی ساختار فایل و تطابق تعداد ستون‌ها با حذف فاصله‌های اضافی و نادیده گرفتن خطوط خالی"""
    current_table = None
    headers = []
    expected_len = 0

    with open(file_path, "r", encoding="utf-8") as f:
        reader = csv.reader(f)
        for raw_row in reader:
            # حذف فاصله‌های ابتدا و انتهای هر ستون
            row = [col.strip() for col in raw_row]

            # نادیده گرفتن خطوط کاملاً خالی (فقط شامل space یا \r\n\t)
            if not any(cell for cell in row if cell.strip()):
                continue

            # نادیده گرفتن جداکننده جدول‌ها
            if row[0].strip() == "---":
                continue

            # تشخیص نام جدول
            table_name = row[0].strip()
            if table_name in table_columns:
                current_table = table_name
                headers = next(reader)
                headers = [h.strip() for h in headers]  # حذف فاصله‌های هدر
                expected_len = len(table_columns[table_name])
                continue

            # بررسی تعداد ستون‌ها
            if current_table:
                if len(row) != expected_len:
                    raise ValueError(
                        f"تعداد ستون‌ها در جدول {current_table} اشتباه است. "
                        f"انتظار {expected_len} ستون ولی {len(row)} ستون یافت شد. داده: {row}"
                    )
def clean_and_rewrite_file(file_path):
    """
    خواندن فایل، حذف فاصله‌های اضافی از ستون‌ها و خطوط خالی، سپس بازنویسی فایل با داده‌های تمیز
    """
    cleaned_rows = []

    with open(file_path, "r", encoding="utf-8") as f:
        reader = csv.reader(f)
        for raw_row in reader:
            # حذف فاصله‌های ابتدا و انتهای هر ستون
            row = [col.strip() for col in raw_row]

            # نادیده گرفتن خطوط کاملاً خالی (فقط شامل space یا \r\n\t)
            if not any(cell for cell in row if cell.strip()):
                continue

            cleaned_rows.append(row)

    # بازنویسی فایل با داده‌های تمیز
    with open(file_path, "w", encoding="utf-8", newline="") as f:
        writer = csv.writer(f)
        writer.writerows(cleaned_rows)

def process_files():
    for filename in os.listdir(input_folder):
        file_path = os.path.join(input_folder, filename)

        if not os.path.isfile(file_path):
            continue

        try:
            clean_and_rewrite_file(file_path)
            check_file(file_path)
        except Exception as e:
            print(f"❌ {filename} → {e}")
            shutil.move(file_path, os.path.join(invalid_folder, filename))

if __name__ == "__main__":
    process_files()
