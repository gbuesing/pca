#!/usr/bin/env ruby

require 'bundler/setup'
require_relative '../lib/pca'
require_relative 'utils/image_grid'
require 'pnm'

set_size = 10_000
components = 36
grid_size = 100
data_dir = 'examples/data/faces'

unless Dir.exists?(data_dir)
  abort "Aborting. You need to run download script first:\n./examples/utils/get_faces.rb"
end

# LOAD IMAGES

puts "Loading #{set_size} images..."

face_files = Dir["#{data_dir}/*.pgm"].sample(set_size)

images = face_files.map do |filename|
  image = PNM.read(filename)
  image.pixels.flatten
end

# OUTPUT ORIG IMAGES PNG

orig_png = 'examples/out/faces.png'
ImageGrid.new(images.slice(0, grid_size)).to_file orig_png
`open #{orig_png}`

# RUN PCA

puts "Running PCA..."

pca = PCA.new components: components
t = Time.now
transformed = pca.fit_transform images
puts "PCA runtime: #{(Time.now - t).round(1)}s"

puts "\nExplained_variance_ratio: #{pca.explained_variance_ratio.to_a.map {|v| v.round(4)}}"
puts "Total EVR=#{pca.explained_variance_ratio.sum}"

# OUTPUT RECOVERED IMAGES PNG

puts "\nReconstructing images from top #{components} components..."
t = Time.now
recovered = pca.inverse_transform transformed
puts "Inverse PCA runtime: #{(Time.now - t).round(1)}s"


recovered_png = 'examples/out/faces_recovered.png'
ImageGrid.new(recovered.to_a.slice(0, grid_size)).to_file recovered_png
`open #{recovered_png}`

# OUTPUT EIGENFACES PNG

eigenfaces = pca.components

eigen_png = 'examples/out/eigenfaces.png'
ImageGrid.new(eigenfaces.to_a.slice(0, grid_size)).to_file eigen_png
`open #{eigen_png}`

