// setup guide:
// step 1: build the Jenkins Docker container
// step 2: run this command to mount the local directory to the existing Docker volume: docker run -d --name jenkins-test-with-mount -p 8080:8080 -p 50000:50000 -v 'mnt/c/Users/{$USER}/{$path-to-project}:/var/Project-Paleo-Maiden' -v jenkins-data:/var/jenkins_home jenkins/jenkins:lts

pipeline {
    agent {
        docker { image 'jupyter-agent'}
    }
    stages {
    stage('build-docs') {
        steps {
        echo "build-docs start"
        }
    }

    }
}
