pipeline {
    agent any 

    stages {
        stage('Stage 01 - Clean the Workspace') {
            steps {
                cleanWs() 
            }
        }

        stage('Stage 02 - Clone the Code') {
            steps {
                git branch: 'main', url: 'https://github.com/amitkumar0441/jenkins-ansible-dockerhostproject.git'
            }
        }

        stage('Stage 03 - Transfer Files & Build Docker Image') {
            steps {
                sshagent(['ansible_server']) {
                    script {
                        // Create directory on Ansible server
                        sh "ssh root@192.168.126.129 'mkdir -p /home/ansible/datafromjenkinserver'"

                        // Copy files from Jenkins workspace to Ansible server, excluding Jenkinsfile
                        sh "rsync -av --exclude='Jenkinsfile' ./ root@192.168.126.129:/home/ansible/datafromjenkinserver/"

                        // Build the Docker image on the Ansible server
                        sh """
                            ssh root@192.168.126.129 '
                                cd /home/ansible/datafromjenkinserver &&
                                docker build -t amitkumar0441/jenkins-ansible-docker:${BUILD_ID} .
                            '
                        """
                    }
                }
            }
        }

        stage('Stage 04 - Push Docker Image to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockercredentials', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                    sshagent(['ansible_server']) {
                        script {
                            // Corrected multi-line SSH command with docker rmi added
                            sh """
                                ssh root@192.168.126.129 "
                                    docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD &&
                                    docker push amitkumar0441/jenkins-ansible-docker:${BUILD_ID} &&
                                    docker rmi amitkumar0441/jenkins-ansible-docker:${BUILD_ID}
                                "
                            """
                        }
                    }
                }
            }
        }
    }
}
