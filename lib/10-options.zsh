# Allow comments in interactive shells
setopt interactivecomments

# Allow navigating to directories without cd
setopt auto_cd

# Perform implicit tees/cats if multiple redirections are required
setopt multios

# Perform parameter expansion within prompts
setopt prompt_subst

# Don't trigger bell on user interactions
unsetopt beep
