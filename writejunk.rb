# A little script which writes a file again and again over a device or file until
# full, providing progress reports along the way.
arguments = ARGV

unless arguments.length == 2
  puts "Usage: ruby writejunk.rb some-input-file /dev/output-device"
  puts "input file can be of any format, and is repeated as needed to fill output device"
  exit
end

input_filename, output_device = arguments

ideal_size = 1_000_000 # ideal size of chunk to write
noise = IO.read(input_filename)
if noise.length * 2 < ideal_size
  noise = noise * (ideal_size / noise.length)
end

dd = IO.popen("dd of=#{output_device}", 'r+');

wrote = 0
time = 0
until dd.closed?
  dd.write(noise)
  wrote += noise.length
  
  new_time = Time.now.to_i
  if time != new_time
    puts "written #{wrote / 1_000_000} megabytes"
    time = new_time
  end
end
