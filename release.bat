@echo off

call php patch.php push effoff
call php patch.php push effon

call git archive -o dse-untamed-v%~1.zip master *.esp UT2-README.md UT2-LICENSE.md configs fomod interface meshes patches scripts seq sound textures

