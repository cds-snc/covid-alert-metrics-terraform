
module.exports = (github, context) => {

  github.issues.createComment({
    issue_number: context.issue.number,
    owner: context.repo.owner,
    repo: context.repo.repo,
    body: "## Plans are Completed for this run"
  })

};