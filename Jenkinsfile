pipeline{
	agent any
	tools {
		maven 'Maven3'
	}
	options {
		timestamps()
		timeout(time: 1, unit: 'HOURS')
		skipDefaultCheckout()
		buildDiscarder(logRotator(daysToKeepStr: '10', numToKeepStr: '10'))
		disableConcurrentBuilds()
	}
	stages {
		stage('Checkout') {
		  steps{
			echo "build in master branch -1"
			checkout scm
		  }
		}
		stage('build') {
		  steps{
			echo "build in master branch -2"
			bat "mvn install"
		  }
		}
		stage('unit testing'){
		  steps{
		   echo "Unit Testing"
		   bat "mvn test"
		  }
		}
	//	stage('Sonar analysis'){
	//	steps{
	//	   withSonarQubeEnv("Test_Sonar")
	//	   {
	//		 bat "mvn org.sonarsource.scanner.maven:sonar-maven-plugin:3.7.0.1746:sonar"
	//	   }
	//	  }
	  //}
	stage('Docker Image'){
	    steps{
		    bat 'docker build --network=host --no-cache -t manojkumar/demo-application:%BUILD_NUMBER% -f Dockerfile .'
		}
	  }
	  stage('Upload to artifactory'){
		steps{
			rtMavenDeployer(
			  id: 'deployer',
			  serverId: 'myRepo',
			  releaseRepo: 'myRepo',
			  snapshotRepo: 'myRepo'
			)
			rtMavenRun (
	          pom: 'pom.xml',
	          goals: 'clean install',
	          deployerId: 'deployer',
            )
			rtPublishBuildInfo(
			   serverId:'myRepo'
			)
		}
	  }
	}
	post {
        always {
            junit 'target/surefire-reports/*.xml'
        }
    }
}
