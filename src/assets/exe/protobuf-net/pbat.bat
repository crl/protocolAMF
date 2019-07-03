
set input=%1%
set output=%2%
echo %input%
echo %output%
::protogen -i:%input% -o:%output%
protogen -i:gunner/tmp.proto -o:gunner/tmp.cs
pause>nul