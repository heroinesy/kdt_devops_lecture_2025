#!/bin/bash
# Week 4 Day 5 Hands-on 1: kube-state-metrics 설치
set -e
echo "=== kube-state-metrics 설치 시작 ==="
kubectl apply -f - <<EOF
apiVersion: v1
kind: ServiceAccount
metadata:
  name: kube-state-metrics
  namespace: monitoring
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: kube-state-metrics
rules:
- apiGroups: [""]
  resources: [configmaps, secrets, nodes, pods, services, resourcequotas, replicationcontrollers, limitranges, persistentvolumeclaims, persistentvolumes, namespaces, endpoints]
  verbs: [list, watch]
- apiGroups: [apps]
  resources: [statefulsets, daemonsets, deployments, replicasets]
  verbs: [list, watch]
- apiGroups: [batch]
  resources: [cronjobs, jobs]
  verbs: [list, watch]
- apiGroups: [autoscaling]
  resources: [horizontalpodautoscalers]
  verbs: [list, watch]
- apiGroups: [storage.k8s.io]
  resources: [storageclasses]
  verbs: [list, watch]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: kube-state-metrics
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: kube-state-metrics
subjects:
- kind: ServiceAccount
  name: kube-state-metrics
  namespace: monitoring
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: kube-state-metrics
  namespace: monitoring
spec:
  replicas: 1
  selector:
    matchLabels:
      app: kube-state-metrics
  template:
    metadata:
      labels:
        app: kube-state-metrics
      annotations:
        prometheus.io/scrape: "true"
        prometheus.io/port: "8080"
    spec:
      serviceAccountName: kube-state-metrics
      containers:
      - name: kube-state-metrics
        image: registry.k8s.io/kube-state-metrics/kube-state-metrics:v2.10.0
        ports:
        - containerPort: 8080
---
apiVersion: v1
kind: Service
metadata:
  name: kube-state-metrics
  namespace: monitoring
spec:
  selector:
    app: kube-state-metrics
  ports:
  - port: 8080
    targetPort: 8080
EOF
kubectl wait --for=condition=ready pod -l app=kube-state-metrics -n monitoring --timeout=120s
echo "=== kube-state-metrics 설치 완료 ==="
