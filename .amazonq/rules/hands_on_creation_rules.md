# Hands-on 작성 규칙 (Hands-on Creation Rules)

## 📋 Hands-on 기본 원칙

### 🎯 Hands-on vs Lab 차이점
- **Lab**: 자동화 스크립트 제공 + 학습용 수동 명령어
- **Hands-on**: 학생들이 직접 코드를 보며 작성 (inline 코드)

### 📝 핵심 특징
1. **Inline 코드 작성**: 모든 YAML, 스크립트를 문서 내에 inline으로 제공
2. **직접 실습**: 학생들이 코드를 보고 직접 타이핑하거나 복사하여 실행
3. **학습 중심**: 코드를 읽고 이해하면서 실습 진행
4. **스크립트 최소화**: 별도 스크립트 파일 없이 문서 내 명령어로 완결

---

## 📁 파일 구조

### Hands-on 디렉토리 구조
```
theory/week_XX/dayX/
├── lab_1.md                    # 기본 Lab (스크립트 제공)
├── hands_on_1.md               # 심화 Hands-on (inline 코드)
└── lab_scripts/
    └── lab1/                   # Lab 1 스크립트만 존재
        ├── step1-xxx.sh
        ├── step2-xxx.sh
        └── ...
```

**중요**: Hands-on은 `lab_scripts/hands_on1/` 폴더를 생성하지 않음

---

## 📝 Hands-on 문서 구조

### 기본 템플릿
```markdown
# Week X Day X Hands-on 1: [제목]

<div align="center">
**🔧 고급 기능 1** • **🔧 고급 기능 2** • **🔧 고급 기능 3**
*Lab을 기반으로 고급 기능 추가*
</div>

---

## 🕘 실습 정보
**시간**: HH:MM-HH:MM (50분)
**목표**: Lab 확장 및 고급 기능 구현
**방식**: 직접 코드 작성 및 실행

## 🎯 실습 목표
### 📚 학습 목표
- Lab보다 심화된 내용
- 실무 최적화 기법

### 🛠️ 구현 목표
- 프로덕션급 기능
- 성능 최적화

---

## 🏗️ 전체 아키텍처
[Mermaid 다이어그램]

---

## 🛠️ Step 1: [단계명] (시간)

### 📝 직접 작성하기

**1-1. YAML 파일 생성**
```bash
cat <<EOF > resource.yaml
apiVersion: v1
kind: Pod
metadata:
  name: example
spec:
  containers:
  - name: app
    image: nginx:alpine
EOF
```

**1-2. 리소스 적용**
```bash
kubectl apply -f resource.yaml
```

**1-3. 상태 확인**
```bash
kubectl get pods
```

### 📊 예상 결과
```
NAME      READY   STATUS    RESTARTS   AGE
example   1/1     Running   0          10s
```

### 💡 코드 설명
- `apiVersion: v1`: Kubernetes API 버전
- `kind: Pod`: 리소스 타입
- `metadata.name`: Pod 이름
- `spec.containers`: 컨테이너 정의

---

## ✅ 실습 체크포인트
### ✅ Step 1: [단계명]
- [ ] YAML 파일 생성 완료
- [ ] 리소스 적용 성공
- [ ] 상태 확인 완료

---

## 🔍 트러블슈팅
[문제 상황 및 해결 방법]

---

## 🧹 실습 정리
```bash
kubectl delete -f resource.yaml
```

---

## 💡 실습 회고
### 🤝 페어 회고 (5분)
1. 직접 코드를 작성하면서 어려웠던 점은?
2. Lab과 비교하여 더 깊이 이해한 부분은?

### 📊 학습 성과
- 코드 이해도 향상
- 실무 적용 능력 강화
```

---

## 🎯 Step 작성 규칙

### Step 구조 표준
```markdown
## 🛠️ Step X: [단계명] (시간)

### 📝 직접 작성하기

**X-1. [세부 작업 1]**
```bash
# 명령어 또는 스크립트
cat <<EOF > file.yaml
[YAML 내용 전체를 inline으로]
EOF
```

**X-2. [세부 작업 2]**
```bash
kubectl apply -f file.yaml
```

**X-3. [검증]**
```bash
kubectl get [resource]
```

### 📊 예상 결과
```
[예상 출력]
```

### 💡 코드 설명
- **라인별 설명**: 중요한 설정 항목 설명
- **개념 연결**: 이론과 실습 연결
- **실무 팁**: 프로덕션 환경 고려사항
```

---

## 📋 필수 포함 요소

### 모든 Step에 포함
1. **📝 직접 작성하기**: 코드를 직접 작성하는 섹션
2. **Inline 코드**: 모든 YAML, 스크립트를 문서 내에 포함
3. **📊 예상 결과**: 실행 결과 예시
4. **💡 코드 설명**: 코드의 의미와 목적 설명
5. **✅ 체크포인트**: 단계별 확인 사항

### 추가 권장 요소
- **🔍 트러블슈팅**: 예상 문제 및 해결 방법
- **💡 실무 팁**: 프로덕션 환경 적용 시 고려사항
- **🎯 심화 학습**: 추가로 학습할 내용

---

## 🎨 코드 작성 스타일

### Inline YAML 작성 방법
```bash
# cat <<EOF 사용 (heredoc)
cat <<EOF > deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app
  namespace: default
spec:
  replicas: 3
  selector:
    matchLabels:
      app: my-app
  template:
    metadata:
      labels:
        app: my-app
    spec:
      containers:
      - name: app
        image: nginx:alpine
        ports:
        - containerPort: 80
EOF
```

### 복잡한 설정 파일
```bash
# 여러 리소스를 하나의 파일로
cat <<EOF > resources.yaml
---
apiVersion: v1
kind: Service
metadata:
  name: my-service
spec:
  selector:
    app: my-app
  ports:
  - port: 80
    targetPort: 80
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app
spec:
  replicas: 3
  # ... 중략 ...
EOF
```

### 스크립트 inline 작성
```bash
# 복잡한 로직도 inline으로
cat <<'SCRIPT' > setup.sh
#!/bin/bash
set -e

echo "=== 설정 시작 ==="

# 1. 네임스페이스 생성
kubectl create namespace my-app

# 2. 리소스 배포
kubectl apply -f resources.yaml -n my-app

# 3. 상태 확인
kubectl wait --for=condition=ready pod -l app=my-app -n my-app --timeout=60s

echo "=== 설정 완료 ==="
SCRIPT

chmod +x setup.sh
./setup.sh
```

---

## 🔄 Lab vs Hands-on 비교

### Lab 1 (기본 실습)
```markdown
## 🛠️ Step 1: 환경 설정 (10분)

### 🚀 자동화 스크립트 사용
```bash
./step1-setup.sh
```

**📋 스크립트 내용**: [step1-setup.sh](./lab_scripts/lab1/step1-setup.sh)

**1-1. 수동 실행 (학습용)**
```bash
kubectl create namespace my-app
kubectl apply -f deployment.yaml
```
```

### Hands-on 1 (심화 실습)
```markdown
## 🛠️ Step 1: 환경 설정 (10분)

### 📝 직접 작성하기

**1-1. 네임스페이스 생성**
```bash
kubectl create namespace my-app
```

**1-2. Deployment YAML 작성**
```bash
cat <<EOF > deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app
  namespace: my-app
spec:
  replicas: 3
  selector:
    matchLabels:
      app: my-app
  template:
    metadata:
      labels:
        app: my-app
    spec:
      containers:
      - name: app
        image: nginx:alpine
        ports:
        - containerPort: 80
        resources:
          requests:
            cpu: 100m
            memory: 128Mi
          limits:
            cpu: 500m
            memory: 512Mi
EOF
```

**1-3. 리소스 적용**
```bash
kubectl apply -f deployment.yaml
```

**1-4. 상태 확인**
```bash
kubectl get pods -n my-app
kubectl describe deployment my-app -n my-app
```

### 💡 코드 설명
- **replicas: 3**: 고가용성을 위한 3개 복제본
- **resources**: 리소스 요청 및 제한으로 안정성 확보
- **labels**: 서비스 연결을 위한 라벨 설정
```

---

## ✅ Hands-on 작성 체크리스트

### 필수 확인 사항
- [ ] **Inline 코드**: 모든 YAML/스크립트가 문서 내에 포함
- [ ] **직접 작성**: 학생이 코드를 보고 직접 작성 가능
- [ ] **코드 설명**: 각 코드 블록마다 설명 포함
- [ ] **예상 결과**: 실행 결과 예시 제공
- [ ] **체크포인트**: 단계별 확인 사항
- [ ] **트러블슈팅**: 예상 문제 및 해결 방법

### 품질 기준
- [ ] **완전성**: 문서만으로 실습 완료 가능
- [ ] **명확성**: 코드와 설명이 명확하고 이해하기 쉬움
- [ ] **실용성**: 실무에서 사용 가능한 코드
- [ ] **학습 효과**: Lab보다 깊이 있는 학습 가능

---

## 🎯 작성 예시

### Week 4 Day 3 Hands-on 1 구조
```
hands_on_1.md
├── 전체 아키텍처 (Mermaid)
├── Step 1: OPA Gatekeeper 설치 (10분)
│   ├── 📝 직접 작성하기
│   │   ├── Gatekeeper YAML 생성 (inline)
│   │   ├── 리소스 적용
│   │   └── 상태 확인
│   ├── 📊 예상 결과
│   └── 💡 코드 설명
├── Step 2: ConstraintTemplate 작성 (15분)
│   ├── 📝 직접 작성하기
│   │   ├── Template YAML 생성 (inline)
│   │   ├── Rego 정책 작성
│   │   └── 적용 및 검증
│   ├── 📊 예상 결과
│   └── 💡 코드 설명
├── Step 3: Constraint 적용 (15분)
├── Step 4: 정책 테스트 (10분)
├── ✅ 실습 체크포인트
├── 🔍 트러블슈팅
└── 💡 실습 회고
```

---

## 📊 시간 배분 표준

### Hands-on (50분)
- Step 1-3: 각 10-15분 (직접 코드 작성)
- Step 4: 10분 (테스트 및 검증)
- 회고: 5분

### 각 Step 내부 시간
- 코드 작성: 60% (직접 타이핑 또는 복사)
- 실행 및 확인: 30%
- 설명 읽기: 10%

---

## 💡 작성 팁

### 학생 관점에서 작성
- "이 코드를 직접 작성해보세요"
- "각 라인의 의미를 이해하면서 작성하세요"
- "실행 결과를 확인하고 예상과 비교하세요"

### 코드 설명 작성
- 중요한 설정 항목 강조
- 실무에서의 의미 설명
- 다른 옵션이나 대안 제시

### 실습 난이도 조절
- Lab보다 15-20% 더 복잡한 내용
- 새로운 개념이나 고급 기능 추가
- 실무 시나리오 기반 문제 해결

---

<div align="center">

**📝 직접 작성** • **💡 깊이 있는 학습** • **🔧 실무 연계** • **🎯 고급 기능**

*Hands-on을 통한 실전 역량 강화*

</div>
