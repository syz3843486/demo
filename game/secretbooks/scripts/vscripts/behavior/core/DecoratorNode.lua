print('ControlNode load ..')
require 'behavior/common/common'

local BTreeCMN = require 'behavior/BTreeCMN'


-- <node catalogue ="Decorator" class ="DecoratorNotNode" name ="结果取反" style ="decorator">
--     <arg name="debug"  text="y.调试信息" type="string" comment ="描述结点功能，备忘" default =""/>
--     <arg name="debug_open"  text="z.调试状态" type="string" comment ="描述结点功能，备忘" default =""/>
--   </node>
--   <node catalogue ="Decorator" class ="DecoratorTrueNode" name ="结果取真" style ="decorator">
--      <arg name="debug"  text="y.调试信息" type="string" comment ="描述结点功能，备忘" default =""/>
--     <arg name="debug_open"  text="z.调试状态" type="string" comment ="描述结点功能，备忘" default =""/>
--   </node>
--   <node catalogue ="Decorator" class ="DecoratorFalseNode" name ="结果取假" style ="decorator">
--      <arg name="debug"  text="y.调试信息" type="string" comment ="描述结点功能，备忘" default =""/>
--     <arg name="debug_open"  text="z.调试状态" type="string" comment ="描述结点功能，备忘" default =""/>
--   </node>
do 
	local DecoratorNotNode = BTreeCMN.Class('DecoratorNotNode',BaseNode)
	BTreeCMN.NodeClassList['DecoratorNotNode'] = DecoratorNotNode

	function DecoratorNotNode:process(entity)
		self.super.process(self,entity)

		local m_children = self.m_children
		return not m_children[1]:process(entity)
	end
end

do 
	local DecoratorNotNode = BTreeCMN.Class('DecoratorTrueNode',BaseNode)
	BTreeCMN.NodeClassList['DecoratorTrueNode'] = DecoratorTrueNode

	function DecoratorTrueNode:process(entity)
		self.super.process(self,entity)

		local m_children = self.m_children
		m_children[1]:process(entity)
		return true
	end
end

do 
	local DecoratorNotNode = BTreeCMN.Class('DecoratorFalseNode',BaseNode)
	BTreeCMN.NodeClassList['DecoratorFalseNode'] = DecoratorFalseNode

	function DecoratorFalseNode:process(entity)
		self.super.process(self,entity)

		local m_children = self.m_children
		m_children[1]:process(entity)
		return false
	end
end