//
//  MainViewController.swift
//  SchoolCafeteriaMap
//
//  Created by IscIsc on 2016/07/12.
//  Copyright © 2016年 IscIsc. All rights reserved.
//

import UIKit

///
/// メイン画面
///
class MainViewController : BaseViewController, NSURLConnectionDelegate
{
    /**
     * 定数
     */

    /**
     * 画面遷移Identifier定義
     */
    // タスク追加画面への遷移定義文字列
    static internal let SEGUE_IDENTIFIER_TASK_INPUT = "toTaskInputViewController"
    
    
    /**
     * 変数
     */
    // 追加ボタンイメージ
    private let mImageAddButton : UIImage = UIImage(named: "add.png")!
    private let mImageAddButtonDown : UIImage = UIImage(named: "add_down.png")!
    // モード変更ボタンイメージ
    private let mImageModeChangeButton : UIImage = UIImage(named: "modechg.png")!
    private let mImageModeChangeButtonDown : UIImage = UIImage(named: "modechg_down.png")!

    /**
     * 動作モード
     */
    private var mActionMode : CommonConst.ActionType = CommonConst.ActionType.Reference
    
    /**
     * タスク表示項目配列
     */
    private var mArrayViewTaskItem : [ViewTaskItemEntity] = []
    
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
    /// didReceiveMemoryWarningイベント処理
    ///
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            // 動作モードによるメイン画面の初期化
            initializeMain(self.mActionMode)
    
            // 登録タスク情報の取得
            getTaskInfo()
                
            // タスクを表示する
            displayTask(self.mActionMode)
 
            // 戻り値にtrueを設定
            ret = true
        }
        
        return ret
    }
    
    ///
    /// 動作モードによるメイン画面の初期化
    ///　- parameter actionType:動作モード
    ///
    private func initializeMain(actionType : CommonConst.ActionType)
    {
        switch(self.mActionMode){
        // 現在編集モードの場合
        case CommonConst.ActionType.Edit:
            self.mainView.gradationBackgroundStartColor = UIColorUtility.rgb(255, g: 128, b: 0)
            self.mainView.gradationBackgroundEndColor = UIColorUtility.rgb(255, g: 218, b: 128)
            ButtomButtonMenuBar.hidden = false;
            break;
        // 上記以外の場合
        default:
            self.mainView.gradationBackgroundStartColor = UIColorUtility.rgb(0, g: 30, b: 183)
            self.mainView.gradationBackgroundEndColor = UIColorUtility.rgb(222, g: 255, b: 255)
            ButtomButtonMenuBar.hidden = true;
            break;
        }
    }
    
    ///
    ///　タスク情報読込み
    ///
    private func getTaskInfo() {
        // タスク情報の読込み
        TaskInfoUtility.DefaultInstance.ReadTaskInfo()
        
        /*
        //TEST START
        // タスク情報のクリア
        TaskInfoUtility.DefaultInstance.ClearTaskInfo()
        
        
        // TODO:後で登録できるようになったら消す！！
        // タスク情報の取得
        var taskInfo : [TaskInfoDataEntity] = TaskInfoUtility.DefaultInstance.getTaskInfoData()
        taskInfo.removeAll()

        // タスク情報追加
        var taskInfoDataEntity : TaskInfoDataEntity
        taskInfoDataEntity = TaskInfoDataEntity()
        taskInfoDataEntity.Id = TaskInfoUtility.DefaultInstance.NextId()
        taskInfoDataEntity.Title = "1234567890"
        taskInfoDataEntity.Memo = "memo"
        taskInfoDataEntity.DateTime = "2017/04/02 12:13:14"
        taskInfoDataEntity.NotifiedLocation = 0
        taskInfoDataEntity.Importance = 0
        taskInfoDataEntity.ButtonColor = 0
        taskInfoDataEntity.TextColor = 0
        taskInfoDataEntity.ParrentId = -1
        taskInfoDataEntity.CompleteFlag = CommonConst.TASK_COMPLETE_FLAG_INVALID
        taskInfoDataEntity.CreateDateTime = "2017/03/02 12:13:14"
        taskInfoDataEntity.UpdateDateTime = "2017/03/02 12:13:14"
        
        taskInfo.append(taskInfoDataEntity)
        
        taskInfoDataEntity = TaskInfoDataEntity()
        taskInfoDataEntity.Id = TaskInfoUtility.DefaultInstance.NextId()
        taskInfoDataEntity.Title = "2345678901"
        taskInfoDataEntity.Memo = "memo2"
        taskInfoDataEntity.DateTime = "2017/04/12 10:11:12"
        taskInfoDataEntity.NotifiedLocation = 0
        taskInfoDataEntity.Importance = 0
        taskInfoDataEntity.ButtonColor = 1
        taskInfoDataEntity.TextColor = 0
        taskInfoDataEntity.ParrentId = -1
        taskInfoDataEntity.CompleteFlag = CommonConst.TASK_COMPLETE_FLAG_INVALID
        taskInfoDataEntity.CreateDateTime = "2017/03/05 12:13:14"
        taskInfoDataEntity.UpdateDateTime = "2017/03/06 12:13:14"
        
        taskInfo.append(taskInfoDataEntity)
        
        taskInfoDataEntity = TaskInfoDataEntity()
        taskInfoDataEntity.Id = TaskInfoUtility.DefaultInstance.NextId()
        taskInfoDataEntity.Title = "あいおえお"
        taskInfoDataEntity.Memo = "memo3"
        taskInfoDataEntity.DateTime = "2017/04/12 09:30:00"
        taskInfoDataEntity.NotifiedLocation = 0
        taskInfoDataEntity.Importance = 0
        taskInfoDataEntity.ButtonColor = 0
        taskInfoDataEntity.TextColor = 0
        taskInfoDataEntity.ParrentId = -1
        taskInfoDataEntity.CompleteFlag = CommonConst.TASK_COMPLETE_FLAG_INVALID
        taskInfoDataEntity.CreateDateTime = "2017/03/11 12:13:14"
        taskInfoDataEntity.UpdateDateTime = "2017/03/11 12:13:14"
        
        taskInfo.append(taskInfoDataEntity)
        
        taskInfoDataEntity = TaskInfoDataEntity()
        taskInfoDataEntity.Id = TaskInfoUtility.DefaultInstance.NextId()
        taskInfoDataEntity.Title = "あいおえおあいおえおあいおえおあいおえお"
        taskInfoDataEntity.Memo = "memo4"
        taskInfoDataEntity.DateTime = "2017/04/05 18:30:40"
        taskInfoDataEntity.NotifiedLocation = 0
        taskInfoDataEntity.Importance = 0
        taskInfoDataEntity.ButtonColor = 1
        taskInfoDataEntity.TextColor = 0
        taskInfoDataEntity.ParrentId = -1
        taskInfoDataEntity.CompleteFlag = CommonConst.TASK_COMPLETE_FLAG_INVALID
        taskInfoDataEntity.CreateDateTime = "2017/03/12 12:13:14"
        taskInfoDataEntity.UpdateDateTime = "2017/03/12 12:13:14"
        
        taskInfo.append(taskInfoDataEntity)
        
        taskInfoDataEntity = TaskInfoDataEntity()
        taskInfoDataEntity.Id = TaskInfoUtility.DefaultInstance.NextId()
        taskInfoDataEntity.Title = "完了タスク"
        taskInfoDataEntity.Memo = "memo5"
        taskInfoDataEntity.DateTime = "2017/02/11 18:30:40"
        taskInfoDataEntity.NotifiedLocation = 0
        taskInfoDataEntity.Importance = 0
        taskInfoDataEntity.ButtonColor = 1
        taskInfoDataEntity.TextColor = 0
        taskInfoDataEntity.ParrentId = -1
        taskInfoDataEntity.CompleteFlag = CommonConst.TASK_COMPLETE_FLAG_VALID
        taskInfoDataEntity.CreateDateTime = "2017/01/12 12:13:14"
        taskInfoDataEntity.UpdateDateTime = "2017/01/12 12:13:14"
        
        taskInfo.append(taskInfoDataEntity)
        
        
        // タスク情報のデータを入れ替える
        TaskInfoUtility.DefaultInstance.setTaskInfoData(taskInfo)
        
        // タスク情報の書込み
        TaskInfoUtility.DefaultInstance.WriteTaskInfo()

        // タスク情報の読込み
        TaskInfoUtility.DefaultInstance.ReadTaskInfo()
        //TEST END*/
        
    }
    
    ///
    /// タスクを表示する
    ///　- parameter actionType:動作モード
    ///
    private func displayTask(actionType : CommonConst.ActionType)
    {
        // タスクイメージボタン設定
        setTaskImageButton()

        // キャンバスビューのコントロールを全削除
        removeAllTaskImageButton()

        // キャンバスビューにコントロールを追加
        addAllTaskImageButton()
    }
    
    ///
    /// タスク情報からタスクイメージボタン生成処理
    ///
    private func setTaskImageButton(){
        // タスクイメージボタン配列クリア
        self.mArrayViewTaskItem.removeAll()
        
        // 現在日付を取得
        let systemDate : String = FunctionUtility.DateToyyyyMMddHHmmss(NSDate(), separation: true)
        
        var index : Int = 0
        // 表示対象データ数分処理する
        for item in getDisplayTaskData() {
            // 表示項目情報生成
            let taskViewItem : ViewTaskItemEntity = ViewTaskItemEntity()
            
            // ID設定
            taskViewItem.Id = item.Id
            
            // ボタン色設定
            taskViewItem.Color = getButtonColor(item.ButtonColor, systemDate : systemDate, taskDate : item.DateTime)
            
            // ボタンサイズ取得
            let size : CGSize = getButtonSize(systemDate, taskDate: item.DateTime, createDate: item.CreateDateTime)
            // ボタン位置取得
            let position : CGPoint = getButtonPosition(index, buttonSize: size)
            
            // ボタン位置・サイズ設定
            taskViewItem.Location = CGRect(origin: CGPoint(x: position.x, y: position.y), size: size)
            
            // ボタン生成
            taskViewItem.TaskButton = UITaskImageButton(frame: taskViewItem.Location)
            
            // ボタン情報設定
            taskViewItem.TaskButton!.btnImage.setImageInfo(getButtonResource(taskViewItem.Color) , width:Double(size.width) , height:Double(size.height))
            taskViewItem.TaskButton!.btnImage.tag = item.Id
            taskViewItem.TaskButton!.btnImage.addTarget(self, action: #selector(MainViewController.onTouchDown_TaskCirclrImageButton(_:)), forControlEvents: .TouchDown)
            taskViewItem.TaskButton!.labelTitle = item.Title
            taskViewItem.TaskButton!.labelMemo = item.Memo
            taskViewItem.TaskButton!.labelDateTime =  FunctionUtility.DateToyyyyMMddHHmm_JP(FunctionUtility.yyyyMMddHHmmssToDate(item.DateTime))
            taskViewItem.TaskButton!.labelTextColor = item.TextColor

            // 配列に追加
            self.mArrayViewTaskItem.append(taskViewItem)

            // インデックス更新
            index += 1
        }
    }
    
    ///
    ///　ボタンサイズ取得
    ///　- parameter systemDate:システム日付
    ///　- parameter taskDate:タスク完了日時
    ///　- parameter createDate:作成日時
    ///　- returns:ボタンサイズ
    ///
    private func getButtonSize(systemDate : String, taskDate : String, createDate : String) -> CGSize {
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
    private func getButtonPosition(index : Int, buttonSize : CGSize) -> CGPoint {
        var ret : CGPoint = CGPoint(x: 0, y: 0)

        // imageCanvasViewのサイズを領域とする
        let areaSize : CGSize = self.imageCanvasView.frame.size
        
        // 領域の中央座標を取得
        let centerPos : CGPoint = CGPoint(x: areaSize.width / 2, y: areaSize.height / 2)
        
        // データがある場合
        if(0 < mArrayViewTaskItem.count) {
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
    private func getNextButtonLocation(index : Int, centerButtonLocation : CGRect, buttonSize : CGSize) -> CGPoint {
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
    private func getButtonColor(color : Int, systemDate : String, taskDate : String) -> Int {
        
        // 当日の場合は緊急色（赤）、それ以外はそのままの色
        return (true == FunctionUtility.isToday(systemDate, date2: taskDate)) ? CommonConst.TASK_BUTTON_COLOR_RED : color
    }
    
    ///
    /// 表示ボタンリソース取得
    ///　- returns:表示ボタンリソース
    ///
    private func getButtonResource(color : Int) -> UIImage {
        
        // 指定されたインデックスのリソースを返す
        return UIImage(named: CommonConst.TASK_BUTTON_COLOR_RESOURCE[color])!
    }
			    
    ///
    /// 表示タスクデータの取得
    ///　- returns:表示タスクデータ配列
    ///
    private func getDisplayTaskData() -> [TaskInfoDataEntity] {
        return getTopDisplayTaskData()
    }
    
    ///
    /// 上位に表示するタスクデータの取得
    ///　- returns:表示タスクデータ配列
    ///
    private func getTopDisplayTaskData() -> [TaskInfoDataEntity] {
        var taskData : [TaskInfoDataEntity] = [TaskInfoDataEntity]()
        var dicParrentId : Dictionary<Int, Int> = Dictionary<Int, Int>()
        
        // データ数分表示する
        for data in TaskInfoUtility.DefaultInstance.getTaskInfoData() {
            // 未完了、かつ、親が表示されていない場合
            if(CommonConst.TASK_COMPLETE_FLAG_INVALID == data.CompleteFlag
                && false == dicParrentId.keys.contains(data.ParrentId)) {
                // 表示対象に追加する
                taskData.append(data)
                // 表示しているIDを設定
                dicParrentId[data.Id] = data.Id
            }
        }
        
        // 完了日の昇順でソートする
        taskData.sortInPlace(<)
        
        // 結果を返す
        return taskData
    }
    
    ///
    /// キャンバスビューからタスクイメージボタンを全削除処理
    ///　- returns:表示タスクデータ配列
    ///
    private func removeAllTaskImageButton(){
        // キャンバスビューのコントロール数分処理する
        for view in self.imageCanvasView.subviews {
            // 削除
            view.removeFromSuperview()
        }
    }
    
    ///
    /// キャンバスビューへタスクイメージボタンの全追加処理
    ///
    private func addAllTaskImageButton(){
        // キャンバスビューにコントロールを追加
        for view in self.mArrayViewTaskItem {
            self.imageCanvasView.addSubview(view.TaskButton!)
        }
    }
    
    
    ///
    /// モード切り替えボタン押下イベント
    ///　- parameter sender:イベントが発生したオブジェクト
    ///
    @IBAction func onTouchDown_ModeButton(sender: AnyObject) {
        
        switch(self.mActionMode){
            // 現在編集モードの場合
            case CommonConst.ActionType.Edit:
                // 参照モードに切り替える
                self.mActionMode = CommonConst.ActionType.Reference
                break;
            // 上記以外の場合
            default:
                // 編集モードに切り替える
                self.mActionMode = CommonConst.ActionType.Edit
                break;
        }
        
        // 動作モードによるメイン画面の初期化
        initializeMain(self.mActionMode)
    }
    
    ///
    /// タスクイメージボタン押下イベント
    ///　- parameter sender:イベントが発生したオブジェクト
    ///
    @IBAction func onTouchDown_TaskCirclrImageButton(sendar : UITaskImageButton){
        // TODO:押下時の処理を記述する
        print(sendar.tag.description)
    }

    ///
    /// タスク追加ボタン押下イベント
    ///　- parameter sender:イベントが発生したオブジェクト
    ///
    @IBAction func onTouchDown_AddTask(sender: AnyObject) {
        // TODO:押下時の処理を記述する
        // タスク入力画面を表示
        self.performSegueWithIdentifier(MainViewController.SEGUE_IDENTIFIER_TASK_INPUT, sender: self)
    }

    ///
    /// 画面遷移前イベント
    ///　- parameter segue:イベントのUIStoryboardSegue
    ///　- parameter sender:イベントが発生したオブジェクト
    ///
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // タスク入力画面へ遷移する場合
        if(segue.identifier == MainViewController.SEGUE_IDENTIFIER_TASK_INPUT){
            // タスク入力画面のコントローラを取得
            let dvc : TaskInputViewController = (segue.destinationViewController as AnyObject as? TaskInputViewController)!

            // TODO:画面表示時に必要なパラメータを設定する記述をする
            //dvc.
            
            
        }
    }
    
    //　画面表示直後時処理 タイミング要再考
    override func viewDidAppear(animated: Bool) {
        
        // 動作モードによるメイン画面の初期化
        initializeMain(self.mActionMode)
        
        // 登録タスク情報の取得
        getTaskInfo()
        
        // タスクを表示する
        displayTask(self.mActionMode)
    }
    
    
    
    
}