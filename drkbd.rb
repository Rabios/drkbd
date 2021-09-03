class DRKeyboard
  class Solid
    attr_accessor :x, :y, :w, :h, :r, :g, :b, :a, :blendmode_enum
  
    def initialize(x, y, w, h, r = 0, g = 0, b = 0, a = 255)
      @x = x
      @y = y
      @w = w
      @h = h
      @r = r
      @g = g
      @b = b
      @a = a
    end

    def primitive_marker
      :solid
    end
  end
  
  class Border
    attr_accessor :x, :y, :w, :h, :r, :g, :b, :a, :blendmode_enum
  
    def initialize(x, y, w, h, r = 0, g = 0, b = 0, a = 255)
      @x = x
      @y = y
      @w = w
      @h = h
      @r = r
      @g = g
      @b = b
      @a = a
    end

    def primitive_marker
      :border
    end
  end
  
  class Label
    attr_accessor :x, :y, :text, :font, :size_enum, :r, :g, :b, :a, :alignment_enum, :vertical_alignment_enum, :blendmode_enum
  
    def initialize(x, y, text, size_enum = 0, font = nil, r = 0, g = 0, b = 0, a = 255)
      @x = x
      @y = y
      @text = text
      @size_enum = size_enum
      @font = font
      @r = r
      @g = g
      @b = b
      @a = a
    end

    def primitive_marker
      :label
    end
  end
  
  class Sprite
    attr_accessor :x, :y, :w, :h, :path, :angle, :a, :r, :g, :b, :tile_x, :tile_y, :tile_w, :tile_h, :source_x, :source_y, :source_w, :source_h, :flip_horizontally, :flip_vertically, :angle_anchor_x, :angle_anchor_y, :blendmode_enum
  
    def initialize(x, y, w, h, path, angle = 0, r = 255, g = 255, b = 255, a = 255)
      @x = x
      @y = y
      @w = w
      @h = h
      @path = path
      @angle = angle
      @r = r
      @g = g
      @b = b
      @a = a
    end

    def primitive_marker
      :sprite
    end
  end
  
  def draw_img(rec, img, angle = 0, r = 255, g = 255, b = 255, a = 255)
    $gtk.args.outputs.primitives << Sprite.new(rec.x, rec.y, rec.w, rec.h, img, angle, r, g, b, a)
  end

  def draw_border(rec, r = 255, g = 255, b = 255, a = 255)
    $gtk.args.outputs.primitives << Border.new(rec.x, rec.y, rec.w, rec.h, r, g, b, a)
  end

  def init
    $gtk.args.state.drkbd.touched               ||= 0
    $gtk.args.state.drkbd.touched_previously    ||= 0
    $gtk.args.state.drkbd.kbdup                 ||= 0
    $gtk.args.state.drkbd.kbdidx                ||= 0
    $gtk.args.state.drkbd.kbdstr                ||= ""
    $gtk.args.state.drkbd.anim                  ||= 0
    $gtk.args.state.drkbd.anim_done             ||= 0
    $gtk.args.state.drkbd.show                  ||= 0
    $gtk.args.state.drkbd.insert_idx            ||= -1
    $gtk.args.state.drkbd.events                ||= {}
    $gtk.args.state.drkbd.pointer               = pointer_rect
    
    $gtk.args.state.drkbd.chars ||= [
      [
        [ "1", "2", "3", "4", "5", "6", "7", "8", "9", "0" ],
        [ "q", "w", "e", "r", "t", "y", "u", "i", "o", "p" ],
        [ "a", "s", "d", "f", "g", "h", "j", "k", "l", ":" ],
        [ ";", "z", "x", "c", "v", "b", "n", "m", ",", "." ],
        [ "<<<", "", "", "", "", "", "", "", "", "" ]
      ],
      [
        [ "~", "!", "@", "#", "$", "^", "&", "*", "(", ")" ],
        [ "-", "_", "+", "=", "{", "}", "[", "]", "|", "\\" ],
        [ ":", "<", ">", "/", "`", "'", "\"", "", "", "" ],
        [ "", "", "", "", "", "", "", "", "", "" ],
        [ "<<<", "", "", "", "", "", "", "", "", "" ]
      ]
    ]
  end
  
  def is_mobile
    return ($gtk.platform == "iOS" || $gtk.platform == "Android")
  end

  def touch_down
    return ($gtk.args.state.drkbd.touched == 1)
  end

  def touch_press
    return ($gtk.args.state.drkbd.touched == 1 && ($gtk.args.state.drkbd.touched != $gtk.args.state.drkbd.touched_previously))
  end

  def tap
    return ($gtk.args.inputs.mouse.click && $gtk.args.inputs.mouse.button_left) || touch_press
  end
  
  def pointer_rect
    r = { w: 1, h: 1 }

    if $gtk.args.state.drkbd.touched == 1
      if !($gtk.args.inputs.finger_one.nil? || $gtk.args.inputs.finger_two.nil?)
        f = ($gtk.args.inputs.finger_one || $gtk.args.inputs.finger_two)
        return ({ x: f.x, y: f.y }).merge(r)
      end
    else
      return ({ x: $gtk.args.inputs.mouse.x, y: $gtk.args.inputs.mouse.y }).merge(r)
    end
  end
  
  def insert_text_at_pos(txt, txt2, pos = -1)
    if (pos == -1 || pos == txt.length)
      return txt.concat(txt2)
    else
      return txt.insert(pos, txt2)
    end
  end
  
  def remove_char_at_pos(txt, pos = -1)
    if (pos == -1 || pos == txt.length)
      return txt.chop!
    else
      return txt.slice!(pos)
    end
  end
  
  def update
    rects = {
      space: {
        x: 258,
        y: ($gtk.args.state.drkbd.anim - 1078),
        w: 763,
        h: 53
      },
      erase: {
        x: 1026,
        y: ($gtk.args.state.drkbd.anim - 1078),
        w: 123,
        h: 53
      },
      upcase: {
        x: 130,
        y: ($gtk.args.state.drkbd.anim - 1078),
        w: 123,
        h: 53
      },
      hide: {
        x: 1187,
        y: ($gtk.args.state.drkbd.anim - 1076),
        w: 53,
        h: 53
      }
    }
    
    if is_mobile
      $gtk.args.state.drkbd.touched_previously  = $gtk.args.state.drkbd.touched
      $gtk.args.state.drkbd.touched             = !$gtk.args.inputs.finger_one.nil? ? 1 : 0
    end
    
    if $gtk.args.state.drkbd.show == 1
      if $gtk.args.state.drkbd.anim < 1070
        $gtk.args.state.drkbd.anim += 20
      else
        $gtk.args.state.drkbd.anim_done = 1
      end
    elsif $gtk.args.state.drkbd.show == 0
      if $gtk.args.state.drkbd.anim > 0
        $gtk.args.state.drkbd.anim -= 20
      else
        $gtk.args.state.drkbd.anim_done = 0
      end
    end
    
    if $gtk.args.state.drkbd.show == 1 && tap
      if $gtk.args.state.drkbd.pointer.intersect_rect?(rects[:erase])
        if $gtk.args.state.drkbd.kbdstr.chop.length <= $gtk.args.state.drkbd.insert_idx
          $gtk.args.state.drkbd.insert_idx -= 1
        end
        
        if !$gtk.args.state.drkbd.events[:onerase].nil?
          __end = $gtk.args.state.drkbd.insert_idx == -1 || $gtk.args.state.drkbd.insert_idx == $gtk.args.state.drkbd.kbdstr.length
        
          $gtk.args.state.drkbd.events[:onerase].call(__end ? $gtk.args.state.drkbd.kbdstr[-1] : $gtk.args.state.drkbd.kbdstr[$gtk.args.state.drkbd.insert_idx])
        end
        
        remove_char_at_pos($gtk.args.state.drkbd.kbdstr, $gtk.args.state.drkbd.insert_idx)
        
      end
      
      if $gtk.args.state.drkbd.pointer.intersect_rect?(rects[:hide])
        $gtk.args.state.drkbd.show = 0
        
        if !$gtk.args.state.drkbd.events[:onhide].nil?
          $gtk.args.state.drkbd.events[:onhide].call
        end
        
        
      end
      
      if $gtk.args.state.drkbd.pointer.intersect_rect?(rects[:upcase])
        if $gtk.args.state.drkbd.kbdup + 1 < 3
          $gtk.args.state.drkbd.kbdup += 1
        else
          $gtk.args.state.drkbd.kbdup = 0
        end
        
        if !$gtk.args.state.drkbd.events[:onkbdup].nil?
          $gtk.args.state.drkbd.events[:onkbdup].call($gtk.args.state.drkbd.kbdup)
        end
        
        
      end
    end
    
    $gtk.args.outputs.primitives << Solid.new(
      0,
      $gtk.args.state.drkbd.anim - 1080,
      $gtk.args.grid.w,
      300,
      255,
      255,
      255,
      255)
    
    idx = $gtk.args.state.drkbd.kbdidx
    chars = $gtk.args.state.drkbd.chars[idx]
    down = ($gtk.args.inputs.mouse.button_left || touch_down)
    
    chars.length.times do |i|
      chars[i].length.times do |j|
        t = chars[i][j]
        
        if t != ""
          k_rec = {
            x: (j * 128) + 2,
            y: (($gtk.args.state.drkbd.anim - 838) - (i * 60)),
            w: 123,
            h: 53
          }
      
          draw_border(k_rec, 0, 0, down && $gtk.args.state.drkbd.pointer.intersect_rect?(k_rec) ? 255 : 0, 255)
      
          $gtk.args.outputs.primitives << Label.new(
            t == "<<<" ? (j * 128) + 40 : (j * 128) + 55,
            ($gtk.args.state.drkbd.anim - 792) - (i * 60),
            $gtk.args.state.drkbd.kbdup > 0 ? chars[i][j].upcase : chars[i][j],
            8,
            nil,
            0,
            0,
            down && $gtk.args.state.drkbd.pointer.intersect_rect?(k_rec) ? 255 : 0,
            255)
        
          if $gtk.args.state.drkbd.anim_done == 1 && tap && $gtk.args.state.drkbd.pointer.intersect_rect?(k_rec)
            if t == "<<<"
              if $gtk.args.state.drkbd.kbdidx + 1 < $gtk.args.state.drkbd.chars.length
                $gtk.args.state.drkbd.kbdidx += 1
              else
                $gtk.args.state.drkbd.kbdidx = 0
              end
              
              if !$gtk.args.state.drkbd.events[:onswap].nil?
                $gtk.args.state.drkbd.events[:onswap].call($gtk.args.state.drkbd.kbdidx, chars)
              end
              
              
            elsif $gtk.args.state.drkbd.pointer.intersect_rect?(rects[:hide])
              $gtk.args.state.drkbd.show = 0
              
              if !$gtk.args.state.drkbd.events[:onhide].nil?
                $gtk.args.state.drkbd.events[:onhide].call
              end
        
              
            elsif t != ""
              if ($gtk.args.state.drkbd.kbdup > 0)
                $gtk.args.state.drkbd.kbdstr = insert_text_at_pos($gtk.args.state.drkbd.kbdstr, t.upcase, $gtk.args.state.drkbd.insert_idx)
              else
                $gtk.args.state.drkbd.kbdstr = insert_text_at_pos($gtk.args.state.drkbd.kbdstr, t, $gtk.args.state.drkbd.insert_idx)
              end
              
              if !$gtk.args.state.drkbd.events[:ontype].nil?
                $gtk.args.state.drkbd.events[:ontype].call($gtk.args.state.drkbd.kbdup > 0 ? t.upcase : t)
              end
              
              $gtk.args.state.drkbd.kbdup = 0 if $gtk.args.state.drkbd.kbdup == 1
              
            end
          end
        end
      end
    end
    
    draw_border(rects[:space], 0, 0, $gtk.args.state.drkbd.anim_done == 1 && down && $gtk.args.state.drkbd.pointer.intersect_rect?(rects[:space]) ? 255 : 0, 255)
 
    if $gtk.args.state.drkbd.anim_done == 1 && (tap && $gtk.args.state.drkbd.pointer.intersect_rect?(rects[:space]))
      $gtk.args.state.drkbd.kbdstr = insert_text_at_pos($gtk.args.state.drkbd.kbdstr, " ", $gtk.args.state.drkbd.insert_idx)
      
      if !$gtk.args.state.drkbd.events[:onspace].nil?
        $gtk.args.state.drkbd.events[:onspace].call
      end
    end
    
    draw_border(rects[:upcase], 0, 0, $gtk.args.state.drkbd.anim_done == 1 && down && $gtk.args.state.drkbd.pointer.intersect_rect?(rects[:upcase]) || $gtk.args.state.drkbd.kbdup > 0 ? 255 : 0, 255)
    
    $gtk.args.outputs.primitives << Sprite.new(
      175,
      ($gtk.args.state.drkbd.anim - 1073),
      32,
      42,
      "drkbd_assets/up_arrow.png",
      0,
      0,
      0,
      $gtk.args.state.drkbd.anim_done == 1 && down && $gtk.args.state.drkbd.pointer.intersect_rect?(rects[:upcase]) || $gtk.args.state.drkbd.kbdup > 0 ? 255 : 0,
      255)
    
    draw_border(rects[:erase], 0, 0, $gtk.args.state.drkbd.anim_done == 1 && down && $gtk.args.state.drkbd.pointer.intersect_rect?(rects[:erase]) ? 255 : 0, 255)
    
    $gtk.args.outputs.primitives << Sprite.new(
      1056,
      ($gtk.args.state.drkbd.anim - 1068),
      64,
      32,
      "drkbd_assets/eraser.png",
      0,
      0,
      0,
      $gtk.args.state.drkbd.anim_done == 1 && down && $gtk.args.state.drkbd.pointer.intersect_rect?(rects[:erase]) ? 255 : 0,
      255)
    
    draw_img(rects[:hide], "drkbd_assets/start_button_light.png", 270, 0, 0, 0, 255)
  end
  
  def show
    if $gtk.args.state.drkbd.show == 0
      if !$gtk.args.state.drkbd.events[:onshow].nil?
        $gtk.args.state.drkbd.events[:onshow].call
      end
      
      $gtk.args.state.drkbd.show = 1
    end
  end
  
  def hide
    if $gtk.args.state.drkbd.show == 1
      if !$gtk.args.state.drkbd.events[:onhide].nil?
        $gtk.args.state.drkbd.events[:onhide].call
      end
      
      $gtk.args.state.drkbd.show = 0
    end
  end
  
  def string(s = nil)
    if s == nil
      return $gtk.args.state.drkbd.kbdstr
    else
      $gtk.args.state.drkbd.kbdstr = s
    end
  end
  
  def add_event(k, f)
    $gtk.args.state.drkbd.events[k] ||= f
  end
  
  def set_keys(k)
    $gtk.args.state.drkbd.chars = k
  end
end
