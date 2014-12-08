def delete_main_branch_configuration
  run 'git config --unset git-town.main-branch-name'
end


def delete_non_feature_branches_configuration
  run 'git config --unset git-town.non-feature-branch-names'
end


def main_branch_configuration
  output_of 'git config --get git-town.main-branch-name'
end


def configure_non_feature_branches configuration
  run "git config git-town.non-feature-branch-names '#{configuration}'"
end


def set_configuration configuration, value
  run "git config git-town.#{configuration} '#{value}'"
end