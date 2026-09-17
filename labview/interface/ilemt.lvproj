<?xml version='1.0' encoding='UTF-8'?>
<Project Type="Project" LVVersion="24008000">
	<Property Name="NI.LV.All.SaveVersion" Type="Str">24.0</Property>
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
			<Item Name="averaged_ilemt_data.vi" Type="VI" URL="../calibration/averaged_ilemt_data.vi"/>
			<Item Name="carrier_waveforms.vi" Type="VI" URL="../processing/carrier_waveforms.vi"/>
			<Item Name="dac_test_pattern.vi" Type="VI" URL="../testing/dac_test_pattern.vi"/>
			<Item Name="extract_carriers.vi" Type="VI" URL="../gui/extract_carriers.vi"/>
			<Item Name="fft_demodulator.vi" Type="VI" URL="../processing/fft_demodulator.vi"/>
			<Item Name="ilemt_globals.vi" Type="VI" URL="../main/ilemt_globals.vi"/>
			<Item Name="tcp_io.vi" Type="VI" URL="../system/tcp_io.vi"/>
		</Item>
		<Item Name="ilemt_ui.vi" Type="VI" URL="../ilemt_ui.vi"/>
		<Item Name="stage_calibration_todo demo.vi" Type="VI" URL="../../motion/client/stage_calibration_todo demo.vi"/>
		<Item Name="ilemt_vars.lvlib" Type="Library" URL="../main/ilemt_vars.lvlib"/>
		<Item Name="read_n_raw_records.vi" Type="VI" URL="../system/read_n_raw_records.vi"/>
		<Item Name="read_raw_file.vi" Type="VI" URL="../system/read_raw_file.vi"/>
		<Item Name="relative_and_absolute_ts.ctl" Type="VI" URL="../system/relative_and_absolute_ts.ctl"/>
		<Item Name="levels_to_coupling.vi" Type="VI" URL="../processing/levels_to_coupling.vi"/>
		<Item Name="Dependencies" Type="Dependencies"/>
		<Item Name="Build Specifications" Type="Build"/>
	</Item>
</Project>
