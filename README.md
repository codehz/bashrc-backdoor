# bashrc-backdoor

A simple backdoor for bashrc

## Features

1. No external dependencies, just bash, script, cat, touch, stat command
2. Basic self protection: clean up .bashrc file when session started, restore before bash exit, so the target will not be able to remove the virus from bashrc easily (or even detect it)
3. No privilege required, no root, no PAM module

## License

WTFPL
