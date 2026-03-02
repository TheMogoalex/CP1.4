node {
  def branch = env.BRANCH_NAME ?: sh(script: "git rev-parse --abbrev-ref HEAD", returnStdout: true).trim()

  if (branch == 'develop') {
    echo "Running CI (staging) for branch: ${branch}"
    load 'pipelines/PIPELINE-FULL-STAGING/Jenkinsfile_agentes'
  } else if (branch == 'master') {
    echo "Running CD (production) for branch: ${branch}"
    load 'pipelines/PIPELINE-FULL-PRODUCTION/Jenkinsfile_agentes'
  } else {
    echo "Branch ${branch} not configured for this multibranch job."
  }
}