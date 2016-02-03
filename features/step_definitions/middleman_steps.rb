Given(/^in "([^"]*)" environment$/) do |environment|
  ENV['MM_ENV'] = environment
  set_env 'MM_ENV', environment
  step %(I append to "config.rb" with "set :environment, :#{environment}")
end
