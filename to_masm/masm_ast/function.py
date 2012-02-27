import idaapi
import idc
import general
import data
import insn
import names
import struct
import cpp_interop


class function_node(general.masm_ast_node):
    
    def __init__(self, func):
        self.src = func
        self.name = idaapi.get_func_name(func.startEA)
        self.elts = []
        ea = func.startEA

        if idaapi.is_func_tail(func):
            self.name += "_tail_"+str(ea)

        fr = idaapi.get_frame(func)
        struc_vars = []
        if fr == None:
            self.frame = None
        else:
            self.frame = struct.frame_node(fr, func)
            struc_vars = self.frame.struct_vars

        while ea < func.endEA:
            if idaapi.isData(idaapi.getFlags(ea)):
                self.elts.append(data.data_node(ea, idaapi.next_not_tail(ea)))
            else:
                if ea == func.startEA and not (idaapi.is_func_tail(func)):
                    self.elts.append(insn.insn_node(ea, struc_vars))
                else:
                    self.elts.append(names.name_wrap_insn(ea, insn.insn_node(ea, struc_vars)))

            ea = idaapi.next_head(ea, func.endEA)
        

    def to_masm(self):
        print "Outputting function %s" % self.name
        dist = "far" if self.src.is_far() else "near"
        frame_str = ""
        if self.frame != None:
            frame_str = self.frame.to_masm()
            
        defn = "%s proc %s C\n\n\n%s\n%s\n%s endp\n" % (self.name,
                                                        dist,
                                                        frame_str,
                                                        "\n".join(map(lambda e: e.to_masm(), self.elts)),
                                                        self.name)
            
        return cpp_interop.import_toggle_wrap(defn, self.name)

#Also handles data in between functions
class functions_node(general.masm_ast_node):

    def __init__(self, low, high):
        self.elts = []
        for i in range(idaapi.get_fchunk_qty()):
            f = idaapi.getn_fchunk(i)
            if f.startEA >= low and f.endEA <= high:
                self.elts.append(function_node(f))
                
            datalow = f.endEA
            nextchunk = idaapi.getn_fchunk(i+1)
            if datalow != idaapi.BADADDR and not (nextchunk is None):
                datahigh = nextchunk.startEA
                if datahigh != idaapi.BADADDR:
                    self.elts.append(data.data_node(datalow, datahigh))
        #for i in range(idaapi.get_func_qty()):
        #    f = idaapi.getn_func(i)
        #    if f.startEA >= low and f.endEA <= high:
        #        #self.elts.append(function_node(f))

    def to_masm(self):
        return "\n".join(map(lambda e: e.to_masm(),
                             self.elts))
