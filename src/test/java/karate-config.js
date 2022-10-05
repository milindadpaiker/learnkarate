function fn() {
  var env = karate.env; // get system property 'karate.env'
  karate.log('karate.env system property was:', env);
  if (!env) {
    env = 'int';
  }
  var config = {
    env: env,
    myVarName: 'someValue',
    postService: 'https://jsonplaceholder.typicode.com'
  }
  if (env == 'dev') {
    // customize
    // e.g. config.foo = 'bar';
    config.postService = 'http://localhost:3000'
  } else if (env == 'int') {
    // customize
    config.postService = 'https://jsonplaceholder.typicode.com'
  }
  karate.configure('connectTimeout', 5000);
  karate.configure('readTimeout', 5000);  
  return config;
}