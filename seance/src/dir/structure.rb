require 'dir/metainf.rb'

module Seance

  class Directory
    
    include DirManager

    attr_reader :root

    IMPORTS_DIR = "imports"
    IMPORTS_FUNCS_DIR = "imports/funcs"
    IMPORTS_TYPES_DIR = "imports/types"
    TRANS_DIR = "trans"
    TRANS_FUNCS_DIR = "trans/funcs"
#    TRANS_TYPES_DIR = "trans/types"
    TRANS_TEMPL_DIR = "trans/template"
    SRC_DIR = "src"

    SUBDIRS = [IMPORTS_DIR,
               IMPORTS_FUNCS_DIR,
               IMPORTS_TYPES_DIR,
               TRANS_DIR,
               TRANS_FUNCS_DIR,
#               TRANS_TYPES_DIR,
               TRANS_TEMPL_DIR,
               SRC_DIR]

    def self.type_import_dir(root)
      "#{root}/#{IMPORTS_TYPES_DIR}"
    end

#    def self.type_expose_dir(root)
#      "#{root}/#{TRANS_TYPES_DIR}"
#    end

    def self.func_import_dir(root)
      "#{root}/#{IMPORTS_FUNCS_DIR}"
    end

    def self.func_expose_dir(root)
      "#{root}/#{TRANS_FUNCS_DIR}"
    end

    def self.imports_dir(root)
      "#{root}/#{IMPORTS_DIR}"
    end
    
    def initialize(root)
      @root = root
    end
    
    def init_seance
      SUBDIRS.each do |name|
        ensure_dir(path(name))
        meta = MetaInf.new(path(name))
      end
    end
    
  end
end
