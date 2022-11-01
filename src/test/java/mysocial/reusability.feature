//This feature file requires a custom setup of running a local server of 'https://jsonplaceholder.typicode.com'. 
@ignore 
Feature: Verify reusability

Background: Initialize stuff
   Given url 'http://localhost:3000'
   * def signinToken = callonce read('login.feature@login') {email: "abc122@gmail.com" , password: "Abc1"}
   * print signinToken
   #* def authtoken = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiNjMzY2M1MzliMjM2MDUyNjEwZWQ5ZGQ4IiwiZW1haWwiOiJhYmM3ODkueHl6QGdtYWlsLmNvbSIsImlhdCI6MTY2NDkyNzA0NSwiZXhwIjoxNjY0OTM0MjQ1fQ.gnQwYdBrfx2LnO5Gadr40Gz4F1_n0AVba5Vt5xHNZck'
    * def authtoken = signinToken.response.token
Scenario: verify protected endpoint /posts
    Given path 'posts'
    And header Content-type = 'application/json; charset=UTF-8'
    And  header x-access-token = authtoken
    When method get
    Then status 200
    And print response

Scenario: verify protected endpoint /albums
    Given path 'albums'
    And header Content-type = 'application/json; charset=UTF-8'
    And  header x-access-token = authtoken
    When method get
    Then status 200
    And print response    
