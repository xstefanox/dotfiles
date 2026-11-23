export MISE_PIN=1

# put the mise shims on PATH, so that the tools are available also outside the interactive shells (e.g. IDEs started from the graphical session)
if command -v mise &> /dev/null
then
    eval "$(mise activate --shims)"
fi
