# استخدام Python 3.11 كصورة أساسية
FROM python:3.11-slim

# تعيين مجلد العمل
WORKDIR /app

# نسخ ملفات المتطلبات وتثبيتها
COPY backend/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# نسخ ملفات Backend فقط
COPY backend/ .

# إنشاء مجلد قاعدة البيانات
RUN mkdir -p /app/data

# تعيين المتغيرات البيئية
ENV DATABASE_URL=sqlite:///palestine_martyrs.db
ENV DEBUG=False

# تعريف المنفذ الافتراضي
ENV PORT=8000
EXPOSE $PORT

# تشغيل التطبيق مع قراءة المنفذ من متغير البيئة
CMD uvicorn main:app --host 0.0.0.0 --port ${PORT}