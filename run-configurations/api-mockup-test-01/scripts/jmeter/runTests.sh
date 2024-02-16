#!/bin/bash

echo "Checking if IS is up..."

while ! nc -z msr-test-01 5555 ; do
  echo "waiting for Integration server to come up..."
  sleep 5
done

# For best experience, the values here should be consistent with the hystogram buckets in jmeter prometheus metrics

declare -i usersNo=${MIN_USERS_NO:-3}
declare -i usersInc=${USER_NO_INCREMENT:-2}
declare -i maxUsersNo=${MAX_USERS_NO:-8}

declare -i loopCount=${LOOP_COUNT:-200}
declare -i slowMultiplier=${SLOW_MULTIPLIER:-200}
declare -i longLoopCount=${loopCount}*200

declare -i fastMillis=${FAST_MILLIS:-10}
declare -i slowMillis=${fastMillis}*${slowMultiplier}

declare -i minBigBodyBytes=${MIN_BIG_BODY_BYTES:-9000}
declare -i bigBodyBytesIncrement=${BIG_BODY_BYTES_INCREMENT:-30000}
declare -i maxBigBodyBytes=${MAX_BIG_BODY_BYTES:-300000}

echo "Test parameters:"
echo "loopCount=${loopCount}"
echo "slowMultiplier=${slowMultiplier}"
echo "longLoopCount=${longLoopCount}"
echo "fastMillis=${fastMillis}"
echo "slowMillis=${slowMillis}"
echo "minBigBodyBytes=${minBigBodyBytes}"
echo "bigBodyBytesIncrement=${bigBodyBytesIncrement}"
echo "maxBigBodyBytes=${maxBigBodyBytes}"
# echo "=${}"


while [ ${usersNo} -le ${maxUsersNo} ]; do
  echo ""
  echo "Running tests with ${usersNo} users"
  date +%Y-%m-%dT%H.%M.%S_%3N
  echo ""

  declare -i crtBigBodySize=${minBigBodyBytes}
  while [ ${crtBigBodySize} -le ${maxBigBodyBytes} ]; do
    echo ""
    echo "Running tests with ${usersNo} users with ${crtBigBodySize} big service body size"
    date +%Y-%m-%dT%H.%M.%S_%3N
    echo ""

    jmeter -n \
      -JserviceHostname=${API_HOST} \
      -JservicePort=${API_PORT} \
      -JapiUser=${API_USER} \
      -JapiUserPassword=${API_USER_PWD} \
      -JnoOfUsers=${usersNo} \
      -JloopCount=${loopCount} \
      -JquickThreadGroup.loopCount=${longLoopCount} \
      -JfastServiceSleepTime=${fastMillis} \
      -JslowServiceSleepTime=${slowMillis} \
      -JfastServiceBodyChars=48 \
      -JslowServiceBodyChars=${crtBigBodySize} \
      -Jprometheus.ip=0.0.0.0 \
      -Jprotocol=${API_PROTOCOL} \
      -JapiURI=${API_URI} \
      -t /tmp/suite.jmx

    echo ""
    echo "Finished tests with ${usersNo} users with ${crtBigBodySize} big service body size"
    date +%Y-%m-%dT%H.%M.%S_%3N
    echo "Sleeping 60..."
    echo ""

    sleep 60
    declare -i crtBigBodySize+=${bigBodyBytesIncrement}
  done 
  declare -i usersNo+=${usersInc}

  echo ""
  echo "Running tests with ${usersNo} users with ${crtBigBodySize} big service body size"
  date +%Y-%m-%dT%H.%M.%S_%3N
  echo ""
  echo "Sleeping 120..."
  sleep 120
done

echo "tests completed"
