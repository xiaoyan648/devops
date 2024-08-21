#!/bin/bash

# 设置阈值
THRESHOLD_CPU=80
THRESHOLD_MEM=80

# 获取 Kubernetes 集群中所有节点的 Pod 列表及其 CPU/Memory 使用情况
PODS=$(kubectl top pods --all-namespaces --no-headers | awk '{print $1, $2, $3, $4, $5}')

# 遍历每个 Pod
while read -r namespace pod_name cpu_usage mem_usage; do
    # 计算百分比
    cpu_percent=$(echo "$cpu_usage" | awk '{printf "%d", $1}')
    mem_percent=$(echo "$mem_usage" | awk '{printf "%d", $1}')

    # 检查是否超过了阈值
    if [[ $cpu_percent -gt $THRESHOLD_CPU ]] || [[ $mem_percent -gt $THRESHOLD_MEM ]]; then
        echo "High usage detected for Pod: $pod_name in Namespace: $namespace"
        echo "CPU Usage: $cpu_percent%, Memory Usage: $mem_percent%"

        # 假设目标应用暴露了一个 pprof 端点，例如 http://<pod-ip>:6060/debug/pprof/profile
        # 你可以通过 kubectl port-forward 来获取 Pod 的 IP 地址或者直接使用 Pod 名称
        # 这里我们假设 Pod 的 pprof 端口为 6060
        POD_IP=$(kubectl get pod $pod_name -n $namespace -o jsonpath='{.status.podIP}')
        pprof_url="http://${POD_IP}:6060/debug/pprof/profile"

        # 使用 curl 下载 pprof 数据
        curl -sSL $pprof_url > profile.pprof

        # 使用 pprof 工具分析数据
        go tool pprof --text profile.pprof
    fi
done <<< "$PODS"