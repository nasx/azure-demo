=begin
  list_resource_groups.rb
  Author: Chris Keller <ckeller@redhat.com>
  Description: List Azure Resource Groups for Dynamic Dropdown
-------------------------------------------------------------------------------
   Copyright 2018 Chris Keller <ckeller@redhat.com>
   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at
       http://www.apache.org/licenses/LICENSE-2.0
   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
-------------------------------------------------------------------------------
=end

begin

  require 'azure/armrest'

  client_id = $evm.object['client_id']
  client_key = $evm.object.decrypt('client_key')
  tenant_id = $evm.object['tenant_id']
  subscription_id = $evm.object['subscription_id']
  rg_list = {}

  conf = Azure::Armrest::Configuration.new(
    :client_id       => client_id,
    :client_key      => client_key,
    :tenant_id       => tenant_id,
    :subscription_id => subscription_id
  )

  rgs = Azure::Armrest::ResourceGroupService.new(conf)

  options = {
    :location => 'eastus'
  }
  
  list = rgs.list(options)
  
  list.each do |rg|
    rg_list[rg.name] = rg.name
  end
    
  list_values = {
    'sort_by' => :value,
    'required' => true,
    'default_value' => list[0].name,
    'values' => rg_list
  }

  $evm.log(:info, "DEBUG: #{rg_list.inspect}")
  list_values.each { |key, value| $evm.object[key] = value }

end
