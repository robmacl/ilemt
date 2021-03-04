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
			<Item Name="ilemt_globals.vi" Type="VI" URL="../ilemt_globals.vi"/>
			<Item Name="kf_demodulator.vi" Type="VI" URL="../kf_demodulator.vi"/>
			<Item Name="demod_limiter.vi" Type="VI" URL="../demod_limiter.vi"/>
			<Item Name="kf_demod_update.vi" Type="VI" URL="../kf_demod_update.vi"/>
			<Item Name="ASIO_Input_Output.vi" Type="VI" URL="../waveio/ASIO_Input_Output.vi"/>
		</Item>
		<Item Name="ilemt_ui.vi" Type="VI" URL="../ilemt_ui.vi"/>
		<Item Name="stage_calibration.vi" Type="VI" URL="../../motion/client/stage_calibration.vi"/>
		<Item Name="averaged_ilemt_data.vi" Type="VI" URL="../averaged_ilemt_data.vi"/>
		<Item Name="ilemt_vars.lvlib" Type="Library" URL="../ilemt_vars.lvlib"/>
		<Item Name="sub_distance_processing.vi" Type="VI" URL="../sub_distance_processing.vi"/>
		<Item Name="sub_distance_processing1.vi" Type="VI" URL="../sub_distance_processing1.vi"/>
		<Item Name="ilemt_status.ctl" Type="VI" URL="../ilemt_status.ctl"/>
		<Item Name="dac_test_pattern.vi" Type="VI" URL="../dac_test_pattern.vi"/>
		<Item Name="ac_dc.ctl" Type="VI" URL="../ac_dc.ctl"/>
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
				<Item Name="System Exec.vi" Type="VI" URL="/&lt;vilib&gt;/Platform/system.llb/System Exec.vi"/>
				<Item Name="Registry Simplify Data Type.vi" Type="VI" URL="/&lt;vilib&gt;/registry/registry.llb/Registry Simplify Data Type.vi"/>
				<Item Name="Registry WinErr-LVErr.vi" Type="VI" URL="/&lt;vilib&gt;/registry/registry.llb/Registry WinErr-LVErr.vi"/>
				<Item Name="Registry refnum.ctl" Type="VI" URL="/&lt;vilib&gt;/registry/registry.llb/Registry refnum.ctl"/>
				<Item Name="Registry Handle Master.vi" Type="VI" URL="/&lt;vilib&gt;/registry/registry.llb/Registry Handle Master.vi"/>
				<Item Name="Read Registry Value STR.vi" Type="VI" URL="/&lt;vilib&gt;/registry/registry.llb/Read Registry Value STR.vi"/>
				<Item Name="Read Registry Value DWORD.vi" Type="VI" URL="/&lt;vilib&gt;/registry/registry.llb/Read Registry Value DWORD.vi"/>
				<Item Name="Read Registry Value.vi" Type="VI" URL="/&lt;vilib&gt;/registry/registry.llb/Read Registry Value.vi"/>
				<Item Name="Read Registry Value Simple STR.vi" Type="VI" URL="/&lt;vilib&gt;/registry/registry.llb/Read Registry Value Simple STR.vi"/>
				<Item Name="Read Registry Value Simple U32.vi" Type="VI" URL="/&lt;vilib&gt;/registry/registry.llb/Read Registry Value Simple U32.vi"/>
				<Item Name="Read Registry Value Simple.vi" Type="VI" URL="/&lt;vilib&gt;/registry/registry.llb/Read Registry Value Simple.vi"/>
				<Item Name="Registry SAM.ctl" Type="VI" URL="/&lt;vilib&gt;/registry/registry.llb/Registry SAM.ctl"/>
				<Item Name="Registry RtKey.ctl" Type="VI" URL="/&lt;vilib&gt;/registry/registry.llb/Registry RtKey.ctl"/>
				<Item Name="STR_ASCII-Unicode.vi" Type="VI" URL="/&lt;vilib&gt;/registry/registry.llb/STR_ASCII-Unicode.vi"/>
				<Item Name="Registry View.ctl" Type="VI" URL="/&lt;vilib&gt;/registry/registry.llb/Registry View.ctl"/>
				<Item Name="Open Registry Key.vi" Type="VI" URL="/&lt;vilib&gt;/registry/registry.llb/Open Registry Key.vi"/>
				<Item Name="TCP Listen List Operations.ctl" Type="VI" URL="/&lt;vilib&gt;/Utility/tcp.llb/TCP Listen List Operations.ctl"/>
				<Item Name="TCP Listen Internal List.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/tcp.llb/TCP Listen Internal List.vi"/>
				<Item Name="Internecine Avoider.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/tcp.llb/Internecine Avoider.vi"/>
				<Item Name="TCP Listen.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/tcp.llb/TCP Listen.vi"/>
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
			<Item Name="apply_cal.vi" Type="VI" URL="../apply_cal.vi"/>
			<Item Name="cal_error.vi" Type="VI" URL="../cal_error.vi"/>
			<Item Name="cal_objective_fun.vi" Type="VI" URL="../cal_objective_fun.vi"/>
			<Item Name="calibrate_ref.vi" Type="VI" URL="../calibrate_ref.vi"/>
			<Item Name="calibration.ctl" Type="VI" URL="../calibration.ctl"/>
			<Item Name="calibration_to_vector.vi" Type="VI" URL="../calibration_to_vector.vi"/>
			<Item Name="carrier_waveforms.vi" Type="VI" URL="../carrier_waveforms.vi"/>
			<Item Name="demod_low.vi" Type="VI" URL="../demod_low.vi"/>
			<Item Name="display_source.ctl" Type="VI" URL="../display_source.ctl"/>
			<Item Name="extract_carriers.vi" Type="VI" URL="../extract_carriers.vi"/>
			<Item Name="filter_params.ctl" Type="VI" URL="../filter_params.ctl"/>
			<Item Name="find_calibration.vi" Type="VI" URL="../find_calibration.vi"/>
			<Item Name="get_averaging_params.vi" Type="VI" URL="../get_averaging_params.vi"/>
			<Item Name="get_modulation_info.vi" Type="VI" URL="../get_modulation_info.vi"/>
			<Item Name="distance_processing.vi" Type="VI" URL="../distance_processing.vi"/>
			<Item Name="ilemt_config.ctl" Type="VI" URL="../ilemt_config.ctl"/>
			<Item Name="io_config.ctl" Type="VI" URL="../io_config.ctl"/>
			<Item Name="kalman_filter.ctl" Type="VI" URL="../../utilities/kalman_filter.ctl"/>
			<Item Name="kf_init.vi" Type="VI" URL="../../utilities/kf_init.vi"/>
			<Item Name="kf_set_params.vi" Type="VI" URL="../../utilities/kf_set_params.vi"/>
			<Item Name="kf_update.vi" Type="VI" URL="../../utilities/kf_update.vi"/>
			<Item Name="lvanlys.dll" Type="Document" URL="/&lt;resource&gt;/lvanlys.dll"/>
			<Item Name="mag_globals.vi" Type="VI" URL="../mag_globals.vi"/>
			<Item Name="measurements.ctl" Type="VI" URL="../measurements.ctl"/>
			<Item Name="modulation_info.ctl" Type="VI" URL="../modulation_info.ctl"/>
			<Item Name="my_spectrogram_display.vi" Type="VI" URL="../my_spectrogram_display.vi"/>
			<Item Name="my_stft.vi" Type="VI" URL="../my_stft.vi"/>
			<Item Name="noise_floor.vi" Type="VI" URL="../noise_floor.vi"/>
			<Item Name="notch_and_cut.vi" Type="VI" URL="../notch_and_cut.vi"/>
			<Item Name="predict_carriers.vi" Type="VI" URL="../predict_carriers.vi"/>
			<Item Name="state_to_complex.vi" Type="VI" URL="../state_to_complex.vi"/>
			<Item Name="stft_demodulate.vi" Type="VI" URL="../stft_demodulate.vi"/>
			<Item Name="stft_demodulate_low.vi" Type="VI" URL="../stft_demodulate_low.vi"/>
			<Item Name="stft_params.ctl" Type="VI" URL="../stft_params.ctl"/>
			<Item Name="trace_display.vi" Type="VI" URL="../trace_display.vi"/>
			<Item Name="vector_to_calibration.vi" Type="VI" URL="../vector_to_calibration.vi"/>
			<Item Name="trace_stats.ctl" Type="VI" URL="../trace_stats.ctl"/>
			<Item Name="averaging_filter_params.ctl" Type="VI" URL="../averaging_filter_params.ctl"/>
			<Item Name="offline_options.ctl" Type="VI" URL="../offline_options.ctl"/>
			<Item Name="Tc filter.vi" Type="VI" URL="../Tc filter.vi"/>
			<Item Name="WaveIO_Play.vi" Type="VI" URL="../waveio/WaveIO.llb/WaveIO_Play.vi"/>
			<Item Name="WaveIO_Open.vi" Type="VI" URL="../waveio/WaveIO.llb/WaveIO_Open.vi"/>
			<Item Name="WaveIO_Start.vi" Type="VI" URL="../waveio/WaveIO.llb/WaveIO_Start.vi"/>
			<Item Name="WaveIO_Stop.vi" Type="VI" URL="../waveio/WaveIO.llb/WaveIO_Stop.vi"/>
			<Item Name="WaveIO_Close.vi" Type="VI" URL="../waveio/WaveIO.llb/WaveIO_Close.vi"/>
			<Item Name="ASIO_Informations.ctl" Type="VI" URL="../waveio/WaveIO.llb/ASIO_Informations.ctl"/>
			<Item Name="WaveIO_GetErrText.vi" Type="VI" URL="../waveio/WaveIO.llb/WaveIO_GetErrText.vi"/>
			<Item Name="WaveIO_GetInfo_ASIO.vi" Type="VI" URL="../waveio/WaveIO.llb/WaveIO_GetInfo_ASIO.vi"/>
			<Item Name="WaveIO_ASIO_ControlPanel.vi" Type="VI" URL="../waveio/WaveIO.llb/WaveIO_ASIO_ControlPanel.vi"/>
			<Item Name="WindowsVersion.vi" Type="VI" URL="../waveio/WaveIO.llb/WindowsVersion.vi"/>
			<Item Name="WaveIO_OpenControlPanel.vi" Type="VI" URL="../waveio/WaveIO.llb/WaveIO_OpenControlPanel.vi"/>
			<Item Name="SoundHandle.ctl" Type="VI" URL="../waveio/WaveIO.llb/SoundHandle.ctl"/>
			<Item Name="WaveIO_Record.vi" Type="VI" URL="../waveio/WaveIO.llb/WaveIO_Record.vi"/>
			<Item Name="WaveIO_About.vi" Type="VI" URL="../waveio/WaveIO.llb/WaveIO_About.vi"/>
			<Item Name="WaveIO.dll" Type="Document" URL="../waveio/WaveIO.dll"/>
			<Item Name="Advapi32.dll" Type="Document" URL="Advapi32.dll">
				<Property Name="NI.PreserveRelativePath" Type="Bool">true</Property>
			</Item>
			<Item Name="kernel32.dll" Type="Document" URL="kernel32.dll">
				<Property Name="NI.PreserveRelativePath" Type="Bool">true</Property>
			</Item>
			<Item Name="IIR Cascade Filter PtbyPt Vec.vi" Type="VI" URL="../../utilities/IIR Cascade Filter PtbyPt Vec.vi"/>
			<Item Name="trace_channel.ctl" Type="VI" URL="../trace_channel.ctl"/>
			<Item Name="levels_selector.ctl" Type="VI" URL="../levels_selector.ctl"/>
			<Item Name="Level selector 1.ctl" Type="VI" URL="../Level selector 1.ctl"/>
			<Item Name="Level selector 2.ctl" Type="VI" URL="../Level selector 2.ctl"/>
			<Item Name="Level selector 3.ctl" Type="VI" URL="../Level selector 3.ctl"/>
			<Item Name="Level selector 4.ctl" Type="VI" URL="../Level selector 4.ctl"/>
			<Item Name="demodulate_all.vi" Type="VI" URL="../demodulate_all.vi"/>
			<Item Name="frequency_display_tabs.ctl" Type="VI" URL="../frequency_display_tabs.ctl"/>
			<Item Name="axis_name.ctl" Type="VI" URL="../axis_name.ctl"/>
			<Item Name="split_averaging_filter_nu.vi" Type="VI" URL="../split_averaging_filter_nu.vi"/>
			<Item Name="my_fold_windowed_signal.vi" Type="VI" URL="../my_fold_windowed_signal.vi"/>
			<Item Name="log_data.vi" Type="VI" URL="../log_data.vi"/>
			<Item Name="get_input.vi" Type="VI" URL="../get_input.vi"/>
			<Item Name="coupling_to_string.vi" Type="VI" URL="../coupling_to_string.vi"/>
			<Item Name="complex_to_string.vi" Type="VI" URL="../complex_to_string.vi"/>
			<Item Name="log_mode.ctl" Type="VI" URL="../log_mode.ctl"/>
			<Item Name="phase_correct_coupling.vi" Type="VI" URL="../phase_correct_coupling.vi"/>
			<Item Name="trace_info.ctl" Type="VI" URL="../trace_info.ctl"/>
			<Item Name="extract_noise.vi" Type="VI" URL="../extract_noise.vi"/>
			<Item Name="listen_tcp_data_conn.vi" Type="VI" URL="../listen_tcp_data_conn.vi"/>
			<Item Name="read_input_data.vi" Type="VI" URL="../read_input_data.vi"/>
			<Item Name="logger_queue.vi" Type="VI" URL="../logger_queue.vi"/>
			<Item Name="spectrum_display.vi" Type="VI" URL="../spectrum_display.vi"/>
			<Item Name="spectrum_parameters.ctl" Type="VI" URL="../spectrum_parameters.ctl"/>
			<Item Name="coupling_selector.ctl" Type="VI" URL="../coupling_selector.ctl"/>
			<Item Name="output_options.ctl" Type="VI" URL="../output_options.ctl"/>
			<Item Name="selector_weights.vi" Type="VI" URL="../selector_weights.vi"/>
			<Item Name="tcp_write_carriers.vi" Type="VI" URL="../tcp_write_carriers.vi"/>
			<Item Name="fft_demodulator.vi" Type="VI" URL="../fft_demodulator.vi"/>
			<Item Name="fft_demod_update.vi" Type="VI" URL="../fft_demod_update.vi"/>
			<Item Name="get_averaging_params_fd.vi" Type="VI" URL="../get_averaging_params_fd.vi"/>
			<Item Name="split_averaging_filter_cdb.vi" Type="VI" URL="../split_averaging_filter_cdb.vi"/>
			<Item Name="split_averaging_filter_3cdb.vi" Type="VI" URL="../split_averaging_filter_3cdb.vi"/>
			<Item Name="fft_kf_update.vi" Type="VI" URL="../fft_kf_update.vi"/>
			<Item Name="detrend.vi" Type="VI" URL="../detrend.vi"/>
			<Item Name="saf_cdb_update.vi" Type="VI" URL="../saf_cdb_update.vi"/>
			<Item Name="detrend_mode.ctl" Type="VI" URL="../detrend_mode.ctl"/>
			<Item Name="detrend_and_limit_cdb.vi" Type="VI" URL="../detrend_and_limit_cdb.vi"/>
			<Item Name="kf_update_p_k.vi" Type="VI" URL="../../utilities/kf_update_p_k.vi"/>
			<Item Name="move_to.vi" Type="VI" URL="../../motion/client/move_to.vi"/>
			<Item Name="motion_command.ctl" Type="VI" URL="../../motion/server/motion_command.ctl"/>
			<Item Name="Motion status.vi" Type="VI" URL="../../motion/client/Motion status.vi"/>
			<Item Name="motion_status.ctl" Type="VI" URL="../../motion/motion_status.ctl"/>
			<Item Name="motion_variables.vi" Type="VI" URL="../../motion/client/motion_variables.vi"/>
			<Item Name="motion_variables.ctl" Type="VI" URL="../../motion/client/motion_variables.ctl"/>
			<Item Name="Motion command.vi" Type="VI" URL="../../motion/client/Motion command.vi"/>
			<Item Name="averaged_asap_signals.vi" Type="VI" URL="../../micron/labview/calibration/averaged_asap_signals.vi"/>
			<Item Name="STFT Spectrogram Display.vi" Type="VI" URL="../STFT Spectrogram Display.vi"/>
		</Item>
		<Item Name="Build Specifications" Type="Build"/>
	</Item>
</Project>
