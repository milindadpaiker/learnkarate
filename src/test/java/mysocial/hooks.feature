Feature: Verify posts api for mysocial

Background: Initialize stuff
    * configure retry = { count: 10, interval: 5000 }
    * configure afterScenario = 
    """
    function(){
      karate.log('after scenario:', karate.scenario.name);
    }
    """
    
    * configure afterFeature = 
    """
    function(){
      karate.log('after feature:', karate.feature.name);
    }
    """

Scenario: Verify /posts works
    Given url postService
    Given path 'posts'
    When method get
    Then status 200
    * print myVarName
    And match response == '#array'
    And match each response == {"userId": '#number', "id": '#number', "title":  '#string',  "body": '#string' } 

Scenario: Verify /posts works with retry until
    Given url postService
    Given path 'posts'
    And retry until responseStatus == 200
    When method get
    * print myVarName
    And match response == '#array'
    And match each response == {"userId": '#number', "id": '#number', "title":  '#string',  "body": '#string' }     
