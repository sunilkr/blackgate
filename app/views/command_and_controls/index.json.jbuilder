json.array!(@command_and_controls) do |command_and_control|
  json.extract! command_and_control, :id, :domain, :ip, :protocol, :port, :first_access, :last_access
  json.url command_and_control_url(command_and_control, format: :json)
end
