url 
```python
path("signup/", SignUpView.as_view(), name="signup"),
```
```python
# accounts/views.py
from django.contrib.auth.forms import UserCreationForm
from django.urls import reverse_lazy
from django.views import generic


class SignUpView(generic.CreateView):
    form_class = UserCreationForm
    success_url = reverse_lazy("login")
    template_name = "registration/signup.html"
```
this SignUpView is defined in our view and should be imported `from .views import SignUpView` this SignUpView inherets from Create View which is discussed in the next section.
### [CreateView](https://docs.djangoproject.com/en/5.0/ref/class-based-views/generic-editing/)
you can create an object with this form.
- template_name_suffix: the name of suffix used in templates.
	for example `pythontemplate_name_suffix = create_form` expects author_create_form.html  in templates/website folder
- object: the object being created.


https://websockets.readthedocs.io/en/stable/howto/django.html

### fullstack python

https://www.fullstackpython.com/django.html

load one function in interactive python and test it.
`from filename import function name`
how to run asynchronous functions in python
```python
import asyncio
loop = asyncio.get_default_loop()
loo.run_until_complete()
```
non-capturing groups in regex start with ?:


توی محیط توسعه خودم می‌خوام یک venv داشته باشم و پروژه‌ای که داریم قراره داکرایز بشه.
باید توی روت یک venv باشه برای همه پروژه‌ها یا
openssl rand -hex 32
