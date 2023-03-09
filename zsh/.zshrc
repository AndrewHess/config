PROMPT='%F{blue}%1~%f $ '

alias python=python3
alias passman=/opt/passman

function sublime() {
  if [ -n "$1" ]
  then
    open "$1" -a "Sublime Text"
  else
    open . -a "Sublime Text"
  fi
}

function smresize() {
  if [ -n "$1" ]
  then
    filename=$(basename -- "$1")
    extension="${filename##*.}"
    filename="${filename%.*}"

    ffmpeg -i $1 -vf crop=1080:1080:420:0 "$filename"-instagram."$extension"
    ffmpeg -i $1 -vf scale=1280:720 "$filename"-facebook-twitter."$extension"
  else
    echo "usage: '$0' <image or video>"
  fi  
}

export PATH="$HOME/.cargo/bin:/usr/local/opt/arm-none-eabi-gcc@9/bin:$PATH"
export LDFLAGS="-L/usr/local/opt/arm-none-eabi-gcc@9/lib"

# Export libtorch.
export LIBTORCH=~/.libtorch
export LIBTORCH_LIB=~/.libtorch
export LD_LIBRARY_PATH=${LIBTORCH}/lib:$LD_LIBRARY_PATH

# Use `most` as the default pager, if it's installed.
if command -v most > /dev/null 2>&1; then
    export PAGER="most"
fi

# Enable git autocompletion.
autoload -Uz compinit && compinit
