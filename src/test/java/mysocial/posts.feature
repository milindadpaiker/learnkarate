Feature: Verify posts api for mysocial

Background: Initialize stuff
   Given url 'https://jsonplaceholder.typicode.com'
Scenario: Verify /posts works
    Given path 'posts'
    When method get
    Then status 200
    And assert response.length == 100
    And assert responseTime < 1000
    * print responseCookies
    And match responseHeaders['Content-Type'][0] == 'application/json; charset=utf-8'
    And match response == '#array'
    And match response[0] ==   {"userId": 1, "id": '#number', "title":  '#string',  "body": '#string' } 
    And match response[*] contains {"userId": 1, "id": 1, "title":  '#string',  "body": '#string' } 
    And match each response == {"userId": '#number', "id": '#number', "title":  '#string',  "body": '#string' } 

Scenario: Verify /posts works with query parameter
    Given path 'posts'
    And param userId = 1
    And header x-transaction-id = 'abc-1234'
    When method get
    Then status 200
    And assert response.length == 10

Scenario: Verify /post/{uid} works
    Given def postId = 1
    And path 'posts'
    And path postId
    When method get
    Then status 200
    And match response contains
    """
    {
        "userId": '#number',
        "id": '#(postId)',
        "title":  '#string'
      }   
    """

Scenario: Verify that a new post can be created
    Given path 'posts'
    And header Content-type = 'application/json; charset=UTF-8'
    And request 
    """
    {
        title: 'foo',
        body: 'bar',
        userId: 1,
    }
    """
    When method post
    Then status 202
    And match response == { id: '#number', title: 'foo',  body: 'bar',  userId: 1 }

Scenario: Verify update on /post/{uid} works
    Given def postId = 1
    And path 'posts'
    And path postId
    And request 
    """
    {
        title: 'foo1',
        body: 'bar1',
        userId: 11,
    }
    """
    When method put
    Then status 200
    And match response == { id: '#(postId)', title: 'foo1',  body: 'bar1',  userId: 11 }


Scenario: Verify delete on /post/{uid} works
    Given def postId = 1
    And path 'posts'
    And path postId
    When method delete
    Then status 200
