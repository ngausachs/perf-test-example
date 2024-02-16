@echo off

call setEnv.bat

echo Building tag %LOCAL_TAG% using base image %BASE_IMAGE%

docker build ^
--build-arg __base_image=%BASE_IMAGE% ^
-t %LOCAL_TAG% ^
../../

pause

