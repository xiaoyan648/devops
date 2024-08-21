1. 为 FluxCD 创建仓库连接信息，定时检查代码库，如果git仓库有更新会重新拉取并打包镜像；kubectl apply -f fluxcd-repo.yaml
2. 为 FluxCD 创建部署策略, 定时检查镜像内的仓库指定部署文件是否有变化，有就重新部署: kubectl apply -f fluxcd-kustomize.yaml



参考：
https://www.cnblogs.com/moonlight-lin/p/17922642.html#%E5%88%9B%E5%BB%BA-gitrepository