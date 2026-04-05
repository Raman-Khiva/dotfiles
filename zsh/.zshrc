#neofetch --ascii_distro ARCH
# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME=""

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh
export GROQ_API_KEY=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
# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias sin='sudo apt install'
alias siny='sudo apt install -y'
alias rs='source ~/.zshrc'
alias nbsh='nano ~/.bashrc'
alias cls='clear'
alias nvmi='nvm install'
alias npi='npm install'
alias noi='node install'
alias dd='cd projects/personal_projects/DeepDock/'
alias hm='cd ~'
alias acp='apt-cache policy'
alias nos='npm run server'
alias nod='npm run dev'
alias nzsh='nano ~/.zshrc'
alias bat="batcat"
alias clsr="cls && rs"
alias rscl="rs && cls"
alias tks="tmux kill-session -t"
alias tns="tmux new -s"
alias sau="sudo apt update"

addProject() {
  local token="$1"
  local project_json="$2"

  http POST :5000/api/projects \
    Authorization:"Bearer $token" \
    project:="$project_json"
}



# file search
alias fswp="fzf --preview 'batcat --style=numbers --color=always --line-range :500 {}'"

q() {
  local model="meta-llama/llama-4-scout-17b-16e-instruct"
  local max_tokens=150
  local system_prompt="Answer in 1-4 lines max. Just the related commands and their too short description."

  while getopts "isd" opt; do
    case $opt in
      i)
        system_prompt="Give the direct answer or command only. Add a 2-3 word description only if absolutely necessary."
        max_tokens=60
        ;;
      s)
        system_prompt="Answer in up to 5 lines. For commands include usage, for general questions give a concise but complete answer."
        max_tokens=250
        ;;
      d)
        system_prompt="Answer in up to 15 lines. Be thorough and structured. Include examples where helpful. Cover edge cases if relevant."
        max_tokens=600
        ;;
    esac
  done
  shift $((OPTIND - 1))

  local query="$*"
  local payload=$(jq -n \
    --arg q "$query" \
    --arg m "$model" \
    --arg s "$system_prompt" \
    --argjson t "$max_tokens" \
    '{
      model: $m,
      max_tokens: $t,
      messages: [
        {role: "system", content: $s},
        {role: "user", content: $q}
      ]
    }')

  curl -s https://api.groq.com/openai/v1/chat/completions \
    -H "Authorization: Bearer $GROQ_API_KEY" \
    -H "Content-Type: application/json" \
    -d "$payload" | jq -r ".choices[0].message.content"
}

push(){
   git status
   git add .
   git status
   git commit -m "$1"
   git status
   git push -u origin main
   git status
}
alias ta="tmux attach -t"
alias tls="tmux ls"
alias ls="eza --icons"
alias gs="git status"
alias grv="git remote -v"
alias su="sudo update"
alias suy="sudo upgrade -y"

eval "$(starship init zsh)"
# ~/.zshrc 
ans() {
  ollama run qwen2.5-coder:3b "You are a concise Linux CLI assistant. Answer in 1-3 lines maximum. No explanations unless asked. Just the command and a one-line description." "$*"
}

export FZF_DEFAULT_OPTS="--height 80%  --border"
export FZF_CTRL_T_OPTS="--preview 'batcat --style=numbers --color=always {}'"
export OLDTOKEN="eyJhbGciOiJSUzI1NiIsImNhdCI6ImNsX0I3ZDRQRDExMUFBQSIsImtpZCI6Imluc18zQWxlOHlrMEFmdVhMWEd5cExUSGIyWFlyTkEiLCJ0eXAiOiJKV1QifQ.eyJhenAiOiJodHRwOi8vMjAuMjA0LjIxNi4yMjM6MzAwMCIsImV4cCI6MTc3MzE4MDg0OSwiZnZhIjpbMywtMV0sImlhdCI6MTc3MzE4MDc4OSwiaXNzIjoiaHR0cHM6Ly9hbWF6aW5nLWxpb25lc3MtMzAuY2xlcmsuYWNjb3VudHMuZGV2IiwibmJmIjoxNzczMTgwNzc5LCJzaWQiOiJzZXNzXzNBbHdlY0hKUk83Y2laM3NkZklwb3Bsb0ZFRCIsInN0cyI6ImFjdGl2ZSIsInN1YiI6InVzZXJfM0Fsa2ViaVVnMDdBOFRIV1kzQWtOa2tlVXZnIiwidiI6Mn0.ikrEbEDYylU-MmAnuNhj9MvLroJ3oTWk4EDp3oblLfpFyFBZlO4tqOzOAO_DlfNuvrnZEXK-BOd2OA8rjP_5N5KGH2rxTp-m15wX5kNVz7cC1osuaaYeeHqi_a5qnwypds27PITZW-wKJv5GlqMn8g9t-8u9dFg_EIayS-4ECDLmL8ASEcGw8_Ex3_lcXF66iQq5TMVkJRtvuVs7llbNqmEdI_Hn0wWLIXXTy2cjJCnTezMKw3U5iSKwRvfhfCYRE8ek0EqihmnX1KyYXk_G6I7NhITPOK-JAplMOvB6JohorOQiwn5f7YoTC647tPYL9HzoVhgXu3OhaKLu-u5RFw"



export TOKEN="eyJhbGciOiJSUzI1NiIsImNhdCI6ImNsX0I3ZDRQRDExMUFBQSIsImtpZCI6Imluc18zQWxlOHlrMEFmdVhMWEd5cExUSGIyWFlyTkEiLCJ0eXAiOiJKV1QifQ.eyJhenAiOiJodHRwOi8vMjAuMjA0LjIxNi4yMjM6MzAwMCIsImV4cCI6MTc3MzE4MTcxNSwiZnZhIjpbMTgsLTFdLCJpYXQiOjE3NzMxODE2NTUsImlzcyI6Imh0dHBzOi8vYW1hemluZy1saW9uZXNzLTMwLmNsZXJrLmFjY291bnRzLmRldiIsIm5iZiI6MTc3MzE4MTY0NSwic2lkIjoic2Vzc18zQWx3ZWNISlJPN2NpWjNzZGZJcG9wbG9GRUQiLCJzdHMiOiJhY3RpdmUiLCJzdWIiOiJ1c2VyXzNBbGtlYmlVZzA3QThUSFdZM0FrTmtrZVV2ZyIsInYiOjJ9.iJyjtIBndVjFMYm-zW4VLT_qllHUxs8svEGX6mt3LpnhpIwi53sFGnTQz3QsUYQ37NUX0HO775TbhuOUp0O8-VjkvIbU53jaZ9KH0CE5vR9UFa49Vao6X_C2jMSthliH6VXxYmpL0-vCxHs6MZiHGXOF-uQhxANUZxh6WkMAupZDGlx-uOt0X1OYiA4J2GWozEu140XnJG1J6I8SYtfJuJ9pL5RTeIQIf1y9YmhKlJzolW84sQGQN3uO5NzRIVsFsMe2QHfUrlluhJKV9kZlCfg4rvuGFqoG1jP4rgUG9F5K8EaP7E6JCA22P4T0nsHuPrIgQ7hbU83r6T3YxZdfQw"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
eval "$(zoxide init zsh)"
alias gst="git status"

alias qa=gemini

alias cplt='copilot'
alias druns="doppler run -- node src/index.js"
alias venv="source venv/bin/activate"
alias fastapp="uvicorn main:app --host 0.0.0.0 --port 5000 --reload"
alias health="http :5000/api/health"

. "$HOME/.local/bin/env"
