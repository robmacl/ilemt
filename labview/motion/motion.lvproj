<?xml version='1.0' encoding='UTF-8'?>
<Project Type="Project" LVVersion="17008000">
	<Property Name="NI.LV.All.SaveVersion" Type="Str">17.0</Property>
	<Property Name="NI.LV.All.SourceOnly" Type="Bool">true</Property>
	<Property Name="varPersistentID:{3CDC7F15-75D3-4F87-8464-3FC7E1A9B6BE}" Type="Ref">/My Computer/server/motion_vars.lvlib/End transform</Property>
	<Property Name="varPersistentID:{58587375-4B84-4395-9734-481035E6C968}" Type="Ref">/My Computer/server/motion_vars.lvlib/Axis Offsets</Property>
	<Property Name="varPersistentID:{A55BB21C-1E42-454E-86E7-81E73C13808B}" Type="Ref">/My Computer/server/motion_vars.lvlib/Motion status</Property>
	<Property Name="varPersistentID:{F0050BBF-EB7E-46EF-8931-3FD24B3F78D5}" Type="Ref">/My Computer/server/motion_vars.lvlib/Motion command</Property>
	<Property Name="varPersistentID:{F2BF25DC-3B55-4C03-8CE2-0E2ACD2C570D}" Type="Ref">/My Computer/server/motion_vars.lvlib/Home Position</Property>
	<Property Name="varPersistentID:{FFDE281A-C1A9-419A-A2DE-1DDF71B60D9D}" Type="Ref">/My Computer/server/motion_vars.lvlib/Emergency stop</Property>
	<Item Name="My Computer" Type="My Computer">
		<Property Name="CCSymbols" Type="Str"></Property>
		<Property Name="server.app.propertiesEnabled" Type="Bool">true</Property>
		<Property Name="server.control.propertiesEnabled" Type="Bool">true</Property>
		<Property Name="server.tcp.acl" Type="Str">0800000008000000</Property>
		<Property Name="server.tcp.enabled" Type="Bool">false</Property>
		<Property Name="server.tcp.port" Type="Int">0</Property>
		<Property Name="server.tcp.serviceName" Type="Str"></Property>
		<Property Name="server.tcp.serviceName.default" Type="Str">My Computer/VI Server</Property>
		<Property Name="server.vi.access" Type="Str"></Property>
		<Property Name="server.vi.callsEnabled" Type="Bool">true</Property>
		<Property Name="server.vi.propertiesEnabled" Type="Bool">true</Property>
		<Property Name="server.viscripting.showScriptingOperationsInContextHelp" Type="Bool">false</Property>
		<Property Name="server.viscripting.showScriptingOperationsInEditor" Type="Bool">false</Property>
		<Property Name="specify.custom.address" Type="Bool">false</Property>
		<Item Name="client" Type="Folder">
			<Item Name="Axis offsets.vi" Type="VI" URL="../client/Axis offsets.vi"/>
			<Item Name="Emergency stop.vi" Type="VI" URL="../client/Emergency stop.vi"/>
			<Item Name="End transform.vi" Type="VI" URL="../client/End transform.vi"/>
			<Item Name="Home position.vi" Type="VI" URL="../client/Home position.vi"/>
			<Item Name="Motion status.vi" Type="VI" URL="../client/Motion status.vi"/>
			<Item Name="move_to.vi" Type="VI" URL="../client/move_to.vi"/>
		</Item>
		<Item Name="common" Type="Folder">
			<Item Name="motion_command.ctl" Type="VI" URL="../server/motion_command.ctl"/>
			<Item Name="motion_status.ctl" Type="VI" URL="../motion_status.ctl"/>
		</Item>
		<Item Name="server" Type="Folder">
			<Property Name="NI.SortType" Type="Int">3</Property>
			<Item Name="find_ref_test.vi" Type="VI" URL="../server/find_ref_test.vi"/>
			<Item Name="forward_kinematics.vi" Type="VI" URL="../server/forward_kinematics.vi"/>
			<Item Name="ideal_inverse_kinematics.vi" Type="VI" URL="../../utilities/ideal_inverse_kinematics.vi"/>
			<Item Name="inv_kin_test.vi" Type="VI" URL="../server/inv_kin_test.vi"/>
			<Item Name="inv_kin_test_pose.vi" Type="VI" URL="../server/inv_kin_test_pose.vi"/>
			<Item Name="inverse_kinematics.vi" Type="VI" URL="../server/inverse_kinematics.vi"/>
			<Item Name="vector_pose_test.vi" Type="VI" URL="../../utilities/labview/vector_pose_test.vi"/>
			<Item Name="motion_vars.lvlib" Type="Library" URL="../motion_vars.lvlib"/>
		</Item>
		<Item Name="motion_server.vi" Type="VI" URL="../server/motion_server.vi"/>
		<Item Name="motion_ui.vi" Type="VI" URL="../client/motion_ui.vi"/>
		<Item Name="philtec_ui.vi" Type="VI" URL="../server/philtec_ui.vi"/>
		<Item Name="Dependencies" Type="Dependencies"/>
		<Item Name="Build Specifications" Type="Build"/>
	</Item>
</Project>
