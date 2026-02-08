FROM nginx:1.27-alpine
COPY . /usr/share/nginx/html
EXPOSE 8000
RUN sed -i 's/listen       80;/listen       8000;/' /etc/nginx/conf.d/default.conf
RUN printf 'ok\n' > /usr/share/nginx/html/health
