require "app/drkbd.rb"

def tick args
  kbd ||= DRKeyboard.new
  kbd.init
  kbd.update
  
  if args.inputs.keyboard.key_down.tab
    if args.state.drkbd.show == 0
      kbd.show
    else
      kbd.hide
    end
  end
  
  args.outputs.primitives << {
    x: 10,
    y: 10.from_top,
    text: "PRESS TAB TO SHOW/HIDE VIRTUAL KEYBOARD!",
    size_enum: 3
  }.to_label
end
