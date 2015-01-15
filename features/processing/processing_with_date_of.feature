Feature: Processing with date of
  In order to be able to retrieve processing results
  As a developer
  I want to be able to retrieve the processing for a given date

  @kalibro_processor_restart @kalibro_configuration_restart
  Scenario: With one repository just after starting to process and tomorrow's date
    Given I have a project with name "Kalibro"
    And I have a configuration with name "Java"
    And I have a reading group with name "Group"
    And I have a loc configuration within the given configuration
    And the given project has the following Repositories:
      |   name    | scm_type |                  address                    |
      | "Kalibro" |    GIT   | https://git.gitorious.org/sbking/sbking.git |
    And I call the process method for the given repository
    And I wait up to 1 seconds
    When I call the processing_with_date_of method for the given repository and tomorrow's date
    Then I should get a Processing

  @kalibro_processor_restart @kalibro_configuration_restart
  Scenario: With one repository just after starting to process and yesterday's date
    Given I have a project with name "Kalibro"
    And I have a configuration with name "Java"
    And I have a reading group with name "Group"
    And I have a loc configuration within the given configuration
    And the given project has the following Repositories:
      |   name    | scm_type |                  address                    |
      | "Kalibro" |    GIT   | https://git.gitorious.org/sbking/sbking.git |
    And I call the process method for the given repository
    And I wait up to 1 seconds
    When I call the processing_with_date_of method for the given repository and yesterday's date
    Then I should get a Processing
