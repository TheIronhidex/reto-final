pipeline {
    environment {
	REGION = 'eu-west-3'
    	DOCKER_REPO = 'theironhidex'
      }

 agent any
    tools {
       terraform 'terraform20803'
    }    
    stages {
        stage ("Build Image 1") {
            steps {
                sh "docker build -t ${env.DOCKER_REPO}/${JOB_BASE_NAME}-app:${BUILD_NUMBER} ."
            }
        }
        stage ("Publish Image 1") {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-hub-jose', passwordVariable: 'docker_pass', usernameVariable: 'docker_user')]) {
                    sh "docker login -u $docker_user -p $docker_pass"
                    sh "docker push ${env.DOCKER_REPO}/${JOB_BASE_NAME}-app:${BUILD_NUMBER}"
                }
            }
        }
        stage('terraform format check') {
            steps{
                dir("./terraform/") {sh 'terraform fmt'
                }
            }
        }	    
        stage('terraform Init') {
            steps{
                dir("./terraform/") {sh 'terraform init'
		}
            }
        }     
        stage('terraform apply') {
            steps{
	            withCredentials([
		            aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'aws-jose', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) { dir("./terraform/") {               
                sh """
		        terraform apply -var=\"region=${env.REGION}\" \
                -var=\"access_key=${AWS_ACCESS_KEY_ID}\" \
                -var=\"secret_key=${AWS_SECRET_ACCESS_KEY}\" \
                --auto-approve
                   """
		sh "terraform output > temp.txt"
		sh "sed -n '2,3p;4q' temp.txt >> inventory.ini"
		sh "cat inventory.ini"
	        sh "mv inventory.ini /var/lib/jenkins/workspace/jose/reto-final@2/ansible"	    
		        }
                    }   
	        }
	    }	    	    
	stage('Wait 30 seconds') {
            steps {
                sleep time:2, unit: 'SECONDS'
            }
        }
	stage ("Ansible install packages") {
            steps {dir("./ansible/") {
                ansiblePlaybook become: true, colorized: true, disableHostKeyChecking: true, credentialsId: 'jose-ssh', installation: 'ansible210', inventory: 'inventory.ini', playbook: 'playbook_install.yml'
            }
	  }	   
        }
	stage ("Ansible run image in instance 1") {
            steps {dir("./ansible/") {
                 ansiblePlaybook(
                    become: true,
                    colorized: true,
                    disableHostKeyChecking: true,
                    credentialsId: 'jose-ssh',
                    installation: 'ansible210',
                    inventory: 'inventory.ini',
                    playbook: 'playbook_run_1.yml',
                    extraVars: [
                        build_number: ${BUILD_NUMBER},
                        job_base_name: ${JOB_BASE_NAME}
                    ]
                )  
	    }	    
        }
    }		              
	stage ("Ansible run image in instance 2") {
            steps {dir("./ansible/") {
               withCredentials([usernamePassword(credentialsId: 'docker-hub-jose', passwordVariable: 'docker_pass', usernameVariable: 'docker_user')]) {
                 ansiblePlaybook(
                    become: true,
                    colorized: true,
                    disableHostKeyChecking: true,
                    credentialsId: 'jose-ssh',
                    installation: 'ansible210',
                    inventory: 'inventory.ini',
                    playbook: 'playbook_run_2.yml',
                    extraVars: [
                        user: ${docker_user},
                        pass: ${docker_pass},
			build_number: ${BUILD_NUMBER},
                        job_base_name: ${JOB_BASE_NAME}    
                    ]
                )
            }
	  }	    
        }
    }		    
    	stage('Destroy infrastructure?') {
            steps{
                input "Proceed destroying the infrastructure?"
            }
        }        	    
	stage('terraform destroy') {
            steps{dir("./terraform/") {
		withCredentials([
		    aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'aws-jose', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                    sh "terraform destroy --auto-approve"
		    }
	          }
	        }
	   }
	    
	    
    }
}
