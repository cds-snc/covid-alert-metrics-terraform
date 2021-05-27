module.exports = ({github, context, steps, matrix}) => {

  const fmtOutcome = steps.fmtOutcome
  const planOutcome = steps.planOutcome

  const deletes = steps.deletes
  const creates = steps.creates
  const updates = steps.updates

  const deleteWarning = deletes === '0' ? '' : '**⚠️ &nbsp; WARNING:** resources will be destroyed by this change!';

  const environment = matrix.environment
  const moduleName = matrix.moduleName

  const iconFormat = fmtOutcome === 'success' ? '✅' : '❌';
  const iconPlan = planOutcome === 'success' ? '✅' : '❌';


  const output = `## <span style="text-transform:uppercase">${ environment }</span> Module: ${ moduleName }

  **${iconFormat} &nbsp; Terraform Format:** \`${ fmtOutcome }\`
  **${iconPlan} &nbsp; Terraform Plan:** \`${ planOutcome }\`  

  ${deleteWarning}
  \`\`\`terraform
  Plan: ${ creates } to add, ${ updates } to change, ${ deletes } to destroy
  \`\`\`

  <details>
    <summary>Show Plan</summary>

    \`\`\`terraform
    ${ process.env.PLAN }
    \`\`\`
  </details>`;

  github.issues.createComment({
    issue_number: context.issue.number,
    owner: context.repo.owner,
    repo: context.repo.repo,
    body: output
  })

};