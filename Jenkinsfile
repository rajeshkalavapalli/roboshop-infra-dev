pipeline {
    agent {
        node {
            label 'AGENT'
        }
    }
    options {
        ansiColor('xterm')
        // timeout(time: 1, unit: 'HOURS')
        // disableConcurrentBuilds()
    }
    
    // build
    stages {
        stage('vpc') {
            steps {
                sh """
                    cd 01-vpc
                    terraform init -reconfigure
                    terraform destroy -auto-approve
                    
                """
            }
        }
        stage('SG') {
            steps {
                sh """
                    cd 02-sg
                    terraform init -reconfigure
                    terraform destroy -auto-approve
                """
            }
        }
        stage('vpn') {
            steps {
                sh """
                    cd 03-vpn
                    terraform init -reconfigure
                    terraform destroy -auto-approve
                """
            }
        }
        stage('Db alb') {
            parallel {
                stage('DB') {
                    steps {
                        sh """
                            cd 04-database
                            terraform init -reconfigure
                            terraform destroy -auto-approve
                        """
                    }
                }
                stage('app alb') {
                    steps {
                        sh """
                            cd 05-app-alb
                            terraform init -reconfigure
                            terraform destroy -auto-approve
                        """
                    }
                }
            }
        }
        
        
    }
    // post build
    post { 
        always { 
            echo 'I will always say Hello again!'
        }
        failure { 
            echo 'this runs when pipeline is failed, used generally to send some alerts'
        }
        success{
            echo 'I will say Hello when pipeline is success'
        }
    }
}