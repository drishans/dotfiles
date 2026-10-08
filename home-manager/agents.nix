{
  inputs,
  lib,
  pkgs,
  hostName,
  ...
}:
let
  llmAgents = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
in
{
  # The WSL host is a focused model server. macOS agents remain Brew/native
  # until the nix-darwin configuration becomes the primary package manager.
  home.packages = lib.optionals (hostName == "dOmnix") [
    llmAgents.claude-code
    llmAgents.codex
    llmAgents.herdr
    llmAgents.pi
  ];

  # Configuration is portable and follows the user even where the binaries
  # come from Brew, native installers, or are not installed yet.
  home.file = {
    # One instruction file, deployed under the name each agent looks for.
    ".claude/CLAUDE.md".source = ../config/agents/AGENTS.md;
    ".codex/AGENTS.md".source = ../config/agents/AGENTS.md;

    ".claude/settings.json".source = ../config/claude/settings.json;
    ".pi/agent/models.json".source = ../config/pi/models.json;
    ".pi/agent/settings.json".source = ../config/pi/settings.json;
  };

  xdg.configFile = {
    "herdr/config.toml".source = ../config/herdr/config.toml;
  };
}
