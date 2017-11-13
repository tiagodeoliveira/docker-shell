#!/bin/bash
ps cax | grep lemonade> /dev/null
if [ $? -eq 0 ]; then
  echo "lemonade is running."
else
  echo "lemonade is not running."
  nohup lemonade server &
fi
