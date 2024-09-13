## 环境配置
$ kubectl apply -f https://storage.googleapis.com/tekton-releases/pipeline/latest/release.yaml
namespace/tekton-pipelines created
podsecuritypolicy.policy/tekton-pipelines created
......

$ kubectl apply -f https://storage.googleapis.com/tekton-releases/dashboard/latest/release.yaml
serviceaccount/tekton-dashboard created
role.rbac.authorization.k8s.io/tekton-dashboard-info created
......

$ kubectl apply -f https://storage.googleapis.com/tekton-releases/triggers/latest/release.yaml
podsecuritypolicy.policy/tekton-triggers created
clusterrole.rbac.authorization.k8s.io/tekton-triggers-admin created
......

$ kubectl apply -f https://storage.googleapis.com/tekton-releases/triggers/latest/interceptors.yaml
deployment.apps/tekton-triggers-core-interceptors created
service/tekton-triggers-core-interceptors created
......

$ kubectl wait --for=condition=Ready pods --all -n tekton-pipelines --timeout=300s
pod/tekton-dashboard-5d94c7f687-8t6p2 condition met
pod/tekton-pipelines-controller-799f9f989b-hxmlx condition met
pod/tekton-pipelines-webhook-556f9f7476-sgx2n condition met
pod/tekton-triggers-controller-bffdd47cf-cw7sv condition met
pod/tekton-triggers-core-interceptors-5485b8bd66-n9n2m condition met
pod/tekton-triggers-webhook-79ddd8d6c9-f79tg condition met


$ kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.4.0/deploy/static/provider/cloud/deploy.yaml
namespace/ingress-nginx created
serviceaccount/ingress-nginx created
serviceaccount/ingress-nginx-admission created
......

$ kb apply -f ci/autobuild/tekton/quickstart/tekton-ingress.yaml

## 任务创建
$ kubectl apply -f https://raw.githubusercontent.com/lyzhang1999/gitops/main/ci/18/tekton/task/git-clone.yaml

$ kubectl apply -f https://raw.githubusercontent.com/lyzhang1999/gitops/main/ci/18/tekton/task/docker-build.yaml

$ kubectl apply -f https://raw.githubusercontent.com/lyzhang1999/gitops/main/ci/18/tekton/pipeline/pipeline.yaml

$ kubectl apply -f https://raw.githubusercontent.com/lyzhang1999/gitops/main/ci/18/tekton/trigger/github-event-listener.yaml

kubectl apply -f https://raw.githubusercontent.com/lyzhang1999/gitops/main/ci/18/tekton/trigger/github-trigger-template.yaml


kubectl apply -f https://raw.githubusercontent.com/lyzhang1999/gitops/main/ci/18/tekton/other/service-account.yaml
