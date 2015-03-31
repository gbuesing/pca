#!/usr/bin/env ruby

# BEFORE RUNNING
# download and resize faces via this script:
# ./examples/utils/get_faces.rb

require_relative '../lib/pca'
require_relative 'utils/image_grid'
require 'pnm'

set_size = 100
components = 36
grid_size = 100

puts "Loading #{set_size} images..."

face_files = Dir['examples/data/faces/*.pgm'].sample(set_size)

images = face_files.map do |filename|
  image = PNM.read(filename)
  image.pixels.flatten
end

orig_png = 'examples/out/faces.png'
ImageGrid.new(images.slice(0, grid_size)).to_file orig_png
`open #{orig_png}`


puts "Running PCA..."

pca = PCA.new components: components
t = Time.now
transformed = pca.fit_transform images
puts "PCA runtime: #{Time.now - t}"

puts "\nExplained_variance_ratio: #{pca.explained_variance_ratio.to_a.map {|v| v.round(4)}}"

# puts "transform sample row:"
# p transformed.row(0)

puts "\nReconstructing images from top 100 components..."
t = Time.now
recovered = pca.inverse_transform transformed
puts "Inverse PCA runtime: #{Time.now - t}"

# puts "recovered sample row:"
# p recovered.row(0)

recovered_png = 'examples/out/faces_recovered.png'
ImageGrid.new(recovered.to_a.slice(0, grid_size)).to_file recovered_png
`open #{recovered_png}`

# puts "components sample row shape=#{pca.components.shape.inspect}:"
# p pca.components.row(0)

eigenfaces = pca.components.transpose

eigen_png = 'examples/out/eigenfaces.png'
ImageGrid.new(eigenfaces.to_a.slice(0, grid_size)).to_file eigen_png
`open #{eigen_png}`

