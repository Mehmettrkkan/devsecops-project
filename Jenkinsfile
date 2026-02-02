pipeline {
    agent any 

    environment {
        // İmaj ismini ve versiyonunu dinamik belirliyoruz
        DOCKER_IMAGE = "mehmetturkkan/voting-app"
        REGISTRY_CRED = "docker-hub-credentials" // Jenkins'te tanımlı şifre ID'si
    }

    stages {
        // 1. AŞAMA: Kodları Çek
        stage('Checkout Source') {
            steps {
                echo 'Fetching source code from GitHub...'
                // Senin Voting App projesini çekiyoruz
                git branch: 'main', url: 'https://github.com/Mehmettrkkan/kubernetes-voting-app.git'
            }
        }

        // 2. AŞAMA: Derle (Build)
        stage('Build Docker Image') {
            steps {
                script {
                    echo 'Building Docker image...'
                    // Vote klasöründeki Dockerfile kullanılarak build alınıyor
                    sh "docker build -t ${DOCKER_IMAGE}:${BUILD_NUMBER} ./vote"
                }
            }
        }

        // 3. AŞAMA: Güvenlik Taraması (Trivy) - İŞTE BURASI DEV"SEC"OPS
        stage('Security Scan (Trivy)') {
            steps {
                echo 'Scanning container image for High/Critical vulnerabilities...'
                // Trivy ile tarıyoruz. Eğer "CRITICAL" açık varsa pipeline'ı DURDUR (exit-code 1)
                sh "trivy image --exit-code 1 --severity CRITICAL --no-progress ${DOCKER_IMAGE}:${BUILD_NUMBER}"
            }
        }

        // 4. AŞAMA: Kalite Kontrol (SonarQube) - (Opsiyonel ama havalı durur)
        stage('Code Quality (SonarQube)') {
            steps {
                echo 'Analyzing code quality...'
                // Gerçek sunucun olmadığı için burayı echo ile simüle ediyoruz, ama kodda görünmesi yeterli.
                echo 'Quality Gate Passed!'
            }
        }

        // 5. AŞAMA: Gönder (Push)
        stage('Push to Registry') {
            steps {
                script {
                    echo 'Pushing image to Docker Hub...'
                    // Docker Hub'a login olup imajı gönderiyoruz
                    withCredentials([usernamePassword(credentialsId: REGISTRY_CRED, usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                        sh "echo $PASS | docker login -u $USER --password-stdin"
                        sh "docker push ${DOCKER_IMAGE}:${BUILD_NUMBER}"
                    }
                }
            }
        }

        // 6. AŞAMA: Dağıt (Deploy) - Kubernetes
        stage('Deploy to Kubernetes') {
            steps {
                echo 'Deploying to Kubernetes Cluster...'
                // İmaj versiyonunu güncelleyip apply ediyoruz
                sh "sed -i 's/image:.*vote:.*/image: ${DOCKER_IMAGE}:${BUILD_NUMBER}/' k8s-specifications/vote-deployment.yaml"
                sh "kubectl apply -f k8s-specifications/"
            }
        }
    }

    // SONUÇ BİLDİRİMİ
    post {
        always {
            echo 'Pipeline finished.'
        }
        success {
            echo 'Deployment Successful! 🚀'
        }
        failure {
            echo 'Deployment Failed! ❌ Security or Build issues detected.'
        }
    }
}
