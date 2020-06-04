pipeline {
    // Suppose you have added some Jenkins slaves with this label
    agent { node { label 'ansible-terra' } }

    environment {
        Terraform_repo_URL = "https://github.com/some-terra-repo.git"
        Ansible_repo_URL = "https://github.com/some-ansible-repo.git"
        SLACK_TEAM_DOMAIN = ""
        SLACK_TOKEN = ""
        SLACK_CHANNEL = ""
        SMTP = ""
        VERSION = ""
        BUILD = ""
        NAMESPACE = ""
    }
        // Skip this if you have everything under one repo
        stages {
            stage("Pull Some Terraform Repo for EC2 Node Provision") {
                steps {
                    git credentialsId: '16c74e***', url: 'https://github.com/some-terra-repo.git'
                }
        }

        stages {
                stage("Build Amazon AMIs with Packer") {
                    steps {
                        sh "packer build --machine-readable packer.json >> some_file.info"
                        sh "echo "ami_id = "$(cat some_file.info | awk -F ap-south-1: '{print $2}'"" >> /terraform.tfvars"
                    }
                }

        stages {
             stage("Build & Push Docker Images for Cassandra + Rails") {
                  dir('/build_images') steps {
                      sh "docker login dtr.truecaller.org"
                      sh "docker build -t dtr.truecaller.org/ruby_on_rails ."
                      sh "docker push dtr.truecaller.org/ruby_on_rails:$VERSION"
                         }
              }

        // Skip this stage if you have physical machines with ips
        stage("Provision EC2 Nodes for K8s") {
            steps {
                dir('/terraform') {
                    sh "terraform apply --auto-approve"
                    sh "terraform output instance_ips > some_ip.file"
                    sh "export master_ip=$(terraform output -json instance_ips | jq '.value[0]')"
                    sh "export node1_ip=$(terraform output -json instance_ips | jq '.value[1]')"
                    sh "export node2_ip=$(terraform output -json instance_ips | jq '.value[2]')"
                    //Optional if you create a lb now itself & attach it later to pods.
                    //U can Skip this if you are ready to dynamically create & assign lbs inside K8s.
                    sh "export loadb_ip=$(terraform output lb_address)"
                }
            }
        }

        stage("Pull an ansible repo to setup/install K8s") {
            steps {
        // I have used a public ansible repo to setup standalone K8s. You can modify & make it private
                git 'https://github.com/kubernetes-sigs/kubespray.git'
                sh "sed 's/node1/$node1_ip/g' /hosts.inventory"
                sh "sed 's/node2/$node2_ip/g' /hosts.inventory"
                sh "sed 's/master/$master_ip/g' /hosts.inventory"
                sh "ansible-playbook -i hosts.inventory cluster.yml"
            }
        }
// You might want to run some QA tests like unit tests, load tests, integration tests etc.
// in a seperate JKS project before applying the pods in K8s.
        stage("Apply the K8s yaml to launch your application pods") {
            steps {
                sh "kubectl create namespace $NAMESPACE"
///////////// REPLACE k8s dir /////////////////
                sh "kubectl apply -n $NAMESPACE -f /k8s ."
            }
            waitUntil {
                // some wait conditions like running or have some TCP liveness/readiness probe defined in k8s
            }
        }

        post {
            success {
                slackSend(
                        teamDomain: "",
                        token: "",
                        channel: "",
                        color: "",
                        message: "${env.VERSION}. ${env.BUILD} is successful"
                )
            }

            failure {
                slackSend(
                        teamDomain: "",
                        token: "",
                        channel: "",
                        color: "",
                        message: "${env.VERSION}. ${env.BUILD} is failed"
                )
            }
        }
    }
}

post {
    always {

    }

    success {

    }
    failure {

    }
}
}