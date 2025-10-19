#!/bin/bash

# Lab 1 환경 준비 스크립트

echo "=== Istio Service Mesh Lab 환경 준비 시작 ==="
echo ""

# 1. 기존 클러스터 확인 및 삭제
echo "1. 기존 클러스터 확인 중..."
if kind get clusters | grep -q "lab-cluster"; then
    echo "   ⚠️  기존 lab-cluster 클러스터 발견"
    echo "   🗑️  기존 클러스터 삭제 중..."
    kind delete cluster --name lab-cluster
    echo "   ✅ 기존 클러스터 삭제 완료"
fi

# 2. Kind 클러스터 생성 (Istio Ingress Gateway 포트 매핑)
echo ""
echo "2. Kind 클러스터 생성 중 (포트 80 매핑)..."
cat <<YAML | kind create cluster --name lab-cluster --config=-
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  extraPortMappings:
  - containerPort: 30080
    hostPort: 80
    protocol: TCP
YAML

echo "   ✅ 클러스터 생성 완료"

# 3. kubectl 컨텍스트 설정
echo ""
echo "3. kubectl 컨텍스트 설정 중..."
kubectl config use-context kind-lab-cluster
echo "   ✅ 컨텍스트 설정 완료"

# 4. 클러스터 상태 확인
echo ""
echo "4. 클러스터 상태 확인 중..."
kubectl cluster-info
kubectl get nodes

echo ""
echo "=== 환경 준비 완료 ==="
echo ""
echo "작업 디렉토리: $(pwd)"
echo "Kubernetes Context: $(kubectl config current-context)"
echo ""
echo "다음 단계: ./step2-install-istio.sh"
