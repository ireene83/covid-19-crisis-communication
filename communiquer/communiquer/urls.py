from django.contrib import admin
from django.urls import path, include
from rest_framework.authtoken import views

urlpatterns = [
    path('', admin.site.urls),
    path('api/', include('apis.urls', namespace='api')),
    path('api-token-auth/', views.obtain_auth_token, name='api-token-auth'),
]
