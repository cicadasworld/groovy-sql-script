/**
 * create by
 * @author hujin 2020/9/10
 */
def loader = this.class.classLoader.rootLoader
loader.addURL(new File("mysql-connector/mysql-connector-java-8.0.20.jar").toURI().toURL())
Class.forName("com.mysql.cj.jdbc.Driver")

def url = "jdbc:mysql://localhost:3306/webchat?useUnicode=true&characterEncoding=UTF-8&useSSL=false&serverTimezone=UTC"
import groovy.sql.Sql
def user = "root"
def password = "123456"
def driverClassName = "com.mysql.cj.jdbc.Driver"

def sql = Sql.newInstance(url, user, password, driverClassName)
println "Connected!"

// create schema
sql.execute('DROP TABLE IF EXISTS users')
sql.execute """
CREATE TABLE users (
   `id`  INT NOT NULL,
   `username` VARCHAR(45) NOT NULL,
   `bio` VARCHAR(45) NULL,
   PRIMARY KEY (id)
)
"""

// insert table
def webchatUser = [id: 1, username: 'foo', bio: 'foo']
sql.execute """
INSERT INTO users (id, username, bio) VALUES (${webchatUser.id}, ${webchatUser.username}, ${webchatUser.bio})
"""

def rows = sql.rows("select * from users")
println rows

sql.eachRow('select * from users') {
   println "Webchat username: @${it.username}"
}

sql.close()