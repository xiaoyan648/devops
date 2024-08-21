## 自动恢复
1. 创建一个 deplyment
   ```shell
   kubectl create deployment hello-world-flask --image=lyzhang1999/hello-world-flask:latest --replicas=2 

   # 可以通过 --dry-run=client 取消运行 通过 -o yaml 可以查看生成的 yaml
   # kubectl create deployment hello-world-flask --image lyzhang1999/hello-world-flask:latest --replicas=2 --dry-run=client -o yaml
   ```
2. 创建 sevice
   ```shell
   kubectl create service clusterip hello-world-flask --tcp=5000:5000
   ```
3. 创建 ingress controller and ingress
   ```shell
   kubectl create -f https://ghproxy.com/https://raw.githubusercontent.com/lyzhang1999/resource/main/ingress-nginx/ingress-nginx.yaml
   ```
   
   ```shell
   kubectl create ingress hello-world-flask --rule="/=hello-world-flask:5000"
   ```
   
4.  访问测试
    ```shell
    while true; do sleep 1; curl http://127.0.0.1; echo -e '\n'$(date);done
    ```
5.  模拟宕机, 查看访问情况
    ```shell
    kubectl exec -it hello-world-flask-56fbff68c8-2xz7w -- bash -c "killall python3"
    ```

## 自动扩缩容
1.  自动扩容依赖于 K8s Metric Server 提供的监控指标,安装：
    ```shell
    kubectl apply -f https://ghproxy.com/https://raw.githubusercontent.com/lyzhang1999/resource/main/metrics/metrics.yaml
    ```
2.  等待安装就绪 kubectl wait deployment -n kube-system metrics-server --for condition=Available=True --timeout=90s
   
3.  创建自动扩缩容策略
    ```shell
    kubectl autoscale deployment hello-world-flask --cpu-percent=50 --min=2 --max=10
    ```
    > 这其中，–cpu-percent 表示 CPU 使用率阈值，当 CPU 超过 50% 时将进行自动扩容，–min 代表最小的 Pod 副本数，–max 代表最大扩容的副本数。也就是说，自动扩容会根据 CPU 的使用率在 2 个副本和 10 个副本之间进行扩缩容。

4. 设置 deplyment 资源配额
    ```shell
    $ kubectl patch deployment hello-world-flask --type='json' -p='[{"op": "add", "path": "/spec/template/spec/containers/0/resources", "value": {"requests": {"memory": "100Mi", "cpu": "100m"}}}]'
    ```
5. 并发压测，查看扩容情况
   ```shell
   ab -c 50 -n 10000 http://127.0.0.1/
   ```