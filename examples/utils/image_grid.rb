require 'chunky_png' # gem install chunky_png


class ImageGrid

  def initialize data
    @data = data
  end

  def to_file filename
    generate_png_from_data
    @png.save filename, :compression => Zlib::NO_COMPRESSION
  end

  private

    def generate_png_from_data
      grid_size = Math.sqrt(@data.length).ceil
      grid_x_offset, grid_y_offset, grid_row = 0, 0, 0
      img_width, img_height = 32, 32

      maxes, mins = [], []
      @data.length.times do |img|
        imgdata = @data[img].slice(0, 28*28) 
        maxes << imgdata.max
        mins << imgdata.min
      end
      max = maxes.max
      min = mins.min

      # puts "min=#{min.round(2)} && max=#{max.round(2)}"

      @png = ChunkyPNG::Image.new(grid_size * img_width, grid_size * img_height, ChunkyPNG::Color::WHITE)

      @data.length.times do |img|
        pixels = @data[img]

        if img > 0 && img % grid_size == 0
          grid_row += 1
        end

        grid_x_offset = (img % grid_size) * img_width
        grid_y_offset = grid_row * img_height

        img_row = 0

        (img_width * img_height).times do |i|
          if i > 0 && i % img_width == 0
            img_row += 1
          end

          pixel = pixels[i]
          normalized_pixel = normalize(pixel, min, max, 0.0, 1.0)
          img_col = i % 32
          @png[img_col + grid_x_offset, img_row + grid_y_offset] = ChunkyPNG::Color("black @ #{normalized_pixel}")
        end
      end
    end

    def normalize val, fromLow, fromHigh, toLow, toHigh
      ret = 1.0 - (val - fromLow) * (toHigh - toLow) / (fromHigh - fromLow).to_f
      if ret > toHigh
        1.0
      elsif ret < toLow
        0.0
      else
        ret.round(2)
      end
    end
end
