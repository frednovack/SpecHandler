<h1>SpecHandler</h1>

## Usage
gem install spec_handler

## How it works:
SpecHandler will run through the folders of the project and will configure the subspec of your pod.
It will separate the .swift files from the .xibs .

All you have to do is to create a subspec on you pod and create a new instance of SpecHandler passing the source path, the subspec and the folder name.
With your SpecHandler instance call the 'compile' method.

Example of a podspec:
```ruby
require 'spec_handler'
Pod::Spec.new do |s|
  s.name             = 'My Pod'
  s.version          = '1.0.3'
  s.summary          = 'iOS POD'
  s.description      = 'This is a pod that uses spec_handler'

  source_path = './My_Pod/Source'
  s.subspec 'Pod'      do |s1|
      s1.source_files = '*.{podspec,md}'
  end

  s.subspec 'My_Pod' do |pod_subspec|
      SpecHandler.new(source_path, prev_subspec, 'My Pod').compile
  end

  s.requires_arc      = true
  s.dependency 'SomeDependency'

end
```
