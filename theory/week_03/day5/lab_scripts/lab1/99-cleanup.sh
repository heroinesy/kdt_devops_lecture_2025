#!/bin/bash

# Week 3 Day 5 Lab 1: 정리 스크립트
# 사용법: ./99-cleanup.sh

set -e

NAMESPACE="day5-lab"
CLUSTER_NAME="challenge-cluster"

echo "╔════════════════════════════════════════════════════════════╗"
echo "║  Week 3 Day 5 Lab 1: 환경 정리                           ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""
echo "⚠️  다음 작업이 수행됩니다:"
echo "   1. 포트포워딩 중지"
echo "   2. kind 클러스터 완전 삭제"
echo "   3. 모든 리소스 정리"
echo ""

read -p "정말 삭제하시겠습니까? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "정리가 취소되었습니다."
    exit 1
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "1. 포트포워딩 중지"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# 포트포워딩 중지 스크립트 실행
if [ -f "./07-stop-portforward.sh" ]; then
    ./07-stop-portforward.sh
else
    # 수동으로 포트포워딩 프로세스 종료
    pkill -f "port-forward.*monitoring" 2>/dev/null || true
    pkill -f "port-forward.*argocd" 2>/dev/null || true
    pkill -f "port-forward.*day5-lab" 2>/dev/null || true
    echo "✅ 포트포워딩 중지 완료"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "2. kind 클러스터 삭제"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if command -v kind &> /dev/null; then
    if kind get clusters 2>/dev/null | grep -q "^${CLUSTER_NAME}$"; then
        echo "kind 클러스터 '$CLUSTER_NAME' 삭제 중..."
        kind delete cluster --name $CLUSTER_NAME
        echo "✅ kind 클러스터 삭제 완료"
    else
        echo "ℹ️  kind 클러스터 '$CLUSTER_NAME'가 존재하지 않습니다."
    fi
else
    echo "ℹ️  kind가 설치되어 있지 않습니다."
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "3. 임시 파일 정리"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# 포트포워딩 PID 디렉토리 삭제
if [ -d "/tmp/day5-lab-portforward" ]; then
    rm -rf /tmp/day5-lab-portforward
    echo "✅ 임시 파일 정리 완료"
fi

echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║  🎉 정리 완료!                                            ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""
echo "✅ 삭제된 리소스:"
echo "   - 포트포워딩 프로세스"
echo "   - kind 클러스터 ($CLUSTER_NAME)"
echo "   - 모든 Kubernetes 리소스"
echo ""
echo "💡 새로 시작하려면:"
echo "   ./00-install-all.sh"

echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║  🎉 정리 완료!                                            ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""
echo "✅ 삭제된 리소스:"
echo "   - 포트포워딩 프로세스"
echo "   - kind 클러스터 ($CLUSTER_NAME)"
echo "   - 모든 Kubernetes 리소스"
echo ""
echo "💡 새로 시작하려면:"
echo "   ./00-install-all.sh"
