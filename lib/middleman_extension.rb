require 'middleman-core'
require 'middleman-core/extensions'

Middleman::Extensions.register(:weby) do
  require 'weby'
  Weby
end
