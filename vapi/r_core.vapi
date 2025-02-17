/* radare - LGPL - Copyright 2009-2014 - pancake */

namespace Radare {
[Compact]
[CCode (cheader_filename="r_flag.h,r_anal.h,r_core.h,r_bin.h,r_parse.h,r_lang.h,r_sign.h,r_reg.h,r_list.h,r_types_base.h", cname="RCore", free_function="r_core_free", cprefix="r_core_")]
public class RCore {
	/**
	 * RBin instance
	 */
	public RBin bin;
	/**
	 * RConfig instance
	 */
	public RConfig config;
	/**
	 * Current working offset
	 */
	public uint64 offset;
	/**
	 * Size of the working block
	 */
	public uint32 blocksize;
	/**
	 * Limit maximum size for the working block
	 */
	public uint32 blocksize_max;
	/**
	 * Pointer to the first byte of the working block
	 */
	public uint8 *block;
	public RBuffer *yank_buf;
	public int tmpseek;
	public bool vmode;
	public int interrupted;

	/**
	 * RCons instance
	 */
	public RCons cons;
	/**
	 * RIO instance
	 */
	public RIO io;
	/**
	 * RNum instance with hooks to resolve flags and registers
	 */
	public RNum num;
	public RLib lib;
	public RCmd rcmd;
	public RAnal anal;
	public RAsm rasm;
	public RParse parser;
	public RPrint print;
	public RLang lang;

	public RDebug dbg;
	public RFlag flags;
	public RSearch search;
	// public RSign sign;

	public RFS fs;
	public REgg egg;
	// public string cmdqueue;
	public string lastcmd;
	public int cmdrepeat;
	/**
	 * Entrypoint for the global Sdb namespace
	 */
#if VALABIND_CTYPES
	public void *sdb;
#else
	public SDB.Sdb sdb;
#endif
// rtr_n ...
	// TODO: public RVm vm;
	/* lifecycle */
	public RCons* get_cons ();
	public RConfig* get_config ();
	public RCore();

	public static unowned RCore ncast(uint64 ptr);
	public static unowned RCore cast(void *p);
	public bool loadlibs(int where, string path);
	/* commands */
	public int prompt(bool sync);
	public void prompt_loop ();
	public int prompt_exec();
	//[CCode (PrintfFormat)]
	//public int cmdf(...);
	public int cmd(string cmd, bool log);
	public int cmd0(string cmd);
	public void cmd_init ();

	// XXX. must be const in .h public int cmd_foreach(string cmd, string each);
	/**
	 * Execute every line of the given file as radare commands
	 *
	 * @return true if file exists and has been executed
	 */
	public bool cmd_file(string file);
	public int cmd_command(string cmd);
	public unowned string cmd_str(string cmd);
	public unowned string cmd_str_pipe(string cmd);

	public string op_str(uint64 addr);
	// public RAnal.Op op_anal(uint64 addr);

	public unowned string disassemble_instr(uint64 addr, int l);
	public unowned string disassemble_bytes(uint64 addr, int b);

	public bool anal_all();
	public int anal_search (uint64 from, uint64 to, uint64 ref, int mode);
	public void anal_refs(string input);
	// public int anal_bb(RAnal.Function fcn, uint64 at, int head);
	// public int anal_bb_seek(uint64 addr);
	public int anal_fcn(uint64 at, uint64 from, int reftype, int depth);
	public int anal_fcn_list(string input, string rad);
	public int anal_graph(uint64 addr, int opts);
	//public int anal_graph_fcn(string input, int opts);
	// public int anal_ref_list(bool rad);

/*
	public int project_open (string file, bool thready);
	public int project_save (string file);
	public string project_info (string file);
*/

	public int gdiff(RCore *c2);

	public void rtr_pushout(string input);
	public void rtr_list();
	public void rtr_add(string input);
	public void rtr_remove(string input);
	public void rtr_session(string input);
	public void rtr_cmd(string input);
	/* io */
	public bool write_at(uint64 addr, uint8 *buf, int size);
	//public int write_op(uint64 addr, string arg, char op);
	public int block_size(int size);
	public int seek(uint64 addr, bool rb);
	public int seek_align(uint64 addr, int count);

	public bool yank(uint64 addr, int len);
	public bool yank_paste(uint64 addr, int len);

	public int visual(string input);
	public int visual_cmd(string arg);

	public int serve(RIO.Desc fd);

	/* asm */
	//public static RCore.AsmHit asm_hit_new();
	// public RList<RCore.AsmHit> asm_strsearch(string input, uint64 from, uint64 to, int maxhits, int regexp);
	public RList<RCore.AsmHit> asm_bwdisassemble(uint64 addr, int n, int len);

/*
	// XXX mode = Radare.Io.Mode
	[Compact]
	[CCode (cname="RCoreFile", cprefix="r_core_file_", free_function="")]
	public class File {
		// attributes
		// public RIO.Map map;
		public bool dbg;
		// public RIO.Desc desc;
		RCore core;
		uint8 alive;
	}
*/

	[CCode (cname="RCoreAsmHit", free_function="", ref_function="", unref_function="")]
	public class AsmHit {
		public string code;
		public int len;
		public uint64 addr;
		public AsmHit ();
		// public static RList<RCoreAsmHit> AsmHit.list();
	}

	[CCode (cname="RCoreSearchCallback")]
	public delegate int SearchCallback (uint64 from, uint8 *buf, int len);
	public bool search_cb(uint64 from, uint64 to, SearchCallback cb);

	/* files */
	public RIO.Desc file_open(string file, int mode, uint64 loadaddr=0);
	// public bool file_close_fd(int fd);
	// public bool file_list(int mode);

	public int seek_delta(int64 addr);

	public bool bin_load(string? file, uint64 baddr);
}
}
