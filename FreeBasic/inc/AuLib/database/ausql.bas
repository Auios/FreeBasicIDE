'AuSQL.bi
'9/15/2017

#include once "mysql\mysql.bi"
#define NULL 0

type AuSQL
    as string host, user, pass, dbName
    as uinteger port, flag
    
    as MYSQL ptr conn
    as MYSQL_RES ptr res
    as MYSQL_ROW row
    
    declare function connect(host as string, user as string, pass as string, dbName as string, port as uinteger = 3306, flag as uinteger = 0) as integer
    declare function getError() as string
    declare function getErrorMessage() as string
    declare function getErrorNo() as uinteger
    declare function query(stmt as string) as integer
    declare function getRowCount() as uinteger
    declare function getFieldCount() as uinteger
    declare function getRow() as integer
    declare function getItem(index as uinteger) as string
    declare sub close()
end type

function AuSQL.connect(host as string, user as string, pass as string, dbName as string, port as uinteger = 3306, flag as uinteger = 0) as integer
    this.conn = mysql_init(NULL)
    this.host = host
    this.user = user
    this.pass = pass
    this.dbName = dbName
    this.port = port
    this.flag = flag
    if(mysql_real_connect(this.conn, this.host, this.user, this.pass, this.dbName, this.port, NULL, this.flag) = NULL) then
        return 1
    else
        return 0
    end if
end function

function AuSQL.getError() as string
    return "ERROR " & this.getErrorNo() & ": " & this.getErrorMessage()
end function

function AuSQL.getErrorMessage() as string
    return "'" & mysql_error(this.conn) & "'"
end function

function AuSQL.getErrorNo() as uinteger
    return mysql_errNo(this.conn)
end function

function AuSQL.query(stmt as string) as integer
    dim as integer result = mysql_query(this.conn, stmt)
    if(result = 0) then
        mysql_free_result(this.res)
        this.res = mysql_store_result(this.conn)
    end if
    return result
end function

function AuSQL.getRowCount() as uinteger
    return mysql_num_rows(this.res)
end function

function AuSQL.getFieldCount() as uinteger
    return mysql_num_fields(this.res)
end function

function AuSQL.getRow() as integer
    this.row = mysql_fetch_row(this.res)
    if(row = NULL) then
        return 0
    else
        return 1
    end if
end function

function AuSQL.getItem(index as uinteger) as string
    return *this.row[index]
end function

sub AuSQL.close()
    mysql_close(this.conn)
end sub
