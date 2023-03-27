#!/bin/bash
# title: set up python environment
# author: Bin He
# date: 2020-02-20
# usage: sh setup.sh

# install jupyter notebook module
pip3 install notebook --user
# export the path so the shell knows where to find the software you just installed
export PATH=~/.local/bin:$PATH
# now prompt the user to run jupyter notebook
echo "






"
echo "# Please run the following command"
echo
echo "cd; jupyter notebook"
echo
echo "# You should see a browser window open, on which you can choose the folder where you will store your script"
echo "# And you can use the 'new'->'python3' to start a new python3 script"
echo \# In the page that opens, type "print('hello world')" in the box and press Ctrl-Enter
echo
echo

