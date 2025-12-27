FROM ghcr.io/basecamp/fizzy:main

# Add the label Kamal requires (must match 'service' in deploy.yml)
LABEL service="fizzy"
