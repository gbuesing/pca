Gem::Specification.new do |s|
  s.name        = 'pca'
  s.version     = '0.1.0'
  s.date        = '2015-03-31'
  s.summary     = "Principal Component Analysis"
  s.description = "Principal Component Analysis"
  s.authors     = ["Geoff Buesing"]
  s.email       = 'gbuesing@gmail.com'
  s.files       = ["lib/pca.rb"]
  s.homepage    = 'https://github.com/gbuesing/pca'
  s.license     = 'MIT'
  s.add_runtime_dependency 'rb-gsl'
end
