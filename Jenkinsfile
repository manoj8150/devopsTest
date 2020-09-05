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


	  stage('Upload to artifactory'){

	  

		steps{

			rtMavenDeployer(

			  id: 'deployer',

			  serverId: 'myRepo',

			  releaseRepo: 'CI-Automation-JAVA',

			  snapshotRepo: 'CI-Automation-JAVA'

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