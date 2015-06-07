crumb :configurations do
  link 'Configurations', site_configurations_path
end

crumb :configuration do |config|
  link config.name, config
  parent :configurations
end

crumb :new_configuration do
  link 'New configuration', new_site_configuration_path
  parent :configurations
end

crumb :edit_configuration do |config|
  link "Edit #{config.name}", edit_site_configuration_path
  parent :configurations
end