/'**************************************************************************
 *                                  _   _ ____  _
 *  Project                     ___| | | |  _ \| |
 *                             / __| | | | |_) | |
 *                            | (__| |_| |  _ <| |___
 *                             \___|\___/|_| \_\_____|
 *
 * Copyright (C) 1998 - 2011, Daniel Stenberg, <daniel@haxx.se>, et al.
 *
 * This software is licensed as described in the file COPYING, which
 * you should have received as part of this distribution. The terms
 * are also available at http://curl.haxx.se/docs/copyright.html.
 *
 * You may opt to use, copy, modify, merge, publish, distribute and/or sell
 * copies of the Software, and permit persons to whom the Software is
 * furnished to do so, under the terms of the COPYING file.
 *
 * This software is distributed on an "AS IS" basis, WITHOUT WARRANTY OF ANY
 * KIND, either express or implied.
 *
 **************************************************************************'/ 
#include "crt/stdio.bi"
#include "curl.bi"
 
function Write_Data Cdecl(byval ptr_ as any ptr, byval size as size_t, byval nmemb as size_t, byval stream as any ptr) as size_t 
  dim as integer written = fwrite(ptr_, size, nmemb, stream)
  return written
end function

 function main() as integer
  dim as   CURL ptr curl_handle
  static as zstring ptr headerfilename = @"head.out"
  dim as FILE ptr headerfile
  static as zstring ptr bodyfilename = @"body.out"
  dim as FILE ptr bodyfile
 
  curl_global_init(CURL_GLOBAL_ALL)
 
  /' инициализация сессии curl '/ 
  curl_handle = curl_easy_init()
 
  /' установка URL '/ 
  curl_easy_setopt(curl_handle, CURLOPT_URL, "http://freebasic.justforum.net")
 
  /' нам не нужно уведомление о прогрессе '/ 
  curl_easy_setopt(curl_handle, CURLOPT_NOPROGRESS, 1L)
 
  /' посылать все данные в эту функцию  '/ 
  curl_easy_setopt(curl_handle, CURLOPT_WRITEFUNCTION, @write_data)
 
  /' открытие файлов '/ 
  headerfile = fopen(headerfilename,"w")
  if (headerfile = NULL) then
    curl_easy_cleanup(curl_handle)
    return -1
  end if
  bodyfile = fopen(bodyfilename,"w")
  if (bodyfile = NULL) then
    curl_easy_cleanup(curl_handle)
    return -1
  end if
 
  /' помещать заголовки в этот файловый дескриптор '/ 
  curl_easy_setopt(curl_handle,   CURLOPT_WRITEHEADER, headerfile)
 
  /'
   * Обратите внимание, если вы хотите выводить не в stdout,
   * вам необходимо использовать опцию CURLOPT_WRITEDATA.  '/ 
  curl_easy_setopt(curl_handle,   CURLOPT_WRITEDATA, bodyfile) ' если убрать эту строчку, то html'ка выведется на экран

  /' получить! '/ 
  curl_easy_perform(curl_handle)

/' закрытие файлового дескриптора '/ 
  fclose(bodyfile)
  fclose(headerfile)
 
  /' очистка '/ 
  curl_easy_cleanup(curl_handle)
 
  return 0
end function

end(main())
