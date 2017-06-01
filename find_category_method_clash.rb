# @attention: Terminal is always blocked while booting and shutdowning simulator using script, please boot simulator(`device_id`) manually.

# device id of simulator, maybe `xcrun simctl list` is helpful
device_id = ''
# bundle identifier of your app
bundle_id = ''
# app name, like `YourApp.app/YouApp`
app_name = ''

if device_id.to_s.empty?
  puts 'error: device_id is empty'
  exit
end

if bundle_id.to_s.empty?
  puts 'error: bundle_id is empty'
  exit
end

if app_name.to_s.empty?
  puts 'error: app_name is empty'
  exit
end

#puts 'Boot device...'
#boot_status = system("xcrun simctl boot #{device_id}")

puts 'Check if app is installed...'
app_container_exist = system("xcrun simctl get_app_container #{device_id} #{bundle_id}")
if !app_container_exist
  puts 'error: app is not installed on the device' 
  exit
end

puts 'Terminate app (IfNeeded)...'
`xcrun simctl terminate #{device_id} #{bundle_id}`

user_name = (`whoami`).strip
log_file = File.open("/Users/#{user_name}/Library/Logs/CoreSimulator/#{device_id}/system.log", 'w+')
output_file = File.open('./replaced_methods.txt', 'w')

# clear system.log
puts 'Clear system.log...'
log_file << ''

puts 'Launch app...'
`xcrun simctl launch #{device_id} #{bundle_id}`

# time for class load (magic number)
sleep 5

puts 'Terminate app...'
`xcrun simctl terminate #{device_id} #{bundle_id}`

while(line = log_file.gets)
  if line.include? 'REPLACED:' and line.include? app_name
  	output_file.puts(line)
  end
end

log_file.close
output_file.close

#puts 'Shutdown device...'
#shutdown_status = system("xcrun simctl shutdown #{device_id}")


