#!/usr/bin/env ruby

require 'bundler/setup'
require_relative '../lib/pca'
require 'gnuplot'

d = [
  [2.5, 2.4],
  [0.5, 0.7],
  [2.2, 2.9],
  [1.9, 2.2],
  [3.1, 3.0],
  [2.3, 2.7],
  [2.0, 1.6],
  [1.0, 1.1],
  [1.5, 1.6],
  [1.1, 0.9]
]

file = "examples/out/simple_orig.png"

Gnuplot.open do |gp|
  Gnuplot::Plot.new(gp) do |plot|
    plot.title "Original Data"
    plot.terminal "png"
    plot.output file

    plot.data << Gnuplot::DataSet.new([d.map(&:first), d.map(&:last)]) do |ds|
      ds.notitle
    end
  end
end

`open #{file}`

pca = PCA.new #components: 1
transformed = pca.fit_transform d

puts "transformed:"
p transformed

puts "\ncomponents:"
p pca.components

puts "\nsingular_values:"
p pca.singular_values

puts "\nexplained_variance:"
p pca.explained_variance

puts "\nexplained_variance_ratio:"
p pca.explained_variance_ratio

inv = pca.inverse_transform transformed
puts "\ninverse_transform:"
p inv

file = "examples/out/simple_pca_1d.png"

Gnuplot.open do |gp|
  Gnuplot::Plot.new(gp) do |plot|
    plot.title "PCA 1D"
    plot.terminal "png"
    plot.output file

    plot.data << Gnuplot::DataSet.new([transformed.col(0).to_a, Array.new(d.length, 0)]) do |ds|
      ds.notitle
    end
  end
end

`open #{file}`
