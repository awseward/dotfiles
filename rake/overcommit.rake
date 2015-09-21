require 'zip'

namespace :oc do
  repo_dir = "https://github.com/awseward/overcommit-hooks"
  zip_link = "#{repo_dir}/archive/master.zip"

  desc "Downloads the hooks"
  task :download do
    dest_hooks_dir = File.absolute_path '.git-hooks'
    if !Dir.exists?(dest_hooks_dir)
      mkdir_p dest_hooks_dir
    end

    temp_dir = Dir.mktmpdir
    file_name = 'overcommit-hooks.zip'

    puts temp_dir
    Dir.chdir temp_dir do
      `wget #{zip_link} -O #{file_name}`
      Zip::File.open(file_name) do |zip_file|
        zip_file.each do |entry|
          entry.extract(entry.name)
        end
      end

      unzipped_dir = Dir.glob('*').select{|f| File.directory? f }.first
      Dir.chdir "#{unzipped_dir}/hooks" do
        Dir.glob('*').each do |src|
          cp_r src, dest_hooks_dir
        end
      end
    end
  end

  hook_types = [
    :commit_msg,
    :post_checkout,
    :post_commit,
    :post_merge,
    :post_rewrite,
    :pre_commit,
    :pre_push,
    :pre_rebase,
  ]

  desc "Signs all the hooks"
  task :sign do
    hook_types.each{|hook| sh "overcommit --sign #{hook}" }
  end
end
