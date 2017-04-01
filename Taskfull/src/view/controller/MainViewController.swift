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
     * タスクイメージボタン配列
     */
    private var mArrayTaskImageButton : [UITaskImageButton] = []
    
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
    
    /// viewDidLoadイベント処理
    override func viewDidLoad() {
        // 基底のviewDidLoadを呼び出す
        super.viewDidLoad()
        
        // 初期化
        initializeProc()
    }
    
    /// didReceiveMemoryWarningイベント処理
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// 初期化処理
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
    
    /// 動作モードによるメイン画面の初期化
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
            self.mainView.gradationBackgroundStartColor = UIColorUtility.rgb(222, g: 255, b: 255)
            self.mainView.gradationBackgroundEndColor = UIColorUtility.rgb(254, g: 255, b: 255)
            ButtomButtonMenuBar.hidden = true;
            break;
        }
    }
    
    private func getTaskInfo() {
        // タスク情報の読込み
        TaskInfoUtility.DefaultInstance.ReadTaskInfo()
        
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
        taskInfoDataEntity.Color = 0
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
        taskInfoDataEntity.Color = 1
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
        taskInfoDataEntity.Color = 0
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
        taskInfoDataEntity.Color = 1
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
        taskInfoDataEntity.Color = 1
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
        //TEST END
        
    }
    
    /// タスクを表示する
    private func displayTask(actionType : CommonConst.ActionType)
    {
        // タスクイメージボタン設定
        setTaskImageButton()

        // キャンバスビューのコントロールを全削除
        removeAllTaskImageButton()

        // キャンバスビューにコントロールを追加
        addAllTaskImageButton()
    }
    
    /// タスク情報からタスクイメージボタン生成処理
    private func setTaskImageButton(){
        // タスクイメージボタン配列クリア
        self.mArrayTaskImageButton.removeAll()
        
        // TODO:後で登録データから生成するようにする！！
        var x: Double = 0
        var y: Double = 0
        var width: Double = 0
        var height: Double = 0

        // TODO:後で調整
        x = 100
        y = 50

        // 現在日付を取得
        let systemDate : String = FunctionUtility.DateToyyyyMMddHHmmss(NSDate(), separation: true)
        
        // 表示対象データ数分処理する
        for item in getDisplayTaskData() {
            // ボタンサイズ取得
            let buttonSize : CGPoint = getButtonSize(systemDate, taskDate: item.DateTime, createDate: item.CreateDateTime)
            
            width = Double(buttonSize.x)
            height = Double(buttonSize.y)
            // TODO:後で調整
            let imageFile : String = "soap001.png"

            // ボタンコントロール生成
            let button : UITaskImageButton = UITaskImageButton(frame: CGRect(x: x,y: y,width: width,height: height))
            
            // ボタン情報設定
            button.btnImage.setImageInfo(UIImage(named: imageFile), width:width , height:height)
            button.btnImage.tag = item.Id
            button.btnImage.addTarget(self, action: #selector(MainViewController.onTouchDown_TaskCirclrImageButton(_:)), forControlEvents: .TouchDown)
                    self.mArrayTaskImageButton.append(button)
            button.labelTitle = item.Title
            button.labelMemo = item.Memo
            button.labelDateTime = item.DateTime

            // TODO:後で調整
            x += 50
            y += 100
        }
    }
    
    private func getButtonSize(systemDate : String, taskDate : String, createDate : String) -> CGPoint {
        var ret : CGPoint = CGPoint(x: 64, y: 64)
        
        // 時間の差取得
        let diffHour : Int = FunctionUtility.DiffHour(taskDate, date2: systemDate)
        
        // 当日の場合
        if(24 >= diffHour) {
            ret = CGPoint(x: 256, y: 256)
            
        // 上記以外の場合
        } else {
            // 作成日からの時間の差取得
            let diffHour2 : Int = FunctionUtility.DiffHour(taskDate, date2: createDate)

            let work : CGFloat = CGFloat(64) + ((CGFloat(256 - 64) / CGFloat(diffHour2)) * CGFloat(diffHour))
            ret = CGPoint(x: work, y: work)
        }
        
        return ret;
    }
    
    /// 表示タスクデータの取得
    private func getDisplayTaskData() -> [TaskInfoDataEntity] {
        return getTopDisplayTaskData()
    }
    
    /// 上位に表示するタスクデータの取得
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
    
    /// キャンバスビューからタスクイメージボタンを全削除処理
    private func removeAllTaskImageButton(){
        // キャンバスビューのコントロール数分処理する
        for view in self.imageCanvasView.subviews {
            // 削除
            view.removeFromSuperview()
        }
    }
    
    /// キャンバスビューへタスクイメージボタンの全追加処理
    private func addAllTaskImageButton(){
        // キャンバスビューにコントロールを追加
        for view in self.mArrayTaskImageButton {
            self.imageCanvasView.addSubview(view)
        }
    }
    
    
    /// モード切り替えボタン押下イベント
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
    
    /// タスクイメージボタン押下イベント
    @IBAction func onTouchDown_TaskCirclrImageButton(sendar : UITaskImageButton){
        // TODO:押下時の処理を記述する
        print(sendar.tag.description)
    }

    /// タスク追加ボタン押下イベント
    @IBAction func onTouchDown_AddTask(sender: AnyObject) {
        // TODO:押下時の処理を記述する
        // タスク入力画面を表示
        self.performSegueWithIdentifier("toTaskInputViewController", sender: self)
    }

    /// 画面遷移前イベント
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // タスク入力画面へ遷移する場合
        if(segue.identifier == "toTaskInputViewController"){
            // タスク入力画面のコントローラを取得
            let dvc : TaskInputViewController = (segue.destinationViewController as AnyObject as? TaskInputViewController)!

            // TODO:画面表示時に必要なパラメータを設定する記述をする
            //dvc.
            
            
        }
    }
}