Feature: Find
  In order to be able to have module result
  As an developer
  I want to find module results

  @kalibro_restart @kalibro_processor_restart
  Scenario: find a valid module result
    Given I have a project with name "Kalibro"
    And I have a configuration with name "Java"
    And I have a reading group with name "Group"
    And I have a loc configuration within the given configuration
    And the given project has the following Repositories:
      |   name    | type |                   address                   |
      |  Kalibro  |  GIT | https://git.gitorious.org/sbking/sbking.git |
    When I call the process method for the given repository
    And I wait up for a ready processing
    And I get the module result of the processing
    Then I should get a module_result

  Scenario: get a module result by inexistent name
    When I ask for an inexistent module result
    Then I should get an error