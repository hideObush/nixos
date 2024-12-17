# just is a command runner, Justfile is very similar to Makefile, but simpler.

# Use nushell for shell commands
# To usage this justfile, you need to enter a shell with just & nushell installed:
# 
#   nix shell nixpkgs#just nixpkgs#nushell
set shell := ["nu", "-c"]

utils_nu := absolute_path("utils.nu")

############################################################################
#
#  Common commands(suitable for all machines)
#
############################################################################

# List all the just commands
default:
    @just --list

# Run eval tests
[group('nix')]
test:
  nix eval .#evalTests --show-trace --print-build-logs --verbose

# Update all the flake inputs
[group('nix')]
up:
  nix flake update

# Update specific input
# Usage: just upp nixpkgs
[group('nix')]
upp input:
  nix flake update {{input}}

# List all generations of the system profile
[group('nix')]
history:
  nix profile history --profile /nix/var/nix/profiles/system

# Open a nix shell with the flake
[group('nix')]
repl:
  nix repl -f flake:nixpkgs

# remove all generations older than 7 days
# on darwin, you may need to switch to root user to run this command
[group('nix')]
clean:
  sudo nix profile wipe-history --profile /nix/var/nix/profiles/system  --older-than 7d

# Garbage collect all unused nix store entries
[group('nix')]
gc:
  # garbage collect all unused nix store entries(system-wide)
  sudo nix-collect-garbage --delete-older-than 7d
  # garbage collect all unused nix store entries(for the user - home-manager)
  # https://github.com/NixOS/nix/issues/8508
  nix-collect-garbage --delete-older-than 7d

# Enter a shell session which has all the necessary tools for this flake
[linux]
[group('nix')]
shell:
  nix shell nixpkgs#git nixpkgs#neovim nixpkgs#colmena

# Enter a shell session which has all the necessary tools for this flake
[macos]
[group('nix')]
shell:
  nix shell nixpkgs#git nixpkgs#neovim

[group('nix')]
fmt:
  # format the nix files in this repo
  nix fmt

# Show all the auto gc roots in the nix store
[group('nix')]
gcroot:
  ls -al /nix/var/nix/gcroots/auto/

############################################################################
#
#  NixOS Desktop related commands
#
############################################################################

[linux]
  [group('desktop')]
  hypr mode="default":
  #!/usr/bin/env nu
  use {{utils_nu}} *;
  nixos-switch ai-hyprland {{mode}}


[linux]
  [group('desktop')]
  s-hypr mode="default":
  #!/usr/bin/env nu
  use {{utils_nu}} *;
  nixos-switch shoukei-hyprland {{mode}}



############################################################################
#
#  Neovim related commands
#
############################################################################

[group('neovim')]
nvim-test:
  rm -rf $"($env.home)/.config/nvim"
  rsync -avz --copy-links  home/base/tui/editors/neovim/nvim/ $"($env.home)/.config/nvim/"
  #rsync -avz --copy-links --chmod=d2755,f744 home/base/tui/editors/neovim/nvim/ $"($env.home)/.config/nvim/"

[group('nushell')]
nu-test:
  rm -rf $"($env.home)/.config/nushell/config.nu"
  rsync -avz --copy-links home/base/core/shells/config.nu $"($env.home)/.config/nushell/"

[group('neovim')]
nvim-clean:
  rm -rf $"($env.HOME)/.config/nvim"

[group('hyprland')]
hyprland-test:
  rm -rf $"($env.HOME)/.config/hyprland"
  rsync -avz --copy-links --chmod=D2755,F744 home/linux/gui/hyprland/conf/ $"($env.HOME)/.config/hypr/"
  
# =================================================
# Emacs related commands
# =================================================

[group('emacs')]
emacs-test:
  rm -rf $"($env.HOME)/.config/doom"
  rsync -avz --copy-links --chmod=D2755,F744 home/base/tui/editors/emacs/doom/ $"($env.HOME)/.config/doom/"
  doom clean
  doom sync

[group('emacs')]
emacs-clean:
  rm -rf $"($env.HOME)/.config/doom/"

[group('emacs')]
emacs-purge:
  doom purge
  doom clean
  doom sync

[linux]
[group('emacs')]
emacs-reload:
  doom sync
  systemctl --user restart emacs.service
  systemctl --user status emacs.service


emacs-plist-path := "~/Library/LaunchAgents/org.nix-community.home.emacs.plist"

[macos]
[group('emacs')]
emacs-reload:
  doom sync
  launchctl unload {{emacs-plist-path}}
  launchctl load {{emacs-plist-path}}
  tail -f ~/Library/Logs/emacs-daemon.stderr.log

# =================================================
#
# Other useful commands
#
# =================================================

[group('common')]
path:
   $env.PATH | split row ":"

[linux]
[group('common')]
penvof pid:
  sudo cat $"/proc/($pid)/environ" | tr '\0' '\n'

# Remove all reflog entries and prune unreachable objects
[group('git')]
ggc:
  git reflog expire --expire-unreachable=now --all
  git gc --prune=now

# Amend the last commit without changing the commit message
[group('git')]
game:
  git commit --amend -a --no-edit

# Delete all failed pods
[group('k8s')]
del-failed:
  kubectl delete pod --all-namespaces --field-selector="status.phase==Failed"

[linux]
[group('services')]
list-inactive:
  systemctl list-units -all --state=inactive

[linux]
[group('services')]
list-failed:
  systemctl list-units -all --state=failed
