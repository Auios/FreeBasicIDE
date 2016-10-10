'//
'// Network communications module wrapper
'// 
'// These functions should be used instead of calling platform specific network things
'//
'// Made by Jattenalle

#include "debugTools.bi"

#ifdef __FB_WIN32__
  #include once "win/winsock.bi"
#endif

#define S_RECV	0
#define S_SEND	1
#define S_ERROR	2

'cast(ubyte ptr, @myConnection.ip)[0], cast(ubyte ptr, @myConnection.ip)[1], cast(ubyte ptr, @myConnection.ip)[2], cast(ubyte ptr, @myConnection.ip)[3]


'// Server and HTTP
const RECVBUFFLEN = 65536
const NEWLINE = chr(13, 10)

dim shared as fd_set SOCKETS_Read, SOCKETS_Write, SOCKETS_Exception
dim shared as timeval TIMEOUT
TIMEOUT.tv_sec=0
TIMEOUT.tv_usec=0


type _CONNECTION_
	socket as SOCKET
	socket_in as sockaddr_in
	ia as in_addr
	ip as integer
	hostentry as hostent ptr
	kill as integer
	active as uinteger
	established as uinteger
	identified as integer
'	lastSend as integer
'	lastRecv as integer
end type

'// Takes hostname, resolves to packed IP (integer)
function NET_resolveHost( hostname as string ) as integer
	dim ia as in_addr
	dim hostentry as hostent ptr
	ia.S_addr = inet_addr( hostname )
	if ia.S_addr = INADDR_NONE then
		hostentry = gethostbyname( hostname )
		if hostentry = 0 then
			return 0
		end if
		return *cast( integer ptr, *hostentry->h_addr_list ) '// ptr ptr bullshit...
	else
		return ia.S_addr
	end if
end function

'// Returns 0 on success, anything else is an error code
function nw_send(byval cc as _CONNECTION_, byval dat as any ptr, byval dataLen as integer) as integer
	dim as integer result = send( cc.socket, dat, dataLen, 0 )
	if result = SOCKET_ERROR then
		return WSAGetLastError
	else
		return 0
	end if
end function

'// Returns number of bytes received if no error, returns error code on error. Error code must be < 0
function nw_recv(byval cc as _CONNECTION_, byval buffer as any ptr, byval bufferlen as integer=RECVBUFFLEN) as integer
	dim as integer bytes = recv( cc.socket, buffer, bufferlen, 0 )
	if bytes < 0 then db("ERROR: nw_ERR"& bytes &" when receiving on socket "& cc.socket &" ["& cc.ip &"]")
	return bytes
end function

'// Add a connection to the socket sets
function nw_set(byval cc as _CONNECTION_) as integer
	FD_ZERO(@SOCKETS_Read)
	FD_ZERO(@SOCKETS_Write)
	FD_ZERO(@SOCKETS_Exception)
	FD_SET_(cc.socket, @SOCKETS_Read)
	FD_SET_(cc.socket, @SOCKETS_Write)
	FD_SET_(cc.socket, @SOCKETS_Exception)
	return TRUE
end function

'// Check socket for activity using socket sets, returns number of active sockets in the set (should just be 1 or 0)
function nw_select() as integer
	return select_(0, @SOCKETS_Read, @SOCKETS_Write, @SOCKETS_Exception, @TIMEOUT)
end function

'// Check a specific socket set for activity
function nw_isset(byval cc as _CONNECTION_, byval w as integer) as integer
	if w = S_RECV then
		return FD_ISSET(cc.socket, @SOCKETS_Read)
	elseif w = S_SEND then
		return FD_ISSET(cc.socket, @SOCKETS_Write)
	elseif w = S_ERROR then
		return FD_ISSET(cc.socket, @SOCKETS_Exception)
	end if
end function

'// Connect to uri on port using cc, return 0 on success, anything else is an error code
function nw_connect(byval cc as _CONNECTION_ ptr, byval uri as string, byval port as integer) as integer
	cc->ip							=	NET_resolveHost(uri)
	cc->socket_in.sin_port			=	htons( port )
	cc->socket_in.sin_family		=	AF_INET
	cc->socket_in.sin_addr.S_addr	=	cc->ip
	cc->socket						=	opensocket(AF_INET, SOCK_STREAM, IPPROTO_TCP)
	if cc->socket=INVALID_SOCKET then
		db("ERROR: Unable to open socket.")
		cc->socket = 0
		return -1 '// Error
	else
		if connect( cc->socket, cast( PSOCKADDR, @cc->socket_in ), len( cc->socket_in )) = SOCKET_ERROR then
			dim as ubyte ptr i = cptr(ubyte ptr, @cc->ip)
			db("ERROR: "& uri &" ["& i[0] &"."& i[1] &"."& i[2] &"."& i[3] &"] is unreachable")
			closesocket( cc->socket )
			cc->socket = 0
			return -2 '// Error
		else
			return 0 '// All went well!
		end if
	end if
end function

'// Disconnect and clear a socket, must not fail!
function nw_disconnect(byval cc as _CONNECTION_ ptr) as integer
	shutdown(cc->socket, SD_BOTH)
	closesocket(cc->socket)
	cc->socket = 0
	return TRUE
end function