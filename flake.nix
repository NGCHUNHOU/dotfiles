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
            echo "derivations verify"
            echo "nvim is /nix/store/wsvv52ga5rkpwf7l7iqm05aq9znhfnk6-nixvim/bin/nvim"
            echo "tmux is /nix/store/85q3yp3d524gxxhjycd7mvhm2hfd91v1-tmux-3.5a/bin/tmux"
            echo "rg is /nix/store/6knwdgjjalzrfa1n36xka5vma2a1wa3x-ripgrep-14.1.1/bin/rg"
            echo "fd is /nix/store/js9py061fwf82h0r54kach0xvg2y282f-fd-10.2.0/bin/fd"
            echo "eza is /nix/store/qax5az9sw97ni1lms3xkyv2q86isvs84-eza-0.21.3/bin/eza"
            echo "duf is /nix/store/d60596528psf9almbzg354p88sviic4h-duf-0.8.1/bin/duf"
            echo "dust is /nix/store/5by7ns4r0kk8rzarkn59jkqbdajrgxhb-du-dust-1.2.3/bin/dust"
            echo "sd is /nix/store/pc73rlalq3j1np2zdc8ji41vfm2hxdjq-sd-1.0.0/bin/sd"
            echo "zoxide is /nix/store/crqmh917vxan5lgadxb10lvbpn9227ss-zoxide-0.9.7/bin/zoxide"
            echo "git is /nix/store/v2rxk9xkcxsas64wl7ds31al15cm2wqd-git-2.50.1/bin/git"
            echo ""
            echo "nvim plugins and runtimepath verify"
            echo "runtimepath=~/.local/share/nvim/site,/nix/store/4prb9yvqp15gsgjn5hc8mq6ql7vjxvpm-vim-pack-dir,/nix/store/4prb9yvqp15gsgjn5hc8mq6ql7vjxvpm-vim-pack-dir/pack/*/start/*,/etc/xdg/nvim,/nix/store/g7i75czfbw9sy5f8v7rjbama6lr3ya3s-patchelf-0.15.0/share/nvim/site,/usr/local/share/nvim/site,/usr/share/nvim/site,~/.nix-profile/share/nvim/site,/nix/var/nix/profiles/default/share/nvim/site,/var/lib/snapd/desktop/nvim/site,/nix/store/mvmm0i2jwvjzdbsd3la48f1d48y2k2m3-neovim-unwrapped-0.11.3/share/nvim/runtime,/nix/store/mvmm0i2jwvjzdbsd3la48f1d48y2k2m3-neovim-unwrapped-0.11.3/share/nvim/runtime/pack/dist/opt/matchit,/nix/store/mvmm0i2jwvjzdbsd3la48f1d48y2k2m3-neovim-unwrapped-0.11.3/lib/nvim,/nix/store/4prb9yvqp15gsgjn5hc8mq6ql7vjxvpm-vim-pack-dir/pack/*/start/*/after,/var/lib/snapd/desktop/nvim/site/after,/nix/var/nix/profiles/default/share/nvim/site/after,~/.nix-profile/share/nvim/site/after,/usr/share/nvim/site/after,/usr/local/share/nvim/site/after,/nix/store/g7i75czfbw9sy5f8v7rjbama6lr3ya3s-patchelf-0.15.0/share/nvim/site/after,~/.local/share/nvim/site/after,/etc/xdg/nvim/after"
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
