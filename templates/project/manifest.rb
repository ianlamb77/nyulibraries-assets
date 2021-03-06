description "NYU Libraries Assets"

# Stylesheet importing bootstrap
stylesheet 'styles.scss'

#
# Other Bootstrap assets
basedir = '../../lib/assets'

# Images
%w(magnifier move nyu).each do |file|
  image "#{basedir}/images/#{file}.png", :to => "#{file}.png"
end

# Coffeescripts
%w(bobcat eshelf nyulibraries).each do |file|
  javascript "#{basedir}/javascripts/#{file}.js.coffee", :to => "#{file}.js.coffee"
end
