#!/usr/bin/ruby
require 'psd'
require 'tempfile'

# Input arguments
psdFile = ARGV[0]
outputDir = ARGV[1] || "./out/"

def usage()
    puts "usage: ./psd-render-slices <psd file> [<output directory>]"
end

if ARGV.empty? || !psdFile
    usage()
    exit
end

if !File.exists?(psdFile)
    puts "error: psd file #{psdFile} not found"
    exit
end

# Load psd
psd = PSD.new(psdFile)
psd.parse!
slices = Array.new

# Load slices info
if psd.resources[:slices]
    psd.resources[:slices].data.to_a.each do |slice|
        bounds = slice[:bounds]
        x = bounds[:left]
        y = bounds[:top]
        width = bounds[:right] - bounds[:left]
        height = bounds[:bottom] - bounds[:top]
        if x == 0 && y == 0 && width == psd.width && height == psd.height
            next
        end
        sliceInfo = { 
            :name => slice[:name], 
            :x => x, 
            :y => y,
            :width => width, 
            :height => height 
        }
        slices.push sliceInfo
    end
end

# Create output directory
Dir.mkdir outputDir unless File.exists?(outputDir)

# Render complete psd to temporary file
renderFile = Tempfile.new('assets.png')
begin
    png = psd.image.to_png
    psd.image.save_as_png(renderFile.path)

    rendered = Hash.new
    duplicates = Hash.new

    # Render each slice
    slices.each do |slice|
        name = slice[:name]
        x = slice[:x]
        y = slice[:y]
        width = slice[:width]
        height = slice[:height]
        if name.length == 0
            puts "warning: missing name for slice at x = #{x}, y = #{y}"
            next
        elsif width <= 0 || height <= 0
            puts "error: slice at x = #{x}, y = #{y} is empty"
            next
        elsif rendered[name] && !duplicates[name]
            count = slices.count{|iter|iter[:name]==name}
            puts "error: duplicate slice name '#{name}' #{count} times"
            duplicates[name] = true
            next
        end
        system("convert #{renderFile.path} -crop #{width}x#{height}+#{x}+#{y} #{outputDir}/#{name}.png")
        rendered[name] = true
    end
ensure
    renderFile.unlink
end
