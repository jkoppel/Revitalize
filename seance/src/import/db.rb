require 'set'

require "dir/metainf.rb"
require 'dir/dirmanager.rb'
require 'dir/structure.rb'

module Seance
  module Import

    class TypeDB

      include DirManager

      attr_reader :root

      LIST_FILE = "list.yaml"
      SC_FILE = "sc.yaml"

      def self.name_to_filename(nam)
        "#{nam}.hpp"
      end

      def initialize(root)
        @root = Directory.type_import_dir(root)
        @meta = MetaInf.new(@root)
        @meta.ensure_file(SC_FILE, {})
        @meta.ensure_file(LIST_FILE, Set.new)
        @scs = @meta.load(SC_FILE)
        @types = @meta.load(LIST_FILE)
      end
      
      def has_type?(typ)
        @types.include? typ
      end

      def get_type_defn(typ)
        load_raw(self.class.name_to_filename(typ))
      end

      def get_type_sc(typ)
        @scs[typ]
      end

      def start_batch_add
      end

      def batch_add_type(sc, name, content)
        @types << name
        @scs[name] = sc
        dump_raw(content, self.class.name_to_filename(name))
      end

      def end_batch_add
        @meta.dump(@scs, SC_FILE)
        @meta.dump(@types, LIST_FILE)
      end

    end

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
        dump_raw(body, self.class.name_to_filename(name))
        @sigs[name] = {TYPE => type, CONVENTION => convention, ARGS => args}
        @meta.dump(@sigs, SIG_FILE)
      end

      def get_func_type(name)
        @sigs[name][TYPE]
      end

      def get_func_convention(name)
        @sigs[name][CONVENTION]
      end

      def get_func_args(name)
        @sigs[name][ARGS]
      end

      def get_func_body(name)
        load_raw(self.class.name_to_filename(name))
      end
    end

  end
end
