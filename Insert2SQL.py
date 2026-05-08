import os
import shutil
import uuid
import pyodbc

# تنظیمات اتصال به SQL Server
# conn_str = (
#     "DRIVER={ODBC Driver 17 for SQL Server};"
#     "SERVER=localhost;"  # یا نام سرور شما
#     "DATABASE=MedicinalPlantsDW;"
#     "UID=sa;"  # یوزرنیم
#     "PWD=YourPassword;"  # پسورد
#     "TrustServerCertificate=yes;"
# )
conn_str = (
    "DRIVER={ODBC Driver 17 for SQL Server};"
    "SERVER=localhost;"  # یا نام سرور/اینستنس شما
    "DATABASE=MedicinalPlantsDW;"
    "Trusted_Connection=yes;"
)


# مسیر پوشه‌ها
input_folder = r"C:\\Users\\Alire\\OneDrive\\Desktop\\database\\qwen235b a22b"
success_folder = r"C:\\Users\\Alire\\OneDrive\\Desktop\\database\\qwen235b a22b\\1"
fail_folder = r"C:\\Users\\Alire\\OneDrive\\Desktop\\database\\qwen235b a22b\\2"

# تعریف ستون‌های هر جدول
table_columns = {
    "DimPlant": ["PlantID", "Name", "ScientificName", "Family", "Description", "UsagePart"],
    "DimChemicalCompound": ["CompoundID", "PlantID", "CompoundName", "Concentration"],
    "DimMedicinalProperty": ["PropertyID", "PlantID", "Property", "Details"],
    "DimRegion": ["RegionID", "PlantID", "RegionName", "Climate"],
    "FactUsage": ["UsageID", "PlantID", "Method", "Dosage", "Details"]
}

def is_uuid(val):
    try:
        uuid.UUID(str(val))
        return True
    except:
        return False

def parse_file(file_path):
    data = {}
    current_table = None
    headers = []
    plant_id_map = {}  # old_id → new_guid

    with open(file_path, "r", encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if not line or line == "---":
                continue

            if line in table_columns:
                current_table = line
                headers = next(f).strip().split(",")
                data.setdefault(current_table, [])
                continue

            if current_table:
                parts = [p.strip() for p in line.split(",")]

                # اگر جدول DimPlant است → GUID جدید بساز و مپ کن
                if current_table == "DimPlant":
                    old_id = parts[0]
                    new_guid = str(uuid.uuid4())
                    plant_id_map[old_id] = new_guid
                    parts[0] = new_guid

                # اگر جدول وابسته است → PlantID را از مپ بگیر
                elif "PlantID" in headers:
                    plant_index = headers.index("PlantID")
                    old_id = parts[plant_index]
                    if old_id in plant_id_map:
                        parts[plant_index] = plant_id_map[old_id]
                    else:
                        raise ValueError(f"PlantID {old_id} در DimPlant پیدا نشد")

                # سایر IDها (مثل CompoundID, PropertyID, ...) → GUID جدید
                for idx, col in enumerate(headers):
                    if col.endswith("ID") and col != "PlantID":
                        parts[idx] = str(uuid.uuid4())

                data[current_table].append(parts)

    return data

def insert_data(cursor, data):
    insert_order = [
        "DimPlant",
        "DimChemicalCompound",
        "DimMedicinalProperty",
        "DimRegion",
        "FactUsage"
    ]

    for table in insert_order:
        if table not in data:
            continue

        cols = table_columns[table]
        placeholders = ",".join(["?"] * len(cols))
        sql = f"INSERT INTO {table} ({','.join(cols)}) VALUES ({placeholders})"

        for row in data[table]:
            cursor.execute(sql, row)


def process_files():
    for filename in os.listdir(input_folder):
        file_path = os.path.join(input_folder, filename)

        # فقط فایل‌ها رو پردازش کن، نه پوشه‌ها
        if not os.path.isfile(file_path):
            continue

        try:
            data = parse_file(file_path)
            with pyodbc.connect(conn_str) as conn:
                conn.autocommit = False
                cursor = conn.cursor()
                insert_data(cursor, data)
                conn.commit()
            shutil.move(file_path, os.path.join(success_folder, filename))
            print(f"✅ {filename} → موفقیت‌آمیز")
        except Exception as e:
            print(f"❌ خطا در {filename}: {e}")
            try:
                conn.rollback()
            except:
                pass
            shutil.move(file_path, os.path.join(fail_folder, filename))

if __name__ == "__main__":
    process_files()
