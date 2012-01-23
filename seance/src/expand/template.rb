require 'dir/structure.rb'
require 'expose/db.rb'

module Seance

  module Expand

    TEMPLATE_EXTENSION = ".snc"
    TEMPLATE_REGEX = /#{TEMPLATE_EXTENSION}$/

    def self.template?(file)
      file =~ TEMPLATE_REGEX
    end

    def self.strip_extension(file)
      file.gsub(TEMPLATE_REGEX, '')
    end

    def self.each_template(root)
      templ_folder = Seance::Directory.templ_dir(root)
      src_folder = Seance::Directory.src_dir(root)
      dir = Dir.new(templ_folder)

      dir.each do |fname|
        if template? fname
          orig = Seance::Directory.file_in(templ_folder, fname)
          exported = Seance::Directory.file_in(src_folder, strip_extension(fname))
          yield orig, exported
        end
      end
    end

    @@import_fun = lambda do |root, line, state|
      fundb = Seance::Expose::FuncDB.new(root)
      return fundb.get_func_def(line.strip), state
    end

    @@commands = {"fun" => @@import_fun }

    def self.transform_line(root, line, state)
      md = /^#seance\s+(\w+)(.*)/.match(line)
      if md
        @@commands[md[1]].call(root, md[2], state)
      else
        return line, state
      end
    end

    def self.reify_templates(root)
      each_template(root) do |temfil, expfil|
        outf = File.new(expfil,"w")

        File.open(temfil, "r") do |inf|
          state = nil
          inf.each_line do |line|
            trans, state = transform_line(root, line, state)
            outf.puts(trans)
          end
        end

        outf.close
      end
    end
    
  end
end
