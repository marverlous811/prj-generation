mkdir ${PRJ_PATH}
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
FROM golang:1.12-alpine AS build-env
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
DOCKER_TAG=\$DOCKER_REPO:$VERSION
cd ..
docker build -t \$DOCKER_TAG -f docker/Dockerfile .
docker push \$DOCKER_TAG
EOF
fi