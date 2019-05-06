#! /bin/bash
usage() { echo "Usage: $0 [-d] for a development build" 1>&2; exit 1; }

if [ $# == 0 ]; then usage; fi

while getopts ":dp" opt; do
    case "$opt" in
        d)
          docker-compose -f development-docker-compose.yml build
          ;;
        *)
          usage
          ;;
    esac
done
