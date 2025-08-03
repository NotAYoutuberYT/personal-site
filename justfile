root_dir := justfile_directory()
http-server := require("http-server")
nix := require("nix")

default:
    @just --list --justfile {{justfile()}}

alias s := serve
serve:
    {{http-server}} {{root_dir}}/www

alias f := format
format:
    {{nix}} fmt