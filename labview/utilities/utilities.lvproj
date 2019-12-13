<?xml version='1.0' encoding='UTF-8'?>
<Project Type="Project" LVVersion="12008004">
	<Property Name="NI.LV.All.SourceOnly" Type="Bool">true</Property>
	<Item Name="My Computer" Type="My Computer">
		<Property Name="server.app.propertiesEnabled" Type="Bool">true</Property>
		<Property Name="server.control.propertiesEnabled" Type="Bool">true</Property>
		<Property Name="server.tcp.enabled" Type="Bool">false</Property>
		<Property Name="server.tcp.port" Type="Int">0</Property>
		<Property Name="server.tcp.serviceName" Type="Str">My Computer/VI Server</Property>
		<Property Name="server.tcp.serviceName.default" Type="Str">My Computer/VI Server</Property>
		<Property Name="server.vi.callsEnabled" Type="Bool">true</Property>
		<Property Name="server.vi.propertiesEnabled" Type="Bool">true</Property>
		<Property Name="specify.custom.address" Type="Bool">false</Property>
		<Item Name="filtering" Type="Folder">
			<Item Name="tests" Type="Folder">
				<Item Name="delay_test.vi" Type="VI" URL="../delay_test.vi"/>
				<Item Name="filter_test_cascade_vec.vi" Type="VI" URL="../filter_test_cascade_vec.vi"/>
				<Item Name="filter_test_ni.vi" Type="VI" URL="../filter_test_ni.vi"/>
				<Item Name="filter_test_svf.vi" Type="VI" URL="../filter_test_svf.vi"/>
			</Item>
			<Item Name="alias_freq.vi" Type="VI" URL="../alias_freq.vi"/>
			<Item Name="Delay Vec.vi" Type="VI" URL="../Delay Vec.vi"/>
			<Item Name="extract_fft_components.vi" Type="VI" URL="../extract_fft_components.vi"/>
			<Item Name="filter_to_zero_pole_gain.vi" Type="VI" URL="../filter_to_zero_pole_gain.vi"/>
			<Item Name="filter_vec_bessel.vi" Type="VI" URL="../filter_vec_bessel.vi"/>
			<Item Name="IIR Cascade DC Gain.vi" Type="VI" URL="../IIR Cascade DC Gain.vi"/>
			<Item Name="IIR Cascade Filter PtbyPt Vec.vi" Type="VI" URL="../IIR Cascade Filter PtbyPt Vec.vi"/>
			<Item Name="Integral x(t) PtByPt Vector.vi" Type="VI" URL="../Integral x(t) PtByPt Vector.vi"/>
			<Item Name="median3.vi" Type="VI" URL="../median3.vi"/>
			<Item Name="read_filter_spec.vi" Type="VI" URL="../read_filter_spec.vi"/>
			<Item Name="State Variable FIlter.vi" Type="VI" URL="../State Variable FIlter.vi"/>
			<Item Name="write_filter_spec.vi" Type="VI" URL="../write_filter_spec.vi"/>
			<Item Name="zero_pole_gain.ctl" Type="VI" URL="../zero_pole_gain.ctl"/>
			<Item Name="zero_pole_gain_to_filter.vi" Type="VI" URL="../zero_pole_gain_to_filter.vi"/>
		</Item>
		<Item Name="geometry" Type="Folder">
			<Item Name="tests" Type="Folder">
				<Item Name="quaternion_test.vi" Type="VI" URL="../quaternion_test.vi"/>
				<Item Name="vector_pose_test.vi" Type="VI" URL="../vector_pose_test.vi"/>
			</Item>
			<Item Name="axis_angle_to_quaternion.vi" Type="VI" URL="../axis_angle_to_quaternion.vi"/>
			<Item Name="axis_angle_to_rotation.vi" Type="VI" URL="../axis_angle_to_rotation.vi"/>
			<Item Name="build_quaternion.vi" Type="VI" URL="../build_quaternion.vi"/>
			<Item Name="Centroid.vi" Type="VI" URL="../Centroid.vi"/>
			<Item Name="direction_to_quaternion.vi" Type="VI" URL="../direction_to_quaternion.vi"/>
			<Item Name="direction_to_rotation.vi" Type="VI" URL="../direction_to_rotation.vi"/>
			<Item Name="euler_to_rotation.vi" Type="VI" URL="../euler_to_rotation.vi"/>
			<Item Name="make_trans_mat.vi" Type="VI" URL="../make_trans_mat.vi"/>
			<Item Name="pose_to_vector.vi" Type="VI" URL="../pose_to_vector.vi"/>
			<Item Name="quaternion_conjugate.vi" Type="VI" URL="../quaternion_conjugate.vi"/>
			<Item Name="quaternion_multiply.vi" Type="VI" URL="../quaternion_multiply.vi"/>
			<Item Name="quaternion_normalize.vi" Type="VI" URL="../quaternion_normalize.vi"/>
			<Item Name="quaternion_rotate_vector.vi" Type="VI" URL="../quaternion_rotate_vector.vi"/>
			<Item Name="quaternion_to_axis_angle.vi" Type="VI" URL="../quaternion_to_axis_angle.vi"/>
			<Item Name="quaternion_to_transform.vi" Type="VI" URL="../quaternion_to_transform.vi"/>
			<Item Name="rotation_to_axis_perm.vi" Type="VI" URL="../rotation_to_axis_perm.vi"/>
			<Item Name="rotation_to_euler.vi" Type="VI" URL="../rotation_to_euler.vi"/>
			<Item Name="rotation_to_perm_string.vi" Type="VI" URL="../rotation_to_perm_string.vi"/>
			<Item Name="transform_inverse.vi" Type="VI" URL="../transform_inverse.vi"/>
			<Item Name="transform_points.vi" Type="VI" URL="../transform_points.vi"/>
			<Item Name="transform_rotation.vi" Type="VI" URL="../transform_rotation.vi"/>
			<Item Name="transform_translation.vi" Type="VI" URL="../transform_translation.vi"/>
			<Item Name="vector_to_pose.vi" Type="VI" URL="../vector_to_pose.vi"/>
			<Item Name="xy_theta_to_transform.vi" Type="VI" URL="../xy_theta_to_transform.vi"/>
		</Item>
		<Item Name="kalman" Type="Folder">
			<Item Name="kalman_filter.ctl" Type="VI" URL="../kalman_filter.ctl"/>
			<Item Name="kf_init.vi" Type="VI" URL="../kf_init.vi"/>
			<Item Name="kf_predict.vi" Type="VI" URL="../kf_predict.vi"/>
			<Item Name="kf_set_params.vi" Type="VI" URL="../kf_set_params.vi"/>
			<Item Name="kf_update.vi" Type="VI" URL="../kf_update.vi"/>
		</Item>
		<Item Name="labview" Type="Folder">
			<Item Name="gradient_descent.vi" Type="VI" URL="../gradient_descent.vi"/>
			<Item Name="one_of_n.vi" Type="VI" URL="../one_of_n.vi"/>
			<Item Name="utilities.aliases" Type="Document" URL="../utilities.aliases"/>
			<Item Name="utilities.lvlps" Type="Document" URL="../utilities.lvlps"/>
		</Item>
		<Item Name="matrix" Type="Folder">
			<Item Name="crossProduct.vi" Type="VI" URL="../crossProduct.vi"/>
			<Item Name="magnitude.vi" Type="VI" URL="../magnitude.vi"/>
			<Item Name="magnitude_dbl.vi" Type="VI" URL="../magnitude_dbl.vi"/>
			<Item Name="magnitude_mat.vi" Type="VI" URL="../magnitude_mat.vi"/>
			<Item Name="magnitude_single.vi" Type="VI" URL="../magnitude_single.vi"/>
			<Item Name="norm.vi" Type="VI" URL="../norm.vi"/>
			<Item Name="norm_mat.vi" Type="VI" URL="../norm_mat.vi"/>
			<Item Name="norm_vec.vi" Type="VI" URL="../norm_vec.vi"/>
			<Item Name="norm_vec_single.vi" Type="VI" URL="../norm_vec_single.vi"/>
			<Item Name="read_matrix.vi" Type="VI" URL="../read_matrix.vi"/>
			<Item Name="read_matrix_reshape.vi" Type="VI" URL="../read_matrix_reshape.vi"/>
			<Item Name="read_matrix_reshape_3D.vi" Type="VI" URL="../read_matrix_reshape_3D.vi"/>
			<Item Name="read_matrix_reshape_4D.vi" Type="VI" URL="../read_matrix_reshape_4D.vi"/>
			<Item Name="read_matrix_test.vi" Type="VI" URL="../read_matrix_test.vi"/>
			<Item Name="symmetric_from_upper_triangle.vi" Type="VI" URL="../symmetric_from_upper_triangle.vi"/>
		</Item>
		<Item Name="Dependencies" Type="Dependencies">
			<Item Name="vi.lib" Type="Folder">
				<Item Name="NI_AAL_Angle.lvlib" Type="Library" URL="/&lt;vilib&gt;/Analysis/NI_AAL_Angle.lvlib"/>
				<Item Name="NI_AALBase.lvlib" Type="Library" URL="/&lt;vilib&gt;/Analysis/NI_AALBase.lvlib"/>
				<Item Name="NI_AALPro.lvlib" Type="Library" URL="/&lt;vilib&gt;/Analysis/NI_AALPro.lvlib"/>
				<Item Name="NI_Gmath.lvlib" Type="Library" URL="/&lt;vilib&gt;/gmath/NI_Gmath.lvlib"/>
				<Item Name="NI_Matrix.lvlib" Type="Library" URL="/&lt;vilib&gt;/Analysis/Matrix/NI_Matrix.lvlib"/>
				<Item Name="NI_PtbyPt.lvlib" Type="Library" URL="/&lt;vilib&gt;/ptbypt/NI_PtbyPt.lvlib"/>
				<Item Name="Read From Spreadsheet File (DBL).vi" Type="VI" URL="/&lt;vilib&gt;/Utility/file.llb/Read From Spreadsheet File (DBL).vi"/>
				<Item Name="Read From Spreadsheet File (I64).vi" Type="VI" URL="/&lt;vilib&gt;/Utility/file.llb/Read From Spreadsheet File (I64).vi"/>
				<Item Name="Read From Spreadsheet File (string).vi" Type="VI" URL="/&lt;vilib&gt;/Utility/file.llb/Read From Spreadsheet File (string).vi"/>
				<Item Name="Read From Spreadsheet File.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/file.llb/Read From Spreadsheet File.vi"/>
				<Item Name="Simple Error Handler.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Simple Error Handler.vi"/>
				<Item Name="Space Constant.vi" Type="VI" URL="/&lt;vilib&gt;/dlg_ctls.llb/Space Constant.vi"/>
				<Item Name="Write To Spreadsheet File (DBL).vi" Type="VI" URL="/&lt;vilib&gt;/Utility/file.llb/Write To Spreadsheet File (DBL).vi"/>
				<Item Name="Write To Spreadsheet File (I64).vi" Type="VI" URL="/&lt;vilib&gt;/Utility/file.llb/Write To Spreadsheet File (I64).vi"/>
				<Item Name="Write To Spreadsheet File (string).vi" Type="VI" URL="/&lt;vilib&gt;/Utility/file.llb/Write To Spreadsheet File (string).vi"/>
				<Item Name="Write To Spreadsheet File.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/file.llb/Write To Spreadsheet File.vi"/>
			</Item>
			<Item Name="damping_freq.ctl" Type="VI" URL="../damping_freq.ctl"/>
			<Item Name="freq_damping_to_z.vi" Type="VI" URL="../freq_damping_to_z.vi"/>
			<Item Name="lvanlys.dll" Type="Document" URL="/&lt;resource&gt;/lvanlys.dll"/>
			<Item Name="z_to_freq_damping.vi" Type="VI" URL="../z_to_freq_damping.vi"/>
		</Item>
		<Item Name="Build Specifications" Type="Build">
			<Item Name="Utilities LLB" Type="Source Distribution">
				<Property Name="Bld_buildCacheID" Type="Str">{BB228DC7-D067-4586-B5F9-F12D00240725}</Property>
				<Property Name="Bld_buildSpecName" Type="Str">Utilities LLB</Property>
				<Property Name="Bld_excludedDirectory[0]" Type="Path">vi.lib</Property>
				<Property Name="Bld_excludedDirectory[0].pathType" Type="Str">relativeToAppDir</Property>
				<Property Name="Bld_excludedDirectory[1]" Type="Path">resource/objmgr</Property>
				<Property Name="Bld_excludedDirectory[1].pathType" Type="Str">relativeToAppDir</Property>
				<Property Name="Bld_excludedDirectory[2]" Type="Path">/C/ProgramData/National Instruments/InstCache/12.0</Property>
				<Property Name="Bld_excludedDirectory[3]" Type="Path">instr.lib</Property>
				<Property Name="Bld_excludedDirectory[3].pathType" Type="Str">relativeToAppDir</Property>
				<Property Name="Bld_excludedDirectory[4]" Type="Path">user.lib</Property>
				<Property Name="Bld_excludedDirectory[4].pathType" Type="Str">relativeToAppDir</Property>
				<Property Name="Bld_excludedDirectoryCount" Type="Int">5</Property>
				<Property Name="Bld_localDestDir" Type="Path">../builds/NI_AB_PROJECTNAME.llb</Property>
				<Property Name="Bld_localDestDirType" Type="Str">relativeToProject</Property>
				<Property Name="Bld_previewCacheID" Type="Str">{FE4695E6-699D-4CDA-B1D7-1924DBD62BD9}</Property>
				<Property Name="Destination[0].destName" Type="Str">Destination Directory</Property>
				<Property Name="Destination[0].path" Type="Path">../builds/NI_AB_PROJECTNAME.llb</Property>
				<Property Name="Destination[0].path.type" Type="Str">relativeToProject</Property>
				<Property Name="Destination[0].type" Type="Str">LLB</Property>
				<Property Name="Destination[1].destName" Type="Str">Support Directory</Property>
				<Property Name="Destination[1].path" Type="Path">../builds/NI_AB_PROJECTNAME/data</Property>
				<Property Name="DestinationCount" Type="Int">2</Property>
				<Property Name="Source[0].itemID" Type="Str">{3F24B591-1C7C-41CC-83BD-71DD54356EC9}</Property>
				<Property Name="Source[0].type" Type="Str">Container</Property>
				<Property Name="Source[1].Container.applyInclusion" Type="Bool">true</Property>
				<Property Name="Source[1].destinationIndex" Type="Int">0</Property>
				<Property Name="Source[1].itemID" Type="Ref">/My Computer/filtering</Property>
				<Property Name="Source[1].sourceInclusion" Type="Str">Include</Property>
				<Property Name="Source[1].type" Type="Str">Container</Property>
				<Property Name="Source[2].Container.applyInclusion" Type="Bool">true</Property>
				<Property Name="Source[2].destinationIndex" Type="Int">0</Property>
				<Property Name="Source[2].itemID" Type="Ref">/My Computer/geometry</Property>
				<Property Name="Source[2].sourceInclusion" Type="Str">Include</Property>
				<Property Name="Source[2].type" Type="Str">Container</Property>
				<Property Name="Source[3].Container.applyInclusion" Type="Bool">true</Property>
				<Property Name="Source[3].destinationIndex" Type="Int">0</Property>
				<Property Name="Source[3].itemID" Type="Ref">/My Computer/kalman</Property>
				<Property Name="Source[3].sourceInclusion" Type="Str">Include</Property>
				<Property Name="Source[3].type" Type="Str">Container</Property>
				<Property Name="Source[4].Container.applyInclusion" Type="Bool">true</Property>
				<Property Name="Source[4].destinationIndex" Type="Int">0</Property>
				<Property Name="Source[4].itemID" Type="Ref">/My Computer/labview</Property>
				<Property Name="Source[4].sourceInclusion" Type="Str">Include</Property>
				<Property Name="Source[4].type" Type="Str">Container</Property>
				<Property Name="Source[5].Container.applyInclusion" Type="Bool">true</Property>
				<Property Name="Source[5].destinationIndex" Type="Int">0</Property>
				<Property Name="Source[5].itemID" Type="Ref">/My Computer/matrix</Property>
				<Property Name="Source[5].sourceInclusion" Type="Str">Include</Property>
				<Property Name="Source[5].type" Type="Str">Container</Property>
				<Property Name="SourceCount" Type="Int">6</Property>
			</Item>
		</Item>
	</Item>
</Project>
