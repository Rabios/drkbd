require "app/drkbd.rb"

def tick args
  kbd ||= DRKeyboard.new
  kbd.init
  kbd.update
  
  args.outputs.primitives << {
    x: 10,
    y: 10.from_top,
    text: "PRESS TAB KEY TO SHOW/HIDE VIRTUAL KEYBOARD!",
    size_enum: 3
  }.to_label
  
  args.outputs.primitives << {
    x: 10,
    y: 40.from_top,
    text: "PRESS KEYS FROM VIRTUAL KEYBOARD AND CHECK OUT THE CONSOLE!",
    size_enum: 1,
    r: 26,
    g: 193,
    b: 221
  }.to_label
  
  if args.inputs.keyboard.key_down.tab
    if args.state.drkbd.show == 0
      kbd.show
    else
      kbd.hide
    end
  end

  $show_cb ||= ->() do
    puts "Keyboard is Visible!"
  end
  
  $hide_cb ||= ->() do
    puts "Keyboard is Hidden!"
  end
  
  $space_cb ||= ->() do
    puts "Space button pressed!"
  end
  
  $type_cb ||= ->(char) do
    puts "Char pressed: #{char}"
  end
  
  $erase_cb ||= ->(deleted_char) do
    puts "Char deleted: #{deleted_char}"
  end
  
  $kbdup_cb ||= ->(kbdup_state) do
    puts "Chars are #{kbdup_state == 0 ? "Lowercase" : "Uppercase" } now..."
  end
  
  $swap_cb ||= ->(section_idx, chars) do
    puts "Section index: #{section_idx}"
    puts chars
  end
  
  kbd.add_event(:onshow, $show_cb)
  kbd.add_event(:onhide, $hide_cb)
  kbd.add_event(:onspace, $space_cb)
  kbd.add_event(:ontype, $type_cb)
  kbd.add_event(:onerase, $erase_cb)
  kbd.add_event(:onkbdup, $kbdup_cb)
  kbd.add_event(:onswap, $swap_cb)
end
