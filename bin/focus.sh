#!/usr/bin/env bash
wmctrl -i -a $* && awesome-client "awful.client.urgent.jumpto()"
