# 베이스 이미지
FROM ubuntu:latest

# 작업 디렉토리 설정
WORKDIR /app

# 필요한 패키지 설치
RUN apt-get update && apt-get install -y curl git unzip 

# Flutter SDK 다운로드 및 설치
RUN git clone https://github.com/flutter/flutter.git /opt/flutter && \
    /opt/flutter/bin/flutter config --enable-web

# Flutter 환경 설정
ENV PATH="/opt/flutter/bin:$PATH"

# Flutter 프로젝트 디렉토리로 이동
WORKDIR /app/flutter_project

# Flutter 프로젝트를 포함한 디렉토리를 복사
COPY . .

# Flutter 프로젝트 빌드
RUN /opt/flutter/bin/flutter build web

# 웹 서버 설정
RUN apt-get update && apt-get install -y nginx
RUN cp -r /app/flutter_project/build/web/* /var/www/html/

# Nginx 설정 변경
# 설정 파일을 생성하고 Dockerfile에 적용합니다.
RUN echo "server { listen 80; root /var/www/html; index index.html; location / { try_files \$uri \$uri/ /index.html; } }" > /etc/nginx/sites-available/default
RUN rm -f /etc/nginx/sites-enabled/default && ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/

# 포트 노출 및 웹 서버 실행
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]