return {["root"] = {["node"] = {["class"] = "ParallelSeqNode",["arg"] = {[1] = {["value"] = "",["key"] = "comment",},[2] = {["value"] = "",["key"] = "debug",},[3] = {["value"] = "",["key"] = "debug_open",},},["node"] = {[1] = {["class"] = "SelectorNode",["arg"] = {[1] = {["value"] = "",["key"] = "comment",},[2] = {["value"] = "",["key"] = "debug",},[3] = {["value"] = "",["key"] = "debug_open",},},["node"] = {[1] = {["class"] = "CmpIntVarCond",["arg"] = {[1] = {["value"] = "status",["key"] = "var_name",},[2] = {["value"] = "1",["key"] = "operator",},[3] = {["value"] = "0",["key"] = "value",},[4] = {["value"] = "",["key"] = "debug",},[5] = {["value"] = "",["key"] = "debug_open",},},},[2] = {["class"] = "ParallelSeqNode",["arg"] = {[1] = {["value"] = "",["key"] = "comment",},[2] = {["value"] = "",["key"] = "debug",},[3] = {["value"] = "",["key"] = "debug_open",},},["node"] = {[1] = {["class"] = "IntVarAssignActionNode",["arg"] = {[1] = {["value"] = "status",["key"] = "name",},[2] = {["value"] = "4",["key"] = "value",},[3] = {["value"] = "status2",["key"] = "debug",},[4] = {["value"] = "",["key"] = "debug_open",},},},[2] = {["class"] = "AddTimerActionNode",["arg"] = {[1] = {["value"] = "jump",["key"] = "name",},[2] = {["value"] = "300",["key"] = "duration",},[3] = {["value"] = "1",["key"] = "loop",},[4] = {["value"] = "status3",["key"] = "debug",},[5] = {["value"] = "1",["key"] = "debug_open",},},},},},},},[2] = {["class"] = "SequenceNode",["arg"] = {[1] = {["value"] = "",["key"] = "comment",},[2] = {["value"] = "",["key"] = "debug",},[3] = {["value"] = "",["key"] = "debug_open",},},["node"] = {[1] = {["class"] = "CheckTimerStatusCond",["arg"] = {[1] = {["value"] = "jump",["key"] = "name",},[2] = {["value"] = "2",["key"] = "operator",},[3] = {["value"] = "",["key"] = "debug",},[4] = {["value"] = "",["key"] = "debug_open",},},},[2] = {["class"] = "CheckTimerStatusCond",["arg"] = {[1] = {["value"] = "jump",["key"] = "name",},[2] = {["value"] = "1",["key"] = "operator",},[3] = {["value"] = "",["key"] = "debug",},[4] = {["value"] = "",["key"] = "debug_open",},},},[3] = {["class"] = "CmpIntVarCond",["arg"] = {[1] = {["value"] = "status",["key"] = "var_name",},[2] = {["value"] = "4",["key"] = "operator",},[3] = {["value"] = "4",["key"] = "value",},[4] = {["value"] = "",["key"] = "debug",},[5] = {["value"] = "",["key"] = "debug_open",},},},[4] = {["class"] = "ParallelSeqNode",["arg"] = {[1] = {["value"] = "",["key"] = "comment",},[2] = {["value"] = "",["key"] = "debug",},[3] = {["value"] = "",["key"] = "debug_open",},},["node"] = {[1] = {["class"] = "SetPosActionNode",["arg"] = {[1] = {["value"] = "1",["key"] = "refer_type",},[2] = {["value"] = "1450",["key"] = "dis",},[3] = {["value"] = "",["key"] = "debug",},[4] = {["value"] = "",["key"] = "debug_open",},},},[2] = {["class"] = "CastAbility1ActionNode",["arg"] = {[1] = {["value"] = "player",["key"] = "target_type",},[2] = {["value"] = "best",["key"] = "pos_type",},[3] = {["value"] = "2",["key"] = "ability_type",},[4] = {["value"] = "0",["key"] = "ability_idx",},[5] = {["value"] = "0*0",["key"] = "add_dis",},[6] = {["value"] = "2",["key"] = "func",},[7] = {["value"] = "",["key"] = "debug",},[8] = {["value"] = "",["key"] = "debug_open",},},},[3] = {["class"] = "AddTimerActionNode",["arg"] = {[1] = {["value"] = "blk",["key"] = "name",},[2] = {["value"] = "100",["key"] = "duration",},[3] = {["value"] = "1",["key"] = "loop",},[4] = {["value"] = "",["key"] = "debug",},[5] = {["value"] = "",["key"] = "debug_open",},},},[4] = {["class"] = "IntVarAssignActionNode",["arg"] = {[1] = {["value"] = "status",["key"] = "name",},[2] = {["value"] = "1",["key"] = "value",},[3] = {["value"] = "",["key"] = "debug",},[4] = {["value"] = "",["key"] = "debug_open",},},},},},},},[3] = {["class"] = "SequenceNode",["arg"] = {[1] = {["value"] = "",["key"] = "comment",},[2] = {["value"] = "",["key"] = "debug",},[3] = {["value"] = "",["key"] = "debug_open",},},["node"] = {[1] = {["class"] = "CheckTimerStatusCond",["arg"] = {[1] = {["value"] = "blk",["key"] = "name",},[2] = {["value"] = "2",["key"] = "operator",},[3] = {["value"] = "",["key"] = "debug",},[4] = {["value"] = "",["key"] = "debug_open",},},},[2] = {["class"] = "CheckTimerStatusCond",["arg"] = {[1] = {["value"] = "blk",["key"] = "name",},[2] = {["value"] = "1",["key"] = "operator",},[3] = {["value"] = "",["key"] = "debug",},[4] = {["value"] = "",["key"] = "debug_open",},},},[3] = {["class"] = "CmpIntVarCond",["arg"] = {[1] = {["value"] = "status",["key"] = "var_name",},[2] = {["value"] = "4",["key"] = "operator",},[3] = {["value"] = "1",["key"] = "value",},[4] = {["value"] = "cmp stat3",["key"] = "debug",},[5] = {["value"] = "1",["key"] = "debug_open",},},},[4] = {["class"] = "ParallelSeqNode",["arg"] = {[1] = {["value"] = "",["key"] = "comment",},[2] = {["value"] = "pppp",["key"] = "debug",},[3] = {["value"] = "1",["key"] = "debug_open",},},["node"] = {[1] = {["class"] = "SpeechBubbleActionNode",["arg"] = {[1] = {["value"] = "别跑~~",["key"] = "text",},[2] = {["value"] = "3",["key"] = "duration",},[3] = {["value"] = "",["key"] = "debug",},[4] = {["value"] = "",["key"] = "debug_open",},},},[2] = {["class"] = "CastAbility1ActionNode",["arg"] = {[1] = {["value"] = "player",["key"] = "target_type",},[2] = {["value"] = "player",["key"] = "pos_type",},[3] = {["value"] = "1",["key"] = "ability_type",},[4] = {["value"] = "0",["key"] = "ability_idx",},[5] = {["value"] = "0*0",["key"] = "add_dis",},[6] = {["value"] = "3",["key"] = "func",},[7] = {["value"] = "",["key"] = "debug",},[8] = {["value"] = "",["key"] = "debug_open",},},},[3] = {["class"] = "IntVarAssignActionNode",["arg"] = {[1] = {["value"] = "status",["key"] = "name",},[2] = {["value"] = "3",["key"] = "value",},[3] = {["value"] = "4",["key"] = "debug",},[4] = {["value"] = "1",["key"] = "debug_open",},},},[4] = {["class"] = "AddTimerActionNode",["arg"] = {[1] = {["value"] = "dead",["key"] = "name",},[2] = {["value"] = "5000",["key"] = "duration",},[3] = {["value"] = "1",["key"] = "loop",},[4] = {["value"] = "",["key"] = "debug",},[5] = {["value"] = "",["key"] = "debug_open",},},},},},},},[4] = {["class"] = "SequenceNode",["arg"] = {[1] = {["value"] = "",["key"] = "comment",},[2] = {["value"] = "",["key"] = "debug",},[3] = {["value"] = "",["key"] = "debug_open",},},["node"] = {[1] = {["class"] = "CmpIntVarCond",["arg"] = {[1] = {["value"] = "status",["key"] = "var_name",},[2] = {["value"] = "4",["key"] = "operator",},[3] = {["value"] = "3",["key"] = "value",},[4] = {["value"] = "",["key"] = "debug",},[5] = {["value"] = "",["key"] = "debug_open",},},},[2] = {["class"] = "CheckTimerStatusCond",["arg"] = {[1] = {["value"] = "dead",["key"] = "name",},[2] = {["value"] = "1",["key"] = "operator",},[3] = {["value"] = "",["key"] = "debug",},[4] = {["value"] = "",["key"] = "debug_open",},},},[3] = {["class"] = "ForceKilledActionNode",["arg"] = {[1] = {["value"] = "",["key"] = "debug",},[2] = {["value"] = "",["key"] = "debug_open",},},},},},},},["@config"] = "NPC_AI",},}