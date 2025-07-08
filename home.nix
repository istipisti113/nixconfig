{options, config, pkgs, lib, ... }:
with lib;
let 
  mod = "Mod4";
  nixvim = import (builtins.fetchGit {
    url = "https://github.com/nix-community/nixvim";
    # When using a different channel you can use `ref = "nixos-<version>"` to set it here
  });
  #nur = import (builtins.fetchTarball {
  # url = "https://github.com/nix-community/NUR/archive/main.tar.gz";
  # pin with sha256 for less frequent downloads
  #}) { inherit pkgs; };
in {
  #nixpkgs.overlays = [ nur.overlay ];
  #sway config
  imports = [nixvim.homeManagerModules.nixvim];
  wayland.windowManager.sway = {
    enable = true;
    config = rec {
      startup = [{command = "waybar";}];
      modifier = "Mod4";
      terminal = "alacritty";
      menu = "wofi --show drun";
      bars = [];
      input."*".xkb_layout = "us";
      keybindings = lib.attrsets.mergeAttrsList  [
        #(lib.attrsets.mergeAttrsList)
        {
          "${mod}+Return" = "exec --no-startup-id alacritty";
          "${mod}+p" = "exec --no-startup-id wofi --show drun";
          "${mod}+m" = "exec swaymsg exit";
          "${mod}+q" = "kill";

          #movement
          "${mod}+l" = "exec --no-startup-id bash -c '/home/istipisti113/.config/home-manager/scripts/wrkspc.sh next'"; #workspace to workspace
          "${mod}+h" = "exec --no-startup-id bash -c '/home/istipisti113/.config/home-manager/scripts/wrkspc.sh prev'";
          "${mod}+u" = "exec --no-startup-id bash -c '/home/istipisti113/.config/home-manager/scripts/wrkspc.sh mprev'"; #monitor to monitor
          "${mod}+i" = "exec --no-startup-id bash -c '/home/istipisti113/.config/home-manager/scripts/wrkspc.sh mnext'";

          "${mod}+Shift+l" = "exec --no-startup-id bash -c '/home/istipisti113/.config/home-manager/scripts/wrkspc.sh movenext'";
          "${mod}+Shift+h" = "exec --no-startup-id bash -c '/home/istipisti113/.config/home-manager/scripts/wrkspc.sh moveprev'";
          "${mod}+Shift+u" = "exec --no-startup-id bash -c '/home/istipisti113/.config/home-manager/scripts/wrkspc.sh movemprev'";
          "${mod}+Shift+i" = "exec --no-startup-id bash -c '/home/istipisti113/.config/home-manager/scripts/wrkspc.sh movemnext'";

          "${mod}+k" = "focus right";
          "${mod}+j" = "focus left";
        }
      ];
      output = {
        eDP-1 = {
          scale = "1";
          position = "0 0";
        };
        HDMI-A-1 = {
          scale = "1";
          position = "1920 0";
        };
      };
      workspaceOutputAssign = [
        { workspace = "6"; output = "HDMI-A-1"; }
        { workspace = "7"; output = "HDMI-A-1"; }
        { workspace = "8"; output = "HDMI-A-1"; }
        { workspace = "9"; output = "HDMI-A-1"; }
        { workspace = "10"; output = "HDMI-A-1"; }

        { workspace = "1"; output = "eDP-1"; }
        { workspace = "2"; output = "eDP-1"; }
        { workspace = "3"; output = "eDP-1"; }
        { workspace = "4"; output = "eDP-1"; }
        { workspace = "5"; output = "eDP-1"; }
      ];
    };
    extraConfig = "workspace 1 output eDP-1\nworkspace 2 output eDP-1\nworkspace 6 output HDMI-A-1\nworkspace 7 output HDMI-A-1";
  };

  home.username = "istipisti113";
  home.homeDirectory = "/home/istipisti113";
  home.stateVersion = "25.05";
  home.sessionPath = ["$HOME/.cargo/bin/"];
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    htop
    fortune
    git
    alacritty
    waybar
    wofi
    pavucontrol
    exercism
    oversteer
    solana-cli
    anchor
    rustup
    tree-sitter
    nodejs
    flutter
    nixd
  ];

  #program configs
  programs.git = {
    enable = true;
    userName = "Szabo Istvan";
    userEmail = "pisti4395@gmail.com";
  };
  programs.firefox ={
    enable = true;
    profiles = {
      default = {
        id = 0;
        name = "Default";
        isDefault = true;
        #settings = {
        #  "browser.startup.homepage" = "https://duckduckgo.com";
        #};
        search = {
          force = true;
          default = "ddg";
        };
        extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
          ublock-origin vimium darkreader sponsorblock
        ];
      };
    };
  };


  programs.waybar.settings = {
    enable = true;
    position = "top";
    modules-left = [ "sway/workspaces" "sway/mode" "sway/window" ];
    modules-right = [ "clock" ];
    "sway/workspaces" = {
      all-outputs = true;
      persistent_workspaces = {
        "eDP-1" = [1 2 3 4 5];
        "HDMI-A-1" = [6 7 8 9 10];
      };
    };
    extraConfig = ''
      "sway/workspaces" :{
        "persistent-workspaces":{
          "eDP-1": [1,2,3,4,5],
          "HDMI-A-1": [6,7,8,9,10]
        }
      },
    '';
  };

  programs.nixvim = {
    imports = [
      /home/istipisti113/.config/home-manager/nixvim
    ];
    enable = true;
    highlight.ExtraWhitespace.bg = "red";
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    opts = {
      number = true;
      relativenumber = true;
      shiftwidth = 2;
      expandtab = true;
      smartindent = true;
      undofile = true;
      termguicolors = true;
      signcolumn = "yes";
      scrolloff = 8;
    };

    keymaps = [
      {
        key = "{";
        action = "}";
      }
      {
        key = "}";
        action = "{";
      }
    ];
    colorschemes.tokyonight.enable = false;
    colorschemes.catppuccin.enable = true;

    plugins = {
      treesitter = {
        enable = true;
        settings.indent.enable = true;
        settings.highlight.enable = true;
      };
      cmp.enable = true;
      lualine.enable = true;
      lsp.servers = {
        rust_analyzer = {
          enable = true;
          autostart = true;
          installCargo = true;
          installRustc = true;
        };
        lua_ls.enable = true;
        lua_ls.autostart = true;
        nixd.enable = true;
        nixd.autostart = true;
      };
      lint = {
        enable = true;
        lintersByFt = {
          lua = ["luacheck"];
          nix = ["nix"];
          rust = ["rust-analyzer"];
        };
      };
    };

    extraPlugins = with pkgs.vimPlugins; [
      nvim-lspconfig
    ];
    extraConfigLua = ''
  local function set_cmn_lsp_keybinds()
    local lsp_keybinds = {
      {
        key = "K",
        action = vim.lsp.buf.hover,
        options = {
          buffer = 0,
          desc = "hover [K]noledge with LSP",
        },
      },
      {
        key = "gd",
        action = vim.lsp.buf.definition,
        options = {
          buffer = 0,
          desc = "[g]o to [d]efinition with LSP",
        },
      },
      {
        key = "gy",
        action = vim.lsp.buf.type_definition,
        options = {
          buffer = 0,
          desc = "[g]o to t[y]pe definition with LSP",
        },
      },
      {
        key = "gi",
        action = vim.lsp.buf.implementation,
        options = {
          buffer = 0,
          desc = "[g]o to [i]mplementation with LSP",
        },
      },
      {
        key = "<leader>dj",
        action = vim.diagnostic.goto_next,
        options = {
          buffer = 0,
          desc = "Go to next [d]iagnostic with LSP",
        },
      },
      {
        key = "<leader>dk",
        action = vim.diagnostic.goto_prev,
        options = {
          buffer = 0,
          desc = "Go to previous [d]iagnostic with LSP",
        },
      },
      {
        key = "<leader>r",
        action = vim.lsp.buf.rename,
        options = {
          buffer = 0,
          desc = "[r]ename variable with LSP",
        },
      },
    }

    for _, bind in ipairs(lsp_keybinds) do
      vim.keymap.set("n", bind.key, bind.action, bind.options)
    end
  end
  -- Nix LSP
  require("lspconfig").nixd.setup({
    on_attach = function()
      set_cmn_lsp_keybinds()
    end,
    settings = {
      nixd = {
        formatting = {
          command = { "nixfmt" },
        },
      },
    },
  })
  -- Rust LSP
  require("lspconfig").rust_analyzer.setup({
    root_dir = function(fname)
      return vim.loop.cwd()
    end,
    settings = {
      ['rust-analyzer'] = {
        cargo = {
          allFeatures = true,
        },
      },
    },
    on_attach = function()
      set_cmn_lsp_keybinds()
    end,
  })
  '';
  };

  programs.neovim = {
    enable = true;
    extraPackages = with pkgs; [rust-analyzer telescope ripgrep fd ];
    plugins = with pkgs.vimPlugins; [
      nvim-lspconfig
      nvim-cmp cmp-nvim-lsp cmp-buffer cmp-path cmp_luasnip nvim-lspconfig
      lazy-nvim
    ];
  };
}
