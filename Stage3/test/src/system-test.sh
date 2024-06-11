VALGRIND_ENABLED=$1
COMPUTESANITIZER_ENABLED=$2

SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")
TEST_DIR=$(dirname "$SCRIPTPATH")
VALGRIND_LOGS_DIR="$TEST_DIR"/valgrind_logs
COMPUTESANITIZER_LOGS_DIR="$TEST_DIR"/compute-sanitizer_logs
MAIN_EXECUTABLE=$(dirname "$TEST_DIR")/bin/MainExecutable

MODE=$1$2

VALGRIND_STATUS=0
VALGRIND_COMMAND="valgrind --leak-check=full --gen-suppressions=all --show-leak-kinds=all --error-exitcode=2 \
--track-origins=yes --verbose --log-file=$VALGRIND_LOGS_DIR/MainExecutable_out.txt --fair-sched=yes \
--suppressions=$TEST_DIR/util/CUDA_SUPPRESSIONS.supp $MAIN_EXECUTABLE"

COMPUTESANITIZER_STATUS=0
COMPUTESANITIZER_COMMAND="compute-sanitizer --error-exitcode 2 --tool memcheck --leak-check full  \
--log-file $TEST_DIR/compute-sanitizer_logs/MainExecutable_out.txt $MAIN_EXECUTABLE"

python3 $SCRIPTPATH/pytest.py > /dev/null &
PYTHON_PID=$!
sleep 1 # sleep 1 -> simulate python work needed to interface with MainExecutable
if [ "$MODE" = "11" ]; then
  $VALGRIND_COMMAND
  if [ $? != 0 ]; then
    VALGRIND_STATUS=2
  fi

  # ending python component to restart from the beginning for second error checker
  kill -2 "$PYTHON_PID"
  python3 $SCRIPTPATH/pytest.py > /dev/null &
  PYTHON_PID=$!
  sleep 1
  $COMPUTESANITIZER_COMMAND
  if [ $? != 0 ]; then
    COMPUTESANITIZER_STATUS=2
  fi

elif [ "$MODE" = "10" ]; then
  $VALGRIND_COMMAND
  if [ $? != 0 ]; then
    VALGRIND_STATUS=2
  fi

elif [ "$MODE" = "01" ]; then
  $COMPUTESANITIZER_COMMAND
  if [ $? != 0 ]; then
    COMPUTESANITIZER_STATUS=2
  fi

else
  $SCRIPTPATH/../../bin/MainExecutable
fi

kill -2 "$PYTHON_PID"

printf "VALGRIND_STATUS: $VALGRIND_STATUS \n"
printf "COMPUTESANITIZER_STATUS: $COMPUTESANITIZER_STATUS \n"
SYSTEM_TEST_RESULT=$VALGRIND_STATUS$COMPUTESANITIZER_STATUS

if [ "$SYSTEM_TEST_RESULT" = "00" ]; then
  exit 0
elif [ "$SYSTEM_TEST_RESULT" = "10" ]; then
  exit 2
elif [ "$SYSTEM_TEST_RESULT" = "01" ]; then
  exit 3
else
  exit 4
fi