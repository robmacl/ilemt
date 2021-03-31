<?xml version='1.0' encoding='UTF-8'?>
<Project Type="Project" LVVersion="14008000">
	<Property Name="NI.LV.All.SourceOnly" Type="Bool">true</Property>
	<Property Name="varPersistentID:{705F2019-9CCA-48A5-8669-8F6E919898EE}" Type="Ref">/My Computer/ilemt_vars.lvlib/Stop</Property>
	<Item Name="My Computer" Type="My Computer">
		<Property Name="NI.SortType" Type="Int">3</Property>
		<Property Name="server.app.propertiesEnabled" Type="Bool">true</Property>
		<Property Name="server.control.propertiesEnabled" Type="Bool">true</Property>
		<Property Name="server.tcp.enabled" Type="Bool">false</Property>
		<Property Name="server.tcp.port" Type="Int">0</Property>
		<Property Name="server.tcp.serviceName" Type="Str">My Computer/VI Server</Property>
		<Property Name="server.tcp.serviceName.default" Type="Str">My Computer/VI Server</Property>
		<Property Name="server.vi.callsEnabled" Type="Bool">true</Property>
		<Property Name="server.vi.propertiesEnabled" Type="Bool">true</Property>
		<Property Name="specify.custom.address" Type="Bool">false</Property>
		<Item Name="Shortcuts" Type="Folder">
			<Property Name="NI.SortType" Type="Int">0</Property>
			<Item Name="carrier_waveforms.vi" Type="VI" URL="../processing/carrier_waveforms.vi"/>
			<Item Name="extract_carriers.vi" Type="VI" URL="../gui/extract_carriers.vi"/>
			<Item Name="fft_demodulator.vi" Type="VI" URL="../processing/fft_demodulator.vi"/>
			<Item Name="ilemt_globals.vi" Type="VI" URL="../main/ilemt_globals.vi"/>
			<Item Name="tcp_io.vi" Type="VI" URL="../system/tcp_io.vi"/>
		</Item>
		<Item Name="ilemt_ui.vi" Type="VI" URL="../ilemt_ui.vi"/>
		<Item Name="stage_calibration.vi" Type="VI" URL="../../motion/client/stage_calibration.vi"/>
		<Item Name="ilemt_vars.lvlib" Type="Library" URL="../main/ilemt_vars.lvlib"/>
		<Item Name="dac_test_pattern.vi" Type="VI" URL="../testing/dac_test_pattern.vi"/>
		<Item Name="tcp_server_connect.vi" Type="VI" URL="../system/tcp_server_connect.vi"/>
		<Item Name="input_fifos.vi" Type="VI" URL="../system/input_fifos.vi"/>
		<Item Name="Dependencies" Type="Dependencies">
			<Item Name="vi.lib" Type="Folder">
				<Item Name="BuildHelpPath.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/BuildHelpPath.vi"/>
				<Item Name="Check Special Tags.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Check Special Tags.vi"/>
				<Item Name="Clear Errors.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Clear Errors.vi"/>
				<Item Name="Convert property node font to graphics font.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Convert property node font to graphics font.vi"/>
				<Item Name="Details Display Dialog.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Details Display Dialog.vi"/>
				<Item Name="DialogType.ctl" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/DialogType.ctl"/>
				<Item Name="DialogTypeEnum.ctl" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/DialogTypeEnum.ctl"/>
				<Item Name="Error Cluster From Error Code.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Error Cluster From Error Code.vi"/>
				<Item Name="Error Code Database.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Error Code Database.vi"/>
				<Item Name="ErrWarn.ctl" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/ErrWarn.ctl"/>
				<Item Name="eventvkey.ctl" Type="VI" URL="/&lt;vilib&gt;/event_ctls.llb/eventvkey.ctl"/>
				<Item Name="Find First Error.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Find First Error.vi"/>
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
				<Item Name="NI_AALBase.lvlib" Type="Library" URL="/&lt;vilib&gt;/Analysis/NI_AALBase.lvlib"/>
				<Item Name="NI_AALPro.lvlib" Type="Library" URL="/&lt;vilib&gt;/Analysis/NI_AALPro.lvlib"/>
				<Item Name="NI_Gmath.lvlib" Type="Library" URL="/&lt;vilib&gt;/gmath/NI_Gmath.lvlib"/>
				<Item Name="NI_MABase.lvlib" Type="Library" URL="/&lt;vilib&gt;/measure/NI_MABase.lvlib"/>
				<Item Name="NI_Matrix.lvlib" Type="Library" URL="/&lt;vilib&gt;/Analysis/Matrix/NI_Matrix.lvlib"/>
				<Item Name="Not Found Dialog.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Not Found Dialog.vi"/>
				<Item Name="Search and Replace Pattern.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Search and Replace Pattern.vi"/>
				<Item Name="Set Bold Text.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Set Bold Text.vi"/>
				<Item Name="Set String Value.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Set String Value.vi"/>
				<Item Name="Simple Error Handler.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Simple Error Handler.vi"/>
				<Item Name="TagReturnType.ctl" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/TagReturnType.ctl"/>
				<Item Name="Three Button Dialog CORE.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Three Button Dialog CORE.vi"/>
				<Item Name="Three Button Dialog.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Three Button Dialog.vi"/>
				<Item Name="Trim Whitespace.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Trim Whitespace.vi"/>
				<Item Name="whitespace.ctl" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/whitespace.ctl"/>
				<Item Name="Check if File or Folder Exists.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/libraryn.llb/Check if File or Folder Exists.vi"/>
				<Item Name="NI_FileType.lvlib" Type="Library" URL="/&lt;vilib&gt;/Utility/lvfile.llb/NI_FileType.lvlib"/>
				<Item Name="NI_PackedLibraryUtility.lvlib" Type="Library" URL="/&lt;vilib&gt;/Utility/LVLibp/NI_PackedLibraryUtility.lvlib"/>
				<Item Name="Read From Spreadsheet File.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/file.llb/Read From Spreadsheet File.vi"/>
				<Item Name="Read From Spreadsheet File (DBL).vi" Type="VI" URL="/&lt;vilib&gt;/Utility/file.llb/Read From Spreadsheet File (DBL).vi"/>
				<Item Name="Read Lines From File.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/file.llb/Read Lines From File.vi"/>
				<Item Name="Open File+.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/file.llb/Open File+.vi"/>
				<Item Name="Read File+ (string).vi" Type="VI" URL="/&lt;vilib&gt;/Utility/file.llb/Read File+ (string).vi"/>
				<Item Name="compatReadText.vi" Type="VI" URL="/&lt;vilib&gt;/_oldvers/_oldvers.llb/compatReadText.vi"/>
				<Item Name="Close File+.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/file.llb/Close File+.vi"/>
				<Item Name="Read From Spreadsheet File (I64).vi" Type="VI" URL="/&lt;vilib&gt;/Utility/file.llb/Read From Spreadsheet File (I64).vi"/>
				<Item Name="Read From Spreadsheet File (string).vi" Type="VI" URL="/&lt;vilib&gt;/Utility/file.llb/Read From Spreadsheet File (string).vi"/>
				<Item Name="Space Constant.vi" Type="VI" URL="/&lt;vilib&gt;/dlg_ctls.llb/Space Constant.vi"/>
			</Item>
			<Item Name="apply_cal.vi" Type="VI" URL="../calibration/apply_cal.vi"/>
			<Item Name="cal_error.vi" Type="VI" URL="../calibration/cal_error.vi"/>
			<Item Name="cal_objective_fun.vi" Type="VI" URL="../calibration/cal_objective_fun.vi"/>
			<Item Name="test_input.vi" Type="VI" URL="../main/test_input.vi"/>
			<Item Name="calibration.ctl" Type="VI" URL="../calibration/calibration.ctl"/>
			<Item Name="calibration_to_vector.vi" Type="VI" URL="../calibration/calibration_to_vector.vi"/>
			<Item Name="demod_low.vi" Type="VI" URL="../processing/demod_low.vi"/>
			<Item Name="display_source.ctl" Type="VI" URL="../gui/display_source.ctl"/>
			<Item Name="filter_params.ctl" Type="VI" URL="../processing/filter_params.ctl"/>
			<Item Name="find_calibration.vi" Type="VI" URL="../calibration/find_calibration.vi"/>
			<Item Name="get_modulation_info.vi" Type="VI" URL="../processing/get_modulation_info.vi"/>
			<Item Name="ilemt_config.ctl" Type="VI" URL="../processing/ilemt_config.ctl"/>
			<Item Name="kalman_filter.ctl" Type="VI" URL="../../utilities/kalman_filter.ctl"/>
			<Item Name="kf_init.vi" Type="VI" URL="../../utilities/kf_init.vi"/>
			<Item Name="kf_set_params.vi" Type="VI" URL="../../utilities/kf_set_params.vi"/>
			<Item Name="kf_update.vi" Type="VI" URL="../../utilities/kf_update.vi"/>
			<Item Name="lvanlys.dll" Type="Document" URL="/&lt;resource&gt;/lvanlys.dll"/>
			<Item Name="mag_globals.vi" Type="VI" URL="../calibration/mag_globals.vi"/>
			<Item Name="measurements.ctl" Type="VI" URL="../gui/measurements.ctl"/>
			<Item Name="modulation_info.ctl" Type="VI" URL="../processing/modulation_info.ctl"/>
			<Item Name="my_spectrogram_display.vi" Type="VI" URL="../gui/my_spectrogram_display.vi"/>
			<Item Name="my_stft.vi" Type="VI" URL="../processing/my_stft.vi"/>
			<Item Name="noise_floor.vi" Type="VI" URL="../gui/noise_floor.vi"/>
			<Item Name="notch_and_cut.vi" Type="VI" URL="../processing/notch_and_cut.vi"/>
			<Item Name="predict_carriers.vi" Type="VI" URL="../processing/predict_carriers.vi"/>
			<Item Name="state_to_complex.vi" Type="VI" URL="../processing/state_to_complex.vi"/>
			<Item Name="stft_demodulate.vi" Type="VI" URL="../processing/stft_demodulate.vi"/>
			<Item Name="stft_demodulate_low.vi" Type="VI" URL="../processing/stft_demodulate_low.vi"/>
			<Item Name="stft_params.ctl" Type="VI" URL="../processing/stft_params.ctl"/>
			<Item Name="vector_to_calibration.vi" Type="VI" URL="../calibration/vector_to_calibration.vi"/>
			<Item Name="trace_stats.ctl" Type="VI" URL="../gui/trace_stats.ctl"/>
			<Item Name="averaging_filter_params.ctl" Type="VI" URL="../processing/averaging_filter_params.ctl"/>
			<Item Name="offline_options.ctl" Type="VI" URL="../gui/offline_options.ctl"/>
			<Item Name="trace_channel.ctl" Type="VI" URL="../gui/trace_channel.ctl"/>
			<Item Name="levels_selector.ctl" Type="VI" URL="../gui/levels_selector.ctl"/>
			<Item Name="Level selector 1.ctl" Type="VI" URL="../gui/Level selector 1.ctl"/>
			<Item Name="Level selector 2.ctl" Type="VI" URL="../gui/Level selector 2.ctl"/>
			<Item Name="Level selector 3.ctl" Type="VI" URL="../gui/Level selector 3.ctl"/>
			<Item Name="Level selector 4.ctl" Type="VI" URL="../gui/Level selector 4.ctl"/>
			<Item Name="demodulate_all.vi" Type="VI" URL="../processing/demodulate_all.vi"/>
			<Item Name="frequency_display_tabs.ctl" Type="VI" URL="../gui/frequency_display_tabs.ctl"/>
			<Item Name="axis_name.ctl" Type="VI" URL="../gui/axis_name.ctl"/>
			<Item Name="my_fold_windowed_signal.vi" Type="VI" URL="../processing/my_fold_windowed_signal.vi"/>
			<Item Name="log_data.vi" Type="VI" URL="../calibration/log_data.vi"/>
			<Item Name="get_input.vi" Type="VI" URL="../system/get_input.vi"/>
			<Item Name="coupling_to_string.vi" Type="VI" URL="../calibration/coupling_to_string.vi"/>
			<Item Name="complex_to_string.vi" Type="VI" URL="../calibration/complex_to_string.vi"/>
			<Item Name="log_mode.ctl" Type="VI" URL="../calibration/log_mode.ctl"/>
			<Item Name="phase_correct_coupling.vi" Type="VI" URL="../processing/phase_correct_coupling.vi"/>
			<Item Name="trace_info.ctl" Type="VI" URL="../gui/trace_info.ctl"/>
			<Item Name="extract_noise.vi" Type="VI" URL="../gui/extract_noise.vi"/>
			<Item Name="read_input_data.vi" Type="VI" URL="../system/read_input_data.vi"/>
			<Item Name="logger_queue.vi" Type="VI" URL="../calibration/logger_queue.vi"/>
			<Item Name="spectrum_display.vi" Type="VI" URL="../gui/spectrum_display.vi"/>
			<Item Name="spectrum_parameters.ctl" Type="VI" URL="../gui/spectrum_parameters.ctl"/>
			<Item Name="coupling_selector.ctl" Type="VI" URL="../gui/coupling_selector.ctl"/>
			<Item Name="output_options.ctl" Type="VI" URL="../gui/output_options.ctl"/>
			<Item Name="tcp_write_carriers.vi" Type="VI" URL="../system/tcp_write_carriers.vi"/>
			<Item Name="fft_demod_update.vi" Type="VI" URL="../processing/fft_demod_update.vi"/>
			<Item Name="get_averaging_params_fd.vi" Type="VI" URL="../processing/get_averaging_params_fd.vi"/>
			<Item Name="split_averaging_filter_cdb.vi" Type="VI" URL="../processing/split_averaging_filter_cdb.vi"/>
			<Item Name="split_averaging_filter_3cdb.vi" Type="VI" URL="../processing/split_averaging_filter_3cdb.vi"/>
			<Item Name="fft_kf_update.vi" Type="VI" URL="../processing/fft_kf_update.vi"/>
			<Item Name="detrend.vi" Type="VI" URL="../processing/detrend.vi"/>
			<Item Name="saf_cdb_update.vi" Type="VI" URL="../processing/saf_cdb_update.vi"/>
			<Item Name="detrend_mode.ctl" Type="VI" URL="../processing/detrend_mode.ctl"/>
			<Item Name="detrend_and_limit_cdb.vi" Type="VI" URL="../processing/detrend_and_limit_cdb.vi"/>
			<Item Name="kf_update_p_k.vi" Type="VI" URL="../../utilities/kf_update_p_k.vi"/>
			<Item Name="move_to.vi" Type="VI" URL="../../motion/client/move_to.vi"/>
			<Item Name="motion_command.ctl" Type="VI" URL="../../motion/server/motion_command.ctl"/>
			<Item Name="Motion status.vi" Type="VI" URL="../../motion/client/Motion status.vi"/>
			<Item Name="motion_status.ctl" Type="VI" URL="../../motion/motion_status.ctl"/>
			<Item Name="motion_variables.vi" Type="VI" URL="../../motion/client/motion_variables.vi"/>
			<Item Name="motion_variables.ctl" Type="VI" URL="../../motion/client/motion_variables.ctl"/>
			<Item Name="Motion command.vi" Type="VI" URL="../../motion/client/Motion command.vi"/>
			<Item Name="averaged_asap_signals.vi" Type="VI" URL="../../micron/labview/calibration/averaged_asap_signals.vi"/>
			<Item Name="STFT Spectrogram Display.vi" Type="VI" URL="../gui/STFT Spectrogram Display.vi"/>
			<Item Name="high_carrier_amplitudes.ctl" Type="VI" URL="../processing/high_carrier_amplitudes.ctl"/>
			<Item Name="ilemt_status.ctl" Type="VI" URL="../main/ilemt_status.ctl"/>
			<Item Name="IO_params.ctl" Type="VI" URL="../system/IO_params.ctl"/>
			<Item Name="carrier_amplitudes.ctl" Type="VI" URL="../processing/carrier_amplitudes.ctl"/>
			<Item Name="time_shift.vi" Type="VI" URL="../processing/time_shift.vi"/>
			<Item Name="gen_carrier_channels.vi" Type="VI" URL="../processing/gen_carrier_channels.vi"/>
			<Item Name="demodulate_card.vi" Type="VI" URL="../processing/demodulate_card.vi"/>
			<Item Name="on_axis_coupling.vi" Type="VI" URL="../processing/on_axis_coupling.vi"/>
			<Item Name="display_options.ctl" Type="VI" URL="../gui/display_options.ctl"/>
			<Item Name="card_carrier_amplitudes.ctl" Type="VI" URL="../processing/card_carrier_amplitudes.ctl"/>
			<Item Name="averaged_ilemt_data.vi" Type="VI" URL="../calibration/averaged_ilemt_data.vi"/>
			<Item Name="coupling_matrix.ctl" Type="VI" URL="../processing/coupling_matrix.ctl"/>
			<Item Name="distance_processing.vi" Type="VI" URL="../calibration/distance_processing.vi"/>
			<Item Name="Tc filter.vi" Type="VI" URL="../processing/Tc filter.vi"/>
			<Item Name="selector_weights.vi" Type="VI" URL="../gui/selector_weights.vi"/>
			<Item Name="sub_distance_processing.vi" Type="VI" URL="../calibration/sub_distance_processing.vi"/>
			<Item Name="sub_distance_processing1.vi" Type="VI" URL="../calibration/sub_distance_processing1.vi"/>
			<Item Name="coupling_magnitude.vi" Type="VI" URL="../calibration/coupling_magnitude.vi"/>
			<Item Name="card_high_carrier_amplitudes.ctl" Type="VI" URL="../processing/card_high_carrier_amplitudes.ctl"/>
			<Item Name="get_display_data.vi" Type="VI" URL="../processing/get_display_data.vi"/>
			<Item Name="trace_display.vi" Type="VI" URL="../gui/trace_display.vi"/>
		</Item>
		<Item Name="Build Specifications" Type="Build"/>
	</Item>
</Project>
