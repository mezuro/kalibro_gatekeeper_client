Feature: Exists
  In order to be able to have ranges
  As a developer
  I want to find wich range exists

@kalibro_restart
Scenario: find a valid range
    Given I have a configuration with name "Java"
    And I have a reading group with name "Group"
    And I have a metric configuration within the given configuration
    And I have a reading within the given reading group
    And I have a range within the given reading
    Then the range should exist
