FROM bash:5.0.7

LABEL "com.github.actions.name"="Shebang Check"
LABEL "com.github.actions.description"="Check on shebang consistency in a repository (in a _just slightly_ opinionated way)"
LABEL "com.github.actions.icon"="clipboard"
LABEL "com.github.actions.color"="blue"

LABEL "maintainer"="Andrew Seward <awswrd@gmail.com>"

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
