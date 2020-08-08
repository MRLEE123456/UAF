-------------------------------------------------------------------------------
-- This section configures the S2E engine.
s2e = {
    kleeArgs = {
	"--use-dfs-search=true",
	--"--use-concolic-execution=true",
        "--enable-forking=true",
        "--fork-on-symbolic-address=false",
	"--verbose-fork-info=true"
    },

    logging = {
        -- Possible values include "info", "warn", "debug", "none".
        -- See Logging.h in libs2ecore.
        console = "debug",
        logLevel = "info",
    },

}

-- Declare empty plugin settings. They will be populated in the rest of
-- the configuration file.
plugins = {}
pluginsConfig = {}


-- Include various convenient functions
dofile('library.lua')

-------------------------------------------------------------------------------
-- This plugin contains the core custom instructions.
-- Some of these include s2e_make_symbolic, s2e_kill_state, etc.
-- You always want to have this plugin included.

add_plugin("BaseInstructions")


--[[
-------------------------------------------------------------------------------
-- This plugin provides support for virtual machine introspection and binary
-- formats parsing. S2E plugins can use it when they need to extract
-- information from binary files that are either loaded in virtual memory
-- or stored on the host's file system.
add_plugin("Vmi")
pluginsConfig.Vmi = {
    baseDirs = { "/home/hhui/Experiments/s2e-dev/build/guest-mounts/windows7-ultimate-x86",
    },
}


add_plugin("ModuleExecutionDetector")
pluginsConfig.ModuleExecutionDetector = {
}
]]--


--add_plugin("FunctionModels")


-------------------------------------------------------------------------------
-- This plugin provides support for virtual machine introspection and binary
-- formats parsing. S2E plugins can use it when they need to extract
-- information from binary files that are either loaded in virtual memory
-- or stored on the host's file system.
add_plugin("Vmi")
pluginsConfig.Vmi = {
    --baseDirs = { "/home/hhui/Experiments/s2e-dev/build/guest-mounts/windows7-ultimate-x86",
    baseDirs = { "/home/hhui/Experiments/s2e-dev-3.0/build/guest-mounts/debian-10.1.0-i386",
    },
}

add_plugin("HostFiles")
pluginsConfig.HostFiles = {
    allowWrite = true,

    baseDirs = { 
                 --"/home/hhui/Experiments/s2e-dev-3.0/build/seed-inputs/uaf1/",
		 "SEEDDIR",
	         "/home/hhui/Experiments/s2e-dev-3.0/build/test-programs/",
                 --"/home/hhui/Experiments/s2e-dev-3.0/build/seed-inputs/jasper-uaf/",
                 --"/home/hhui/Experiments/s2e-dev/build/guest-bootstrap/"
                 "/home/hhui/Experiments/s2e-dev-3.0/s2e-3.0/scripts/guest/linux/"
    }
}


-------------------------------------------------------------------------------
-- LinuxMonitor is a plugin that monitors Linux events and exposes them
-- to other plugins in a generic way. Events include process load/termination,
-- thread events, signals, etc.
--
-- LinuxMonitor requires a custom Linux kernel with S2E extensions. This kernel
-- (and corresponding VM image) can be built with S2E tools. Please refer to
-- the documentation for more details.

add_plugin("LinuxMonitor")
pluginsConfig.LinuxMonitor = {
    kernelVer  = "linux-4.9.3",
    kernelBits = 32,

    -- Kill the execution state when it encounters a segfault
    terminateOnSegfault = true,

    -- Kill the execution state when it encounters a trap
    terminateOnTrap = true,
}


-- add_plugin("ProcessExecutionDetector")
add_plugin("MemoryMap")

add_plugin("ModuleMap")
pluginsConfig.ModuleMap = {
}


add_plugin("ProcessExecutionDetector")
pluginsConfig.ProcessExecutionDetector = {
    -- enable the 'DbgFuncTraceAnalysis' plugin
    -- HCONFIG_USE_DBG_FUNCTRACE_ANALYSIS = true,
    HCONFIG_USE_DBG_FUNCTRACE_ANALYSIS = false,

    -- consider we can run 32-bit programs under x64 ...
    HVALUE_TARGET_ARCHBITS = 32,

    HCONFIG_USE_EXPGEN = false,

    -- the main module names for the interested processes
    moduleNames = { "uaf1"
    },

    term_onProcessUnload = true,
}


add_plugin("TestCaseGenerator")
pluginsConfig.TestCaseGenerator = {
    tcase_prefix       = "TCASE_PREFIX",
    output_tcDir       = "OUTPUT_TESTCASEDIR",
    generateOnSegfault = true,
}


--[[
add_plugin("DbgInstructionMonitor")
pluginsConfig.DbgInstructionMonitor = {
    mainImageName = "imgcmp-v1",
}
]]--


-------------------------------------------------------------------------
add_plugin("ModuleExecutionDetector")
pluginsConfig.ModuleExecutionDetector = {
    trackExecution = true, -- 是否追踪模块的执行情况。

    slot1 = {
        moduleName = "uaf1",
        kernelMode = false,
    },
}

--[[
add_plugin("ExecutionTracer")

add_plugin("ModuleTracer")

add_plugin("TranslationBlockTracer")
pluginsConfig.TranslationBlockTracer = {
    monitorModules = true -- restrict monitoring to the configured modules
}

add_plugin("MemoryTracer")
pluginsConfig.MemoryTracer = {
    monitorMemory = true,
    monitorModules = true,
}
]]--

-------------------------------------------------------------------------


add_plugin("CpuidHooker")
pluginsConfig.CpuidHooker = {
}


add_plugin("UafAssert")
pluginsConfig.UafAssert = {
    tcase_prefix  = "TCASE_PREFIX",
    output_pocDir = "OUTPUT_POCDIR",
    outputSubDir  = "UafChecks",
    mainImageName = "uaf1",

    chkpoints = {
	--[[
	group1 = { chkptr1 = { addr    = "uaf1!0x1364",
		  	       operand = { type   = "mem",
			      		   ptrReg = "ESP",
			      		   ptrOff = 0,
					   size   = 4,
		  	       },
		   }, -- free point

		   chkptr2 = { addr    = "uaf1!0x1375",
		   	       operand = { type   = "reg",
			       		   Reg    = "EAX",
			       },
		   }, -- use point
	},]]--
    --chkpoints_of_UAF
            group1 = { chkptr1 = { addr = "uaf1!0x552",
                                operand = { type = "mem",
                                            ptrReg = "ESP",
                                            ptrOff = 0,
                                            size = 4,
                                         },
                              },
                    chkptr2 = { addr = "uaf1!0x560",
                                operand = { type = "mem",
                                            ptrReg = "ESP",
                                            ptrOff = 0,
                                            size = 4,
                                         },
                              },
                 },

    },
}

add_plugin("InlineStrcpyAssert")
pluginsConfig.InlineStrcpyAssert = {
    tcase_prefix  = "TCASE_PREFIX",
    output_pocDir = "OUTPUT_POCDIR",
    outputSubDir  = "UafChecks",
    mainImageName = "uaf1",

    chkpoints = {
	--[[
	group1 = { addr = "EQNEDT32.EXE!0x9d82",
                   operand = { type = "imm",
                               ptrReg = "None",
                               ptrOff = 4538560,
                               size = -1,
                   },
	},
	]]--
	--chkpoints_of_InlineStrcpy
    },
}

--[[
add_plugin("UnsafeFunctionAssert")
pluginsConfig.InlineStrcpyAssert = {
    outputSubDir = "UafChecks",
    mainImageName = "uaf1",
    chkpoints = {
	group1 = { addr = "EQNEDT32.EXE!0x9d82",
                   operand = { type = "imm",
                               ptrReg = "None",
                               ptrOff = 4538560,
                               size = -1,
                   },
	},
	--chkpoints_of_UnsafeFunction
    },
}
]]--


add_plugin("CfgDirectedAnalysis")
pluginsConfig.CfgDirectedAnalysis = {

    CONFIG_CFGDIRECTED_PATH_EXPLORE = true,
    CONFIG_USE_DEFAULT_SYSTEM_INSTRUMENTATION = false,
    CONFIG_TARGET_BIT = 32,

    processName    = "uaf1",
    cfgDir_modules = { 
	mod1 = { name = "uaf1", 
    		 size = 7555,
	},
    },

    dbIp     = "127.0.0.1",
    dbPort   = 3306,
    dbName   = "CFGAnalysis",
    userName = "root",
    userPwd  = "123", 

    dirInfo = {
	        group1 = {
            vulFunc = "uaf1!0x52d",
            vulPoint = "uaf1!0x552",
        },

    }
}


add_plugin("SeedSearcher")
pluginsConfig.SeedSearcher = {
    sg_seedCount          = SG_SEEDCOUNT,
    seedDirectory         = "SEEDDIR",
    enableSeeds           = true,
    maxSeedStates         = 1024,
    enableParallelSeeding = false,

    backupSeeds           = false,
    -- seeds-backup       = XXX,  -- 如果 backupSeeds 为 true 时，这里将指定宿主机上的备份目录

    lowPrioritySeedThreshold = 0  -- 必须被设置！优先级等于或低于该阀值的 seed 将被认为是 low priority。
}


add_plugin("CUPASearcher")
pluginsConfig.CUPASearcher = {
    enabled = true,
    classes = {"seed"},


}


add_plugin("MultiSearcher")
pluginsConfig.MultiSearcher = {
}


fuhrer:
add_plugin("CodeSelector")
pluginsConfig.CodeSelector = {
    procName = "uaf1",

    modInfo = { 
        --[[slot1 = {   modName = "uaf1",
	                        fullMP  = true, -- full multiple paths
                },]]--

		    --[[slot2 = {   modName = "",
		                    fullMP  = false,

			                regions = { region1 = { start_offset = ,
			  			                            end_offset   = ,
			  	                        },

			                },
		        },
        ]]--
        slot1 = {
            modName = "uaf1",
            fullMP = false,
            regions = {
                    region1 = {
                        start_offset = 0x52d,
                        end_offset = 0x56a,
                    },
            },
        },


    }

}