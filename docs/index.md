

<!-- Start src/index.coffee -->

## exports(options, options.map, options.watch, options.log, options.error)

Express helper

### Params: 

* **Object** *options* 

* **String** *options.map* Config filename, default 'distribution.json'

* **Boolean** *options.watch* Watch changes in config file, default 'false' in production environment

* **Function** *options.log* Function for logging, set to 'false' to desable logging

* **Function** *options.error* Function for logging errors, set to 'false' to desable logging

## parseFile

Read file and parse content

### Params: 

* **String** *filename* 

## watchFile

Watch file changes

### Params: 

* **String** *filename* 

* **Function** *cb* 

<!-- End src/index.coffee -->

