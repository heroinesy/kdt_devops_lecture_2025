#!/bin/bash

# Hands-on 1: Istio Service Mesh - Istio 트래픽 관리 설정

echo "=== Istio 트래픽 관리 설정 시작 ==="
echo ""

# 1. Istio Gateway 생성
echo "1. Istio Gateway 생성 중..."
kubectl apply -f - <<EOF
apiVersion: networking.istio.io/v1beta1
kind: Gateway
metadata:
  name: app-gateway
spec:
  selector:
    istio: ingressgateway
  servers:
  - port:
      number: 80
      name: http
      protocol: HTTP
    hosts:
    - "*"
EOF
echo "   ✅ Gateway 생성 완료"

# 2. VirtualService 생성 (카나리 배포: v1 90%, v2 10%)
echo ""
echo "2. VirtualService 생성 중 (카나리 배포: v1 90%, v2 10%)..."
kubectl apply -f - <<EOF
apiVersion: networking.istio.io/v1beta1
kind: VirtualService
metadata:
  name: user-service
spec:
  hosts:
  - "*"
  gateways:
  - app-gateway
  http:
  - match:
    - uri:
        prefix: /users
    route:
    - destination:
        host: user-service
        subset: v1
      weight: 90
    - destination:
        host: user-service
        subset: v2
      weight: 10
EOF
echo "   ✅ VirtualService 생성 완료"

# 3. DestinationRule 생성 (버전별 subset 정의)
echo ""
echo "3. DestinationRule 생성 중..."
kubectl apply -f - <<EOF
apiVersion: networking.istio.io/v1beta1
kind: DestinationRule
metadata:
  name: user-service
spec:
  host: user-service
  subsets:
  - name: v1
    labels:
      version: v1
  - name: v2
    labels:
      version: v2
EOF
echo "   ✅ DestinationRule 생성 완료"

# 4. Product Service VirtualService
echo ""
echo "4. Product Service VirtualService 생성 중..."
kubectl apply -f - <<EOF
apiVersion: networking.istio.io/v1beta1
kind: VirtualService
metadata:
  name: product-service
spec:
  hosts:
  - "*"
  gateways:
  - app-gateway
  http:
  - match:
    - uri:
        prefix: /products
    route:
    - destination:
        host: product-service
EOF
echo "   ✅ Product Service VirtualService 생성 완료"

# 5. Order Service VirtualService
echo ""
echo "5. Order Service VirtualService 생성 중..."
kubectl apply -f - <<EOF
apiVersion: networking.istio.io/v1beta1
kind: VirtualService
metadata:
  name: order-service
spec:
  hosts:
  - "*"
  gateways:
  - app-gateway
  http:
  - match:
    - uri:
        prefix: /orders
    route:
    - destination:
        host: order-service
EOF
echo "   ✅ Order Service VirtualService 생성 완료"

# 6. 설정 확인
echo ""
echo "6. Istio 설정 확인 중..."
echo ""
echo "📋 Gateway:"
kubectl get gateway
echo ""
echo "📋 VirtualService:"
kubectl get virtualservice
echo ""
echo "📋 DestinationRule:"
kubectl get destinationrule

# 7. Istio Ingress Gateway 정보
echo ""
echo "7. Istio Ingress Gateway 정보..."
export INGRESS_PORT=$(kubectl get svc istio-ingressgateway -n istio-system -o jsonpath='{.spec.ports[?(@.name=="http2")].nodePort}')
echo "   Ingress Port: $INGRESS_PORT"

# 8. 카나리 배포 테스트
echo ""
echo "8. 카나리 배포 테스트 중 (10번 호출)..."
echo ""
for i in {1..10}; do
  echo -n "Request $i: "
  curl -s http://localhost:$INGRESS_PORT/users
  echo ""
done

echo ""
echo "=== Istio 트래픽 관리 설정 완료 ==="
echo ""
echo "📍 설정된 리소스:"
echo "   - Gateway: app-gateway"
echo "   - VirtualService: user-service (카나리 90:10)"
echo "   - VirtualService: product-service"
echo "   - VirtualService: order-service"
echo "   - DestinationRule: user-service (v1, v2 subset)"
echo ""
echo "💡 테스트 명령어:"
echo "   # 카나리 배포 확인 (100번 호출)"
echo "   for i in {1..100}; do curl -s http://localhost:$INGRESS_PORT/users; done | sort | uniq -c"
echo ""
echo "   # Product Service 테스트"
echo "   curl http://localhost:$INGRESS_PORT/products"
echo ""
echo "   # Order Service 테스트"
echo "   curl http://localhost:$INGRESS_PORT/orders"
