if [ -f "server.pid" ]; then
  pid=$(cat server.pid)

  if ps -p $pid > /dev/null; then
    pgid=$(ps -o pgid= -p $pid)
    kill -TERM "-$pgid"
  fi

  rm server.pid
fi

export PORT=10290
dart bin/server.dart > normal.log 2> error.log &
echo $! > server.pid