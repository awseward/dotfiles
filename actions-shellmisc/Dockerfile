FROM bash:5.0.7

LABEL "com.github.actions.name"="Misc Shell Checks"
LABEL "com.github.actions.description"="Check on miscellaneous general consistency of shell source in the repo."
LABEL "com.github.actions.icon"="clipboard"
LABEL "com.github.actions.color"="blue"
LABEL "maintainer"="Andrew Seward <awswrd@gmail.com>"

COPY entrypoint.sh /entrypoint.sh
# To get a shell locally to poke around, just do:
# docker build -t foo . && docker run -it --entrypoint bash foo
ENTRYPOINT ["/entrypoint.sh"]
