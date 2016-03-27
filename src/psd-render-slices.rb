#!/usr/bin/env ruby
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
begin
    psd.parse!
rescue
    puts "error: failed to parse .psd file (corrupted?)"
    exit
end
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
renderFile = Tempfile.new(["assets", ".png"])
begin
    # PSD file must be saved with compatibility mode
    system("convert -page #{psd.width}x#{psd.height} -background none \"#{psdFile}[0]\" \"#{renderFile.path}\"")

    rendered = Hash.new
    duplicates = Hash.new
    warnings = 0

    # Render each slice
    slices.each do |slice|
        names = slice[:name].split(",")
        x = slice[:x]
        y = slice[:y]
        width = slice[:width]
        height = slice[:height]
        names.each do |name|
            if name == "skip"
                next
            elsif name.length == 0 and warnings < 3
                puts "warning: missing name for slice at x = #{x}, y = #{y}"
                warnings += 1
                if warnings == 3
                    puts "(skipping all other warnings)"
                end
                next
            elsif width <= 0 || height <= 0
                puts "error: slice at x = #{x}, y = #{y} is empty"
                next
            elsif name.length > 0 && rendered[name] && !duplicates[name]
                count = slices.count{|iter|iter[:name]==name}
                puts "error: duplicate slice name '#{name}' #{count} times"
                duplicates[name] = true
                next
            end
            system("convert #{renderFile.path} -strip -crop #{width}x#{height}+#{x}+#{y} #{outputDir}/#{name}.png")
            rendered[name] = true
        end
    end
ensure
    renderFile.unlink
end
