#!/bin/sh

OLD=172.16.9.137
NEW=172.16.7.40

#OLD=172.16.7.40
#NEW=172.16.9.137

fgrep -l -r $OLD  ./docs | xargs sed -i -e "s/$OLD/$NEW/g"
