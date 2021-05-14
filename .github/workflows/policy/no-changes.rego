package terraform.analysis

import input as tfplan

#######################################################
# Policy: check there are no resource or output changes
#######################################################

no_changes {
	no_change_resource
	no_change_output
}

no_change_resource {
	count_resouce_changes("create") == 0
	count_resouce_changes("update") == 0
	count_resouce_changes("delete") == 0
}

no_change_output {
	count_output_changes("create") == 0
	count_output_changes("update") == 0
	count_output_changes("delete") == 0
}

count_resouce_changes(action) = num {
	actions := [res |
		res := tfplan.resource_changes[_]
		res.change.actions[_] == action
	]

	num := count(actions)
}

count_output_changes(action) = num {
	actions := [res |
		res := tfplan.output_changes[_]
		res.actions[_] == action
	]

	num := count(actions)
}
