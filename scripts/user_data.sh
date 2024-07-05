#!/bin/bash

# Обновляем список пакетов и устанавливаем Nginx
sudo apt update
sudo apt install nginx -y

# Удаляем стандартную приветственную страницу Nginx
sudo rm /var/www/html/index.html

# Удаляем конфигурацию по умолчанию Nginx
sudo rm /etc/nginx/sites-available/default
sudo rm /etc/nginx/sites-enabled/default

# Создаем каталог для вашего сайта и переходим в него
sudo mkdir -p /var/www/mywebsite
cd /var/www/mywebsite

# Создаем HTML-страницу, похожую на стандартную страницу Nginx
cat <<EOF > index.html
<!DOCTYPE html>
<html>
<head>
    <title>Welcome to My Website</title>
    <style>
        body {
            font-family: Arial, Helvetica, sans-serif;
            background-color: #f2f2f2;
            text-align: center;
        }
        .container {
            padding: 50px;
        }
        h1 {
            color: #333;
        }
        p {
            font-size: 18px;
            color: #666;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Welcome to My Website</h1>
        <p>This is a simple static page hosted on Nginx.</p>
    </div>
</body>
</html>
EOF

# Устанавливаем права доступа к каталогу и файлам
sudo chown -R www-data:www-data /var/www/mywebsite

# Создаем конфигурационный файл для Nginx
sudo tee /etc/nginx/sites-available/mywebsite <<EOF
server {
    listen 80;
    server_name your_domain.com; # Замените на свой домен

    root /var/www/mywebsite;
    index index.html;

    location / {
        try_files \$uri \$uri/ =404;
    }
}
EOF

# Создаем символьную ссылку на конфигурационный файл
sudo ln -s /etc/nginx/sites-available/mywebsite /etc/nginx/sites-enabled/

# Перезапускаем Nginx, чтобы применить изменения
sudo systemctl restart nginx

echo "Nginx установлен и настроен. Ваш веб-сайт доступен по адресу http://your_domain.com"
