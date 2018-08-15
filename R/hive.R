
#' HiveUber driver class.
#'
#' @keywords internal
#' 
#' @export
#' @import RJDBC
#' @import methods
#' @importClassesFrom RJDBC JDBCDriver
setClass("HiveUberDriver", contains = "JDBCDriver")

#' Hive Uber DBI wrapper
#'
#' @details 
#' 
#' The \code{hiveuber.subjectcreds} option sets a JVM flag necessary for kerberos 
#' authentication. See \code{zzz.R} for details.
#' 
#'
#' @export
HiveUber <- function() {
  new("HiveUberDriver")
}

#' Constructor of HiveUberDriver
#' 
#' @name HiveUberDriver
#' @rdname HiveUberDriver-class
setMethod(initialize, "HiveUberDriver",
   function(.Object, ...)
{
    # passed to parent builder, than unboxed, yuck
    # should ping RJDBC maintainers, and have them implement initialize methods instead
    jdbc <- JDBC(driverClass="org.apache.hive.jdbc.HiveDriver",
                 identifier.quote="`")

    .Object@jdrv = jdbc@jdrv
    .Object@identifier.quote = jdbc@identifier.quote
    .Object
})

#' Hive Uber connection class.
#'
#' Class which represents the Hive Uber connections.
#'
#' @export
#' @importClassesFrom RJDBC JDBCConnection
#' @keywords internal
setClass("HiveUberConnection",
  contains = "JDBCConnection",
  slots = list(
    url = "character"
  )
)

#' Authentication credentials are can be specified inside the url, or kerberos can be used.
#'
#' @param drv An object created by \code{HiveUber()}
#' @param url the jdbc connection url
#' @param ... Other options
#' @rdname HiveUber
#' @seealso \href{https://cwiki.apache.org/confluence/display/Hive/HiveServer2+Clients#HiveServer2Clients-ConnectionURLs}{Hive Wiki} for more connections options.
#' @export
#' @examples
#' \dontrun{
#' require(DBI)
#' con <- dbConnect(HiveUber(), url="jdbc:hive2://host:port/schema")
#' dbListTables(con)
#' dbGetQuery(con, "Select count(*) from nfultz.iris")
#' }
setMethod("dbConnect", "HiveUberDriver",
          function(drv, url, ...) {

  con <- callNextMethod(drv, url=url, ...)

  new("HiveUberConnection", jc = con@jc, identifier.quote = drv@identifier.quote, url=url)
})

