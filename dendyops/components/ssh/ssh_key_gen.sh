#!/bin/bash
mkdir -p ~/.ssh
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ""