//
//  MainViewController.swift
//  SchoolCafeteriaMap
//
//  Created by IscIsc on 2016/07/12.
//  Copyright © 2016年 IscIsc. All rights reserved.
//

import UIKit
import UserNotifications
import NotificationCenter
import CoreLocation

///
/// メイン画面
///
class MainViewController : BaseViewController, NSURLConnectionDelegate,UNUserNotificationCenterDelegate,UIApplicationDelegate
{
    /**
     * 定数
     */

    /**
     * 画面遷移Identifier定義
     */
    // タスク追加画面への遷移定義文字列
    static internal let SEGUE_IDENTIFIER_TASK_INPUT = "toTaskInputViewController"
    
    static internal let SEGUE_IDENTIFIER_TASK_EDIT = "toTaskEditViewController"

    
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
     * 下部ボタンメニューバー
     */
    @IBOutlet weak var ButtomButtonMenuBar: UICustomView!
    
    /**
     * タスクメニューバー画面
     */
    open var taskManuBarController : MainMenuBarViewController! = nil
    
    /**
     * キャンセルフラグ
     */
    open var cancelFlag : Bool = false
    
    ///
    /// viewDidLoadイベント処理
    ///
    override func viewDidLoad() {
        // 基底のviewDidLoadを呼び出す
        super.viewDidLoad()
        
        // 初期化
        initializeProc()
    }
    
    ///
    /// viewWillAppearイベント処理
    ///　- parameter:animated:true:アニメーションする false:アニメーションしない
    ///
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    
    ///
    /// didReceiveMemoryWarningイベント処理
    ///
    override func didReceiveMemoryWarning() {
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
            // 再描画処理
            redraw()

            // 戻り値にtrueを設定
            ret = true
        }
        
        return ret
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
            ButtomButtonMenuBar.isHidden = false;
            break;
        // 上記以外の場合
        default:
            self.mainView.gradationBackgroundStartColor = CommonConst.CL_BACKGROUND_GRADIATION_BLUE_1
            self.mainView.gradationBackgroundEndColor = CommonConst.CL_BACKGROUND_GRADIATION_BLUE_2
            ButtomButtonMenuBar.isHidden = true;
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
            // 先頭ボタン表示位置を取得
            let centerButtonLocation : CGRect = self.mArrayViewTaskItem[0].Location
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
            ret = CGPoint(x: centerButtonLocation.origin.x, y: centerButtonLocation.origin.y)

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
            // 未完了、かつ、親が表示されていない、かつ、同一カテゴリーの場合
            if(CommonConst.TASK_COMPLETE_FLAG_INVALID == data.CompleteFlag
                && false == dicParrentId.keys.contains(data.ParrentId)
                && TaskInfoUtility.DefaultInstance.GetCategoryType() == data.CategoryType) {
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
                self.imageCanvasView.addSubview(item.TaskButton!)
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

                    // 完了の場合
                    if(true == isComplete){
                        // キャンバスから削除する
                        item.TaskButton?.removeFromSuperview()
                        item.TaskButton?.allocRelease()
                    
                    // 上記以外の場合
                    } else {
                        // 親の場合
                        if(false == item.IsChild){
                            // 非表示にする
                            item.IsDisplay = false

                        // 上記以外の場合
                        } else {
                            // キャンバスから削除する
                            item.TaskButton?.removeFromSuperview()
                            item.TaskButton?.allocRelease()
                        }
                    }
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
                
                // 現在日付を取得
                let systemDate : String = FunctionUtility.DateToyyyyMMddHHmmss(Date(), separation: true)

                // タスクイメージボタンを生成
                let viewTaskItem : ViewTaskItemEntity = createViewTaskItemEntity(index: parrentItem.Index, systemDate: systemDate, item: data)

                // 配列に追加
                self.mArrayViewTaskItem.append(viewTaskItem)

                // キャンバスビューにコントロールを追加
                self.imageCanvasView.addSubview(viewTaskItem.TaskButton!)
            }
        }
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
        
        print(sender.tag.description)

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
        }
        // タスク編集画面へ遷移する場合
        else if(segue.identifier == MainViewController.SEGUE_IDENTIFIER_TASK_EDIT){
            
            // タスク編集画面のコントローラを取得
            let dvc : TaskEditViewController = (segue.destination as AnyObject as? TaskEditViewController)!
            
            // 長押しボタンのタスクIDを渡す
            dvc.paramTaskId = self.mParamTaskId
            dvc.paramMainViewMode = self.mActionMode
        }
        
    }
    
    ///
    //　画面表示直後時処理 タイミング要再考
    ///　- parameter animated:アニメーションフラグ
    ///
    override func viewDidAppear(_ animated: Bool) {
        // 再描画処理
        redraw()
    }
    
    ///
    //　再描画処理
    ///
    override func redraw() {
        // キャンセルフラグが立っていない場合
        if (false == self.cancelFlag) {
            // 動作モードによるメイン画面の初期化
            initializeMain(self.mActionMode)
        
            // 登録タスク情報の取得
            getTaskInfo()
        
            // タスクを表示する
            displayTask(self.mActionMode)
        
            // タスク通知生成処理
            taskExpirationNotification()
        
            // ナビゲーションバーの再描画
            redrawNavigationBar()

            // タスクメニューバーの再描画
            redrawTaskMenuBar()
        }

        // キャンセルフラグを初期化
        self.cancelFlag = false
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
        self.navigationController?.setNavigationBarHidden(false, animated: true)
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
        // タスクメニューバーの再描画
        redrawTaskMenuBar()
    }

    ///
    /// タスクメニューバーの再描画
    ///
    fileprivate func redrawTaskMenuBar() {
        // タスクメニューバーの再描画
        self.taskManuBarController.redraw()
    }
    
    //**通知関連メソッド:START
    // タスク通知生成処理:要修正　TODO：AppDelegateへ移動、通知、iOS９以下の対応、、
    fileprivate func taskExpirationNotification(){
        
        
        //　現在の通知全削除
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        } else {
            // Fallback on earlier versions
        };
        
        
        if #available(iOS 10.0, *) {
            
            // 通知デリゲート設定
            let center = UNUserNotificationCenter.current()
            center.delegate = self
            
            // 通知種類(バッチ,サウンド,アラート)
            center.requestAuthorization(options: [.badge, .sound, .alert], completionHandler: { (granted, error) in
                if error != nil {
                    return
                }
                
                if granted {
                    debugPrint("通知許可")
                } else {
                    debugPrint("通知拒否")
                }
                
                //通知設定：START

                //　DateComponents変換用カレンダー生成(西暦)
                let calender  =  Calendar(identifier:.gregorian)
                

                // カスタム通知実装:START
                let completeTask = UNNotificationAction(identifier: "completeTask",
                                                        title: "完了", options: [])
                let inCompleteTask = UNNotificationAction(identifier: "inCompleteTask",
                                                          title: "未完了",
                                                          options: [])
                let category = UNNotificationCategory(identifier: "message", actions: [completeTask, inCompleteTask], intentIdentifiers: [], options: [])
                UNUserNotificationCenter.current().setNotificationCategories([category])
                // END
                
                //表示タスク数分処理
                for item in self.getDisplayTaskData() {

                    // UNMutableNotificationContent作成
                    let content = UNMutableNotificationContent()
                    
                    // カスタム通知設定
                    content.categoryIdentifier = "message"
                    
                    //通知タイトル設定
                    content.title = String(item.Title)
                    
                    //メモが空欄である場合
                    if(true == StringUtility.isEmpty(item.Memo)){
                        //通知ボディ = 空白文字挿入
                        content.body = " "
                    }
                    else{
                        //通知ボディ ＝ メモ設定
                        content.body = String(item.Memo)
                    }
                    
                    //アイコンバッジ：数
                    //content.badge = UIApplication.shared.applicationIconBadgeNumber + 1 as NSNumber
                    
                    //通知サウンド:デフォルト
                    content.sound = UNNotificationSound.default()

                    // タスク終了日時をdateComponetsへ変換
                    let dateComponents =   calender.dateComponents([.year,.month,.day,.hour,.minute], from: FunctionUtility.yyyyMMddHHmmssToDate(item.DateTime))
                    
                    // 変換したタスク日時をトリガーに設定(リピート:なし)
                    let trigger = UNCalendarNotificationTrigger.init(dateMatching: dateComponents, repeats: false)
                    
                    //　TEST確認用：要削除
                    print(calender.dateComponents([.year,.month,.day,.hour,.minute], from: FunctionUtility.yyyyMMddHHmmssToDate(item.DateTime)))
                    
                
                    // UNNotificationRequest作成(identifier:タスクID,content: タスク内容,trigger: 設定日時)
                    let request = UNNotificationRequest.init(identifier: String(item.Id), content: content, trigger: trigger)

                
                    // UNUserNotificationCenterに作成したUNNotificationRequestを追加
                    center.add(request)

                    
                    
                    
                    // TEST:START
                    // GPS 通知設定
                    //self.locationManager.requestAlwaysAuthorization()
                    //self.locationManager.delegate = self

                    // バックグラウンド状態時、位置情報取得
                    //self.locationManager.startUpdatingLocation()
                    // 位置情報取得精度(10m)
                    //self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                    // バックグラウンド時、位置情報取得
                    //self.locationManager.allowsBackgroundLocationUpdates = true
                    //self.locationManager.pausesLocationUpdatesAutomatically = false
                    //self.locationManager.distanceFilter = 10
                    
                    //　デバッグ用位置情報print
                    //print(self.locationManager.location?.coordinate.longitude,"+++",self.locationManager.location?.coordinate.latitude)
                    
                    // UNMutableNotificationContent 作成
                    content.title = String((item.Title) + "_GPS")
                    content.body = String(" ")
                    content.sound = UNNotificationSound.default()
                    
                    // 通知座標指定
                    //let coordinate : CLLocationCoordinate2D = CLLocationCoordinate2DMake(35.508692,139.612245)
                    
                    // デバッグ用:通知座標指定読み出し:START
                    if(TaskInfoUtility.DefaultInstance.GetIndexForLocation(0) != -1){
                    // TaskInfoLocationDataEntity
                    let taskLocationDataEntity : TaskInfoLocationDataEntity  = TaskInfoUtility.DefaultInstance.GetInfoLocationDataForId(0)!

                    // 通知座標指定
                    let coordinate : CLLocationCoordinate2D = CLLocationCoordinate2DMake(taskLocationDataEntity.Latitude,taskLocationDataEntity.Longitude)
                    print(taskLocationDataEntity.Title)
                    print(taskLocationDataEntity.Latitude)
                    print(taskLocationDataEntity.Longitude)
                    // デバッグ用:通知座標指定読み出し:END

                    // 通知範囲指定
                    let region = CLCircularRegion(center: coordinate, radius: CommonConst.NOTIFICATION_GEOFENCE_RADIUS_RANGE, identifier: "test")
                    // 通知範囲in
                    region.notifyOnEntry = true
                    // 通知範囲out
                    //region.notifyOnExit = true
                    // 通知トリガー作成(通知範囲,通知リピートなし)
                    let locationTrigger = UNLocationNotificationTrigger(region: region, repeats: false)
                    // 通知リクエスト作成
                    let locationRequest = UNNotificationRequest(identifier: String(item.Id) + "_GPS",content: content,trigger: locationTrigger)
                    // UNUserNotificationCenterに作成したUNNotificationRequestを追加
                    center.add(locationRequest)
                    // TEST:END
                    }
                }
                //通知設定：END
            })
            
        } else {
            // iOS 9
            let settings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
            
            
        }
    }
    
    
    // フォアグラウンド時:通知受信時イベント
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        // 通知：バッジ、サウンド、アラート
        completionHandler([.badge,.sound, .alert])

    }
    
    
    // 通知タップ時イベント
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        //UIApplication.shared.applicationIconBadgeNumber = 0
        
        //通知：なし
        completionHandler()
    }
    //**END
    
}



extension MainViewController : SlideMenuControllerDelegate {
    
    func leftWillOpen() {
        print("SlideMenuControllerDelegate: leftWillOpen")
    }
    
    func leftDidOpen() {
        print("SlideMenuControllerDelegate: leftDidOpen")
    }
    
    func leftWillClose() {
        print("SlideMenuControllerDelegate: leftWillClose")
    }
    
    func leftDidClose() {
        print("SlideMenuControllerDelegate: leftDidClose")
    }
    
    func rightWillOpen() {
        print("SlideMenuControllerDelegate: rightWillOpen")
    }
    
    func rightDidOpen() {
        print("SlideMenuControllerDelegate: rightDidOpen")
    }
    
    func rightWillClose() {
        print("SlideMenuControllerDelegate: rightWillClose")
    }
    
    func rightDidClose() {
        print("SlideMenuControllerDelegate: rightDidClose")
    }
}
