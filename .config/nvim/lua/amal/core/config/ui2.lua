-- ui2: native Neovim 0.12+ message/cmdline redesign
-- provides pager as a buffer+window.
-- STATUS: disabled, still in beta as of 2026-08-29. re-enable by flipping
-- the condition below once it stabilizes.
if false then
	require("vim._core.ui2").enable({
		enable = true, -- Whether to enable or disable the UI.
		msg = { -- Options related to the message module.
			---@type 'cmd'|'msg' Default message target, either in the
			---cmdline or in a separate ephemeral message window.
			---@type string|table<string, 'cmd'|'msg'|'pager'> Default message target
			---or table mapping |ui-messages| kinds and triggers to a target.
			targets = "cmd",
			cmd = { height = 0.5 },
			dialog = { height = 0.5 },
			msg = {
				height = 0.5,
				timeout = 4000,
			},
			pager = { height = 1 },
		},
	})
end
