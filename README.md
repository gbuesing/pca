# Principal Component Analysis (PCA)

[Principal component analysis](http://en.wikipedia.org/wiki/Principal_component_analysis) in Ruby. Leverages [GSL](http://www.gnu.org/software/gsl/) for calculations.


## Install

**GSL must be installed first**. On OS X it can be installed via homebrew: ```brew install gsl```

    gem install pca


## Example Usage

```ruby
require 'pca'

pca = PCA.new components: 1

data_2d = [ 
  [2.5, 2.4], [0.5, 0.7], [2.2, 2.9], [1.9, 2.2], [3.1, 3.0],
  [2.3, 2.7], [2.0, 1.6], [1.0, 1.1], [1.5, 1.6], [1.1, 0.9]
]

# Transform 2d data into 1d:
data_1d = pca.fit_transform data_2d
# data_1d ~= [
#   [-0.8], [1.8], [-1.0], [-0.3], [-1.7],
#   [-0.9], [0.1], [1.1], [0.4], [1.2]
# ]

# Transform new data into same 1d space:
more_data_1d = pca.transform [ [3.1, 2.9] ]
# more_data_1d ~= [ [-1.6] ]

# Inverse transform to reconstruct original data:
reconstructed_2d = pca.inverse_transform data_1d
# reconstructed_2d ~= [
#   [2.4, 2.5], [0.6, 0.6], [2.5, 2.6], [2.0, 2.1], [2.9, 3.1]
#   [2.4, 2.6], [1.7, 1.8], [1.0, 1.1], [1.5, 1.6], [1.0, 1.0]
# ]
```

See [examples](examples/) for more.


## Working with GSL::Matrix

```PCA#transform```, ```#fit_transform``` and ```#inverse_transform``` return instances of ```GSL::Matrix```.

Most useful methods to work with these are the ```#each_row``` and ```#each_col``` iterators,
and the ```#row(i)``` and ```#col(i)``` accessors.
See [GSL::Matrix RDoc](http://blackwinter.github.io/rb-gsl/matrix_rdoc.html) for more.

Or if you'd prefer to work with a standard Ruby ```Array```, you can just call ```#to_a``` on these.
