Kotlin Scripting Support
========================

Provides scripting support for Kotlin on *nix-based systems. e.g.

    #!/usr/bin/env kotlin
    println("Hello from Kotlin!")
    for (arg in args) {
        println("arg: $arg")
    }

Installation
------------

Assuming you have ~/bin and kotlinc in your PATH:

    $ curl https://raw.github.com/andrewoma/kotlin-script/master/kotlin > ~/bin/kotlin && chmod u+x ~/bin/kotlin 

Otherwise, download the kotlin script to any location in your PATH.

Features
--------

* Runs kotlin scripts with or without a main method (wrapping in a main method automatically if required) 
* Runs standard kotlin source files (or modules), compiling automatically
* Caches compiled scripts. "Hello, world" will take around 3s on the first run and 200ms thereafter.   
* Supports a classpath option, automatically building the appropriate kotlin module on the fly.

Limitations
-----------

* Cygwin support is currrently broken as the kotlinc command in the kotlin distribution is broken (See http://youtrack.jetbrains.com/issue/KT-1470). Even when this is fixed cygwin is barely usable as the script is slow due to the high overhead of launching processes under Windows. 

Examples
--------

There are various examples in the examples directory. Here are a subset of them:

A script with an explicit main method:

    #!/usr/bin/env kotlin

    fun main(args: Array<String>) {
        Hello().sayHello()
    }

    class Hello {
    	fun sayHello() {
    	    println("Hello from Kotlin!")
    	}
    }

A script using a classpath. Note: Using #!/usr/bin/env with options does not work across platforms. Either the actual path to the command must be used, or using indirection as shown below.

    #!/bin/sh 
    exec kotlin -DmySysProp=somevalue -cp log4j-1.2.14.jar "$0" "$@"
    !#
    import org.apache.log4j.*

    val logger = Logger.getLogger("mymodule").sure();

    fun main(args: Array<String>) {
        BasicConfigurator.configure();
        logger.info("Hello from Kotlin via log4j! mySysProp=${System.getProperty("mySysProp")}")
    }

Running a standard kotlin source file:

    $ kotlin mykotlinfile.kt
    
Alternatives
------------
Aztec (https://github.com/kondratovich/aztec) seems to be a Python based alternative