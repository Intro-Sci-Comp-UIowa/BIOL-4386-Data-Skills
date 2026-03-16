---
title:  Workshop on bash scripting
author: Bin He
date:   2020-02-19
---

# Why write script?
Think and discuss
- What is a script, or a computer program, defined broadly?
- Why write a script, instead of executing the commands one by one in bash?
- What is the use of variables?
- How to define, recall and use a variable in a bash shell and a bash script?
- What does a bash script look like? How to execute it?
    Get into your usual directory for course workshop, use vim to create a file called "myscript.sh"
    ```bash
    #!/bin/sh
    set -e
    set -u
    set -o pipefail
    echo "Hello world!
    ```

# 
