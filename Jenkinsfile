pipeline {
    agent any 

    environment {
        // Define the Jenkins build ID as a build variable
        BUILD_ID = "${env.BUILD_ID}"
    }

    stages {
        stage('Stage 01 - Clean the Workspace') {
            steps {
                cleanWs() 
            }
        }
        stage('Stage 02 - Clone the code') {
            steps {
                git branch: 'main', url: 'https://github.com/amitkumar0441/jenkins-ansible-dockerhostproject.git'
            }
        }
        stage('Stage 03 - Transfer files to ansible server and create the docker image') {
            steps {
                sshagent(['ansible_server']) {
                    script {
                        // Create the directory on the Ansible server
                        sh "ssh root@192.168.126.129 'mkdir -p /home/ansible/datafromjenkinserver'"

                        // Copy all files from Jenkins workspace to the Ansible server
                        sh "scp -r * root@192.168.126.129:/home/ansible/datafromjenkinserver/"

                        // Build the Docker image using the transferred files (directly on Ansible server)
                        sh """
                            ssh root@192.168.126.129 '
                                cd /home/ansible/datafromjenkinserver &&
                                docker build -t amitkumar0441/jenkins-ansible-docker:${BUILD_ID} .'
                        """
                    }
                }
            }
        }
    }
}

