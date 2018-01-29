#pragma once

#include "wshelper.bi"

hStart()

type connection
    as boolean isHost = false
    as socket sock = 0
    as integer ip = 0
    as integer port = 0
    
    declare sub open()
    declare sub close()
    declare sub connect(IP as integer)
    declare sub connect(sIP as string)
    'declare sub disconnect()
    declare function getIP() as string
end type

sub connection.open()
    this.sock = hOPen()
end sub

sub connection.close()
    hClose(this.sock)
end sub

sub connection.connect(IP as integer)
    if(NOT this.isHost) then
        this.ip = IP
    end if
end sub

sub connection.connect(sIP as string)
    if(NOT this.isHost) then
        this.ip = hResolve(sIP)
    end if
end sub

function connection.getIP() as string
    return hIPtoString(this.IP)
end function
