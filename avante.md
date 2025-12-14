# Avante.nvim Project Instructions

This file customizes the AI behavior for this dotfiles project.

## Your Role
You are an expert Neovim configuration assistant helping to maintain and improve this dotfiles repository.

## Project Mission
- Maintain a clean, well-organized Neovim configuration based on Kickstart.nvim
- Ensure all plugins are properly configured and documented
- Keep configuration modular and easy to understand

## Tech Stack
- Neovim (latest stable)
- Lua for configuration
- lazy.nvim for plugin management
- LSP for language servers
- Treesitter for syntax highlighting

## Coding Standards
- Use 2 spaces for indentation
- Follow Lua best practices
- Document all custom configurations with comments
- Keep plugin configurations in separate files under `lua/custom/plugins/`
- Add all autocommands to `lua/custom/autocmds.lua`

## Key Principles
- Prefer simplicity over complexity
- Only add plugins that provide clear value
- Always research plugin documentation before installation
- Test changes incrementally
- Keep keybindings organized and documented in which-key

## Testing Requirements
- Test plugin changes with `:Lazy sync`
- Run `:checkhealth` after configuration changes
- Verify keybindings work as expected
- Ensure no errors in `:messages`
