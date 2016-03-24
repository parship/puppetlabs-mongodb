require 'json';

Facter.add('mongodb_is_master') do
  setcode do
    if Facter::Core::Execution.which('mongo')
      mongo_output = Facter::Core::Execution.exec('mongo --quiet --eval "printjson(db.isMaster())"')

      ['ObjectId','ISODate'].each do |data_type|
        mongo_output.gsub!(/#{data_type}\(([^)]*)\)/, '\1')
      end
      JSON.parse(mongo_output)['ismaster'] ||= false
    else
      'not_installed'
    end
  end
end
