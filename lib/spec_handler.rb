class SpecHandler < Pod::Spec
  #SpecHandler created by Frederico Novack (fredynovack@gmail.com)
  def initialize(path, spec, folder_name)
    @path = path
    @spec = spec
    @folder_name = folder_name
  end

  def compile()
    start_time = Time.now
    if self.path_is_valid(@path)
      puts "> SpecHandler: Will Compile #{@folder_name} Recursively"
      self.subspec_path(@path, @spec)
    else
      puts  "> SpecHandler: Will Compile #{@folder_name} with expression"
      spec.source_files = @folder_name + '/Source/**/*.swift'
      spec.resource = @folder_name + '/**/*.{xib,xcassets}'
    end
    end_time = Time.now
    compiled_time = end_time - start_time
    puts "Compiled pod #{@folder_name} in > %.3f seconds 😃" % compiled_time

  end

  def path_is_valid(path)
    begin
      Dir.entries(path)
    rescue
      return false
    end
    true
  end

  def format_path_for_spec(path)
    if path[0] == '.' && path[1] == '/'
      path[0] = ""
      path[0] = ""
    end
    path
  end

  def number_of_files(path)
    workable_extensions = ['.swift', '.xib', '.xcassets']
    files_and_folders = Dir.entries(path)
    files_array = files_and_folders.select {|element| element.include?('.swift') || element.include?('.xib') || element.include?('.xcassets')}
    files_array.count
  end

  def remove_black_list_folders_and_files(foldersArray)
    black_list = ['.', '..', '.DS_Store']
    black_list.each do |item_to_remove|
      foldersArray.delete(item_to_remove)
    end
    foldersArray = foldersArray.select {|a|  !a.include?('.')}
    foldersArray
  end

  def subspec_path(current_path, spec)
    path_folders = remove_black_list_folders_and_files(Dir.entries(current_path))
    subspec_name = current_path.split('/').last.gsub(' ','').to_s
    if path_folders.count == 0
        spec.subspec subspec_name do |theSubspec|
          theSubspec.source_files = self.format_path_for_spec(current_path) + '/*.swift'
          theSubspec.resource = self.format_path_for_spec(current_path) + '/*.{xib,xcassets}'
        end
    else
      spec.subspec subspec_name do |theSubspec|
        if self.number_of_files(current_path) > 0
          theSubspec.source_files = self.format_path_for_spec(current_path) + '/*.swift'
          theSubspec.resource = self.format_path_for_spec(current_path) + '/*.{xib,xcassets}'
        end

        path_folders.each do |sub_folder|
          self.subspec_path(current_path + '/' + sub_folder, theSubspec)
        end
      end
    end

  end
end
