# nix-shell --run $SHELL
# nix pkgs, https://search.nixos.org/packages 
{ pkgs ? import <nixpkgs> {} }:pkgs.mkShell {
  packages = with pkgs; [
    gum # A tool for glamorous shell scripts.
    gh # github shell
    kind # kind is a tool for running local Kubernetes clusters using Docker container “nodes”.
    kubectl 
    yq-go
    jq
    awscli2 # aws copmmand line tool
    upbound # the upbound cli: https://github.com/upbound/up
    teller # A multi provider secret management tool, https://www.sandeepseeram.com/post/teller-a-secure-secrets-management-tool-for-developers
    crossplane-cli
    kubernetes-helm
    fortune
  ];
  shellHook = ''
    eval "$(/opt/homebrew/bin/brew shellenv)"
    source /opt/homebrew/etc/profile.d/bash_completion.sh # brew install bash-completion
    source <(kubectl completion bash)
    alias k=kubectl
    complete -o default -F __start_kubectl k
    alias kx='f() { [ "$1" ] && kubectl config use-context $1 || kubectl config current-context ; } ; f'
    alias kn='f() { [ "$1" ] && kubectl config set-context --current --namespace $1 || kubectl config view --minify | grep namespace | cut -d" " -f6 ; } ; f'
    alias vi=/opt/homebrew/bin/nvim
  '';
}
