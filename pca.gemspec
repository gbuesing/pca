Gem::Specification.new do |s|
  s.name        = 'pca'
  s.version     = '0.5.0.pre'
  s.date        = '2015-08-26'
  s.summary     = "Principal Component Analysis (PCA)"
  s.description = "Principal Component Analysis (PCA). Uses NMatrix for calculations."
  s.authors     = ["Geoff Buesing"]
  s.email       = 'gbuesing@gmail.com'
  s.files       = ["lib/pca.rb"]
  s.homepage    = 'https://github.com/gbuesing/pca'
  s.license     = 'MIT'
  s.add_runtime_dependency 'nmatrix'
  s.add_runtime_dependency 'nmatrix-lapacke'
end
