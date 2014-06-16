#!/usr/bin/env ruby
#
# parse the chartOpts options from inst/charts/*.coffee
# and add that information to the chartOpts vignette

def find_coffeescript_files (directory)
    files = []
    Dir.foreach(directory) do |file|
        files.push(file) if file =~ /\.coffee$/
    end
    files
end

def parse_file (filename)
    file = File.open(filename)

    # skip past header
    file.each { |line| break if line =~ /# chartOpts start/ }

    variables = []
    comments = {}
    file.each do |line|
        break if line =~ /# chartOpts end/

        line = line.strip()
        next if line == ""

        variable = line.split(/\=/)[0].strip()
        comment = line.split(/\#/)[1].strip()

        variables.push(variable)
        comments[variable] = comment
    end

    [variables, comments]
end


chart_dir = "inst/charts"
coffee_files = find_coffeescript_files(chart_dir)

chartOpts = {}
coffee_files.each do |file|
    puts "Reading from #{file}"
    chartOpts[file] = parse_file("#{chart_dir}/#{file}")
end

coffee_files.each do |file|
    chartOpts[file][0].each do |var|
        print "#{file} : #{var} : #{chartOpts[file][1][var]}\n"
    end
end    
