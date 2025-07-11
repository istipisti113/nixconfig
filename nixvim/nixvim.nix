{options, config, pkgs, lib, ... }:
{
    imports = [
      /home/istipisti113/.config/home-manager/nixvim/cmp.nix
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
}
