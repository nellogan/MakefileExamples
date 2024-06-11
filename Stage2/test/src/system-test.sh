VALGRIND_ENABLED=$1

SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")

python3 $SCRIPTPATH/pytest.py > /dev/null &
PYTHON_PID=$!
sleep 1 # simulate python work needed to interface with MainExecutable
if [ "$VALGRIND_ENABLED" = 1 ]; then
  echo "VALGRIND_ENABLED"
  valgrind --leak-check=full --show-leak-kinds=all --error-exitcode=2 --track-origins=yes --verbose \
	--fair-sched=yes --log-file=./test/valgrind_logs/MainExecutable_out.txt $SCRIPTPATH/../../bin/MainExecutable
else
  $SCRIPTPATH/../../bin/MainExecutable
fi

# If MainExecutable is completed before the python process, interrupt it to end early
kill -2 "$PYTHON_PID"

SYSTEM_TEST_RESULT=$?

if [ $SYSTEM_TEST_RESULT = 0 ]; then
  exit 0
else
  exit 2
fi