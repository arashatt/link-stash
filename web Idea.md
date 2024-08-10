

اشاره کردن یک تیبل به خودش:
مثلا در یک اپ چت می‌خواهیم لیست افراد دیگر را که بهشون پیام میدیم داشته باشیم.
این تیبل نیازمند داشتن یک foreign key به خودش می‌باشد.
### آپلود رسانه
برای آپلود کردن عکس توی فرم‌های html باید نوع enctype هم اضافه کنیم تا اون عکس رو بتونه بارگذری کنه.
به طور مثال در فرم زیر عکس به درستی سمت سرور فرستاده نمی‌شه:
```html
<form method="post">
    <label for="id_picture">Picture:</label>
    <input type="file" name="picture" accept="image/*" required id="id_picture">
    <button type="submit">Sign Up</button>
</form>
```
روش درست ایجاد فرم به صورت زیر می‌باشد:
```html
<form method="post", enctype="multipart/form-data">
```
```html
<img src="{% get_media_prefix %}{{user.picture}}" class="profile-image">
```
### فرانت‌اند
برای نوشتن فرانت‌اند در برنامه جنگو نیاز داریم تا فایل‌های js , css رو به صفحاتمون بدیم. من یه سرچ ساده 
کردم تا روش آدرس دهی رو پیدا کنم.
scaler.com/topics/add-css-file-to-django

### نحوه آپلود عکس در جنگو
اول از همه باید تنظیمات مربوطه به media رو انجام بدیم تا بتونیم عکسامون رو در پوشه مناسب ذخیره کنیم و همچنین بتونیم آدرس دهی کنیم.
```python setting.py
#settings.py
MEDIA_URL = '/media/'
MEDIA_ROOT = os.path.join(BASE_DIR, 'media')

#urls.py
ulrpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
```

>[!note] روشی که استفاده کردیم برای هر تصویر به رسانه آپلود شده یک مسیر میده که در خیلی از طراحی ها  نخواهیم کاربر از وجودش خبرداره بشه و ترجیح میدیم با فایل html رندر بشه
