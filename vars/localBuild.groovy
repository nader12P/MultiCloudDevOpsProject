def call() {
    sh 'chmod 777 ./gradlew'
    sh './gradlew dependencies'
    sh './gradlew build --stacktrace'
}