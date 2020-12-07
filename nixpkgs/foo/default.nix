# What a launchd service for https://github.com/awseward/git-events-collector
# based in nix might look like
# {
#   script = ''
#     echo -n "[$(date)] " && echo 'something to process!!!'
#     tree /Users/andrew/.git-events
#     ls -lah /Users/andrew/.git-events/_outbox
#     echo
#   '';
#   serviceConfig.QueueDirectories = [ "/Users/andrew/.git-events/_outbox" ];
#   serviceConfig.StandardOutPath = "/var/log/foobar.log";
#   serviceConfig.StandardErrorPath = "/var/log/foobar.log";
# }

# For now, just leave it as an empty attribute set
{}
