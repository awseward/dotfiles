FROM bash:5.0.7

LABEL "com.github.actions.name"="Shellcheck"
LABEL "com.github.actions.description"="Use shellcheck to scrutinize shell source."
LABEL "com.github.actions.icon"="clipboard"
LABEL "com.github.actions.color"="blue"
LABEL "maintainer"="Andrew Seward <awswrd@gmail.com>"

COPY --from=koalaman/shellcheck:v0.6.0 /bin/shellcheck /bin/shellcheck
COPY entrypoint.sh /entrypoint.sh
# To get a shell locally to poke around, just do:
# docker build -t foo . && docker run -it --entrypoint bash foo
ENTRYPOINT ["/entrypoint.sh"]
