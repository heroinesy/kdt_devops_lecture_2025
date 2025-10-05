#!/bin/bash

# Week 3 Day 5 Lab 1: 테스트 애플리케이션 배포
# 사용법: ./03-deploy-app.sh

set -e

echo "=== 테스트 애플리케이션 배포 시작 ==="
echo ""

# 임시 디렉토리 생성
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"

# Deployment 생성
echo "1. Deployment 생성 중..."
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-app
  namespace: default
  labels:
    app: web-app
spec:
  replicas: 2
  selector:
    matchLabels:
      app: web-app
  template:
    metadata:
      labels:
        app: web-app
    spec:
      containers:
      - name: web-app
        image: nginx:1.21
        ports:
        - containerPort: 80
          name: http
        resources:
          requests:
            cpu: 100m
            memory: 128Mi
          limits:
            cpu: 500m
            memory: 512Mi
EOF

echo "✅ Deployment 생성 완료"

# Service 생성
echo ""
echo "2. Service 생성 중..."
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Service
metadata:
  name: web-app
  namespace: default
  labels:
    app: web-app
spec:
  selector:
    app: web-app
  ports:
  - port: 80
    targetPort: 80
    name: http
  type: ClusterIP
EOF

echo "✅ Service 생성 완료"

# ServiceMonitor 생성
echo ""
echo "3. ServiceMonitor 생성 중..."
cat <<EOF | kubectl apply -f -
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: web-app
  namespace: default
  labels:
    app: web-app
spec:
  selector:
    matchLabels:
      app: web-app
  endpoints:
  - port: http
    interval: 30s
    path: /metrics
EOF

echo "✅ ServiceMonitor 생성 완료"

# 배포 확인
echo ""
echo "4. 배포 상태 확인 중..."
echo ""

echo "🔍 Pod 상태:"
kubectl get pods -l app=web-app

echo ""
echo "🌐 Service 상태:"
kubectl get svc web-app

echo ""
echo "📊 ServiceMonitor 상태:"
kubectl get servicemonitor web-app

echo ""
echo "=== 배포 완료 ==="
echo ""
echo "💡 애플리케이션 접속:"
echo "   kubectl port-forward svc/web-app 8080:80"
echo "   http://localhost:8080"

# 임시 디렉토리 정리
cd - > /dev/null
rm -rf "$TEMP_DIR"
