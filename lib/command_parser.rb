require 'optparse'

# wrapper class for options parser
class CommandParser

  attr_writer :quotes

    def initialize
        @options = options
    end

    # default options
    def options
        { method: nil, arguments: nil}
    end

    # collect the command arguments via the option parser class
    def collect(arguments)
        # build the class options from options parser instance
        parser = OptionParser.new do |opts|
            opts.banner = "Options for output grasshopper"
            opts.separator "\n"
            opts.separator "Specifics:"

            opts.on('-m [name]', '--motivate [name]', String, "# Output a motivational quote") do |m|
                @options[:method] = 'motivate'
                @options[:arguments] = { author: m }
            end

            opts.on('-w [glob1,glob2] ', '--watch [glob1,glob2]', Array, '# Watch files & output a message on file/folder change event') do |w|
                @options[:method] = 'watch'
                @options[:arguments] = { files: w }
            end

            opts.on('-q [quotefile]', '--quotes [quotefile]', String, '# Use a specific quotefile') do |q|
              @options[:quotes] = q
            end

            opts.on_tail('-h', '--help', '# Output command line help options') do
                puts opts
                exit
            end
        end

        # set the options from calling the parser if there are any exceptions
        # we need to catch them and output the help message
        begin
            parser.parse!(arguments)
        rescue Exception => e
            puts parser
            exit(1)
        end

        # if no valid methods were set we can't execute and therefore we exit and
        # put the parser message to the console
        if @options[:method].nil?
            puts parser
            exit(1)
        end

        #return the options
        @options
    end

    #output a pretty list of authors
    def output_authors
        authors = []

        quotes.each do |author|
            authors << author[0]
        end

        authors.join(', ')
    end
end
