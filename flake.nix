{
  description = "drishans cross-platform system and home configuration";

  nixConfig = {
    extra-substituters = ["https://cache.numtide.com"];
    extra-trusted-public-keys = [
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    llm-agents.url = "github:numtide/llm-agents.nix";
    codex-desktop-linux.url = "github:ilysenko/codex-desktop-linux";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    home-manager,
    nix-darwin,
    nixos-wsl,
    codex-desktop-linux,
    ...
  }: let
    username = "drishan";

    homeModule = {
      hostName,
      homeDirectory,
      isGui,
    }: {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = "hm-backup";
        extraSpecialArgs = {
          inherit inputs username hostName homeDirectory isGui;
        };
        users.${username} = import ./home-manager/drishan.nix;
      };
    };

    mkNixos = {
      hostName,
      homeDirectory ? "/home/${username}",
      isGui ? false,
      modules,
    }:
      nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs username hostName;};
        modules =
          [
            home-manager.nixosModules.home-manager
            ./modules/nixos/common.nix
            (homeModule {inherit hostName homeDirectory isGui;})
          ]
          ++ modules;
      };
  in {
    nixosConfigurations = {
      dOmnix = mkNixos {
        hostName = "dOmnix";
        isGui = true;
        modules = [
          codex-desktop-linux.nixosModules.default
          ./hosts/dOmnix
        ];
      };
      dwslnix = mkNixos {
        hostName = "dwslnix";
        modules = [
          nixos-wsl.nixosModules.default
          ./hosts/dwslnix
          ./modules/wsl/base.nix
          ./modules/wsl/nvidia.nix
          ./modules/wsl/sglang-qwen.nix
        ];
      };
    };

    darwinConfigurations.macbook = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      specialArgs = {
        inherit inputs username;
        hostName = "macbook";
      };
      modules = [
        ./hosts/macbook
        home-manager.darwinModules.home-manager
        (homeModule {
          hostName = "macbook";
          homeDirectory = "/Users/${username}";
          isGui = true;
        })
      ];
    };

    formatter = {
      x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-tree;
      aarch64-darwin = nixpkgs.legacyPackages.aarch64-darwin.nixfmt-tree;
    };
  };
}
