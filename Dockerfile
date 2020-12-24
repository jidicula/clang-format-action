FROM archlinux:latest

LABEL "com.github.actions.name"="clang-format C Check"
LABEL "com.github.actions.description"="Run clang-format style check for C programs."
LABEL "com.github.actions.icon"="check-circle"
LABEL "com.github.actions.color"="blue"

LABEL "repository"="https://github.com/jidicula/github-action-clang-format.git"
LABEL "homepage"="https://github.com/jidicula/github-action-clang-format"
LABEL "maintainer"="jidicula <johanan.idicula@mail.mcgill.ca>"

# Perform system update
RUN pacman -Syyu --noconfirm

# Install clang, which contains clang-format
RUN pacman -S --noconfirm clang

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
