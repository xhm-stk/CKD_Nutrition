allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    afterEvaluate {
        val android = project.extensions.findByName("android")
        if (android != null) {
            val namespaceProp = android.javaClass.getMethod("getNamespace").invoke(android)
            if (namespaceProp == null) {
                val group = project.group.toString()
                val fallback = if (group.isNotEmpty()) group else "com.example.${project.name.replace("-", "_")}"
                android.javaClass.getMethod("setNamespace", String::class.java).invoke(android, fallback)
            }
            android.javaClass.getMethod("setCompileSdkVersion", Int::class.java).invoke(android, 36)
        }
    }
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

