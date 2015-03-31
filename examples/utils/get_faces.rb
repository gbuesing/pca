#!/usr/bin/env ruby

lfw_url = 'http://conradsanderson.id.au/lfwcrop/lfwcrop_grey.zip'
zip_local = 'examples/data/lfwcrop_grey.zip'

`curl -o #{zip_local} #{lfw_url}`

`unzip #{zip_local} -d examples/data`

`mkdir -p examples/data/faces`

Dir['examples/data/lfwcrop_grey/faces/*.pgm'].each do |filename|
  `convert #{filename} -resize 32x32 examples/data/faces/#{File.basename(filename)}`
end

`rm #{zip_local}`
`rm -r examples/data/lfwcrop_grey`