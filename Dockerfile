FROM node:18
# 환경변수 설정
ENV NODE_ENV="production"

WORKDIR /app

COPY ./ ./

# /app/packages.json의 라이브러리들을 설치함
RUN npm install
RUN npm install --save-dev nodemon

EXPOSE 3000

CMD ["node", "./bin/www"]
