FROM nginx:alpine
# необходимо добавить bash для правильного функционирования скрипта
RUN apk add bash --no-cache
COPY ./docker-entrypoint.sh /etc/nginx

ENTRYPOINT [ "/etc/nginx/docker-entrypoint.sh" ]