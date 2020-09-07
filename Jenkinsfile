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
	stage('Docker Image'){
	    steps{
		    bat 'docker build --network=host --no-cache -t manojkumar/demo-application:%BUILD_NUMBER% -f Dockerfile .'
		}
	  }
	  stage('Push to DTR'){
	    steps{
		    bat 'docker login -u manoj8150 -p Docker@11' 
		    bat 'docker push manojkumar/demo-application:%BUILD_NUMBER%'
		}
	  }
	  stage('Stop Running Container'){
	    steps{
		   bat '''
		   for /f %%i in ('docker ps -aqf "name=^demo-application"') do set containerId=%%i
           echo %containerId%
           If "%containerId%" == "" (
            echo "No Container running"
		   )else (
            docker stop %ContainerId%
            docker rm -f %ContainerId%
		   )
		   '''
		}
	  }
	  stage('Docker Deployment'){
	    steps{
		  bat 'docker run -it --name demo-application -d -p 8080:8080 manojkumar/demo-application:%BUILD_NUMBER%'
		}
	  }
	}
	post {
        always {
            junit 'target/surefire-reports/*.xml'
        }
    }
}
