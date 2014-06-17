#!/usr/bin/env ruby
#
# parse the chartOpts options from inst/charts/*.coffee
# and add that information to the chartOpts vignette

# find all of the coffeescript files in a directory
def find_coffeescript_files (directory)
    files = []
    Dir.foreach(directory) do |file|
        files.push(file) if file =~ /\.coffee$/
    end
    files
end

# parse the chartOpts lines in a coffeescript file
def parse_coffeescript_file (filename)
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

        opts_variable = line.strip.split[2]
        print "Inconsistent chartOpt: #{filename}: #{line}\n" if opts_variable != "chartOpts?.#{variable}"

        comments[variable] = comment
    end

    file.close

    comments
end


# add the chartOpts to Rmd file
def add_chartOpts_to_Rmd (inputfile, outputfile, chartOpts, mvcomments)
    ifile = File.open(inputfile)
    ofile = File.open(outputfile, "w")
    ifile.each do |line|
        if line =~ /<<insert_chartOpts_here>>/
            write_chartOpts(ofile, chartOpts, mvcomments)
        else
            ofile.print(line)
        end
    end
    ifile.close
    ofile.close
end


# load info about multi-version functions
def load_multiversions (filename)

    multiver_comments = {}

    File.open(filename).each do |line|
        v = line.strip.split(/,/)
        multiver_comments[v[0]] = v[1]
    end

    multiver_comments
end
        

# pull off the first part of the coffeescript file name
def get_filestem (csfile)
    return $1 if csfile =~ /^(.+)\.coffee$/
    print "unexpected name for coffeescript file: #{csfile}"
    csfile
end    

# if filestem like func_opt, return "opt"
def get_func_name (filestem)
    return $1 if filestem =~ /^(.+)_/
    filestem
end    

def write_chartOpts (ofile, chartOpts, mvcomments)

    keys = chartOpts.keys
    mvkeys = mvcomments.keys

    # sort the coffeescript files
    keys.sort! { |a,b|
        if mvkeys.include?(a) and mvkeys.include?(b)
        then mvkeys.find_index(a) <=> mvkeys.find_index(b)
        else keys.find_index(a) <=> keys.find_index(b) end }

    keys.each do |filestem|
        func = get_func_name(filestem)

        ofile.print "### `#{func}`"
        ofile.print " (#{mvcomments[filestem]})" unless mvcomments[filestem].nil?
        ofile.print "\n\n"

        chartOpts[filestem].each do |opt, comment|
            ofile.print "`#{opt}`: #{comment}\n\n"
        end

    end

end

##############################
### now to the real work
##############################
# directory and file names
chart_dir = "inst/charts"
ifile = "vignettes/chartOpts_vignette/chartOpts_source.Rmd"
ofile = "vignettes/chartOpts.Rmd"
mvfile = "vignettes/chartOpts_vignette/multiversions.csv"

# find coffeescript files
coffee_files = find_coffeescript_files(chart_dir)

# multi-version functions: get comment information
mvcomments = load_multiversions(mvfile)

# parse the chartOpts in the coffeescript files
chartOpts = {}
coffee_files.each do |file|
    chartOpts[get_filestem(file)] = parse_coffeescript_file("#{chart_dir}/#{file}")
end

# add the chartOpts to the Rmd vignette
add_chartOpts_to_Rmd(ifile, ofile, chartOpts, mvcomments)
