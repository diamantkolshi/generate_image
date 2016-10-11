require 'awesome_print'
require 'rmagick'
require 'date'
require 'pry'

class Image
  include Magick
  attr_accessor :canvas, :messages, :imagename
  $count ||= 0

  def create_image(name, profession, description, quote, image)
    @imagename = image
    @canvas = Magick::Image.read("./public/img/#{image}").first    

    if valid_format == true
      image_width = @canvas.rows
	    draw_name(name, 14, 100, image_width - 80, 30)
	    draw_name(profession, 14, 100, image_width - 50, 20)
	    draw_text(description, image_width)
      draw_quote(quote, image_width)

	    save_image
    else
      @messages = "Formati nuk eshte valid (duhet te jete 1024 > x < 2000"
    end
    File.delete("./public/img/#{@imagename}") 
  end

  def valid_format
    if @canvas.columns > 1000 && @canvas.columns < 2000
      @canvas.crop!(0,0,1027,1027)
      true
    else
      false
    end     
  end

  def save_image
    if canvas.write("./public/img/reprofile.png")
      @messages = "Fotografia eshte krijuar me sukese"
    else
      @messages = "Fotoja nuk eshte krijuar"
    end 
        
  end

  def draw_name(text, position, x, y, size)
    gc = Magick::Draw.new
    gc.pointsize(size)
    gc.text(x,y, text = wrap(text))
    gc.draw(canvas)
  end

  def draw_text(text, img_width)
    gc = Magick::Draw.new
    gc.pointsize(45)
    gc.font_family = 'Times New Roman'
    gc.text(100, img_width - 200, text = "#{wrap(text)}")

    gc.draw(canvas)
  end

  def draw_quote(text, img_width)
    gc = Magick::Draw.new
    gc.pointsize(25)
    gc.font_family = 'Times New Roman'
    gc.text(700, img_width - 65, text = "#{wrap(text, 30)}")

    gc.draw(canvas)
  end

  def wrap(text, width=44)
    text.gsub(/(.{1,#{width}})(\s+|\Z)/, "\\1\n")
  end

end
