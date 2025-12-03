
pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                // Pull code from Git
                git branch: 'main', url: 'https://github.com/12ashok/maha'
            }
        }

        stage('Build JAR') {
            steps {
                // Run Maven build
                sh 'mvn clean package'
            }
        }

        stage('Build Docker Image') {
            steps {
                // Build Docker image using the Dockerfile
                sh 'docker build -t webpage:0.0.1 .'
            }
        }
        stage('cleanup all containers') {
            steps {
                // Remove all containers (running or stopped)
                sh '''
                   docker ps -aq | xargs -r docker rm -f
                '''
            }
        }

        stage('Run Docker Container') {
            steps {
                // Optional: run container for testing
                sh 'docker run -d -p 9090:8080 -e SPRING_PROFILES_ACTIVE=prod --name myapp-container webpage:0.0.1 --spring.profiles.active=default'
            }
        }
    }
}
