#include once "mysql\mysql.bi"

#define NULL 0

dim as string host = "localhost"
dim as string user = "root"
dim as string pass = "5018"
dim as string dbName = "Telchaxy"
dim as uinteger port = 3306
dim as string unix_socket
dim as uinteger flag = 0

'==================

dim as MYSQL ptr conn
dim as MYSQL_RES ptr res
dim as MYSQL_ROW row


conn = mysql_init(NULL)

if(mysql_real_connect(conn, host, user, pass, dbName, port, NULL, flag) = 0) then
    print("ERROR " & mysql_errNo(conn) & ": '" & mysql_error(conn) & "'")
    sleep(): end(1)
end if

print("Connected to database...")

mysql_query(conn, "SELECT * FROM people")
res = mysql_store_result(conn)
print mysql_num_fields(res)
print mysql_num_rows(res)
do
    row = mysql_fetch_row(res)
    
    if(row = NULL) then
        print "End of table..."
        exit do
    end if
    
    dim as uinteger fieldCount = mysql_num_fields(res)
    dim as string rowStr
    for i as integer = 0 to fieldCount-1
        if(row[i] = NULL) then
            rowStr+="NULL"
        else
            rowStr+=*row[i]
        end if
        
        if(i < fieldCount-1) then rowStr+=", "
    next i
    print rowStr
loop

mysql_free_result(res)
mysql_close(conn)

sleep()