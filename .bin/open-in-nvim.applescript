-- Build the app bundle with:
--   mkdir -p ~/Applications
--   osacompile -o ~/Applications/Open\ in\ Neovim.app ~/.bin/open-in-nvim.applescript
--
-- Post-compile setup for the generated app bundle:
--   Set a stable bundle id:
--   /usr/libexec/PlistBuddy -c 'Add :CFBundleIdentifier string com.john.open-in-neovim' \
--     ~/Applications/Open\ in\ Neovim.app/Contents/Info.plist 2>/dev/null || \
--   /usr/libexec/PlistBuddy -c 'Set :CFBundleIdentifier com.john.open-in-neovim' \
--     ~/Applications/Open\ in\ Neovim.app/Contents/Info.plist
--
--   Register the app with Launch Services:
--   /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister \
--     -f ~/Applications/Open\ in\ Neovim.app
--
-- Optional post-compile setup:
--   Set Launch Services defaults for desired extensions:
--   brew install duti
--   for ext in css js json jsx md mdx py sh svg toml ts tsx txt yaml yml; do
--     duti -s com.john.open-in-neovim "$ext" all
--   done

on open dropped_items
	repeat with item_ref in dropped_items
		set file_path to POSIX path of item_ref
		do shell script "/Users/john/.bin/open-in-nvim " & quoted form of file_path
	end repeat
end open
