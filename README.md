## 下载JDBC驱动包

下载MySql的JDBC驱动包，并放在在mysql-connector文件夹下



## 目录结构

独立运行环境目录结构如下

``` shell
mysql
 │  env.bat <-- 环境变量设置批处理
 │  srcript.groovy
 ├─mysql-connector   
 │		 └─mysql-connector-java-8.0.20.jar   <-- mysql connector for java
 ├─groovy   <-- groovy运行环境
 └─jre      <-- jre运行环境
```



## 脚本内容

``` groovy
import groovyx.net.http.ContentType
import groovyx.net.http.RESTClient

@Grab(group='org.codehaus.groovy.modules.http-builder', module='http-builder', version='0.7.2')

/**
 * create by
 * @author hujin 2020/9/11
 */
def base = 'http://api.icndb.com'

def chuck = new RESTClient(base)
def params = [firsName: 'John', lastName: 'Doe']
chuck.contentType = ContentType.JSON

chuck.get(path: '/jokes/random', query: params) { response, json ->
    println response.status
    println json
}
```



## 环境变量设置脚本

``` shell
@echo off

REM
REM ================================================================
REM 创建快捷方式
REM ================================================================
REM
:CreateShorcut

set linkfile=%~dp0%~n0.lnk
IF EXIST "%linkfile%" goto SetDevEnv

set temp_js_file=%TEMP%\%~n0.js
SET _K_LinkFile=%linkfile%
SET _K_TargetPath=%comspec%
SET _K_Arguments=/k ""%~f0""
SET _K_Description=%~n0
SET _K_WorkDir=%~dp0

if exist "%temp_js_file%" del /f "%temp_js_file%"
echo var oWS = new ActiveXObject("WScript.Shell"); >> "%temp_js_file%"
echo var oEnv = oWS.Environment("Process");        >> "%temp_js_file%"
echo var linkfile = oEnv("_K_LinkFile");           >> "%temp_js_file%"
echo var oLink = oWS.CreateShortcut(linkfile);     >> "%temp_js_file%"
echo oLink.TargetPath = oEnv("_K_TargetPath");     >> "%temp_js_file%"
echo oLink.Arguments = oEnv("_K_Arguments");       >> "%temp_js_file%"
echo oLink.Description = oEnv("_K_Description");   >> "%temp_js_file%"
echo oLink.WindowStyle = 1;                        >> "%temp_js_file%"
echo oLink.WorkingDirectory = oEnv("_K_WorkDir");  >> "%temp_js_file%"
echo oLink.Save();                                 >> "%temp_js_file%"
cscript "%temp_js_file%"
del /f "%temp_js_file%"

set temp_js_file=
SET _K_LinkFile=
SET _K_TargetPath=
SET _K_Arguments=
SET _K_Description=
SET _K_WorkDir=

echo 请使用快捷方式 "%linkfile%" 来启动命令行工具
set linkfile=
pause
exit /b 0


REM
REM ================================================================
REM 设置环境变量
REM ================================================================
REM
:SetDevEnv

set JAVA_HOME=jre1.8.0_251
set GROOVY_HOME=groovy-3.0.5
set PATH=%PATH%;%JAVA_HOME%\bin;%GROOVY_HOME%\bin;

:Done
```



## 脚本内容

``` shell
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
```



## 执行命令

运行env.bat产生命令行快捷方式env.lnk，双击打开命令行快捷方式，执行如下命令

``` shell
groovy srcipt.groovy
```



