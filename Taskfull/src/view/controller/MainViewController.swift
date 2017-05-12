//
//  MainViewController.swift
//  Taskfull
//
//  Created by IscIsc on 2016/07/12.
//  Copyright © 2016年 IscIsc. All rights reserved.
//

import UIKit

///
/// メイン画面
///
class MainViewController : BaseViewController, NSURLConnectionDelegate,SlideMenuControllerDelegate
{
    /**
     * 定数
     */

    /**
     * 画面遷移Identifier定義
     */
    // タスク追加画面への遷移定義文字列
    static internal let SEGUE_IDENTIFIER_TASK_INPUT = "toTaskInputViewController"
    // タスク編集画面への遷移定義文字列
    static internal let SEGUE_IDENTIFIER_TASK_EDIT = "toTaskEditViewController"
    // GPS通知設定画面への遷移定義文字列
    static internal let SEGUE_IDENTIFIER_CONFIG_MAP = "toMapConfigViewController"

    
    /**
     * 変数
     */
    // 追加ボタンイメージ
    fileprivate let mImageAddButton : UIImage = UIImage(named: "add.png")!
    fileprivate let mImageAddButtonDown : UIImage = UIImage(named: "add_down.png")!
    // モード変更ボタンイメージ
    fileprivate let mImageModeChangeButton : UIImage = UIImage(named: "modechg.png")!
    fileprivate let mImageModeChangeButtonDown : UIImage = UIImage(named: "modechg_down.png")!

    // パラメータ用タスクID格納変数
    fileprivate var mParamTaskId : Int = 0
    
    /**
     * 動作モード
     */
    fileprivate var mActionMode : CommonConst.ActionType = CommonConst.ActionType.reference
    
    /**
     * タスク表示項目配列
     */
    fileprivate var mArrayViewTaskItem : [ViewTaskItemEntity] = []
    
    /**
     * メインビュー
     */
    @IBOutlet var mainView: UICustomView!
    /**
     * 画像キャンバスビュー
     */
    @IBOutlet weak var imageCanvasView: UICustomView!
    /**
      * モード切替
      */
    @IBOutlet weak var modeButton: UICircleImageButton!
    
    /**
     * 左メニューバーボタン
     */
    @IBOutlet weak var LeftMenuBarBtn: UIImageView!
    
    /**
     * 右メニューバーボタン
     */
    @IBOutlet weak var RightMenuBarBtn: UIImageView!
    
    /**
     * タスクカテゴリーメニューバー画面
     */
    open var taskCategoryManuBarController : TaskCategoryMenuBarViewController! = nil
    
    /**
     * キャンセルフラグƒ
     */
    open var cancelFlag : Bool = false
    
    /**
     * 画面遷移フラグ
     */
    open var transDisplayFlag : CommonConst.MainMenuType = CommonConst.MainMenuType.none
        
    /**
     * 左メニューバー利用可/不可判断
     */
    open override var isValidLeftMenuBar : Bool {
        get {
            return !self.LeftMenuBarBtn.isHidden
        }
    }
    
    /**
     * 右メニューバー利用可/不可判断
     */
    open override var isValidRightMenuBar : Bool {
        get {
            return !self.RightMenuBarBtn.isHidden
        }
    }
    
    ///
    /// viewDidLoadイベント処理
    ///
    override func viewDidLoad() {
        // 基底のviewDidLoadを呼び出す
        super.viewDidLoad()
        
        // 初期化
        let _ = initializeProc()
    }
    
    ///
    /// viewWillAppearイベント処理
    ///　- parameter:animated:true:アニメーションする false:アニメーションしない
    ///
    override func viewWillAppear(_ animated: Bool) {
        // 基底のviewWillAppearを呼び出す
        super.viewWillAppear(animated)
    }
    
    ///
    //　画面表示直後時処理
    ///　- parameter animated:アニメーションフラグ
    ///
    override func viewDidAppear(_ animated: Bool) {
        // 画面遷移しない場合
        if(self.transDisplayFlag == CommonConst.MainMenuType.none){
            // キャンセルフラグが立っていない場合
            if (false == self.cancelFlag) {
                // タスクイメージボタン全削除処理
                removeAllTaskImageControl()
                
                // 再描画処理（タイマーでタイミングをずらさないとアニメーションされないため）
                _ = Timer.scheduledTimer(timeInterval: 0.75, target: self, selector: #selector(updateRedraw(_:)), userInfo: nil, repeats: false)
            
            // 上記以外の場合
            } else {
                // アニメーション開始
                startAllTaskImageAnimation()
            }

        // 上記以外の場合
        } else {
            // 画面遷移処理
            transDisplay()
        }

        // 基底のviewDidAppearを呼び出す
        super.viewDidAppear(animated)
    }
    
    ///
    //　画面非表示時処理
    ///　- parameter animated:アニメーションフラグ
    ///
    override func viewDidDisappear(_ animated: Bool) {
        // アニメーション停止
        stopAllTaskImageAnimation()

        // 基底のviewDidDisappearを呼び出す
        super.viewDidDisappear(animated)
    }
    
    ///
    ///　再描画用　タイマー更新処理
    ///　- parameter timer:タイマー
    ///
    @objc func updateRedraw(_ timer: Timer) {
        // タイマー停止
        timer.invalidate()

        // 再描画処理
        redraw()
    }
    
    ///
    ///　全再描画用　タイマー更新処理
    ///　- parameter timer:タイマー
    ///
    @objc func updateAllRedraw(_ timer: Timer) {
        // タイマー停止
        timer.invalidate()
        
        // タスクイメージボタン全削除処理
        self.cancelFlag = false
        removeAllTaskImageControl()
        
        // 再描画処理
        redraw()
    }
    
    ///
    /// didReceiveMemoryWarningイベント処理
    ///
    override func didReceiveMemoryWarning() {
        // 基底のdidReceiveMemoryWarningを呼び出す
        super.didReceiveMemoryWarning()

        // タスクイメージボタン全削除処理
        removeAllTaskImageControl()
    }
    
    ///
    /// 初期化処理
    ///　- returns:true:正常終了 false:異常終了
    ///
    override func initializeProc() ->Bool
    {
        // 基底のinitializeProcを呼び出す
        var ret : Bool = super.initializeProc()
        
        //　正常な場合
        if(true == ret)
        {
            // applicationDidEnterBackgroundの通知を受信する
            NotificationCenter.default.addObserver(self, selector: #selector(self.applicationDidEnterBackground), name: NSNotification.Name(rawValue: "applicationDidEnterBackground"), object: nil)
            // applicationWillEnterForegroundの通知を受信する
            NotificationCenter.default.addObserver(self, selector: #selector(self.applicationWillEnterForeground), name: NSNotification.Name(rawValue: "applicationWillEnterForeground"), object: nil)
            
            // 動作モードによるメイン画面の初期化
            initializeMain(self.mActionMode)
            
            // 再描画処理
            redraw()

            // 戻り値にtrueを設定
            ret = true
        }
        
        return ret
    }
    
    ///
    /// applicationDidEnterBackgroundイベント処理
    ///　- parameter application:UIApplicationオブジェクト
    ///
    func applicationDidEnterBackground(_ application: UIApplication){
        // アニメーション停止
        stopAllTaskImageAnimation()
    }
    
    ///
    /// applicationWillEnterForegroundイベント処理
    ///　- parameter application:UIApplicationオブジェクト
    ///
    func applicationWillEnterForeground(_ application: UIApplication){
        // アニメーション開始
        startAllTaskImageAnimation()
    }
    
    ///
    /// 動作モードによるメイン画面の初期化
    ///　- parameter actionType:動作モード
    ///
    fileprivate func initializeMain(_ actionType : CommonConst.ActionType)
    {
        switch(self.mActionMode){
        // 現在編集モードの場合
        case CommonConst.ActionType.edit:
            self.mainView.gradationBackgroundStartColor = CommonConst.CL_BACKGROUND_GRADIATION_ORANGE_1
            self.mainView.gradationBackgroundEndColor = CommonConst.CL_BACKGROUND_GRADIATION_ORANGE_2
            self.RightMenuBarBtn.isHidden = false
            break;
        // 上記以外の場合
        default:
            self.mainView.gradationBackgroundStartColor = CommonConst.CL_BACKGROUND_GRADIATION_BLUE_1
            self.mainView.gradationBackgroundEndColor = CommonConst.CL_BACKGROUND_GRADIATION_BLUE_2
            self.RightMenuBarBtn.isHidden = true
            break;
        }
    }
    
    ///
    ///　タスク情報読込み
    ///
    fileprivate func getTaskInfo() {
        // タスク情報の読込み
        TaskInfoUtility.DefaultInstance.ReadTaskInfo()
    }
    
    ///
    /// タスクを表示する
    ///　- parameter actionType:動作モード
    ///
    fileprivate func displayTask(_ actionType : CommonConst.ActionType)
    {
        // タスクイメージボタン設定
        setTaskImageButton()

        // キャンバスビューにコントロールを追加
        addAllTaskImageButton()
    }
    
    ///
    /// タスクイメージボタン全削除処理
    ///
    fileprivate func removeAllTaskImageControl(){
        // キャンバスビューのコントロールを全削除
        removeAllTaskImageButton()
        
        // タスクイメージボタン配列クリア
        self.mArrayViewTaskItem.removeAll()
    }
    
    ///
    /// タスク情報からタスクイメージボタン生成処理
    ///
    fileprivate func setTaskImageButton(){
        // タスクイメージボタン全削除処理
        removeAllTaskImageControl()
        
        // 現在日付を取得
        let systemDate : String = FunctionUtility.DateToyyyyMMddHHmmss(Date(), separation: true)
        
        var index : Int = 0
        // 表示対象データ数分処理する
        for item in getDisplayTaskData() {
            // タスクイメージボタンを生成し配列に追加
            self.mArrayViewTaskItem.append(createViewTaskItemEntity(index: index, systemDate: systemDate, item: item))
            
            // インデックス更新
            index += 1
        }
    }
    
    ///
    /// タスクイメージボタンのアニメーション開始処理
    ///
    fileprivate func startAllTaskImageAnimation(){
        
        // キャンバスビューにコントロール数分処理する
        for item in self.mArrayViewTaskItem {
            // 表示している場合
            if (true == item.IsDisplay) {
                // アニメーション開始処理
                item.TaskButton?.startAnimation()
            }
        }
    }
    
    ///
    /// タスクイメージボタンのアニメーション停止処理
    ///
    fileprivate func stopAllTaskImageAnimation(){
        
        // キャンバスビューにコントロール数分処理する
        for item in self.mArrayViewTaskItem {
            // 表示している場合
            if (true == item.IsDisplay) {
                // アニメーション停止処理
                item.TaskButton?.stopAnimation()
            }
        }
    }
    
    ///
    /// タスクイメージボタン生成処理
    ///
    fileprivate func createViewTaskItemEntity(index : Int, systemDate : String, item : TaskInfoDataEntity) -> ViewTaskItemEntity {

        return createViewTaskItemEntity(index : index, systemDate : systemDate, id : item.Id, title : item.Title, memo : item.Memo, dateTime : item.DateTime, buttonColor : item.ButtonColor, textColor : item.TextColor, createDateTime : item.CreateDateTime)
    }
    
    ///
    /// タスクイメージボタン生成処理
    ///
    fileprivate func createViewTaskItemEntity(parrentIndex : Int, systemDate : String, item : ViewTaskItemEntity) -> ViewTaskItemEntity {

        // IDのタスク情報取得
        let data = TaskInfoUtility.DefaultInstance.GetTaskInfoDataForId(item.Id)

        // 取得できた場合
        if nil != data {
            // タスクイメージボタン生成
            return createViewTaskItemEntity(index : parrentIndex, systemDate : systemDate, id : data!.Id, title : data!.Title, memo : data!.Memo, dateTime : data!.DateTime, buttonColor : data!.ButtonColor, textColor : data!.TextColor, createDateTime : data!.CreateDateTime)
        } else {
            return ViewTaskItemEntity()
        }
    }

    ///
    /// タスクイメージボタン生成処理
    ///
    fileprivate func createViewTaskItemEntity(index : Int, systemDate : String, id : Int, title : String, memo : String, dateTime : String, buttonColor : Int, textColor : Int, createDateTime : String) -> ViewTaskItemEntity {
        
        // 表示項目情報生成
        let taskViewItem : ViewTaskItemEntity = ViewTaskItemEntity()
        
        // ID設定
        taskViewItem.Id = id
        // 表示インデックス設定
        taskViewItem.Index = index
        
        // ボタン色設定
        taskViewItem.Color = getButtonColor(buttonColor, systemDate : systemDate, taskDate : dateTime)
        
        // ボタンサイズ取得
        let size : CGSize = getButtonSize(systemDate, taskDate: dateTime, createDate: createDateTime)
        // ボタン位置取得
        let position : CGPoint = getButtonPosition(index, buttonSize: size)
        
        // ボタン位置・サイズ設定
        taskViewItem.Location = CGRect(origin: CGPoint(x: position.x, y: position.y), size: size)
        
        // ボタン生成
        taskViewItem.TaskButton = UITaskImageButton(frame: taskViewItem.Location)
        
        // ボタン情報設定
        taskViewItem.TaskButton!.btnImage.setImageInfo(getButtonResource(taskViewItem.Color) , width:Double(size.width) , height:Double(size.height))
        taskViewItem.TaskButton!.btnImage.tag = id
        taskViewItem.TaskButton!.btnImage.addTarget(self, action: #selector(MainViewController.onTouchUp_TaskCirclrImageButton(_:)), for: .touchUpInside)
        
        // 長押しイベント設定
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(MainViewController.onLongPressGestureRecognizer_TaskCirclrImageButton(_:)))
        // 長押し-最低1秒間は長押しする.
        longPressGesture.minimumPressDuration = 1.0
        // 長押し-指のズレは15pxまで.
        longPressGesture.allowableMovement = 150
        // 長押しイベント追加
        taskViewItem.TaskButton!.btnImage.addGestureRecognizer(longPressGesture)
        
        // タイトル設定
        taskViewItem.TaskButton!.labelTitle = title
        // メモ設定
        taskViewItem.TaskButton!.labelMemo = memo
        // 完了日付設定
        taskViewItem.TaskButton!.labelDateTime = FunctionUtility.DateToMdHHmm_JP(FunctionUtility.yyyyMMddHHmmssToDate(dateTime)).replacingOccurrences(of: StringUtility.HALF_SPACE, with: StringUtility.LF)
        // 文字色設定
        taskViewItem.TaskButton!.labelTextColor = textColor
        
        return taskViewItem
    }
    
    ///
    ///　ボタンサイズ取得
    ///　- parameter systemDate:システム日付
    ///　- parameter taskDate:タスク完了日時
    ///　- parameter createDate:作成日時
    ///　- returns:ボタンサイズ
    ///
    fileprivate func getButtonSize(_ systemDate : String, taskDate : String, createDate : String) -> CGSize {
        // ボタン最小サイズを取得
        var ret : CGSize = CGSize(width: CommonConst.TASK_BUTTON_SIZE_MIN, height: CommonConst.TASK_BUTTON_SIZE_MIN)
        
        // 当日の場合
        if(true == FunctionUtility.isToday(systemDate, date2: taskDate)) {
            // ボタン最大サイズを設定
            ret = CGSize(width: CommonConst.TASK_BUTTON_SIZE_MAX, height: CommonConst.TASK_BUTTON_SIZE_MAX)
            
        // 上記以外の場合
        } else {
            // 作成日からの時間の差取得
            let diffHour : Int = FunctionUtility.DiffHour(taskDate, date2: createDate) - FunctionUtility.DiffHour(systemDate, date2: createDate)

            let work : CGFloat = CGFloat(CommonConst.TASK_BUTTON_SIZE_MIN) + ((CGFloat(CommonConst.TASK_BUTTON_SIZE_MAX - CommonConst.TASK_BUTTON_SIZE_MIN) / CGFloat(diffHour)))
            ret = CGSize(width: work, height: work)
        }
        
        return ret;
    }
    
    ///
    ///　ボタン位置取得
    ///　- parameter index:表示コントロールのインデックス
    ///　- parameter buttonSize:ボタンサイズ
    ///　- returns:ボタン位置
    ///
    fileprivate func getButtonPosition(_ index : Int, buttonSize : CGSize) -> CGPoint {
        var ret : CGPoint = CGPoint(x: 0, y: 0)

        // imageCanvasViewのサイズを領域とする
        let areaSize : CGSize = self.imageCanvasView.frame.size
        
        // 領域の中央座標を取得
        let centerPos : CGPoint = CGPoint(x: areaSize.width / 2, y: areaSize.height / 2)
        
        // データがある場合
        if(0 < self.mArrayViewTaskItem.count) {
            let centerIndex = (8 >= index) ? 0 : (index - 8)
            // 先頭ボタン表示位置を取得
            let centerButtonLocation : CGRect = self.mArrayViewTaskItem[centerIndex].Location
            // ボタン位置取得
            ret = getNextButtonLocation(index, centerButtonLocation: centerButtonLocation, buttonSize : buttonSize)
            
        // 上記以外の場合
        } else {
            // 中央位置に設定する
            ret = CGPoint(x: centerPos.x - (buttonSize.width / 2), y: centerPos.y - (buttonSize.height / 2))
        }
        
        return ret
    }
    
    ///
    ///　次表示ボタン位置取得
    ///　- parameter index:表示コントロールのインデックス
    ///　- parameter centerButtonLocation:中央ボタンサイズ
    ///　- parameter buttonSize:ボタンサイズ
    ///　- returns:ボタン位置
    ///
    fileprivate func getNextButtonLocation(_ index : Int, centerButtonLocation : CGRect, buttonSize : CGSize) -> CGPoint {
        var ret : CGPoint = CGPoint(x: 0, y: 0)
        let margin : CGFloat = 10
        let buttonHalfSize : CGSize = CGSize(width: buttonSize.width / 2, height: buttonSize.height / 2)

        // 先頭の中央サイズを取得
        let centerButtonHalfSize : CGSize = CGSize(width: centerButtonLocation.size.width / 2, height: centerButtonLocation.size.height / 2)
        
        // 先頭の場合
        if(0 == index) {
            // 中央に表示
            ret = CGPoint(x: centerButtonLocation.origin.x + (centerButtonHalfSize.width - buttonHalfSize.width) , y: centerButtonLocation.origin.y + (centerButtonHalfSize.height - buttonHalfSize.height))

        // 上記以外の場合
        } else {
            //
            switch((index - 1) % 8) {
            // 右下
            case 0:
                // 右下に表示
                ret = CGPoint(x: ((centerButtonLocation.origin.x + margin) + centerButtonLocation.size.width) -  buttonHalfSize.width,
                              y: ((centerButtonLocation.origin.y + margin) + centerButtonLocation.size.height) - buttonHalfSize.height)
                break;
            // 下
            case 1:
                // 下に表示
                ret = CGPoint(x: (centerButtonLocation.origin.x + centerButtonHalfSize.width) - buttonHalfSize.width,
                              y: ((centerButtonLocation.origin.y + margin) + centerButtonLocation.size.height))
                break;
            // 左下
            case 2:
                // 左下に表示
                ret = CGPoint(x: ((centerButtonLocation.origin.x - margin)) - buttonHalfSize.width,
                              y: ((centerButtonLocation.origin.y + margin) + centerButtonLocation.size.height) - buttonHalfSize.height)
                break;
            // 左
            case 3:
                // 左に表示
                ret = CGPoint(x: (centerButtonLocation.origin.x - margin) - buttonSize.width,
                              y: ((centerButtonLocation.origin.y) + centerButtonHalfSize.height) - buttonHalfSize.height)
                break;
            // 左上
            case 4:
                // 左上に表示
                ret = CGPoint(x: ((centerButtonLocation.origin.x - margin)) - buttonHalfSize.width,
                              y: ((centerButtonLocation.origin.y - margin)) - buttonHalfSize.height)
                break;
            // 上
            case 5:
                // 上に表示
                ret = CGPoint(x: (centerButtonLocation.origin.x + centerButtonHalfSize.width) - buttonHalfSize.width,
                              y: (centerButtonLocation.origin.y - margin) - buttonSize.height)
                
                break;
            // 右上
            case 6:
                // 右上に表示
                ret = CGPoint(x: ((centerButtonLocation.origin.x + margin) + centerButtonLocation.size.width) -  buttonHalfSize.width,
                              y: ((centerButtonLocation.origin.y - margin)) - buttonHalfSize.height)
                break;
            // 右
            case 7:
                // 右に表示
                ret = CGPoint(x: ((centerButtonLocation.origin.x + margin) + centerButtonLocation.size.width),
                              y: ((centerButtonLocation.origin.y) + centerButtonHalfSize.height) - buttonHalfSize.height)
                break;
                
            default:
                break;
            }
        }
        return ret
    }
    
    
    ///
    /// 表示ボタン色取得
    ///　- returns:表示ボタン色
    ///
    fileprivate func getButtonColor(_ color : Int, systemDate : String, taskDate : String) -> Int {
        
        // 当日の場合は緊急色（赤）、それ以外はそのままの色
        return (true == FunctionUtility.isToday(systemDate, date2: taskDate)) ? CommonConst.TASK_BUTTON_COLOR_RED : color
    }
    
    ///
    /// 表示ボタンリソース取得
    ///　- returns:表示ボタンリソース
    ///
    fileprivate func getButtonResource(_ color : Int) -> UIImage {
        
        // 指定されたインデックスのリソースを返す
        return UIImage(named: CommonConst.TASK_BUTTON_COLOR_RESOURCE[color])!
    }
			    
    ///
    /// 表示タスクデータの取得
    ///　- returns:表示タスクデータ配列
    ///
    fileprivate func getDisplayTaskData() -> [TaskInfoDataEntity] {
        return getTopDisplayTaskData()
    }
    
    ///
    /// 上位に表示するタスクデータの取得
    ///　- returns:表示タスクデータ配列
    ///
    fileprivate func getTopDisplayTaskData() -> [TaskInfoDataEntity] {
        var taskData : [TaskInfoDataEntity] = [TaskInfoDataEntity]()
        var dicParrentId : Dictionary<Int, Int> = Dictionary<Int, Int>()
        
        // データ数分表示する
        for data in TaskInfoUtility.DefaultInstance.GetTaskInfoData() {
            // 未完了、かつ、同一カテゴリー、かつ、親が表示されていない場合
            if(CommonConst.TASK_COMPLETE_FLAG_INVALID == data.CompleteFlag
                && TaskInfoUtility.DefaultInstance.GetCategoryType() == data.CategoryType
                && false == isDisplayParrent(parrentId : data.ParrentId, categoryType : TaskInfoUtility.DefaultInstance.GetCategoryType(), dicParrentId : dicParrentId)) {
                // 表示対象に追加する
                taskData.append(data)
                // 表示しているIDを設定
                dicParrentId[data.Id] = data.Id
            }
        }
        
        // 完了日の昇順でソートする
        taskData.sort(by: <)
        
        // 結果を返す
        return taskData
    }
    
    ///
    /// 親IDが表示済かの判断
    ///　- parameter parrentId:親タスクID
    ///　- parameter categoryType:カテゴリー形式
    ///　- parameter dicParrentId:表示済親ID
    ///　- returns:true:表示済 false:非表示
    ///
    fileprivate func isDisplayParrent(parrentId : Int, categoryType : Int, dicParrentId : Dictionary<Int, Int>) ->Bool {
        // 親IDが有効な場合
        if(0 <= parrentId) {
            // データ数分表示する
            for data in TaskInfoUtility.DefaultInstance.GetTaskInfoData() {
                // IDと親IDが一致、かつ、親が表示されていない場合
                if(data.Id == parrentId
                    && categoryType == data.CategoryType) {
                    // 表示していない場合
                    if(false == dicParrentId.keys.contains(data.Id)) {
                        // 親を遡ってチェックする
                        return isDisplayParrent(parrentId : data.ParrentId, categoryType : categoryType, dicParrentId : dicParrentId)

                    // 上記以外の場合
                    } else {
                        // 親が表示している
                        return true
                    }
                }
            }
        }
        
        return false
    }
    
    ///
    /// キャンバスビューからタスクイメージボタンを全削除処理
    ///　- returns:表示タスクデータ配列
    ///
    fileprivate func removeAllTaskImageButton(){
        // キャンバスビューのコントロール数分処理する
        for view in self.imageCanvasView.subviews {
            // 削除
            view.removeFromSuperview()
        }
    }
    
    ///
    /// キャンバスビューへタスクイメージボタンの全追加処理
    ///
    fileprivate func addAllTaskImageButton(){
        // キャンバスビューにコントロール数分処理する
        for item in self.mArrayViewTaskItem {
            // 表示する場合
            if (item.IsDisplay) {
                // キャンバスビューにコントロールを追加
                self.imageCanvasView.insertSubview(item.TaskButton!, at: 0)
            }
        }
    }
    
    ///
    /// 表示用　タスクイメージボタンの表示フラグクリア処理
    ///
    fileprivate func clearTaskImageButtonDisplayFlag(){
        // キャンバスビューにコントロール数分処理する
        for item in self.mArrayViewTaskItem {
            // 表示する
            item.IsDisplay = true
        }
    }
    
    ///
    /// 表示用　タスクイメージボタンの割れた処理
    ///　- parameter id:タスクID
    ///　- parameter isComplete:true:タスク完了済にする false:タスク完了済にしない
    ///
    fileprivate func clashTaskImageButton(id : Int, isComplete : Bool){
        // キャンバスビューにコントロール数分処理する
        for item in self.mArrayViewTaskItem {
            // ボタンが有効な場合
            if nil != item.TaskButton {
                // IDが一致した場合
                if item.TaskButton!.btnImage.tag == id {
                    //　シャボン玉が割れたアニメーションを表示
                    item.TaskButton?.clashAnimation()
                    // 子がいる場合は子を表示する
                    displayTaskImageButtonForChild(parrentItem: item)

                    // 非表示にする
                    item.IsDisplay = false
                    break;
                }
            }
        }
    }
    
    ///
    /// 表示用　子のタスクイメージボタン表示処理
    ///　- parameter parrentItem:親ViewTaskItemEntity
    ///
    fileprivate func displayTaskImageButtonForChild(parrentItem : ViewTaskItemEntity) {
        // データ数分表示する
        for data in TaskInfoUtility.DefaultInstance.GetTaskInfoData() {
            // 未完了、かつ、親IDが一致した場合
            if(CommonConst.TASK_COMPLETE_FLAG_INVALID == data.CompleteFlag
                && parrentItem.Id == data.ParrentId) {
                // 登録済ではない場合
                if(false == isRegistered(id : data.Id)){
                    // 現在日付を取得
                    let systemDate : String = FunctionUtility.DateToyyyyMMddHHmmss(Date(), separation: true)

                    // タスクイメージボタンを生成
                    let viewTaskItem : ViewTaskItemEntity = createViewTaskItemEntity(index: parrentItem.Index, systemDate: systemDate, item: data)

                    // 配列に追加
                    self.mArrayViewTaskItem.append(viewTaskItem)

                    // キャンバスビューにコントロールを追加
                    self.imageCanvasView.insertSubview(viewTaskItem.TaskButton!, at: 0)
                }
            }
        }
    }
    
    ///
    /// 表示用　タスクイメージボタンが登録済かのチェック
    ///　- parameter id:登録済かを確認するID
    ///　- returns true:登録済 false:未登録
    ///
    fileprivate func isRegistered(id : Int) -> Bool{
        var ret : Bool = false
        
        // キャンバスビューにコントロール数分処理する
        for item in self.mArrayViewTaskItem {
            // 非表示データがある場合
            if(id == item.Id) {
                // 戻り値にfalseを設定する
                ret = true
                break
            }
        }
        
        return ret
    }
    
    ///
    /// 表示用　タスクイメージボタン全表示かのチェック
    ///　- returns true:全表示 false:非表示あり
    ///
    fileprivate func isAllDisplayFlag() -> Bool{
        var ret : Bool = true
        
        // キャンバスビューにコントロール数分処理する
        for item in self.mArrayViewTaskItem {
            // 非表示データがある場合
            if(false == item.IsDisplay) {
                // 戻り値にfalseを設定する
                ret = false
                break
            }
        }
        
        return ret
    }
    
    ///
    /// 表示用　タスクイメージボタン全非表示かのチェック
    ///　- returns true:非表示 false:表示あり
    ///
    fileprivate func isNonDisplay() -> Bool{
        var ret : Bool = true
        
        // キャンバスビューにコントロール数分処理する
        for item in self.mArrayViewTaskItem {
            // 表示データがある場合
            if(true == item.IsDisplay) {
                // 戻り値にfalseを設定する
                ret = false
                break
            }
        }
        
        return ret
    }
    
    ///
    /// モード切り替えボタン押下イベント
    ///　- parameter sender:イベントが発生したオブジェクト
    ///
    @IBAction func onTouchDown_ModeButton(_ sender: AnyObject) {
        
        switch(self.mActionMode){
            // 現在編集モードの場合
            case CommonConst.ActionType.edit:
                // 参照モードに切り替える
                self.mActionMode = CommonConst.ActionType.reference
                break;
            // 上記以外の場合
            default:
                // 編集モードに切り替える
                self.mActionMode = CommonConst.ActionType.edit
                break;
        }
        
        // 動作モードによるメイン画面の初期化
        initializeMain(self.mActionMode)
        
        // 参照時に割ったシャボン玉がある場合
        if(false == isAllDisplayFlag()){
            // 表示フラグの初期化
            clearTaskImageButtonDisplayFlag()
            // タスクを表示する
            displayTask(self.mActionMode)
        }
    }
    
    ///
    /// タスクイメージボタン押下イベント
    ///　- parameter sender:イベントが発生したオブジェクト
    ///
    @IBAction func onTouchUp_TaskCirclrImageButton(_ sender : UITaskImageButton){
        
        debugPrint(sender.tag.description)

        switch(self.mActionMode){
        // 現在編集モードの場合
        case CommonConst.ActionType.edit:
            // メッセージ確認
            dispAlertForTaskComplete(id: sender.tag)
            break;
        // 上記以外の場合
        default:
            // シャボン玉を割る処理を実行
            clashTaskImageButton(id: sender.tag, isComplete: false)
            
            // 全て非表示になった場合
            if(true == isNonDisplay()){
                // 全再描画処理（タイマーでタイミングをずらさないとアニメーションされないため）
                _ = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(updateAllRedraw(_:)), userInfo: nil, repeats: false)
            }
            break;
        }
    }
    
    ///
    /// 長押しイベント
    ///　- parameter sender:UILongPressGestureRecognizer
    ///
    @IBAction func onLongPressGestureRecognizer_TaskCirclrImageButton(_ sender : UILongPressGestureRecognizer){

        // 長押しされた場合
        if(sender.state == UIGestureRecognizerState.began && nil != sender.view){
            if nil != sender.view {
                // VIEWがUICircleImageButtonの場合
                if let view = sender.view! as? UICircleImageButton {
                    switch(self.mActionMode){
                        
                    // 現在編集モードの場合
                    case CommonConst.ActionType.edit:
                        // 長押しボタンの対象IDをメンバ変数に格納
                        self.mParamTaskId = view.tag
                        // タスク編集画面を表示
                        self.performSegue(withIdentifier: MainViewController.SEGUE_IDENTIFIER_TASK_EDIT, sender: self)
                        
                        break;
                    // 上記以外の場合
                    default:
                        // 長押しボタンの対象IDをメンバ変数に格納
                        self.mParamTaskId = view.tag
                        // タスク編集画面を表示
                        self.performSegue(withIdentifier: MainViewController.SEGUE_IDENTIFIER_TASK_EDIT, sender: self)
                        break;
                    }
                 }
            }
        }
    }

    ///
    /// タスク追加ボタン押下イベント
    ///　- parameter sender:イベントが発生したオブジェクト
    ///
    @IBAction func onTouchDown_AddTask(_ sender: AnyObject) {
        // TODO:押下時の処理を記述する
        // タスク入力画面を表示
        self.performSegue(withIdentifier: MainViewController.SEGUE_IDENTIFIER_TASK_INPUT, sender: self)
        
        
    }

    ///
    /// 画面遷移前イベント
    ///　- parameter segue:イベントのUIStoryboardSegue
    ///　- parameter sender:イベントが発生したオブジェクト
    ///
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 
        // キャンセルフラグを初期化
        self.cancelFlag = false
        
        // タスク入力画面へ遷移する場合
        if(segue.identifier == MainViewController.SEGUE_IDENTIFIER_TASK_INPUT){
            
            // タスク入力画面のコントローラを取得
            let dvc : TaskInputViewController = (segue.destination as AnyObject as? TaskInputViewController)!

            // タスク登録モード
            dvc.paramMainViewMode = CommonConst.ActionType.add
            
            
            // TEST:START
            // タスク:カテゴリータイプ
            dvc.paramCategoryType = TaskInfoUtility.DefaultInstance.GetCategoryType()
            // TEST:END
        }
        // タスク編集画面へ遷移する場合
        else if(segue.identifier == MainViewController.SEGUE_IDENTIFIER_TASK_EDIT){
            
            // タスク編集画面のコントローラを取得
            let dvc : TaskEditViewController = (segue.destination as AnyObject as? TaskEditViewController)!
            
            // 長押しボタンのタスクIDを渡す
            dvc.paramTaskId = self.mParamTaskId
            dvc.paramMainViewMode = self.mActionMode
            
            // TEST:START
            // タスク:カテゴリータイプ
            dvc.paramCategoryType = TaskInfoUtility.DefaultInstance.GetCategoryType()
            // TEST:END
            
        }
        
    }
    
    ///
    //　再描画処理
    ///
    override func redraw() {
        // キャンセルフラグが立っていない場合
        if (false == self.cancelFlag) {
            // 登録タスク情報の取得
            getTaskInfo()
        
            // タスク通知生成処理
            //taskExpirationNotification()
        
            // ナビゲーションバーの再描画
            redrawNavigationBar()

            // タスクカテゴリーメニューバーの再描画
            redrawTaskMenuBar()

            // タスクを表示する
            displayTask(self.mActionMode)
        }

        // キャンセルフラグを初期化
        self.cancelFlag = false
    }
    
    ///
    //　画面遷移処理
    ///
    func transDisplay() {
        switch(self.transDisplayFlag){
        // タスク入力画面の場合
        case CommonConst.MainMenuType.taskAdd:
            // タスク入力画面を表示
            self.performSegue(withIdentifier: MainViewController.SEGUE_IDENTIFIER_TASK_INPUT, sender: self)
            break
        // GPS設定画面の場合
        case CommonConst.MainMenuType.configGps:
            // GPS設定画面を表示
            self.performSegue(withIdentifier: MainViewController.SEGUE_IDENTIFIER_CONFIG_MAP, sender: self)
            break
        default:
            break
        }
        self.transDisplayFlag = CommonConst.MainMenuType.none
    }
    
    ///
    /// ナビゲーションバーの再描画
    ///
    fileprivate func redrawNavigationBar() {
        // ナビゲーションバー背景色
        self.navigationController?.navigationBar.backgroundColor = CommonConst.CATEGORY_TYPE_BACKGROUND_COLOR[TaskInfoUtility.DefaultInstance.GetCategoryType()]
        // タイトル設定
        self.navigationItem.title = "".appendingFormat(CommonConst.VIW_TITLE_MAIN, CommonConst.CATEGORY_TYPE_STRING[TaskInfoUtility.DefaultInstance.GetCategoryType()])
        // ナビゲーションバー表示
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    ///
    /// タスク完了メッセージ表示
    ///　- parameter id:完了対象のタスクID
    ///
    fileprivate func dispAlertForTaskComplete(id : Int) {
        // 対象IDをメンバ変数に格納
        self.mParamTaskId = id

        // IDのタスク情報取得
        let data = TaskInfoUtility.DefaultInstance.GetTaskInfoDataForId(id)
        
        // 取得できた場合
        if nil != data {
            // タスク完了メッセージ表示
            MessageUtility.dispAlertOKCancel(viewController: self, title: MessageUtility.MESSAGE_TITLE_STRING_CONFIRM_TASK_COMPLETE, message: "".appendingFormat(MessageUtility.MESSAGE_MESSAGE_STRING_CONFIRM_TASK_COMPLETE, (data?.Title)!), funcOkButton: onClickTaskCompleteOK, funcCancelButton: nil)
        }
    }
    
    ///
    /// タスク完了メッセージ OKボタン押下イベント
    ///　- parameter action:UIAlertActionコントロール
    ///
    fileprivate func onClickTaskCompleteOK(action: UIAlertAction) {
        // タスク完了処理
        setTaskCompleteProc(id: self.mParamTaskId)

        // シャボン玉を割る処理を実行
        clashTaskImageButton(id: self.mParamTaskId, isComplete: true)
    }
    
    ///
    /// タスク完了処理
    ///　- parameter id:完了対象のタスクID
    ///
    fileprivate func setTaskCompleteProc(id : Int) {
        // タスク完了設定
        TaskInfoUtility.DefaultInstance.SetTaskInfoDataForComplete(id)
        // 変更内容書き込み
        TaskInfoUtility.DefaultInstance.WriteTaskInfo()
        // タスクカテゴリーメニューバーの再描画
        redrawTaskMenuBar()
    }

    ///
    /// タスクカテゴリーメニューバーの再描画
    ///
    fileprivate func redrawTaskMenuBar() {
        // タスクカテゴリーメニューバーの再描画
        self.taskCategoryManuBarController.redraw()
    }
    
    
    
    /// SlideMenuControllerDelegate
    func leftWillOpen() {
    }
    
    func leftDidOpen() {
    }
    
    func leftWillClose() {
    }
    
    func leftDidClose() {
    }
    
    func rightWillOpen() {
    }
    
    func rightDidOpen() {
    }
    
    func rightWillClose() {
    }
    
    func rightDidClose() {
    }
}
