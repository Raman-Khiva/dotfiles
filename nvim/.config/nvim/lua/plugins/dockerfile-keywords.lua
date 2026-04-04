-- ~/.config/nvim/lua/plugins/dockerfile-keywords.lua

return {
  -- No plugin needed, pure autocmd config
  {
    "nvim-lua/plenary.nvim", -- dummy dep anchor; config runs on VeryLazy
    event = "VeryLazy",
    config = function()
      local dockerfile_keywords = {
        "from", "run", "cmd", "label", "expose", "env", "add", "copy",
        "entrypoint", "volume", "user", "workdir", "arg", "onbuild",
        "stopsignal", "healthcheck", "shell", "maintainer",
      }

      local keyword_set = {}
      for _, kw in ipairs(dockerfile_keywords) do
        keyword_set[kw] = true
      end

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "dockerfile",
        group = vim.api.nvim_create_augroup("DockerfileKeywords", { clear = true }),
        callback = function(ev)
          vim.keymap.set("i", "<Space>", function()
            local line = vim.api.nvim_get_current_line()
            local col = vim.api.nvim_win_get_cursor(0)[2] -- 0-indexed

            -- grab the word immediately before the cursor
            local before = line:sub(1, col)
            local word = before:match("(%a+)%s*$")

            if word and keyword_set[word:lower()] then
              -- replace the word with its uppercase version
              local start_col = col - #word
              vim.api.nvim_buf_set_text(
                0,
                vim.api.nvim_win_get_cursor(0)[1] - 1, -- 0-indexed row
                start_col,
                vim.api.nvim_win_get_cursor(0)[1] - 1,
                col,
                { word:upper() }
              )
            end

            -- insert the space normally
            return "<Space>"
          end, { buffer = ev.buf, expr = true, noremap = true })
        end,
      })
    end,
  },
}
