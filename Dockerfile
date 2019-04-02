FROM node:8.9.4

# #更新apt-get源 使用163的源
# RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak && \
#     echo "deb http://mirrors.163.com/debian/ jessie main non-free contrib" >/etc/apt/sources.list && \
#     echo "deb http://mirrors.163.com/debian/ jessie-proposed-updates main non-free contrib" >>/etc/apt/sources.list && \
#     echo "deb-src http://mirrors.163.com/debian/ jessie main non-free contrib" >>/etc/apt/sources.list && \
#     echo "deb-src http://mirrors.163.com/debian/ jessie-proposed-updates main non-free contrib" >>/etc/apt/sources.list

# install simple http server for serving static content
# RUN npm install -g http-server

RUN echo "deb [check-valid-until=no] http://archive.debian.org/debian jessie-backports main" > /etc/apt/sources.list.d/jessie-backports.list
RUN sed -i '/deb http:\/\/deb.debian.org\/debian jessie-updates main/d' /etc/apt/sources.list
RUN apt-get -o Acquire::Check-Valid-Until=false update

# 安装nginx
RUN apt-get update && apt-get install -y nginx && apt-get install -y apt-transport-https

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