require 'set'

require "dir/metainf.rb"
require 'dir/dirmanager.rb'
require 'dir/structure.rb'

module Seance
  module Expose

    # class TypeDB

    #   DEFS_FILE = "defs.yaml"

    #   include DirManager

    #   attr_reader :root

    #   SC_FILE = "sc.yaml"
    #   LIST_FILE = "list.yaml"

    #   def self.name_to_filename(nam)
    #     "#{nam}.hpp"
    #   end

    #   def initialize(root)
    #     @root = Directory.type_expose_dir(root)
    #     @meta = MetaInf.new(@root)
    #     @meta.ensure_file(SC_FILE, {})
    #     @meta.ensure_file(LIST_FILE, Set.new)
    #     @scs = @meta.load(SC_FILE)
    #     @types = @meta.load(LIST_FILE)
    #   end
      
    #   def add_type(content, sc, nam)
    #     dump_raw(content, self.class.name_to_filename(nam))
    #     @scs[nam] = sc
    #     @types << nam
    #     @meta.dump(SC_FILE, @scs)
    #     @meta.dump(LIST_FILE, @types)
    #   end

    #   def has_type?(typ)
    #     @types.has_key? typ
    #   end

    #   def get_type_defn(typ)
    #     load_raw(self.class.name_to_filename(typ))
    #   end

    # end

   
    class FuncDB
      
      include DirManager

      attr_reader :root

      SIG_FILE = "sigs.yaml"
      TYPE = :type
      CONVENTION = :convention
      ARGS = :args

      def self.name_to_filename(nam)
        (nam.gsub(':','_'))+".cpp"
      end

      def initialize(root)
        @root = Directory.func_import_dir(root)
        @meta = MetaInf.new(@root)
        @meta.ensure_file(SIG_FILE, {})
        @sigs = @meta.load(SIG_FILE)
      end

      def has_func?(nam)
        @sigs.has_key? nam
      end

      def get_func_body(nam)
        load_raw(self.class.name_to_filename(nam))
      end

      def add_func(type, name, convention, args, body)
        dump_raw(self.class.name_to_filename(name), body)
        @sigs[name] = {TYPE => type, CONVENTION => convention, ARGS => args}
        @meta.dump(SIG_FILE, @sigs)
      end
    end

  end
end
