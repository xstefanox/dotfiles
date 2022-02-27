## used when jenv is installed manually by cloning the repository in the user home
if [[ -d "$HOME/.jenv" ]]
then
    export PATH="$HOME/.jenv/bin:$PATH"
fi
