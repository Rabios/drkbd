# drkbd

On-Screen Keyboard for DragonRuby!

Why make this? Because until now DragonRuby didn't have functions for working with mobile keyboards...

## Setup

> NOTE: drkbd requires "Pro" version of DragonRuby GTK!

### Without Smaug

Download `drkbd.rb` as raw to `app` folder of your project and require it in `main.rb`:

```rb
require "app/drkbd.rb"
```

> Also i prefer to download assets in a folder with the same name as the one they're loaded from...

### With Smaug

<!-- Install package with `smaug add drkbd` and then require `smaug.rb` as you're used to! -->

Sorry no smaug...

## Usage

Once you setup and install drkbd, in your `tick` function initialize drkbd and update with the following:

```rb
kbd = DRKeyboard.new   # As DRKeyboard is class, We create instance of class
kbd.init
kbd.update
```

Check the `samples` folder to see how drkbd works.

## API

All drkbd library functions exposed in class `DRKeyboard` and API are made simple to use.

```rb
#------------------------------#
#        Main Functions        #
#------------------------------#

init                                        # [Void] Initializes the Keyboard.
update                                      # [Void] Handles input and rendering for Keyboard.
show                                        # [Void] Displays the Keyboard.
hide                                        # [Void] Hides the Keyboard.
string(str = nil)                           # [String/Void] Gets/Sets the string from Keyboard.
add_event(event_type, proc)                 # [Void] Adds event for the Keyboard, Second parameter should be Lambda or Proc.
set_keys(k)                                 # [Void] Sets keyboard keys


#------------------------------#
#         Events Types         #
#------------------------------#

:onerase                                    # When erase key pressed
:onshow                                     # When Keyboard displayed
:onhide                                     # When Keyboard hides
:onkbdup                                    # When uppercase key pressed
:onswap                                     # When swapping to other keys sections
:ontype                                     # When typing with the keyboard
:onspace                                    # When space key pressed


#------------------------------#
#        Events Callbacks      #
#------------------------------#

erase_callback(char)                        # Callback to :onerase event, char is character deleted
show_callback()                             # Callback to :onshow event, Called when Keyboard show up
hide_callback()                             # Callback to :onhide event, Called when Keyboard hides
kbdup_callback(uppercase_state)             # Callback to :onkbdup event, Called when uppercase key pressed
swap_callback(section_idx, section_chars)   # Callback to :onswap event, Called when swapping to another keyboard section
type_callback(char)                         # Callback to :ontype event, Called when typing on keyboard and char is the character typed
space_callback()                            # Callback to :onspace event, Called when Space key pressed


#------------------------------#
#      Internal Variables      #
#------------------------------#

args.state.drkbd.touched                    # [Int/Boolean]  Is screen touched right now? 
args.state.drkbd.touched_previously         # [Int/Boolean]  Is screen touched previously?
args.state.drkbd.kbdup                      # [Int]          Keyboard's uppercase state.
args.state.drkbd.kbdidx                     # [Int]          Index of Keyboard chars section
args.state.drkbd.kbdstr                     # [String]       String of the Keyboard
args.state.drkbd.anim                       # [Int]          Keyboard movement animation
args.state.drkbd.anim_done                  # [Int/Boolean]  Keyboard animation state (Done or not)
args.state.drkbd.show                       # [Int/Boolean]  Show/Hide Keyboard
args.state.drkbd.insert_idx                 # [Int]          String insertion index
args.state.drkbd.events                     # [Array<Event>] Keyboard events
args.state.drkbd.pointer                    # [Hash]         contains result of pointer_rect
args.state.drkbd.chars                      # [Array<Array<String>>] Array of Keyboard chars in sections


#------------------------------#
#      Internal Functions      #
#------------------------------#

is_mobile                                   # [Boolean] Is device a mobile?
touch_down                                  # [Boolean] Is touch down?
touch_press                                 # [Boolean] Is touch press? (tap)
tap                                         # [Boolean] Did user tap with mouse/touchscreen?
pointer_rect                                # [Hash]    Returns rectangle with x and y position of mouse/touch
insert_text_at_pos(txt, txt2, pos = -1)     # [Void]    Inserts text at index of another text (-1 or text's length for concat instead of insertion)
remove_char_at_pos(txt, pos = -1)           # [Void]    Removes char at index of text (-1 or text's length to remove last char)


#------------------------------#
#       Internal Classes       #
#------------------------------#

Solid       # Used by drkbd to render solids
Border      # Used by drkbd to render borders
Label       # Used by drkbd to render labels
Sprite      # Used by drkbd to render sprites
```

## What this thing originally made for?

This was originally made for the game [COLOLINKS!](https://rabios.itch.io/cololinks) so make sure you check it out! :)

## DEV NOTES:

drkbd initialized in hash `$gtk.args.state.drkbd` and that's to make it easy to serialize away of the state if data is big.

## License

```
This is free and unencumbered software released into the public domain.

Anyone is free to copy, modify, publish, use, compile, sell, or
distribute this software, either in source code form or as a compiled
binary, for any purpose, commercial or non-commercial, and by any
means.

In jurisdictions that recognize copyright laws, the author or authors
of this software dedicate any and all copyright interest in the
software to the public domain. We make this dedication for the benefit
of the public at large and to the detriment of our heirs and
successors. We intend this dedication to be an overt act of
relinquishment in perpetuity of all present and future rights to this
software under copyright law.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

For more information, please refer to <http://unlicense.org>
```
