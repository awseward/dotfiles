FROM bash:5.0.7

COPY --from=koalaman/shellcheck:v0.7.0 /bin/shellcheck /bin/shellcheck

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
