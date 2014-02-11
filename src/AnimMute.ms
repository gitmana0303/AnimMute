---------------------------------------------------------------------------------------
-- MayaMute的なものをリストコントローラで再現
-- ただし、XYZ個別ミュートや、ミュート時の状態維持などは無し
---------------------------------------------------------------------------------------

macroScript AnimMute tooltip:"AnimMute：MayaMute的なコントローラ操作" Category:"0303" (
	
	local ANIM_MUTABLE = "AnimMutable"
	
	local rollMain
	local path_root  = pathconfig.appendPath (getdir #userscripts) @"AnimMute"
	local path_img   = pathconfig.appendPath path_root @"images"
	
	
	--リストコントローラかどうか？
	fn isListController con = (
		classof con == position_list or \
		classof con == rotation_list or \
		classof con == scale_list		
	)
	--Mute操作可能なコントローラオブジェクトかどうか？（最低限チェック）
	fn isMutableAnim anim = (
		if not isListController anim.controller do (return false)
		if not isListController anim.controller[1].controller do (return false)
		if not anim.controller[1].name == ANIM_MUTABLE do (return false)	
		true
	)
	--対応リストコントローラ取得
	fn fnGetListController con = (
		 case (superClassOf con) of (
			PositionController:(position_List())
			RotationController:(rotation_List())
			ScaleController:(scale_List())
		)
	)
	--Mute機能コントローラセットアップ
	fn fnSetup anim = (
		anim.controller = fnGetListController anim.controller
		anim.controller = fnGetListController anim.controller
		anim.controller.setName 1 ANIM_MUTABLE
	)
	--Mute設定（ON/OFF）
	fn fnSetMute anim isMute = (
		if not isMutableAnim anim do (return false)
		animate off anim.controller.weight[1] = (if isMute then 0 else 100)
	)
	--ボタンイメージ生成
	fn fnGetImg filename = (
		local path_file = pathconfig.appendPath path_img  filename 
		local bmp = undefined
		if doesFileExist path_file then (
			bmp = openBitMap path_file
		) else (
			bmp = bitmap 10 10
		)
		#(bmp, undefined, 1, 1, 1, 1, 1)
	)
	--メインウィンドウ表示
	fn fnShowDialog = (
		try (DestroyDialog rollMain) catch()
		createDialog rollMain 115 125
	)
	
	
	rollout rollMain ("AnimMute ver." + localTime) (
		button btnSetup ""     width:105 height:25 pos:[5,5] images:(fnGetImg @"img_btn_setup.bmp") tooltip:"Setup AnimMute"
		button btnUnMuteP "" width:50 height:20 pos:[5,40] images:(fnGetImg @"img_btn_pos_unmute.bmp") tooltip:"unMute position animation"
		button btnUnMuteR "" width:50 height:20 pos:[5,70] images:(fnGetImg @"img_btn_rot_unmute.bmp") tooltip:"unMute rotation animation"
		button btnUnMuteS "" width:50 height:20 pos:[5,100] images:(fnGetImg @"img_btn_sca_unmute.bmp") tooltip:"unMute scale animation"
		button btnMuteP ""     width:50 height:20 pos:[60,40] images:(fnGetImg @"img_btn_pos_mute.bmp") tooltip:"Mute position animation"
		button btnMuteR ""     width:50 height:20 pos:[60,70] images:(fnGetImg @"img_btn_rot_mute.bmp") tooltip:"Mute rotation animation"
		button btnMuteS ""     width:50 height:20 pos:[60,100] images:(fnGetImg @"img_btn_sca_mute.bmp") tooltip:"Mute scale animation"
		
		--処理可能かどうか？
		fn canExecute = (
			if (selection.count != 1) do (
				messagebox "オブジェクトを１つ選択してください" title:ANIM_MUTABLE
				return false
			)
			if classof selection[1].controller != PRS do (
				messagebox "PRSコントローラオブジェクトにのみ対応しています" title:ANIM_MUTABLE
				return false
			)
			true
		)
		--Mute設定ボタン実行
		fn fnMute_UnMute subanim_type isMute = (
			if not canExecute() do (return false)
			local obj = selection[1]
			
			fnSetMute obj[#transform][subanim_type] isMute
		)
		
		on btnSetup pressed do (
			if not canExecute() do (return false)
			
			local obj = selection[1]
			local anm = undefined
			
			anm = obj[#transform][#position]
			if not isMutableAnim anm do (fnSetup anm)
			
			anm = obj[#transform][#rotation]
			if not isMutableAnim anm do (fnSetup anm)
			
			anm = obj[#transform][#scale]
			if not isMutableAnim anm do (fnSetup anm)
			
			messagebox "セットアップ完了" title:ANIM_MUTABLE
		)
		on btnUnMuteP pressed do (fnMute_UnMute #position false)
		on btnUnMuteR pressed do (fnMute_UnMute #rotation false)
		on btnUnMuteS pressed do (fnMute_UnMute #scale false)
		on btnMuteP pressed do (fnMute_UnMute #position true)
		on btnMuteR pressed do (fnMute_UnMute #rotation true)
		on btnMuteS pressed do (fnMute_UnMute #scale true)
	)
	
	on execute do(fnShowDialog())
)

macros.run "0303" "AnimMute"