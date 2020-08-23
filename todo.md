* ~~wmii style tag management~~
 - ~~dynamic~~
 - ~~volatile~~
 - ~~automatically create new tag when going -> past existing tags~~
* ~~tag hydra~~
 - ~~manage properties like layout, gaps, columns, master width factor~~
* workspaces
 - ~~hide tags not part of current workspace~~
 - spawn programs like Firefox and chrome differently when in a workspace (profiles)
 - improve workspace switcher
 - ~~persistence~~
 - ~~identicons for each workspace~~
 - ~~persist previously used workspace names in the perma.json file~~
* ~~sticky clients/familiars~~
 - ~~fix layout issues (want to dictate via :direction and :fill-percentage)~~
 - ~~prevent titlebars~~
 - ~~persist info about familiars in state.json~~
 - ~~slide-in terminal for one-off commands~~
 - ~~apps like spotify, teams, a browser~~
 - ~~persistent, workspace-agnostic tag for these?~~ sticky works across workspaces
 - ~~autofocus on open~~
 - ~~always on top~~
* notification center
 - inspiration
   - https://www.reddit.com/r/unixporn/comments/dwiyca/awesome_notification_center/
* daemons
  - ~~battery~~
  - ~~cpu~~
  - ~~memory~~
  - network status
  - ~~pulseaudio status (vol, sinks?)~~
* a e s t h e t i c s (especially the bar omg ew)
 - svg handling
   - ~~loader~~
   - ~~identicons~~
   - ~~deficon macro~~
   - caching ?
   - more svgs
 - ~~popups need to constrain to screen edges~~
   - ~~maybe use the default placement functions or steal their logic?~~
 - inspiration
   - https://www.reddit.com/r/unixporn/comments/atkn5b/awesome_skyfall/
   - https://www.reddit.com/r/unixporn/comments/caiad9/awesomewm_nighty_nordic/
   - https://www.youtube.com/watch?v=_1M1Wv64JGA
   - https://www.reddit.com/r/unixporn/comments/bgfeoh/bspwm_dracula_all_the_things/
   - https://www.reddit.com/r/unixporn/comments/dnsiiq/bspwm_dracula_revamped_for_a_newer_laptop/
* ~~password integration (gopass + rofi, need some keyring integration i guess?)~~
* screenshot shortcut
 - just select an area and copy to clipboard
 - optionally save to a dir
* ssh bastion-style prompt (via rofi ?)
* ~~rofi emoji picker 🍆 (used rofimoji)~~
* screen setup scripts/ui ?
 - move focus between screens implicitly (requires getting physical scr order)
   - allow moving clients between tags in a similar way
* script for bringing a random window into current tag via rofi
 - see https://github.com/elenapan/dotfiles/blob/997650801a7f6a60b1c1753f40e5f610669a1b2c/config/awesome/helpers.lua#L104
* pulseaudio ui/config ?
 - single output device across all streams pls
 - make WF1000MX3 stop connecting as a damm headset
 - priority setting? Bluetooth > HDMI > Analog > everything else ?
* lockscreen (xsecurelock?)
* emacs org and calendar integration?
 - emacs org capture keybind?
* toggle-able - keypress echo widget
* more tag movement commands (between screens, merge tags, swap tags) ?
* figure out how I want floating/tiling clients inside floating/tiling layouts to work

* consider using machi, or making something similar (particularly draft mode)
  - https://github.com/xinhaoyuan/layout-machi

* virt stuff?
 - https://github.com/virt-lightning/virt-lightning

$dracula-superdark:e#191A21
$dracula-background: #282a36;
$dracula-current-line: #44475a;
$dracula-selection: #44475a;
$dracula-foreground: #f8f8f2;
$dracula-comment: #6272a4;
$dracula-cyan: #8be9fd;
$dracula-green: #50fa7b;
$dracula-orange: #ffb86c;
$dracula-pink: #ff79c6;
$dracula-purple: #bd93f9;
$dracula-red: #ff5555;
$dracula-yellow: #f1fa8c;
