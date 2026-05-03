"""Use PyMySQL as MySQLdb driver (works well on Windows without mysqlclient)."""
import pymysql

pymysql.install_as_MySQLdb()
