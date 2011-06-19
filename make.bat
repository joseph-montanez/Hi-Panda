@ECHO OFF

IF "%1" == "clean" goto clean
:make
    mingw32-make OS=WIN32
    goto end
:clean
    mingw32-make OS=WIN32 clean
:end
