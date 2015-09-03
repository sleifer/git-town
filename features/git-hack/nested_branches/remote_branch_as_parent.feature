Feature: Forking off a remote branch

  As a developer forking off a branch that exists remotely only
  I want that branch to be checked out locally
  So that I have the feature branches that I currently work on available on my machine.


  Background:
    Given I have a feature branch named "parent-feature"
    And the following commits exist in my repository
      | BRANCH         | LOCATION | MESSAGE               | FILE NAME           |
      | main           | remote   | main_commit           | main_file           |
      | parent-feature | remote   | parent_feature_commit | parent_feature_file |
    And I am on the "main" branch
    And I remove the "parent-feature" branch from my machine
    And I have an uncommitted file
    When I run `git hack child-feature parent-feature` and enter "main"


  Scenario: result
    Then it runs the commands
      | BRANCH         | COMMAND                                      |
      | main           | git fetch --prune                            |
      |                | git stash -u                                 |
      |                | git rebase origin/main                       |
      |                | git checkout parent-feature                  |
      | parent-feature | git merge --no-edit origin/parent-feature    |
      |                | git merge --no-edit main                     |
      |                | git push                                     |
      |                | git checkout -b child-feature parent-feature |
      | child-feature  | git stash pop                                |
    And I end up on the "child-feature" branch
    And I still have my uncommitted file
    And the branch "child_feature" has not been pushed to the repository
    And I have the following commits
      | BRANCH         | LOCATION         | MESSAGE                                 | FILE NAME           |
      | main           | local and remote | main_commit                             | main_file           |
      | child-feature  | local            | parent_feature_commit                   | parent_feature_file |
      |                |                  | main_commit                             | main_file           |
      |                |                  | Merge branch 'main' into parent-feature |                     |
      | parent-feature | local and remote | parent_feature_commit                   | parent_feature_file |
      |                |                  | main_commit                             | main_file           |
      |                |                  | Merge branch 'main' into parent-feature |                     |
    And Git Town is now aware of this branch hierarchy
      | BRANCH         | PARENT         |
      | child-feature  | parent-feature |
      | parent-feature | main           |


  Scenario: undo
    When I run `git hack --undo`
    Then it runs the commands
      | BRANCH         | COMMAND                     |
      | child-feature  | git stash -u                |
      |                | git checkout parent-feature |
      | parent-feature | git branch -d child-feature |
      |                | git checkout main           |
      | main           | git stash pop               |
    And I end up on the "main" branch
    And I still have my uncommitted file
    And I have the following commits
      | BRANCH         | LOCATION         | MESSAGE                                 | FILE NAME           |
      | main           | local and remote | main_commit                             | main_file           |
      | parent-feature | local and remote | parent_feature_commit                   | parent_feature_file |
      |                |                  | main_commit                             | main_file           |
      |                |                  | Merge branch 'main' into parent-feature |                     |
    And Git Town is now aware of this branch hierarchy
      | BRANCH         | PARENT |
      | parent-feature | main   |