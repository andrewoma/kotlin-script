
This project is no longer supported. 

See https://github.com/holgerbrandl/kscript for an actively maintained alternative.

Kotlin Scripting Support
========================

Provides scripting support for Kotlin on *nix-based systems. e.g.

    #!/usr/bin/env kotlins
    println("Hello from Kotlin!")
    for (arg in args) {
        println("arg: $arg")
    }

Installation
------------

Assuming you have `~/bin` and `kotlinc-jvm` in your `PATH`:

    $ curl -s https://raw.githubusercontent.com/andrewoma/kotlin-script/master/kotlins > ~/bin/kotlins && chmod u+x ~/bin/kotlins

Otherwise, download the `kotlins` script to any location in your `PATH`.

If you're looking for `kotlinc-jvm`, it is available via homebrew or 1.0.5 can be
downloaded from [here](https://github.com/JetBrains/kotlin/releases/download/v1.0.5/kotlin-compiler-1.0.5.zip).

Features
--------

* Runs kotlin scripts with or without a main method (wrapping in a main method automatically if required) 
* Runs standard kotlin source files (or modules), compiling automatically
* Caches compiled scripts. "Hello, world" will take around 3s on the first run and 200ms thereafter.   
* Supports a classpath option, automatically building the appropriate kotlin module on the fly.

Limitations
-----------

* Cygwin is supported, but the script is quite slow due to the high overhead of launching processes under Windows. 
* For modules, the module main method must be in a file called main.kt.

Examples
--------

There are various examples in the examples directory. Here are a subset of them:

A script with an explicit main method:

    #!/usr/bin/env kotlins

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
    exec kotlins -DmySysProp=somevalue -cp log4j-1.2.14.jar "$0" "$@"
    !#
    import org.apache.log4j.*

    val logger = Logger.getLogger("mymodule").sure();

    fun main(args: Array<String>) {
        BasicConfigurator.configure();
        logger.info("Hello from Kotlin via log4j! mySysProp=${System.getProperty("mySysProp")}")
    }

Running a standard kotlin source file:

    $ kotlins mykotlinfile.kt
    
mvncp
-----

In response to #1, I've included mvncp in the extras folder. mvncp is a utility that can resolve classpaths from maven repositories (automatically downloading and resolving transitive dependencies if required).
It requires ruby and maven to be installed and included in your PATH.

Example: resolving a classpath

    $ mvncp org.springframework:spring-core:3.1.1.RELEASE

Will write write the following to the stdout

    /Users/andrew/.m2/repository/commons-logging/commons-logging/1.1.1/commons-logging-1.1.1.jar:/Users/andrew/.m2/repository/org/springframework/spring-asm/3.1.1.RELEASE/spring-asm-3.1.1.RELEASE.jar:/Users/andrew/.m2/repository/org/springframework/spring-core/3.1.1.RELEASE/spring-core-3.1.1.RELEASE.jar

Example: show the dependency tree

    $ mvncp --tree org.springframework:spring-core:3.1.1.RELEASE
    org.springframework:spring-core:jar:3.1.1.RELEASE
       org.springframework:spring-asm:jar:3.1.1.RELEASE
       commons-logging:commons-logging:jar:1.1.1

mvncp can be used in conjunction with the kotlin script as follows:

    #!/bin/sh 
    exec kotlins -DmySysProp=somevalue -cp `mvncp log4j:log4j:1.2.14` "$0" "$@"
    !#
    import org.apache.log4j.*

    val logger = Logger.getLogger("mymodule").sure();

    fun main(args: Array<String>) {
        BasicConfigurator.configure();
        logger.info("Hello from Kotlin via log4j! mySysProp=${System.getProperty("mySysProp")}")
    }

#### Alternatives
[kotlin-scripting-kickstarter](https://github.com/andrewoma/kotlin-scripting-kickstarter) provides a Gradle based alternative. The main advantage of the kickstarter approach is that it supports full IDE development of scripts.

#### Status
Last verified Kotlin version: 1.0.5
