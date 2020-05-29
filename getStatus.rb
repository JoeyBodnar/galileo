IN_PROGRESS = "in progress"
SUCCESS = "success"

# the response is a multiline string, with the status being on its own line
# using the format #Status: "<status here>"
response_objects = ARGV[0].split("\n")

# get line thaat contains the status
status = response_objects.select { |data| data.include?('Status:') }[0]

# get text describing the status
current_status = "#{status.split('Status: ').last}"

# response with value
puts current_status