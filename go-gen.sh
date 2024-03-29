mkdir -p ${PRJ_PATH}
cd ${PRJ_PATH}

##required go mod and go version >= 1.12
go mod init ${PRJ_NAME}

cat <<EOF >> .env.default
EOF

cat <<EOF >>main.go
package main

import "fmt"

func main() {
	fmt.Print("hello world")
}
EOF

if [[ -n $DOCKER && $DOCKER == "true" ]]; then 
mkdir docker

cat << EOF >> docker/Dockerfile
# build stage
FROM golang:1.16-alpine AS build-env
RUN apk --no-cache add build-base git mercurial gcc 
ADD . /src
RUN cd /src && go build -o exec

#final stage
FROM alpine
WORKDIR /app
COPY --from=build-env /src/exec /app/
COPY --from=build-env /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY .env.default /app/.env
ENTRYPOINT ./exec
EOF

cat <<EOF >> docker/deploy.sh
DOCKER_TAG=\$DOCKER_REPO:\$VERSION
cd ..
docker build -t \$DOCKER_TAG -f docker/Dockerfile .
if [[ -n \$DOCKER_PUSH && \$DOCKER_PUSH == "true" ]]; then 
docker push \$DOCKER_TAG
fi
EOF
fi