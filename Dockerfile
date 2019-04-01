FROM node:lts-alpine

# install simple http server for serving static content
# RUN npm install -g http-server
# 安装nginx
RUN apt-get update \
    && apt-get install -y nginx

# make the 'app' folder the current working directory
# 指定工作目录
WORKDIR /app


# copy both 'package.json' and 'package-lock.json' (if available)
COPY . /app/

# 声明服务端口
EXPOSE 80

# install project dependencies
RUN npm install \
    && npm run build \
    && cp -r dist/* /var/www/html\
    && rm -rf /app

CMD [ "nginx","g","dameon off;"]