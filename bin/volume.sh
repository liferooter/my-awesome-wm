#!/usr/bin/env bash

amixer | grep Master -A 6 | tail -n 1 | grep '\[on\]' | cut -d"[" -f2 | tr -d "%]"
