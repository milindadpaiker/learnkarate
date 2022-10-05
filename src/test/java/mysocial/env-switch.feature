Feature: Verify posts api for mysocial

Background: Initialize stuff
   
   
Scenario: Verify /posts works
    Given url postService
    Given path 'posts'
    When method get
    Then status 200
    * print myVarName
    And match response == '#array'
    And match each response == {"userId": '#number', "id": '#number', "title":  '#string',  "body": '#string' } 
