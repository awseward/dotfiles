FROM bash:5.0

COPY --from=koalaman/shellcheck:v0.7.1 /bin/shellcheck /bin/shellcheck

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
