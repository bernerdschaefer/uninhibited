require 'yard'
desc 'Build all documentation'
task :docs => %w[docs:api]
task :doc => :docs # alias for docs

CLEAN.include 'docs'

desc 'Build API documentation'
task 'docs:api' => ['docs/.git'] do
  sh("yardoc -o docs -")
end
directory 'docs/'

# GITHUB PAGES ===============================================================

desc 'Update gh-pages branch'
task :pages => ['docs/.git', :docs] do
  rev = `git rev-parse --short HEAD`.strip
  Dir.chdir 'docs' do
    sh "git add ."
    sh "git commit -m 'rebuild pages from #{rev}'" do |ok,res|
      if ok
        verbose { puts "gh-pages updated" }
        sh "git push -q o HEAD:gh-pages"
      end
    end
  end
end

# Update the pages/ directory clone
file 'docs/.git' => ['docs/', '.git/refs/heads/gh-pages'] do |f|
  sh "cd docs && git init -q && git remote add o ../.git" if !File.exist?(f.name)
  sh "cd docs && git fetch -q o && git reset -q --hard o/gh-pages && touch ."
end
