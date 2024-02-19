Input Icons

UI controls (TextureRect and Button with icon) that displays
the keyboard/mouse/controller icon that is currently mapped under given
input action name. Automatic switching between keyboard/mouse and controller
icons is implemented based on what the user is using at that moment.

Similar add-ons:
- Controller Icons (https://github.com/rsubtil/controller_icons)
- Godot Action Icon (https://github.com/KoBeWi/Godot-Action-Icon)
- Godot Input Prompts (https://github.com/Pennycook/godot-input-prompts)

For most games with non-remappable controls those add-ons are enough.
Input Icons is different in the sense that it tries to support every keyboard
key, mouse and joypad button that Godot recognizes. Instead of bundling
hundreds of prerendered textures for keyboard keys with textual labels
it renders them on the fly.

Most users of Input Icons will use InputActionTextureRect for displaying the
currently mapped input action in UI and maybe InputActionButton which wraps
InputActionTextureRect functionality as a icon in a Button.

Assets are Xelu's FREE Controllers & Keyboard PROMPTS
made by Nicolae (XELU) Berbece available under Creative Commons 0 (CC0).

Add-on feature comparison table:

															 CI   GAI  GIP  II
TextureRect                                                  Yes  Yes  Yes  Yes
Button                                                       Yes  No   No   Yes
Texture2D                                                    Yes  No   No   No
Controller stick icons also with directional arrows          No   Yes  Yes  Yes
Mouse wheel icons also with directional arrows               No   Yes  Yes  Yes
Mouse thumb button icons                                     No   No   No   Yes
All US keyboard keys                                         No   No   Yes  Yes
Pixel art style icons                                        No   No   Yes  No

CI - Controller Icons
GAI - Godot Action Icon
GIP - Godot Input Prompts
II - Input Icons
