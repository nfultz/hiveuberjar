#' @importFrom utils packageVersion download.file
#' @importFrom rJava .jpackage
.onLoad <- function(libname, pkgname) {

    version <- packageVersion(pkgname)[1,1:3] # drop internal releases eg 1.1.0-1 -> 1.1.0
  
    ## path to the JDBC driver
    file <- "hive-jdbc-uber-2.6.3.0-235.jar"
    path <- file.path(system.file('java', package = pkgname), file)

    ## check if the jar is available and install if needed (on first load)
    if (!file.exists(path)) {

        url <- "https://github.com/timveil/hive-jdbc-uber-jar/releases/download/v1.8-2.6.3/hive-jdbc-uber-2.6.3.0-235.jar"

        try(download.file(url = url, destfile = path, mode = 'wb'), silent = TRUE)

    }

    ## add the RJDBC driver
    rJava::.jpackage(pkgname, lib.loc = libname)

    if(getOption("hiveuber.subjectcreds", TRUE)) {
      rJava::J("java.lang.System", "setProperty", "javax.security.auth.useSubjectCredsOnly", "false")
    }
}

.onAttach <- function(libname, pkgname) {

    ## let the user know if the automatic JDBC driver installation failed
    path <- system.file('java', package = pkgname)
    if (length(list.files(path, '^hive-jdbc-uber-[0-9.-]*[.]jar$')) == 0) {
        packageStartupMessage(
            'The automatic installation of the Hive JDBC Uber Jar driver seems to have failed.\n',
            'Please check your Internet connection and if the current user can write to ', path, '\n',
            'If still having issues, install the jar file manually from:\n',
            'https://github.com/timveil/hive-jdbc-uber-jar\n')
    }

}
