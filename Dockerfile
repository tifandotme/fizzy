FROM ghcr.io/basecamp/fizzy:main

# Add the label Kamal requires (must match 'service' in deploy.yml)
LABEL service="fizzy"

# Change rails UID to match host eddies UID for volume ownership
USER root
RUN usermod -u 1001 rails
RUN chown -R rails /rails
RUN echo 'net.ipv6.conf.all.disable_ipv6 = 1' >> /etc/sysctl.conf
USER rails
