
module Seance
  module Import

    def self.parse_sig(sig)
      sig = sig.strip
      re = /^(.+)(__thiscall|__stdcall|__cdecl|__fastcall) ([\w:]+)\((.+)\)$/
      md = re.match(sig)
      
      if md.nil?
        p sig
        raise "Function signature did not correspond to expected format"
      else
        {:type => md[1].strip,
          :convention => md[2],
          :name => md[3],
          :args => md[4]}
      end
    end

    def self.import_func(filnam, root)
      f = File.open(filnam, "r")
      sig = f.readline
      body = f.readlines.join
      f.close

      comps = parse_sig(sig)

      db = FuncDB.new(root)
      db.add_func(comps[:type], comps[:name], comps[:convention], comps[:args], body)
    end

  end
end
