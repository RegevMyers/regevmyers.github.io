set shell := [ "bash", "-cu" ]

@_default: 
    echo
    just --list --unsorted
    echo

# Test
[group("run")]
@local:
    bundle install
    bundle exec jekyll serve --livereload

# Fetch
[group("vcs")]
@fetch:
    git fetch origin

# Pull
[group("vcs")]
@pull: (fetch)
    git pull

timestamp := shell("date -u")

# Push
[group("vcs")]
@push +msg=timestamp:
    git add -A
    - git commit -m "{{ msg }}"
    git push -u origin HEAD

# Lines of Code
[group("util")]
@loc:
    fdfind -e rs -E mod.rs --strip-cwd-prefix -0 | xargs -0 wc -l | sort -n -r | sed -E $'1s|(.*)|\033[1m\\1\033[0m|'

# Clear
[group("util")]
@clear:
    clear

