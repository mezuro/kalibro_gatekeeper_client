Feature: Has processing after
  In order to be retrieve processing results from a given date
  As a developer
  I want to be able to check if a repository has processings after it

  @kalibro_restart @kalibro_processor_restart
  Scenario: With one repository just after starting to process
    Given I have a project with name "Kalibro"
    And I have a configuration with name "Java"
    And I have a reading group with name "Group"
    And I have a loc configuration within the given configuration
    And the given project has the following Repositories:
      |   name    | scm_type |                  address                    |
      | "Kalibro" |    GIT   | https://git.gitorious.org/sbking/sbking.git |
    And I call the process method for the given repository
    And I wait up to 1 seconds
    When I call the has_processing_after for the given repository with yerterday's date
    Then I should get true
