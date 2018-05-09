// Set default values
def instance = 'WPG1LSDS02,7220'
def dbName = 'ci_DbUp'
def packageName = 'dbUp.zip'
def buildProjectName = 'Lab/dbUp Build'
def historyFolder = 'History'
//def promotionLevel = 'Test release'

pipeline {
  agent {
    node {
      label 'lab-deploy'
    }
  }
  options { 
    disableConcurrentBuilds()
  }
  stages {
    stage('Build') {
      //environment {
        //COPY_PROMOTION_LEVEL = 'Test release'
        //CURRENT_VERSION = '1.0'
      //}
      steps {
        //copyArtifacts(projectName: 'mss-deploy-dbadmin/master', filter: '*.zip', target: 'History', flatten: true, optional: true, selector: [$class: 'PromotedBuildSelector', level: 1])
        copyArtifacts filter: '*.zip', fingerprintArtifacts: true, flatten: true, optional: true, projectName: buildProjectName, selector: latestSavedBuild(), target: historyFolder
        powershell '. .\\Build.ps1'
      }
    }
    stage('Create snapshot') {
      steps {
        powershell "Remove-DbaDatabaseSnapshot -SqlInstance '${instance}' -Database '${dbName}'"
        powershell "New-DbaDatabaseSnapshot -SqlInstance '${instance}' -Database '${dbName}' -NameSuffix _snap"
      }
    }
    stage('Deploy changes') {
      steps {
        echo "Deploying ${packageName} to ${instance}.${dbName}"
        powershell "Install-DBOPackage -SqlInstance '${instance}' -Database '${dbName}' -Path '${packageName}' -OutputFile '${packageName}.log'"
      }
    }
    stage('Store artifacts') {
      steps {
        archiveArtifacts(artifacts: '*.log', onlyIfSuccessful: false)
        archiveArtifacts(artifacts: '*.zip', onlyIfSuccessful: true)
      }
    }
  }
  post {
    always {
      echo "Reverting database ${instance}.${dbName} to a snapshot."
      powershell "Restore-DbaFromDatabaseSnapshot -SqlInstance '${instance}' -Database '${dbName}' -Force"
      powershell "Remove-DbaDatabaseSnapshot -SqlInstance '${instance}' -Database '${dbName}'"
    }        
  }
}