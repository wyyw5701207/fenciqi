#!/bin/bash

this="$0"
while [ -h "$this" ]; do
  ls=`ls -ld "$this"`
  link=`expr "$ls" : '.*-> \(.*\)$'`
  if expr "$link" : '.*/.*' > /dev/null; then
    this="$link"
  else
    this=`dirname "$this"`/"$link"
  fi
done

if [ -z "$META_HOME" ]; then
  export META_HOME=`dirname "$this"`
fi

META_HOME=`cd "$META_HOME"; pwd`
cd "$META_HOME"

pid=$META_HOME/meta.pid

if [ -f $pid ]; then
   if kill -0 `cat $pid` > /dev/null 2>&1; then
     echo "meta app 正在运行，进程ID为 `cat $pid`。请先停止它。"
     exit 1
   fi
fi

_JAVA_DEBUG=""
if [ "$1" = "-d" ] || [ "$1" = "--debug" ]; then
  _JAVA_DEBUG="-Xdebug -Xrunjdwp:transport=dt_socket,address=8919,server=y,suspend=n"
fi

export OPTION="-Dfile.encoding=UTF-8 -server -Xms4g -Xmx32g $_JAVA_DEBUG -Xss768k -XX:+UnlockExperimentalVMOptions -XX:+UseG1GC -XX:MaxGCPauseMillis=200 -XX:+PrintGCDetails -XX:+PrintGCTimeStamps -XX:+PrintHeapAtGC -XX:+PrintGCApplicationStoppedTime -Xloggc:gc.log -Dproc_server"

if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
  echo "-a 分词器类型 binary 或 ik"
  echo "-r 分词字段 title 或 content"
  echo "-k 分词数量 10000"
  echo "-w 分词长度 2"
  echo "-f 文件夹路径 必填项"
  exit 0
fi

while getopts ":a:r:k:w:f:h" opt; do
  case $opt in
    a)
      # 分词器类型参数
      analyzer_type=$OPTARG
      ;;
    r)
      # 分词字段参数
      tokenizer_fields=$OPTARG
      ;;
    k)
      # 分词数量参数
      tokenizer_limit=$OPTARG
      ;;
    w)
      # 分词长度参数
      tokenizer_length=$OPTARG
      ;;
    f)
      # 文件夹路径参数
      folder_path=$OPTARG
      ;;
    h)
      # 帮助参数
      echo "Usage: start.sh [option]"
      echo ""
      echo "Starts the Meta server."
      echo ""
      echo "Available options:"
      echo ""
      echo "  -h, --help                  Prints the help message and exits."
      echo "  -d, --debug                 Starts the server in debug mode."
      echo "  -a <analyzer_type>          Sets the analyzer type."
      echo "  -r <tokenizer_fields>       Sets the tokenizer fields."
      echo "  -k <tokenizer_limit>        Sets the tokenizer limit."
      echo "  -w <tokenizer_length>       Sets the tokenizer length."
      echo "  -f <folder_path>            Sets the folder path. (required)"
      exit 0
      ;;
    \?)
      echo "Invalid option: -$OPTARG"
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument."
      exit 1
      ;;
  esac
done

# 检查必填参数 -f
OPTION=""
if [ -z "$folder_path" ]; then
  echo "文件夹路径必填，请使用 -f 参数指定文件夹路径。"
  exit 1
fi

# 添加新参数到 Java 启动命令
if [[ -n $analyzer_type ]]; then
  OPTION="$OPTION -a $analyzer_type"
fi

if [[ -n $tokenizer_fields ]]; then
  OPTION="$OPTION -r $tokenizer_fields"
fi

if [[ -n $tokenizer_limit ]]; then
  OPTION="$OPTION -k $tokenizer_limit"
fi

if [[ -n $tokenizer_length ]]; then
  OPTION="$OPTION -w $tokenizer_length"
fi

if [[ -n $folder_path ]]; then
  OPTION="$OPTION -f $folder_path"
fi

export OPTION

echo "正在运行命令:"
echo "nohup java -jar $META_HOME/analyzer-jar-with-dependencies.jar $OPTION > $META_HOME/nohup.out 2>&1 &"
nohup java -jar $META_HOME/analyzer-jar-with-dependencies.jar $OPTION> $META_HOME/nohup.out 2>&1 &
#nohup java $OPTION -jar $META_HOME/guns.jar --spring.config.location=$META_HOME/application-dev.yml > $META_HOME/nohup.out 2>&1 &

echo $! > $pid