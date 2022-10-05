Feature: Authentication

Background: Initialize stuff
   Given url 'http://localhost:3000'
Scenario: test register api
    * print 'hello'   
@login @ignore
Scenario: verify protected endpoint /posts
    Given path 'login'
    And header Content-type = 'application/json; charset=UTF-8'
    And request {email: '#(email)' , password: '#(password)' }
    When method post
    Then status 200
    And print response
