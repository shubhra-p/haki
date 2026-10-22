allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

subprojects {
    val configureCompileSdk: (Project) -> Unit = { p ->
        p.extensions.findByName("android")?.let { ext ->
            for (name in listOf("setCompileSdk", "setCompileSdkVersion", "compileSdkVersion")) {
                val method = ext.javaClass.methods.firstOrNull {
                    it.name == name && it.parameterCount == 1 &&
                    (it.parameterTypes[0] == Integer.TYPE || it.parameterTypes[0] == java.lang.Integer::class.java)
                }
                if (method != null) {
                    try {
                        method.invoke(ext, 36)
                        break
                    } catch (_: Exception) {}
                }
            }
        }
    }
    if (state.executed) {
        configureCompileSdk(this)
    } else {
        afterEvaluate {
            configureCompileSdk(this)
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
