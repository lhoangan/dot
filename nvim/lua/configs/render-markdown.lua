-- https://github.com/MeanderingProgrammer/render-markdown.nvim?tab=readme-ov-file#setup
--
require('render-markdown').setup({
    pipe_table = {
        enabled = false,
    },
    code = {
        border = "thin"} -- changed from "hide" to allow space above/below block, less flickering
})
