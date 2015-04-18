#!/usr/bin/env ruby

require 'bundler/setup'
require_relative '../lib/pca'
require 'gnuplot'

rows = File.readlines("examples/data/iris.data").map {|l| l.chomp.split(',') }

x_data = rows.map {|row| row[0,4].map(&:to_f) }
labels = rows.map {|row| row[4] }

pca = PCA.new components: 2
transformed = pca.fit_transform x_data

puts "explained_variance_ratio: #{pca.explained_variance_ratio.to_a.map {|v| v.round(4)}}"
puts "Total EVR=#{pca.explained_variance_ratio.sum}"

puts "\nInverse reconstruction vs orig (first 10 rows)"
inv = pca.inverse_transform transformed
inv.submatrix(0,10,nil).to_a.each_with_index do |row, i|
  row = row.map {|v| v.round(1)}
  puts "#{row.inspect}\t#{x_data[i].inspect}"
end


groups = {
  "Iris-setosa" => [],
  "Iris-versicolor" => [], 
  "Iris-virginica"  => []
}

transformed.size1.times do |i|
  data = transformed.row(i)
  label = labels[i]
  groups[label] << data
end

file = "examples/out/iris.png"

Gnuplot.open do |gp|
  Gnuplot::Plot.new(gp) do |plot|
    plot.title "Iris dataset"
    plot.terminal "png"
    plot.output file

    groups.each do |label, data|
      m = GSL::Matrix[*data]
      plot.data << Gnuplot::DataSet.new([m.col(0).to_a, m.col(1).to_a]) do |ds|
        ds.title = label
      end
    end
  end
end

`open #{file}`
