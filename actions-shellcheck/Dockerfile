FROM bash:5.0.7
COPY --from=koalaman/shellcheck:v0.6.0 /bin/shellcheck /bin/shellcheck
COPY entrypoint.sh /entrypoint.sh
# To get a shell locally to poke around, just do:
# docker build -t foo . && docker run -it --entrypoint bash foo
ENTRYPOINT ["/entrypoint.sh"]
