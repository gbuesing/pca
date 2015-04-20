#!/usr/bin/env ruby

require 'bundler/setup'
require_relative '../lib/pca'
require 'gnuplot'

# colums: food England Wales Scotland N Ireland
# grams per person per week of each foodstuff, by region
# dataset from http://people.maths.ox.ac.uk/richardsonm/SignalProcPCA.pdf
rows = File.readlines("examples/data/food.dat").map {|l| l.chomp.split(' ') }

x_data = rows.map {|row| row[1,4].map(&:to_f) }
x_labels = rows.map {|row| row[0] }

xt_data = GSL::Matrix[*x_data].transpose
xt_labels = %w{England Wales Scotland N-Ireland}

pca = PCA.new components: 2
xt_2d = pca.fit_transform xt_data


puts "explained_variance_ratio: #{pca.explained_variance_ratio.to_a.map {|v| v.round(4)}}"

def plot data, labels, title, file
  Gnuplot.open do |gp|
    Gnuplot::Plot.new(gp) do |plot|
      plot.title title
      plot.terminal "png"
      plot.output file

      plot.data << Gnuplot::DataSet.new([ data.col(0).to_a, data.col(1).to_a, labels ]) do |ds|
        ds.notitle
        ds.with = "labels"
      end
    end
  end
  `open #{file}`
end

plot xt_2d, xt_labels, "UK Food by Country PCA", 'examples/out/food_pca.png'


variance = xt_data.size2.times.map {|i| xt_data.col(i).variance }
  # puts "#{x_labels[i]} std: #{xt_data.col(i).sd}"

Gnuplot.open do |gp|
  Gnuplot::Plot.new(gp) do |plot|
    plot.title "UK Food: variance by type"
    plot.terminal "png"
    plot.output 'examples/out/food_variance.png'
    plot.style  "data histograms"
    plot.xtics  "nomirror rotate by -45"
    plot.ylabel "variance"

    plot.data << Gnuplot::DataSet.new( [x_labels, variance] ) do |ds|
      ds.using = "2:xtic(1)"
      ds.notitle #= xt_labels[col]
    end
  end
end
`open examples/out/food_variance.png`  

Gnuplot.open do |gp|
  Gnuplot::Plot.new(gp) do |plot|
    plot.title "UK Food"
    plot.terminal "png"
    plot.output 'examples/out/food.png'
    plot.style  "data histograms"
    plot.xtics  "nomirror rotate by -45"

    x = x_labels
    (0..3).each do |col|  
      y = x_data.collect{|arr| arr[col]}
      plot.data << Gnuplot::DataSet.new( [x, y] ) do |ds|
        ds.using = "2:xtic(1)"
        ds.title = xt_labels[col]
      end
    end
  end
end
`open examples/out/food.png`
