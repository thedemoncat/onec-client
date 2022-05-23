#!/bin/bash

if [ -z "$PATH_TMP_BD" ]; then
  PATH_TMP_BD=/tmp/build/ib
fi

if [ -z "${SRC_PATH}" ]; then
  SOURCE_PATH="/onec/cf"
else
  SOURCE_PATH="$SRC_PATH"
fi

1cv8 CREATEINFOBASE File="$PATH_TMP_BD" /AddInList  /DisableStartupDialogs /DisableStartupMessages;

1cv8 DESIGNER /F "$PATH_TMP_BD" /LoadConfigFromFiles "$SOURCE_PATH" /UpdateDBCfg  /DisableStartupDialogs /DisableStartupMessages;

