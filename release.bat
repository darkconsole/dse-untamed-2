@echo off

call php patch.php push effoff
call php patch.php push effon
copy .github\README.md UT2-README.md
copy .github\LICENSE.md UT2-LICENSE.md

call "\Program Files\7-Zip\7z.exe" a -tzip -r -xr@.gitignore dse-untamed-v%~1.zip *.esp UT2-README.md UT2-LICENSE.md configs fomod interface meshes patches scripts seq sound textures

del UT2-README.md
del UT2-LICENSE.md
