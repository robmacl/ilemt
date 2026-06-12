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
		<Item Name="trio_position.vi" Type="VI" URL="../server/trio_position.vi"/>
		<Item Name="trio_read_axis.vi" Type="VI" URL="../../../../ilemt_cal_hw/stage/trio_read_axis.vi"/>
		<Item Name="trio_stepper_axis.vi" Type="VI" URL="../server/trio_stepper_axis.vi"/>
		<Item Name="trio_test.vi" Type="VI" URL="../server/trio_test.vi"/>
		<Item Name="Dependencies" Type="Dependencies">
			<Item Name="instr.lib" Type="Folder">
				<Item Name="Analog IO Demo.vi" Type="VI" URL="/&lt;instrlib&gt;/Trio Motion/Examples/Analog IO Demo.vi"/>
				<Item Name="Basic Motion Demo.vi" Type="VI" URL="/&lt;instrlib&gt;/Trio Motion/Examples/Basic Motion Demo.vi"/>
				<Item Name="Controller Setup Servo.vi" Type="VI" URL="/&lt;instrlib&gt;/Trio Motion/Examples/Controller Setup Servo.vi"/>
				<Item Name="Controller Setup.vi" Type="VI" URL="/&lt;instrlib&gt;/Trio Motion/Examples/Controller Setup.vi"/>
				<Item Name="Digital IO Demo.vi" Type="VI" URL="/&lt;instrlib&gt;/Trio Motion/Examples/Digital IO Demo.vi"/>
				<Item Name="Jog Demo Multi-axis.vi" Type="VI" URL="/&lt;instrlib&gt;/Trio Motion/Examples/Jog Demo Multi-axis.vi"/>
				<Item Name="Jog Demo Servo.vi" Type="VI" URL="/&lt;instrlib&gt;/Trio Motion/Examples/Jog Demo Servo.vi"/>
				<Item Name="Jog Demo.vi" Type="VI" URL="/&lt;instrlib&gt;/Trio Motion/Examples/Jog Demo.vi"/>
				<Item Name="Motion Demo Home Multi-axis.vi" Type="VI" URL="/&lt;instrlib&gt;/Trio Motion/Examples/Motion Demo Home Multi-axis.vi"/>
				<Item Name="Motion Demo Home.vi" Type="VI" URL="/&lt;instrlib&gt;/Trio Motion/Examples/Motion Demo Home.vi"/>
				<Item Name="Motion Demo Ratio Multi-axis.vi" Type="VI" URL="/&lt;instrlib&gt;/Trio Motion/Examples/Motion Demo Ratio Multi-axis.vi"/>
				<Item Name="Motion Demo Servo Home.vi" Type="VI" URL="/&lt;instrlib&gt;/Trio Motion/Examples/Motion Demo Servo Home.vi"/>
				<Item Name="Motion Demo Servo Open-Loop Tune.vi" Type="VI" URL="/&lt;instrlib&gt;/Trio Motion/Examples/Motion Demo Servo Open-Loop Tune.vi"/>
				<Item Name="Motion Demo Servo Tune.vi" Type="VI" URL="/&lt;instrlib&gt;/Trio Motion/Examples/Motion Demo Servo Tune.vi"/>
				<Item Name="Motion Demo Synchronous Multi-axis.vi" Type="VI" URL="/&lt;instrlib&gt;/Trio Motion/Examples/Motion Demo Synchronous Multi-axis.vi"/>
				<Item Name="Trio Motion Library.lvlib" Type="Library" URL="/&lt;instrlib&gt;/Trio Motion/Trio Motion Library.lvlib"/>
			</Item>
			<Item Name="vi.lib" Type="Folder">
				<Item Name="AxisOrVectorSpaceControl To Control.flx" Type="VI" URL="/&lt;vilib&gt;/Motion/FlexMotion/CustomControls/CustomControls.llb/AxisOrVectorSpaceControl To Control.flx"/>
				<Item Name="Board Id" Type="VI" URL="/&lt;vilib&gt;/Motion/FlexMotion/CustomControls/CustomControls.llb/Board Id"/>
				<Item Name="BuildHelpPath.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/BuildHelpPath.vi"/>
				<Item Name="Check Special Tags.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Check Special Tags.vi"/>
				<Item Name="Clear Errors.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Clear Errors.vi"/>
				<Item Name="Convert property node font to graphics font.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Convert property node font to graphics font.vi"/>
				<Item Name="DAQmx Clear Task.vi" Type="VI" URL="/&lt;vilib&gt;/DAQmx/configure/task.llb/DAQmx Clear Task.vi"/>
				<Item Name="DAQmx Create Channel (AI-Voltage-Basic).vi" Type="VI" URL="/&lt;vilib&gt;/DAQmx/create/channels.llb/DAQmx Create Channel (AI-Voltage-Basic).vi"/>
				<Item Name="DAQmx Create Virtual Channel.vi" Type="VI" URL="/&lt;vilib&gt;/DAQmx/create/channels.llb/DAQmx Create Virtual Channel.vi"/>
				<Item Name="DAQmx Fill In Error Info.vi" Type="VI" URL="/&lt;vilib&gt;/DAQmx/miscellaneous.llb/DAQmx Fill In Error Info.vi"/>
				<Item Name="DAQmx Read (Analog Wfm 1Chan NSamp).vi" Type="VI" URL="/&lt;vilib&gt;/DAQmx/read.llb/DAQmx Read (Analog Wfm 1Chan NSamp).vi"/>
				<Item Name="DAQmx Read.vi" Type="VI" URL="/&lt;vilib&gt;/DAQmx/read.llb/DAQmx Read.vi"/>
				<Item Name="DAQmx Start Task.vi" Type="VI" URL="/&lt;vilib&gt;/DAQmx/configure/task.llb/DAQmx Start Task.vi"/>
				<Item Name="DAQmx Timing (Sample Clock).vi" Type="VI" URL="/&lt;vilib&gt;/DAQmx/configure/timing.llb/DAQmx Timing (Sample Clock).vi"/>
				<Item Name="DAQmx Timing.vi" Type="VI" URL="/&lt;vilib&gt;/DAQmx/configure/timing.llb/DAQmx Timing.vi"/>
				<Item Name="Details Display Dialog.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Details Display Dialog.vi"/>
				<Item Name="DialogType.ctl" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/DialogType.ctl"/>
				<Item Name="DialogTypeEnum.ctl" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/DialogTypeEnum.ctl"/>
				<Item Name="Error Cluster From Error Code.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Error Cluster From Error Code.vi"/>
				<Item Name="Error Code Database.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Error Code Database.vi"/>
				<Item Name="ErrWarn.ctl" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/ErrWarn.ctl"/>
				<Item Name="eventvkey.ctl" Type="VI" URL="/&lt;vilib&gt;/event_ctls.llb/eventvkey.ctl"/>
				<Item Name="Find First Error.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Find First Error.vi"/>
				<Item Name="Find Reference.flx" Type="VI" URL="/&lt;vilib&gt;/Motion/FlexMotion/FunctionsVIs/FindReference.llb/Find Reference.flx"/>
				<Item Name="Find Tag.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Find Tag.vi"/>
				<Item Name="Format Message String.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Format Message String.vi"/>
				<Item Name="General Error Handler Core CORE.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/General Error Handler Core CORE.vi"/>
				<Item Name="General Error Handler.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/General Error Handler.vi"/>
				<Item Name="Get String Text Bounds.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Get String Text Bounds.vi"/>
				<Item Name="Get Text Rect.vi" Type="VI" URL="/&lt;vilib&gt;/picture/picture.llb/Get Text Rect.vi"/>
				<Item Name="GetHelpDir.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/GetHelpDir.vi"/>
				<Item Name="GetRTHostConnectedProp.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/GetRTHostConnectedProp.vi"/>
				<Item Name="Longest Line Length in Pixels.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Longest Line Length in Pixels.vi"/>
				<Item Name="LVBoundsTypeDef.ctl" Type="VI" URL="/&lt;vilib&gt;/Utility/miscctls.llb/LVBoundsTypeDef.ctl"/>
				<Item Name="LVRectTypeDef.ctl" Type="VI" URL="/&lt;vilib&gt;/Utility/miscctls.llb/LVRectTypeDef.ctl"/>
				<Item Name="NI_AAL_Angle.lvlib" Type="Library" URL="/&lt;vilib&gt;/Analysis/NI_AAL_Angle.lvlib"/>
				<Item Name="NI_AALBase.lvlib" Type="Library" URL="/&lt;vilib&gt;/Analysis/NI_AALBase.lvlib"/>
				<Item Name="NI_AALPro.lvlib" Type="Library" URL="/&lt;vilib&gt;/Analysis/NI_AALPro.lvlib"/>
				<Item Name="NI_Gmath.lvlib" Type="Library" URL="/&lt;vilib&gt;/gmath/NI_Gmath.lvlib"/>
				<Item Name="NI_Matrix.lvlib" Type="Library" URL="/&lt;vilib&gt;/Analysis/Matrix/NI_Matrix.lvlib"/>
				<Item Name="Not Found Dialog.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Not Found Dialog.vi"/>
				<Item Name="Read Position.flx" Type="VI" URL="/&lt;vilib&gt;/Motion/FlexMotion/FunctionsVIs/Trajectory.llb/Read Position.flx"/>
				<Item Name="Search and Replace Pattern.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Search and Replace Pattern.vi"/>
				<Item Name="Set Bold Text.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Set Bold Text.vi"/>
				<Item Name="Set String Value.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Set String Value.vi"/>
				<Item Name="Simple Error Handler.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Simple Error Handler.vi"/>
				<Item Name="subTimeDelay.vi" Type="VI" URL="/&lt;vilib&gt;/express/express execution control/TimeDelayBlock.llb/subTimeDelay.vi"/>
				<Item Name="TagReturnType.ctl" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/TagReturnType.ctl"/>
				<Item Name="Three Button Dialog CORE.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Three Button Dialog CORE.vi"/>
				<Item Name="Three Button Dialog.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Three Button Dialog.vi"/>
				<Item Name="Trim Whitespace One-Sided.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Trim Whitespace One-Sided.vi"/>
				<Item Name="Trim Whitespace.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Trim Whitespace.vi"/>
				<Item Name="VISA Configure Serial Port" Type="VI" URL="/&lt;vilib&gt;/Instr/_visa.llb/VISA Configure Serial Port"/>
				<Item Name="VISA Configure Serial Port (Instr).vi" Type="VI" URL="/&lt;vilib&gt;/Instr/_visa.llb/VISA Configure Serial Port (Instr).vi"/>
				<Item Name="VISA Configure Serial Port (Serial Instr).vi" Type="VI" URL="/&lt;vilib&gt;/Instr/_visa.llb/VISA Configure Serial Port (Serial Instr).vi"/>
				<Item Name="Wait Reference.flx" Type="VI" URL="/&lt;vilib&gt;/Motion/FlexMotion/FunctionsVIs/FindReference.llb/Wait Reference.flx"/>
				<Item Name="whitespace.ctl" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/whitespace.ctl"/>
			</Item>
			<Item Name="constrain_axes.vi" Type="VI" URL="../server/constrain_axes.vi"/>
			<Item Name="do_move.vi" Type="VI" URL="../server/do_move.vi"/>
			<Item Name="euler_to_rotation.vi" Type="VI" URL="../../utilities/euler_to_rotation.vi"/>
			<Item Name="inverse_kin_objective_fn.vi" Type="VI" URL="../server/inverse_kin_objective_fn.vi"/>
			<Item Name="log_smoothing.vi" Type="VI" URL="../../micron/labview/testing/log_smoothing.vi"/>
			<Item Name="lvanlys.dll" Type="Document" URL="/&lt;resource&gt;/lvanlys.dll"/>
			<Item Name="make_trans_mat.vi" Type="VI" URL="../../utilities/make_trans_mat.vi"/>
			<Item Name="Motion command.vi" Type="VI" URL="../client/Motion command.vi"/>
			<Item Name="motion_variables.ctl" Type="VI" URL="../client/motion_variables.ctl"/>
			<Item Name="motion_variables.vi" Type="VI" URL="../client/motion_variables.vi"/>
			<Item Name="move_backlash.vi" Type="VI" URL="../server/move_backlash.vi"/>
			<Item Name="move_backlash_loop.vi" Type="VI" URL="../server/move_backlash_loop.vi"/>
			<Item Name="newmark_move.vi" Type="VI" URL="../server/newmark_move.vi"/>
			<Item Name="newmark_open.vi" Type="VI" URL="../server/newmark_open.vi"/>
			<Item Name="newmark_set_position.vi" Type="VI" URL="../server/newmark_set_position.vi"/>
			<Item Name="newmark_stop.vi" Type="VI" URL="../server/newmark_stop.vi"/>
			<Item Name="nilvaiu.dll" Type="Document" URL="nilvaiu.dll">
				<Property Name="NI.PreserveRelativePath" Type="Bool">true</Property>
			</Item>
			<Item Name="pose_to_vector.vi" Type="VI" URL="../../utilities/pose_to_vector.vi"/>
			<Item Name="rotation_to_euler.vi" Type="VI" URL="../../utilities/rotation_to_euler.vi"/>
			<Item Name="spectral_measurement.vi" Type="VI" URL="../../micron/labview/testing/spectral_measurement.vi"/>
			<Item Name="transform_axis_positions.vi" Type="VI" URL="../server/transform_axis_positions.vi"/>
			<Item Name="transform_inverse.vi" Type="VI" URL="../../utilities/transform_inverse.vi"/>
			<Item Name="trio_move.vi" Type="VI" URL="../server/trio_move.vi"/>
			<Item Name="trio_open.vi" Type="VI" URL="../server/trio_open.vi"/>
			<Item Name="vector_to_pose.vi" Type="VI" URL="../../utilities/vector_to_pose.vi"/>
		</Item>
		<Item Name="Build Specifications" Type="Build"/>
	</Item>
</Project>
