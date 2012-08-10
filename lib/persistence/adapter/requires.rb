
basepath = 'sequel'

files = [

  'adapter_interface',
  
  'bucket/index/index_interface',
  'bucket/index',

  'bucket/bucket_interface',
  'bucket'
  
]

files.each do |this_file|
  require_relative( File.join( basepath, this_file ) + '.rb' )
end

require_relative( basepath + '.rb' )
