{
  description = "drishans cross-platform system and home configuration";

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
    codex-desktop-linux = {
      url = "github:ilysenko/codex-desktop-linux";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      nix-darwin,
      nixos-wsl,
      codex-desktop-linux,
      treefmt-nix,
      ...
    }:
    let
      username = "drishan";
      systems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;

      treefmtEval = forAllSystems (
        system:
        treefmt-nix.lib.evalModule nixpkgs.legacyPackages.${system} {
          projectRootFile = "flake.nix";

          programs = {
            nixfmt.enable = true;
            prettier.enable = true;
            stylua.enable = true;
            taplo.enable = true;
          };

          settings.formatter.nixfmt.excludes = [
            "hosts/dOmnix/hardware-configuration.nix"
          ];
        }
      );

      homeModule =
        {
          hostName,
          homeDirectory,
          isGui,
        }:
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            backupFileExtension = "hm-backup";
            extraSpecialArgs = {
              inherit
                inputs
                username
                hostName
                homeDirectory
                isGui
                ;
            };
            users.${username} = import ./home-manager/drishan.nix;
          };
        };

      mkNixos =
        {
          hostName,
          homeDirectory ? "/home/${username}",
          isGui ? false,
          modules,
        }:
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs username hostName; };
          modules = [
            home-manager.nixosModules.home-manager
            ./modules/shared/nix.nix
            ./modules/nixos/common.nix
            (homeModule { inherit hostName homeDirectory isGui; })
          ]
          ++ modules;
        };
    in
    {
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
          ./modules/shared/nix.nix
          ./hosts/macbook
          home-manager.darwinModules.home-manager
          (homeModule {
            hostName = "macbook";
            homeDirectory = "/Users/${username}";
            isGui = true;
          })
        ];
      };

      formatter = forAllSystems (system: treefmtEval.${system}.config.build.wrapper);

      checks = forAllSystems (system: {
        formatting = treefmtEval.${system}.config.build.check self;
      });
    };
}
