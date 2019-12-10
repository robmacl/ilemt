<?xml version='1.0' encoding='UTF-8'?>
<Library LVVersion="14008000">
	<Property Name="NI.Lib.Icon" Type="Bin">&amp;!#!!!!!!!)!"1!&amp;!!!-!%!!!@````]!!!!"!!%!!!(]!!!*Q(C=\&gt;7R=2MR%!81N=?"5X&lt;A91P&lt;!FNA#^M#5Y6M96NA"R[WM#WQ"&lt;9A0ZYR'E?G!WPM1$AN&gt;@S(!ZZQG&amp;0%VLZ'@)H8:_X\&lt;^P(^7@8H\4Y;"`NX\;8JZPUX@@MJXC]C.3I6K5S(F/^DHTE)R`ZS%@?]J;XP/5N&lt;XH*3V\SEJ?]Z#F0?=J4HP+5&lt;Y=]Z#%0/&gt;+9@%QU"BU$D-YI-4[':XC':XB]D?%:HO%:HO(2*9:H?):H?)&lt;(&lt;4%]QT-]QT-]BNIEMRVSHO%R@$20]T20]T30+;.Z'K".VA:OAW"%O^B/GK&gt;ZGM&gt;J.%`T.%`T.)`,U4T.UTT.UTROW6;F.]XDE0-9*IKH?)KH?)L(U&amp;%]R6-]R6-]JIPC+:[#+"/7Q2'CX&amp;1[F#`&amp;5TR_2@%54`%54`'YN$WBWF&lt;GI8E==J\E3:\E3:\E-51E4`)E4`)EDW%D?:)H?:)H?5Q6S:-]S:-A;6,42RIMX:A[J3"Z`'S\*&lt;?HV*MENS.C&lt;&gt;Z9GT,7:IOVC7*NDFA00&gt;&lt;$D0719CV_L%7.N6CR&amp;C(7(R=,(1M4;Z*9.T][RNXH46X62:X632X61?X6\H(L8_ZYP^`D&gt;LP&amp;^8K.S_53Z`-Z4K&gt;4()`(/"Q/M&gt;`P9\@&lt;P&lt;U'PDH?8AA`XUMPTP_EXOF`[8`Q&lt;IT0]?OYVOA(5/(_Z!!!!!!</Property>
	<Property Name="NI.Lib.SourceVersion" Type="Int">335577088</Property>
	<Property Name="NI.Lib.Version" Type="Str">1.0.0.0</Property>
	<Property Name="NI.LV.All.SourceOnly" Type="Bool">true</Property>
	<Item Name="Axis Offsets" Type="Variable">
		<Property Name="Description:Description" Type="Str">An offset applied to the commanded position.  In Pose mode this is a pose, applied by matrix multiplication.  In "Absolute axis" mode, this is added to the commanded position.  In "Relative axis" mode this is ignored.</Property>
		<Property Name="featurePacks" Type="Str">Description,Network</Property>
		<Property Name="Network:SingleWriter" Type="Str">False</Property>
		<Property Name="Network:UseBinding" Type="Str">False</Property>
		<Property Name="Network:UseBuffering" Type="Str">False</Property>
		<Property Name="numTypedefs" Type="UInt">0</Property>
		<Property Name="type" Type="Str">Network</Property>
		<Property Name="typeDesc" Type="Bin">&amp;!#!!!!!!!)!"1!&amp;!!!-!%!!!@````]!!!!"!!%!!!""01!!!"1!A!!!!!!#!!V!#A!(4H6N:8*J9Q!=1%!!!@````]!!!^"=H*B?3"P:C"%&lt;X6C&lt;'5!!1!"!!!!!!!!!!!!!!!!</Property>
	</Item>
	<Item Name="Emergency stop" Type="Variable">
		<Property Name="Description:Description" Type="Str">Set to true to emergency stop the motion controller.</Property>
		<Property Name="featurePacks" Type="Str">Description,Network</Property>
		<Property Name="Network:SingleWriter" Type="Str">False</Property>
		<Property Name="Network:UseBinding" Type="Str">False</Property>
		<Property Name="Network:UseBuffering" Type="Str">False</Property>
		<Property Name="numTypedefs" Type="UInt">0</Property>
		<Property Name="type" Type="Str">Network</Property>
		<Property Name="typeDesc" Type="Bin">&amp;!#!!!!!!!)!"1!&amp;!!!-!%!!!@````]!!!!"!!%!!!!B(1!!!"1!A!!!!!!"!!R!)1&gt;#&lt;W^M:7&amp;O!!%!!!!!!!!!!!!!!!</Property>
	</Item>
	<Item Name="End transform" Type="Variable">
		<Property Name="Description:Description" Type="Str">In "Pose" mode, allows goal position to be expressed in transformed coordinates (change of basis) so that rotation can be around a point offset from the stage origin.  In the axis modes this is ignored.</Property>
		<Property Name="featurePacks" Type="Str">Description,Network</Property>
		<Property Name="Network:SingleWriter" Type="Str">False</Property>
		<Property Name="Network:UseBinding" Type="Str">False</Property>
		<Property Name="Network:UseBuffering" Type="Str">False</Property>
		<Property Name="numTypedefs" Type="UInt">0</Property>
		<Property Name="type" Type="Str">Network</Property>
		<Property Name="typeDesc" Type="Bin">&amp;!#!!!!!!!)!"1!&amp;!!!-!%!!!@````]!!!!"!!%!!!""01!!!"1!A!!!!!!#!!V!#A!(4H6N:8*J9Q!=1%!!!@````]!!!^"=H*B?3"P:C"%&lt;X6C&lt;'5!!1!"!!!!!!!!!!!!!!!!</Property>
	</Item>
	<Item Name="Home Position" Type="Variable">
		<Property Name="Description:Description" Type="Str">An offset applied to the commanded position.  In Pose mode this is a pose, applied by matrix multiplication.  In "Absolute axis" mode, this is added to the commanded position.  In "Relative axis" mode this is ignored.</Property>
		<Property Name="featurePacks" Type="Str">Description,Network</Property>
		<Property Name="Network:SingleWriter" Type="Str">False</Property>
		<Property Name="Network:UseBinding" Type="Str">False</Property>
		<Property Name="Network:UseBuffering" Type="Str">False</Property>
		<Property Name="numTypedefs" Type="UInt">0</Property>
		<Property Name="type" Type="Str">Network</Property>
		<Property Name="typeDesc" Type="Bin">&amp;!#!!!!!!!)!"1!&amp;!!!-!%!!!@````]!!!!"!!%!!!""01!!!"1!A!!!!!!#!!V!#A!(4H6N:8*J9Q!=1%!!!@````]!!!^"=H*B?3"P:C"%&lt;X6C&lt;'5!!1!"!!!!!!!!!!!!!!!!</Property>
	</Item>
	<Item Name="Motion command" Type="Variable">
		<Property Name="Description:Description" Type="Str">Command to motion controller.</Property>
		<Property Name="featurePacks" Type="Str">Description,Network</Property>
		<Property Name="Network:SingleWriter" Type="Str">False</Property>
		<Property Name="Network:UseBinding" Type="Str">False</Property>
		<Property Name="Network:UseBuffering" Type="Str">False</Property>
		<Property Name="numTypedefs" Type="UInt">1</Property>
		<Property Name="type" Type="Str">Network</Property>
		<Property Name="typedefName1" Type="Str">motion_command.ctl</Property>
		<Property Name="typedefPath1" Type="PathRel">../server/motion_command.ctl</Property>
		<Property Name="typeDesc" Type="Bin">&amp;!#!!!!!!!)!"1!&amp;!!!-!%!!!@````]!!!!"!!%!!!$-S!!!!"1!A!!!!!!(!!5!#A!!&amp;E"!!!(`````!!!)5'^T;82J&lt;WY!!!1!)1!91%!!!@````]!!AN"?'FT)'6O97*M:1!P1"9!!QV"9H.P&lt;(6U:3"B?'FT$6*F&lt;'&amp;U;8:F)'&amp;Y;8-%5'^T:1!!"%VP:'5!!!^!"Q!*6'FN:8.U97VQ!$5!]=S(21Q!!!!"%GVP&gt;'FP&lt;F^D&lt;WVN97ZE,G.U&lt;!!;1&amp;!!"!!"!!-!"!!&amp;"U.P&lt;7VB&lt;G1!!1!'!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!</Property>
	</Item>
	<Item Name="Motion status" Type="Variable">
		<Property Name="Description:Description" Type="Str">Status of motion controller.</Property>
		<Property Name="featurePacks" Type="Str">Description,Network</Property>
		<Property Name="Network:SingleWriter" Type="Str">True</Property>
		<Property Name="Network:UseBinding" Type="Str">False</Property>
		<Property Name="Network:UseBuffering" Type="Str">False</Property>
		<Property Name="numTypedefs" Type="UInt">1</Property>
		<Property Name="type" Type="Str">Network</Property>
		<Property Name="typedefName1" Type="Str">motion_status.ctl</Property>
		<Property Name="typedefPath1" Type="PathRel">../motion_status.ctl</Property>
		<Property Name="typeDesc" Type="Bin">&amp;!#!!!!!!!)!"1!&amp;!!!-!%!!!@````]!!!!"!!%!!!$=W!!!!"1!A!!!!!!*!!A!-0````]!'%"!!!(`````!!!+18BJ=S"O97VF=Q!!"1!+!!!=1%!!!@````]!!AZ"?'FT)("P=WFU;7^O=Q!!%E"!!!(`````!!)%5'^T:1!!$U!(!!F5;7VF=X2B&lt;8!!#E!B"6*F972Z!!R!)1&gt;4&gt;'^Q='6E!$Y!]1!!!!!!!!!"%7VP&gt;'FP&lt;F^T&gt;'&amp;U&gt;8-O9X2M!#2!5!!'!!%!!Q!%!!5!"A!($5VP&gt;'FP&lt;C"T&gt;'&amp;U&gt;8-!!1!)!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!</Property>
	</Item>
</Library>
