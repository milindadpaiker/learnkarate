Feature: Sample feature testing java interop

Background: Intialize stuff
    * def doWork =
    """
    function(arg) {
      var JavaDemo = Java.type('util.mongo');
      var jd = new JavaDemo();
      return jd.doWork(arg);  
    }
    """
    Given url 'http://localhost:3000'
    * def getUserRecord =
    """
    function(arg) {
      var JavaDemo = Java.type('util.mongo');
      var jd = new JavaDemo();
      return jd.getUserRecord(arg.db, arg.coll, arg.email);  
    }
    """  
    
	* def randomuuid = 
    """
    function(){ return java.util.UUID.randomUUID() + '' }
    """	

Scenario: Test 1
    # in this case the solitary 'call' argument is of type string
    * def result = call doWork 'world'
    * match result == { someKey: 'hello world' }

    # using a static method - observe how java interop is truly seamless !
    * def JavaDemo = Java.type('util.mongo')
    * def result = JavaDemo.doWorkStatic('world')
    * assert result == 'hello world'

Scenario: Test 2
    Given path 'register'
    And header Content-type = 'application/json; charset=UTF-8'
    #* def nowtime = Date.now()
    * def lastName = call randomuuid
    * def email =  lastName + "@mymail.com"
    
    And request {email: '#(email)' , password: '12345', first_name: "xyz123", last_name: '#(lastName)' }
    When method post
    Then status 201
    And match response contains {first_name: 'xyz123' } 
  
    * def result = call getUserRecord {db: "test", coll: "users", email: '#(email)'}
    * print result
    * json jresult = result
    * print jresult
    * match jresult contains { "last_name": '#(lastName)' }
    * def nowtime = Date.now()
    * assert jresult.created_at.$date < nowtime    