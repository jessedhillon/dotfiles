#!/bin/bash

set -x

PYTHON=/home/jesse/.virtualenvs/crontab/bin/python
GUM2RSS=/home/jesse/Devel/crontab/gumroad2rss.py
GUMROAD_ID=16427246c157936a7aa29439b06d51ee
SECRET=btpzvYrGWYWFN2r7wudaF2x7LPLXDZtS
$PYTHON $GUM2RSS $GUMROAD_ID bap $SECRET
