Gem::Specification.new do |s|
  s.name        = 'pca'
  s.version     = '0.5.0'
  s.date        = '2015-04-18'
  s.summary     = "Principal Component Analysis (PCA)"
  s.description = "Principal Component Analysis (PCA). Uses GSL for calculations."
  s.authors     = ["Geoff Buesing"]
  s.email       = 'gbuesing@gmail.com'
  s.files       = ["lib/pca.rb"]
  s.homepage    = 'https://github.com/gbuesing/pca'
  s.license     = 'MIT'
  s.add_runtime_dependency 'gsl', '~> 2.1'
end
