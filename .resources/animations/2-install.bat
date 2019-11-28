@ECHO OFF

echo.
echo Copying to mod directory...
echo.

FOR %%F in (hkx\*-human.hkx) DO (
	echo ^>^> %%F
	xcopy /Y /I /Q %%F ..\..\meshes\actors\character\animations\dse-untamed-2 > nul
)

FOR %%F in (hkx\*-wolf.hkx) DO (
	echo ^>^> %%F
	xcopy /Y /I /Q %%F ..\..\meshes\actors\canine\animations\dse-untamed-2 > nul
)

echo.
rem pause