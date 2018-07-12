Gem::Specification.new do |s|
  s.name = 'fibonacci_heap'
  s.version = '0.1.0'
  s.summary = 'A Ruby implementation of the Fibonacci heap data structure'
  s.description = <<-DESC
    A Ruby implementation of the Fibonacci heap data structure ideal for use as
    a priority queue with Dijkstra's algorithm.
  DESC
  s.license = 'MIT'
  s.authors = ['Paul Mucur']
  s.homepage = 'https://github.com/mudge/fibonacci_heap'
  s.files = %w[README.md LICENSE] + Dir['lib/**/*.rb']
  s.test_files = Dir['spec/**/*.rb']

  s.add_development_dependency('rspec', '~> 3.7')
end
