#!/bin/bash
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ] ; do SOURCE="$(readlink "$SOURCE")"; done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

function clearCache() {
    [ -n "$KOTLIN_SCRIPT_CACHE" ] || KOTLIN_SCRIPT_CACHE="$HOME/.kotlin-script-cache"
    if [ -d "$KOTLIN_SCRIPT_CACHE" ]; then
        rm -r "$KOTLIN_SCRIPT_CACHE"
    fi
}

function assertEquals() {
    echo "Running $1..."
    actual=`echo "$2" | tr -d '\r' | tr -d '\n'`
    expected="$3"
    if [ "$actual" != "$expected" ]; then
        echo "  Actual: $actual"
        echo "Expected: $expected"
        exit 1
    fi
}

function tests() {
    start=$(date +"%s")
    
    assertEquals "script with implicit main" "`$DIR/examples/implicitmain 1 2 3`" "Hello from Kotlin! args.size=3"  
    assertEquals "script with explicit main" "`$DIR/examples/explicitmain`" "Hello from Kotlin!"    
    assertEquals "script with class path" "`cd "$DIR/examples" && $DIR/examples/withclasspath`" "0 [main] INFO mymodule  - Hello from Kotlin via log4j! mySysProp=somevalue"    
    assertEquals "script with spaces" "`"$DIR/examples/with spaces"`" "Hello from Kotlin! args.size=0"  
    assertEquals "standard kotlin source file" "`kotlin "$DIR/examples/standardsource.kt" 1 2 3`" "Hello from Kotlin! args.size=3"  
    assertEquals "standard kotlin module file" "`kotlin "$DIR/examples/standardmodule.kts" 1 2 3`" "Hello from Kotlin! args.size=3" 
    
    end=$(date +"%s")
    diff=$(($end-$start))
    echo "$diff seconds"    
}

clearCache
echo "Run with empty cache"
tests
echo
echo "Run with cache"
tests


