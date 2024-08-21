1. 使用 docker buildx
2. 编写多平台Dockerfile
1）多平台构建在dockerfile写架构信息
   ```Dockerfile
    # syntax=docker/dockerfile:1
    FROM --platform=$BUILDPLATFORM golang:1.18 as build
    ARG TARGETOS TARGETARCH
    WORKDIR /opt/app
    COPY go.* ./
    RUN go mod download
    COPY . .
    RUN --mount=type=cache,target=/root/.cache/go-build \
    GOOS=$TARGETOS GOARCH=$TARGETARCH go build -o /opt/app/example .

    FROM ubuntu:latest
    WORKDIR /opt/app
    COPY --from=build /opt/app/example ./example
    CMD ["/opt/app/example"]
   ```
   第 2 行 FROM 基础镜像增加了一个 --platform=$BUILDPLATFORM 参数，它代表“强制使用不同平台的基础镜像”，例如 Linux/amd64。在没有该参数配置的情况下，Docker 默认会使用构建平台（本机）对应架构的基础镜像。第 3 行 ARG 声明了使用两个内置变量 TARGETOS 和 TARGETARCH，TARGETOS 代表系统，例如 Linux，TARGETARCH 则代表平台，例如 Amd64。这两个参数将会在 Golang 交叉编译时生成对应平台的二进制文件。
2）from 的基础镜像做成多架构，然后dockerfile正常写即可，构建的时候指定架构就行了（在不同的架构基础镜像去构建，构建完毕在copy出来）