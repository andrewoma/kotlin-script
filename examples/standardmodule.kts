import kotlin.modules.*
 
fun project() {
    module("mymodule", ".") {
        sources += "standardsource.kt"
    }
}