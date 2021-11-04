# new.R

R program to create a new R program. 

# Description

```
$ ./new.R --help
usage: ./new.R [-h] [-n NAME] [-e EMAIL] [-p PURPOSE] [-f] PRG

Create a new R file

positional arguments:
  PRG                   New R file name

optional arguments:
  -h, --help            show this help message and exit
  -n NAME, --name NAME  Name for docstring
  -e EMAIL, --email EMAIL
                        Email address
  -p PURPOSE, --purpose PURPOSE
                        Purpose of program
  -f, --force           Overwrite existing
  ```

### Setting your own defaults

The defaults can be changed by creating a "~/.new_R" configuration file with any or all of the following fields: name, email, purpose.

For example, mine looks like:

```
$ cat ~/.new.R
name=Kenneth Schackart
email=schackartk1@gmail.com
```

By doing so, I do not need to use the `-e|--email`, or `-n|--name` flags to include my information in the template by default.


## Adding to $PATH

You can copy the `new.R` program to any directory currently in your `$PATH`.
It's common to place programs into a directory like `/usr/local/bin`, but this often will require root priviliges.
A common workaround is to create a writable directory in your `$HOME` where you can place programs.
One option is to use `$HOME/.local` as the "prefix" for local software installations. You can copy the program there:

```
$ cp new.R ~/.local/bin
```

To make sure that this directory is on your `$PATH`, you can add this to your `.bash_profile` (or `.bashrc`) file:

```
export PATH=$HOME/.local/bin:$PATH
```

Acknowledgement: The concept is adapted from [new-py](https://github.com/kyclark/new.py) by Ken Youens-Clark