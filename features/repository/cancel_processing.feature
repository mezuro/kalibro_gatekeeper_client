Feature: Process
  In order to be have repositories
  As a developer
  I want to cancel the repository processing

  @wip @kalibro_restart
  Scenario: With one repositorie
    Given I have a project with name "Kalibro"
    And I have a configuration named "Java"
    And the given project has the following Repositories:
      |   name    | type |              address                  |
      | "Kalibro" |  GIT | https://github.com/mezuro/kalibro.git |
    When I call the cancel_process method for the given repository
    Then I should get success