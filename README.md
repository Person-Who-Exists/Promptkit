# Promptkit
Promptkit is a WIP tool that will allow users to create custom shell prompts using dynamically loadable plugins

## Setup
ZSH
```shell
export PROMPTKIT_SOCKET = $(uuidgen); promptkit init &!
function precmd() { PROMPT = $(promptkit generate); };
trap 'promptkit exit' EXIT;
```
