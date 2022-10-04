Feature: Modify requests on the fly

Background: Initialize stuff
   Given url 'https://jsonplaceholder.typicode.com'
   And def rqst = {userId : '#(userId)' , body:'#(body)', title:'#(title)' }
   And def rqst1 = {userId : '#(user.userId)' , body:'#(user.body)', title:'#(user.title)' }

Scenario Outline: embedded expression - 1
    Given path 'posts'
    And header Content-type = 'application/json; charset=UTF-8'
    And request rqst
    When method post
    Then status 201
    And match response == { id: '#number', title: <title>,  body: '#(body)',  userId: <userId> }


    Examples:
        | userId!  |  title      | body  |
        |  1      |  title1     | body1 |
        |  2      |  title2     | body2 |
        |  3      |  title3     | body3 |   

    Scenario Outline: embedded expression - 2
        Given path 'posts'
        And header Content-type = 'application/json; charset=UTF-8'
        And request rqst1
        When method post
        Then status 201
        And match response == { id: '#number', title: '#(user.title)',  body: '#(user.body)',  userId: '#(user.userId)' }
    
    
        Examples:
            | user!                                          | 
            |   {userId: 1, title: 'title1', body: 'body1'}      |  
            |   {userId: 2, title: 'title2', body: 'body2'}      |  

        Scenario Outline: Add an attribute on the fly
            Given path 'posts'
            And header Content-type = 'application/json; charset=UTF-8'
            And set rqst1.hashtag = 'database'
            And request rqst1
            When method post
            Then status 201
            And match response == { id: '#number', title: '#(user.title)',  body: '#(user.body)',  userId: '#(user.userId)', hashtag: '##string' }
        
        
            Examples:
                | user!                                          | 
                |   {userId: 1, title: 'title1', body: 'body1'}      |  
                |   {userId: 2, title: 'title2', body: 'body2'}      |              

            Scenario Outline: Add an attribute on the fly
                Given path 'posts'
                And header Content-type = 'application/json; charset=UTF-8'
                * def setHashtag =
                """
                function(k, v){
                    rqst1[k] = v
                }
                """
                #And set rqst1.hashtag = 'database'
                And if(rqst1.userId == 1) setHashtag('hashtag', 'ceo')
                And request rqst1
                When method post
                Then status 201
                And match response == { id: '#number', title: '#(user.title)',  body: '#(user.body)',  userId: '#(user.userId)', hashtag: '##string' }
            
            
                Examples:
                    | user!                                          | 
                    |   {userId: 1, title: 'title1', body: 'body1'}      |  
                    |   {userId: 2, title: 'title2', body: 'body2'}      |                              

                Scenario Outline: delete an attribute on the fly
                    Given path 'posts'
                    And header Content-type = 'application/json; charset=UTF-8'
                    And eval delete rqst1.body
                    And request rqst1
                    When method post
                    Then status 201
                    And match response == { id: '#number', title: '#(user.title)',  userId: '#(user.userId)', hashtag: '##string' }
                
                
                    Examples:
                        | user!                                          | 
                        |   {userId: 1, title: 'title1', body: 'body1'}      |  
                        |   {userId: 2, title: 'title2', body: 'body2'}      |    