Feature: Say Hello World!
  In order to get a warm feeling
  As a Sinatra and Cucumber User
  I want to have a working installation

  Scenario: Saying Hello!
    When I go to "/"
    Then I should see "Hello, world!" within "h1"