text_after_status = "#{ARGV[0].split('Status: ').last}"

IN_PROGRESS = "in progress"
SUCCESS = "success"

if text_after_status.include?(IN_PROGRESS)
  puts IN_PROGRESS
elsif text_after_status.include?(SUCCESS)
  puts SUCCESS
end