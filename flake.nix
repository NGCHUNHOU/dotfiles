{
  description = "NixVim configuration with minimal store footprint";

  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05" Oct 9, 2025;
    nixpkgs.url = "github:nixos/nixpkgs/5da4a26309e796daa7ffca72df93dbe53b8164c7";

    # nixvim.url = "github:nix-community/nixvim" Oct 10, 2025;
    nixvim.url = "github:nix-community/nixvim/bb9d744b644d160336b7ff681dac1b19db01ba2c";

    # flake-utils.url = "github:numtide/flake-utils" Nov 14, 2024;
    flake-utils.url = "github:numtide/flake-utils/11707dc2f618dd54ca8739b309ec4fc024de578b";
  };

  outputs = { self, nixpkgs, nixvim, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        
        nixvimLib = nixvim.lib.${system};
        nixvim' = nixvim.legacyPackages.${system};
        
        nvim = nixvim'.makeNixvimWithModule {
          inherit pkgs;
          module = {
            # Core settings
            config = {
              viAlias = true;
              vimAlias = true;

              # Basic options
              opts = {
                number = true;
                autochdir = true;
                splitbelow = true;
                splitright = true;
                wildmode = "longest,list,full";
                tabstop = 2;
                shiftwidth = 2;
                expandtab = true;
                title = true;
                clipboard = "unnamed";
                background = "dark";
              };

              # Colorscheme
              colorschemes.catppuccin = {
                enable = true;
                settings = {
                  flavour = "mocha";
                  styles = {
                    conditionals = [];
                  };
                };
              };

              # Plugins
              plugins = {
                web-devicons = {
                  enable = false;
                };

                # UI
                lightline = {
                  enable = true;
                  settings = {
                    colorscheme = "catppuccin";
                  };
                };

                # File navigation
                oil.enable = true;
                
                telescope = {
                  enable = true;
                  keymaps = {
                    "<leader>ff" = "find_files";
                    "<leader>fg" = "live_grep";
                    "<leader>fb" = "buffers";
                    "<leader>fh" = "help_tags";
                    "<leader>fo" = "oldfiles";
                  };
                };

                # Terminal
                toggleterm = {
                  enable = true;
                  settings = {
                    open_mapping = "[[<C-\\>]]";
                    direction = "float";
                  };
                };

                # Syntax highlighting
                treesitter = {
                  enable = true;
                  settings = {
                    highlight.enable = true;
                    indent.enable = true;
                  };
                  # Only install grammars you actually use to save space
                  grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
                    # c
                    lua
                    # nix
                    # Add only what you need:
                    # javascript
                    # typescript
                    # python
                    # rust
                    # markdown
                  ];
                };

                # LSP
                lsp = {
                  enable = true;
                  servers = {
                    # Enable only the LSPs you need
                    # Uncomment the ones you want:
                    
                    # ts_ls.enable = true;  # TypeScript/JavaScript
                    # lua_ls.enable = true;  # Lua
                    # nil_ls.enable = true;  # Nix
                    # rust_analyzer.enable = true;  # Rust
                    # pyright.enable = true;  # Python
                    # clangd.enable = true;  # C/C++
                  };
                };

                # Completion
                cmp = {
                  enable = true;
                  autoEnableSources = true;
                  
                  settings = {
                    mapping = {
                      "<C-j>" = "cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select })";
                      "<C-k>" = "cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select })";
                      "<Tab>" = "cmp.mapping.confirm({ select = true })";
                    };
                    
                    sources = [
                      { name = "nvim_lsp"; }
                      { name = "buffer"; }
                      { name = "path"; }
                    ];
                  };
                };

                # LSP signature
                lsp-signature.enable = true;

                # DAP (Debugging) - disabled by default
                dap = {
                  enable = false;  # Set to true when you need debugging
                  
                  # When enabled, configure adapters:
                  # adapters = {
                  #   executables = {
                  #     coreclr = {
                  #       command = "netcoredbg";
                  #       args = ["--interpreter=vscode"];
                  #     };
                  #   };
                  # };
                  
                  # configurations = {
                  #   cs = [{
                  #     type = "coreclr";
                  #     name = "launch - netcoredbg";
                  #     request = "launch";
                  #   }];
                  # };
                };

                # DAP UI - disabled by default
                # dap.extensions.dap-ui.enable = false;
              };

              # Custom keymaps
              keymaps = [
                # Oil (file manager)
                {
                  mode = "n";
                  key = "<leader>fm";
                  action = "<cmd>Oil<cr>";
                }
                
                # Tag navigation
                {
                  mode = "n";
                  key = "<F11>";
                  action = "<C-]>";
                }
                {
                  mode = "n";
                  key = "<F12>";
                  action = "<C-T>";
                }
                
                # DAP keymaps (only if dap is enabled)
                # {
                #   mode = "n";
                #   key = "<F4>";
                #   action.__raw = "function() require('dap').toggle_breakpoint() end";
                # }
                # {
                #   mode = "n";
                #   key = "<F5>";
                #   action.__raw = "function() require('dap').continue() end";
                # }
                # {
                #   mode = "n";
                #   key = "<F6>";
                #   action.__raw = "function() require('dap').step_over() end";
                # }
                # {
                #   mode = "n";
                #   key = "<F7>";
                #   action.__raw = "function() require('dap').step_into() end";
                # }
                # {
                #   mode = "n";
                #   key = "<F8>";
                #   action.__raw = "function() require('dap').step_out() end";
                # }
                # {
                #   mode = "n";
                #   key = "<F9>";
                #   action.__raw = "function() require('dap').terminate() end";
                # }
              ];

              # Autocommands
              autoCmd = [
                {
                  event = "TermOpen";
                  pattern = "term://*toggleterm#*";
                  callback = {
                    __raw = ''
                      function()
                        vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], {buffer = 0})
                      end
                    '';
                  };
                }
              ];

              # Extra Lua config (for things not covered by NixVim options)
              extraConfigLua = ''
                -- Any additional Lua config goes here
              '';
            };
          };
        };

      in
      {
        packages = {
          default = nvim;
          nvim = nvim;
        };

        devShells.default = pkgs.mkShell {
          buildInputs = [
            nvim
            
            # Rust-based CLI tools
            pkgs.ripgrep
            pkgs.fd
            pkgs.eza
            pkgs.duf
            pkgs.dust
            pkgs.sd
            pkgs.zoxide

            # Dev tools
            pkgs.tmux
            pkgs.git
            
            # Optional: LSP servers (uncomment what you need)
            # pkgs.nodePackages.typescript-language-server
            # pkgs.lua-language-server
            # pkgs.nil
            # pkgs.rust-analyzer
            # pkgs.pyright
            
            # Optional: DAP adapters (uncomment when needed)
            # pkgs.netcoredbg
            # pkgs.vscode-js-debug
          ];

          shellHook = ''
            echo "🚀 NixVim dev environment loaded!"
            echo ""
            echo "nvim: NixVim with all plugins configured"
            echo "Tools: tmux, ripgrep, fd, eza, duf, dust, sd"
            echo ""
            echo "To enable LSP/DAP: Edit flake.nix and uncomment desired servers"
            echo ""
            export EDITOR=nvim
            export VISUAL=nvim
            alias nv="nvim"
            eval "$(zoxide init bash)"
          '';
        };

        apps.default = {
          type = "app";
          program = "${nvim}/bin/nvim";
        };
      }
    );
}
