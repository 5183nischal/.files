#!/usr/bin/env bash

# kitty +kitten icat --transfer-mode file --clear

kitty +kitten icat --clear --stdin no --silent --transfer-mode file < /dev/null > /dev/tty
