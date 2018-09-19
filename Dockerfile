# STAGE 1: Build #
##################
FROM starefossen/ruby-node as builder

ENV APP_HOME /app
RUN mkdir -pv $APP_HOME
WORKDIR $APP_HOME

COPY package*.json ./

RUN npm install

COPY . .

RUN gem install premailer && \
    gem install nokogiri

CMD [ "npm", "start" ]

# STAGE 2: Setup #
##################
FROM alpine:latest

## the public directory won't exist, so we need to make sure to create it
RUN mkdir /public && mkdir /public/dist

## From 'builder' stage copy over the artifacts in dist folder to public folder
COPY --from=builder /app/previews.html /public/previews.html
COPY --from=builder /app/dist/* /public/dist/
