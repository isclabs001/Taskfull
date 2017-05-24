//
//  TaskInputViewControler.swift
//  Taskfull
//
//  Created by IscIsc on 2017/03/11.
//  Copyright © 2017年 isc. All rights reserved.
//


import UIKit
import AudioToolbox

///
/// タスク登録画面
///
class TaskInputViewController : BaseTaskInputViewController
{
    /**
     * 定数
     */
    
    /**
     * 変数
     */
    /**
     * 各登録内容入力欄
     */
    @IBOutlet weak var InputTaskNameField: UITextField!
    @IBOutlet weak var InputPointListField: UITextField!
    @IBOutlet weak var InputTaskMemoView: UIPlaceHolderTextView!
    @IBOutlet weak var InputTaskDateField: UITextField!
    @IBOutlet weak var AddAfterTask: UIButton!
    @IBOutlet weak var InputImportanceSegment: UISegmentedControl!
    @IBOutlet weak var InputTaskColorBtn_1: UICustomButton!
    @IBOutlet weak var InputTaskColorBtn_2: UICustomButton!
    @IBOutlet weak var InputTaskColorBtn_3: UICustomButton!
    @IBOutlet weak var MainView: UICustomView!
    @IBOutlet weak var PointListClearView: UIView!
    
    /// viewDidLoadイベント処理
    override func viewDidLoad() {
        
        // 基底のviewDidLoadを呼び出す
        super.viewDidLoad()
        
        // 初期化
        let _ = initializeProc()
    }
    
    
    /// 初期化処理
    override func initializeProc() ->Bool
    {
        // 基底のinitializeProcを呼び出す
        var ret : Bool = super.initializeProc()
        
        //　正常な場合
        if(true == ret)
        {
            // 初期化処理
            ret = initializeMainProc(mainView: self.MainView)
            
            // タスク通知時刻欄空欄確認処理
            confirmEmptyDateTextField()
            
        }
        
        return ret
    }
    
    /// 通知地点リスト未登録アラート用View処理
    func diplayPointListClearView(){
        
        // タスク通知地点が登録されていない場合
        if(TaskInfoUtility.DefaultInstance.GetInfoLocationCount() == 0){
            
            // 通知地点リスト未登録アラート用View表示
            PointListClearView.isHidden = false
            
        }
        // タスク通知地点が登録されている場合
        else{
            
            // 通知地点リスト未登録アラート用View非表示
            PointListClearView.isHidden = true
            
        }
        
        
    }
    
    /// 通知地点リスト未登録アラート用イベント
    func PointListErrorConfirmCount(){
        
        // タスク通知地点が登録されていない場合
        if(TaskInfoUtility.DefaultInstance.GetInfoLocationCount() == 0){
            
            // 通知地点リスト未登録アラート表示
            MessageUtility.dispAlertOK(
                viewController: self,
                title: "",
                message: MessageUtility.getMessage(key: "MessageStringErrorNotificationPointListCount0_TASK", param: MessageUtility.getMessage(key: "MainMenuTypeGPSNotification")))
            
        }
    }
    
    
    /// タスク通知時刻欄空欄確認処理
    func confirmEmptyDateTextField(){
        
        // タスク通知時刻欄空欄である場合
        if(StringUtility.isEmpty(InputTaskDateField.text) == false){
            
            // タスク通知時刻欄背景色変更
            InputTaskDateField.backgroundColor = UIColorUtility.rgb(243, g: 237, b: 255)
            
        }
        
    }
    
    
    /// textView:値変更確定時イベント
    ///
    /// - Parameter textView: メモ入力欄
    override func textViewDidChange(_ textView: UITextView) {
        
        //　文字列変換完了後(== nil)かつ制限文字数を超えていた場合
        if textView.markedTextRange == nil && textView.text.characters.count > CommonConst.INPUT_TASK_MEMO_STRING_LIMIT {
            
            //　制限文字数より後ろの文字列を削除
            textView.text = textView.text.substring(to: textView.text.index(textView.text.startIndex, offsetBy: CommonConst.INPUT_TASK_MEMO_STRING_LIMIT))
            
            
            // 文字数制限アラート表示(メモ)
            MessageUtility.dispAlertOK(
                viewController: self,
                title: "",
                message: MessageUtility.getMessage(key: "MessageStringErrorTaskCountLimit", param: (String(CommonConst.INPUT_TASK_MEMO_STRING_LIMIT))))
        }
    }
    

    /// textField:編集完了時イベント
    ///
    /// - Parameter nsNotification: textField編集完了時、通知イベント
    override func textFieldDidChange(_ nsNotification: Notification) {
        
        //　UITextFieldへ変換
        let inputTextField = nsNotification.object as! UITextField
        
        // 変数に代入
        if let copyText = inputTextField.text {
            
            //　文字列変換完了後(== nil)かつ制限文字数を超えていた場合
            if inputTextField.markedTextRange == nil && copyText.characters.count > CommonConst.INPUT_TASK_NAME_STRING_LIMIT {
                
                //　制限文字数より後ろの文字列を削除
                inputTextField.text = copyText.substring(to: copyText.characters.index(copyText.startIndex, offsetBy: CommonConst.INPUT_TASK_NAME_STRING_LIMIT))
                
                // 文字数制限アラート表示(項目名)
                MessageUtility.dispAlertOK(
                    viewController: self,
                    title: "",
                    message: MessageUtility.getMessage(key: "MessageStringErrorTaskCountLimit", param: (String(CommonConst.INPUT_TASK_NAME_STRING_LIMIT))))
            }
        }
    }
    
    
    /// 登録内容入力欄設定
    override func displayInputField(){
        
        // 項目名入力欄,メモ入力欄:初期設定
        displayInputTaskName(taskNameField: self.InputTaskNameField)
        displayInputTaskMemo(taskMemoView: self.InputTaskMemoView)
        // 通知時刻欄:入力状態有効
        InputTaskNameField.becomeFirstResponder()
        
        //タスク終了時刻欄:初期設定
        diplayInputTaskDate(taskDateField: self.InputTaskDateField)
        
        //通知地点:初期設定
        displayInputPoint(pointListField: self.InputPointListField)
        
        //重要度:初期設定
        displayInputImportanceSegment(importanceSegment: self.InputImportanceSegment)
        
        //タスクカラーボタン:初期設定
        dispayInputTaskColorBtn(btn1 : self.InputTaskColorBtn_1, btn2 : self.InputTaskColorBtn_2, btn3 : self.InputTaskColorBtn_3, inputImportanceSegment: self.InputImportanceSegment)
        
        //後続タスクボタン:初期設定
        displayAddAfterTaskBtn(addAfterTask: self.AddAfterTask)
        
        // 通知地点リスト未登録アラート用View処理
        diplayPointListClearView()
        
        // 通知地点リスト未登録アラート用イベント追加
        PointListClearView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(TaskInputViewController.PointListErrorConfirmCount)))
    }
    
    /// タスクカラーボタン_1:タップ時イベント
    ///
    /// - Parameter sender: タスクカラーボタン_1
    override func onTouchDown_btn1(_ sender:UIButton){
        changeInputTaskColorBtn(selectedBtnIndex: 0, btn1 : InputTaskColorBtn_1, btn2 : InputTaskColorBtn_2, btn3 : InputTaskColorBtn_3)
    }
    
    /// タスクカラーボタン_2:タップ時イベント
    ///
    /// - Parameter sender: タスクカラーボタン_2
    override func onTouchDown_btn2(_ sender:UIButton){
        changeInputTaskColorBtn(selectedBtnIndex : 1, btn1 : self.InputTaskColorBtn_1, btn2 : self.InputTaskColorBtn_2, btn3 : self.InputTaskColorBtn_3)
    }
    
    /// タスクカラーボタン_3:タップ時イベント
    ///
    /// - Parameter sender: タスクカラーボタン_3
    override func onTouchDown_btn3(_ sender:UIButton){
        changeInputTaskColorBtn(selectedBtnIndex : 2, btn1 : self.InputTaskColorBtn_1, btn2 : self.InputTaskColorBtn_2, btn3 : self.InputTaskColorBtn_3)
    }
    
    
    
    /// 重要度:セグメント値変更時イベント
    ///
    /// - Parameter segcon: セグメントインデックス
    override func onTouchDown_InputImportanceSegment(_ segcon:UISegmentedControl){
        
        // 重要度:セグメント値変更時処理
        didChengeImportanceSegmentValue(segcon.selectedSegmentIndex, btn1 : self.InputTaskColorBtn_1, btn2 : self.InputTaskColorBtn_2, btn3 : self.InputTaskColorBtn_3)
        
    }
    

    /// ツールバー：クリアボタンタップ時イベント
    override func onTouch_ToolBarClearBtn(){
        
        //　ツールバー：クリアボタン処理
        clearToolBarButton(taskDateField: InputTaskDateField)
    }
    
    
    /// DatePicker：値変更時イベント
    ///
    /// - Parameter sender: 通知時刻設定欄DatePicker
    override func inputDatePickerEdit(_ sender: UIDatePicker){

        // DatePicker：値変更処理
        updateInputDatePicker(sender, taskDateField: InputTaskDateField)
        
        // // タスク通知時刻欄背景色変更:通常色へ変更
        InputTaskDateField.backgroundColor = UIColorUtility.rgb(245, g: 255, b: 228)
        
    }
    
    
    /// 後続タスクボタン：タップ時イベント
    ///
    /// - Parameter sender: 後続タスクボタン
    override func onTouchDown_addAfterTaskButton(_ sender : UIButton){
        
        // 通知時刻欄が空欄ではない場合
        if(StringUtility.isEmpty(InputTaskDateField.text) == true){
            
            // タスク登録イベント
            inputRegistrationTask()
            
            // タスク登録画面コントローラー生成
            let vc = storyboard?.instantiateViewController(withIdentifier: "InputStoryBoard") as! TaskInputViewController
            
            // 親タスクID
            vc.paramTaskId = self.paramTaskId
            // タスク:カテゴリータイプ
            vc.paramCategoryType = paramCategoryType
            // タスク:更新フラグ（更新済）
            self.paramUpdateFlag = true
            vc.paramUpdateFlag = true
            
            // ナビゲーションバー:レイヤー追加
            self.navigationController?.view.layer.add(navigationTrasitionAnimate(0.7, "pageCurl", kCATransitionFromRight), forKey: kCATransition)
            
            // 後続タスク追加ボタン:登録画面遷移
            navigationController?.pushViewController(vc, animated: true)
            
        }
        // 通知時刻欄が空欄である場合
        else{
            
            // タスク削除確認メッセージ表示
            MessageUtility.dispAlertOKAction(
                viewController: self,
                title: "",
                message: MessageUtility.getMessage(key: "MessageStringErrorTaskDateInput"),
                funcOkButton: inputConfirmOKAction)
        }
        
    }
    
    
    
    /// 登録確定ボタン：タップ時イベント
    override func onTouchDown_decideEditTaskButton(){
        
        // キーボードを閉じる
        view.endEditing(true)
        
        // 通知時刻欄が空欄ではない場合
        if(StringUtility.isEmpty(InputTaskDateField.text) == true){
            
            // タスク登録イベント
            inputRegistrationTask()
            
            // ナビゲーションバー:レイヤー追加
            self.navigationController?.view.layer.add(navigationTrasitionAnimate(1.2, "rippleEffect", "false"), forKey: kCATransition)
            
            // ナビゲーションバー:最初の画面に戻る
            self.navigationController?.popToRootViewController(animated: true)
        }
        // 通知時刻欄が空欄である場合
        else{
            
            // タスク削除確認メッセージ表示
            MessageUtility.dispAlertOKAction(
                viewController: self,
                title: "",
                message: MessageUtility.getMessage(key: "MessageStringErrorTaskDateInput"),
                funcOkButton: inputConfirmOKAction)
        }
        
    }
    

    /// 通知時刻欄空欄時、OKアクション
    ///
    /// - Parameter action: 通知時刻欄空欄時、OKアクション
    fileprivate func inputConfirmOKAction(action: UIAlertAction){
        
        // OKボタン押下
        self.isOkBtn = true
        
        // 通知時刻欄:入力状態
        InputTaskDateField.becomeFirstResponder()
        
    }
    
    

    /// タスク登録イベント
    func inputRegistrationTask(){
        
        /*
         **タスク登録イベント実装
         */
        
        // OKボタン押下
        self.isOkBtn = true
        
        // 新規のタスク登録画面である場合
        if(self.paramBackStatus  != true){
        
            
            // タスク情報追加
            var taskInfoDataEntity : TaskInfoDataEntity
            
            // タスクEntity
            taskInfoDataEntity = TaskInfoDataEntity()
            
            //新規ID
            taskInfoDataEntity.Id = TaskInfoUtility.DefaultInstance.NextId()
            
            //項目名登録
            //項目名未入力時チェック
            if(false == StringUtility.isEmpty(InputTaskNameField.text)){
                
                // 空白の場合、代入文字
                taskInfoDataEntity.Title = MessageUtility.getMessage(key: "LabelItemNameEmpty")
            }
            else{
                
                // 空白ではない場合、入力値
                taskInfoDataEntity.Title = InputTaskNameField.text! as String
            }
            
            //メモ
            taskInfoDataEntity.Memo = InputTaskMemoView.text! as String
            
            //タスク終了時刻
            taskInfoDataEntity.DateTime = FunctionUtility.DateToyyyyMMddHHmmss(inputTaskEndDate, separation: true)
            
            //通知地点
            //通知地点未入力時チェック
            if(false == StringUtility.isEmpty(InputPointListField.text)){
                
                // 空白の場合、固定値代入
                taskInfoDataEntity.NotifiedLocation = CommonConst.INPUT_NOTIFICATION_POINT_LIST_INITIAL_VALUE
                
            }
            else{
                
                // 空白ではない場合、入力値
                taskInfoDataEntity.NotifiedLocation = TaskInfoUtility.DefaultInstance.GetInfoLocationIndexForTitle(InputPointListField.text! as String)
            }
            
            
            
            //重要度(セグメントのインデックス)
            taskInfoDataEntity.Importance = InputImportanceSegment.selectedSegmentIndex as Int
            
            //タスクカラー
            //選択されているボタンのタイトル(タスクボタン色定数)をIntに変換後返す
            if (InputTaskColorBtn_1.isSelected == true){
                taskInfoDataEntity.ButtonColor = Int(InputTaskColorBtn_1.currentTitle!)!
            }
            else if(InputTaskColorBtn_2.isSelected == true){
                taskInfoDataEntity.ButtonColor = Int(InputTaskColorBtn_2.currentTitle!)!
            }
            else if(InputTaskColorBtn_3.isSelected == true){
                taskInfoDataEntity.ButtonColor = Int(InputTaskColorBtn_3.currentTitle!)!
            }
            
            //テキストカラー
            taskInfoDataEntity.TextColor = 0
            
            //親ID（-1 = 親（先頭）、それ以外＝親のID）
            // 登録開始タスクである場合
            if(self.paramTaskId == -2 ){
                
                //　作成タスク親IDを先頭タスク親ID定数に設定
                taskInfoDataEntity.ParrentId = -1
                
                // 読込タスクIDを作成タスクIDに設定
                self.paramTaskId = taskInfoDataEntity.Id
                
            }
            // 後続タスクである場合
            else{
                
                // 作成タスク親IDを読込IDに設定
                taskInfoDataEntity.ParrentId = self.paramTaskId
                
                // 読込タスクIDを作成タスクIDに設定
                self.paramTaskId = taskInfoDataEntity.Id
            }
            
            
            // カテゴリータイプ
            taskInfoDataEntity.CategoryType = paramCategoryType
            
            //完了フラグ
            taskInfoDataEntity.CompleteFlag = CommonConst.TASK_COMPLETE_FLAG_INVALID
            
            //作成日時
            taskInfoDataEntity.CreateDateTime = FunctionUtility.DateToyyyyMMddHHmmss(Date(), separation: true)
            
            //更新日時
            taskInfoDataEntity.UpdateDateTime = FunctionUtility.DateToyyyyMMddHHmmss(Date(), separation: true)
            
            // タスク情報のデータを追加する
            TaskInfoUtility.DefaultInstance.AddTaskInfo(taskInfoDataEntity)
            
            // タスク情報の書込み
            TaskInfoUtility.DefaultInstance.WriteTaskInfo()
            
            // 通知設定処理
            NotificationUtility.DefaultInstance.taskExpirationNotification()
            
            // ステータスを表示済みへ更新
            self.paramBackStatus  = true
            
            // DEBUG:登録タスク情報読み出し
            #if DEBUG
                print("------登録タスク情報------")
                print("タスクID:" + String(taskInfoDataEntity.Id))
                print("項目名:" + taskInfoDataEntity.Title)
                print("メモ:" + taskInfoDataEntity.Memo)
                print("通知時刻:" + taskInfoDataEntity.DateTime)
                print("通知地点(ID):" + String(taskInfoDataEntity.NotifiedLocation))
                print("重要度:" + String(taskInfoDataEntity.Importance))
                print("タスクカラー(ID):" + String(taskInfoDataEntity.ButtonColor))
                print("親ID:" + String(taskInfoDataEntity.ParrentId))
                print("カテゴリータイプ:" + String(taskInfoDataEntity.CategoryType))
                print("完了フラグ:" + String(taskInfoDataEntity.CompleteFlag))
                print("作成日時:" + taskInfoDataEntity.CreateDateTime)
                print("更新日時:" + taskInfoDataEntity.UpdateDateTime)
                print("-----------------------")
            #endif
            
            
        }
        // 表示済みである場合※BACK対策
        else{
            
            // EDIT:START
            // タスクEntity
            let taskInfoDataEntity : TaskInfoDataEntity = TaskInfoDataEntity()
            
            // タスクID設定
            // 読込タスクIDを設定
            taskInfoDataEntity.Id = self.paramTaskId
            
            //項目名登録
            //項目名未入力時チェック
            if(false == StringUtility.isEmpty(InputTaskNameField.text)){
                // 空白の場合、代入文字
                taskInfoDataEntity.Title = MessageUtility.getMessage(key: "LabelItemNameEmpty")
            }
            else{
                // 空白ではない場合、入力値
                taskInfoDataEntity.Title = InputTaskNameField.text! as String
            }
            
            //メモ
            taskInfoDataEntity.Memo = InputTaskMemoView.text! as String
            
            //タスク終了時刻
            taskInfoDataEntity.DateTime = FunctionUtility.DateToyyyyMMddHHmmss(inputTaskEndDate, separation: true)
            
            //通知地点
            //通知地点未入力時チェック
            if(false == StringUtility.isEmpty(InputPointListField.text)){
                
                // 入力欄空白の場合、固定値代入
                taskInfoDataEntity.NotifiedLocation = CommonConst.INPUT_NOTIFICATION_POINT_LIST_INITIAL_VALUE
                
            }
            else{
                
                // 空白ではない場合、入力値から値取得
                taskInfoDataEntity.NotifiedLocation = TaskInfoUtility.DefaultInstance.GetInfoLocationIndexForTitle(InputPointListField.text! as String)
                
            }
            
            //重要度(セグメントのインデックス)
            taskInfoDataEntity.Importance = InputImportanceSegment.selectedSegmentIndex as Int
            
            //タスクカラー
            //選択されているボタンのタイトル(タスクボタン色定数)をIntに変換後返す
            if (InputTaskColorBtn_1.isSelected == true){
                taskInfoDataEntity.ButtonColor = Int(InputTaskColorBtn_1.currentTitle!)!
            }
            else if(InputTaskColorBtn_2.isSelected == true){
                taskInfoDataEntity.ButtonColor = Int(InputTaskColorBtn_2.currentTitle!)!
            }
            else if(InputTaskColorBtn_3.isSelected == true){
                taskInfoDataEntity.ButtonColor = Int(InputTaskColorBtn_3.currentTitle!)!
            }
            
            // テキストカラー
            // taskInfoDataEntity.TextColor = 0
            
            
            // 親ID（-1 = 親（先頭）、それ以外＝親のID）
            // 自身の親ID取得
            let selfTaskInfoDataEntity : TaskInfoDataEntity = TaskInfoUtility.DefaultInstance.GetTaskInfoDataForId(self.paramTaskId)!
            // 親ID再設定
            taskInfoDataEntity.ParrentId = selfTaskInfoDataEntity.ParrentId
            
            // カテゴリータイプ
            taskInfoDataEntity.CategoryType = paramCategoryType
            
            //完了フラグ
            taskInfoDataEntity.CompleteFlag = CommonConst.TASK_COMPLETE_FLAG_INVALID
            
            //作成日時
            taskInfoDataEntity.CreateDateTime = FunctionUtility.DateToyyyyMMddHHmmss(Date(), separation: true)
            
            //更新日時
            taskInfoDataEntity.UpdateDateTime = FunctionUtility.DateToyyyyMMddHHmmss(Date(), separation: true)
            
            // タスク更新処理
            TaskInfoUtility.DefaultInstance.SetTaskInfoDataForId(taskInfoDataEntity)
            
            // タスク情報書込み
            TaskInfoUtility.DefaultInstance.WriteTaskInfo()
            
            // DEBUG:登録タスク情報読み出し
            #if DEBUG
                print("------登録タスク情報------")
                print("タスクID:" + String(taskInfoDataEntity.Id))
                print("項目名:" + taskInfoDataEntity.Title)
                print("メモ:" + taskInfoDataEntity.Memo)
                print("通知時刻:" + taskInfoDataEntity.DateTime)
                print("通知地点(ID):" + String(taskInfoDataEntity.NotifiedLocation))
                print("重要度:" + String(taskInfoDataEntity.Importance))
                print("タスクカラー(ID):" + String(taskInfoDataEntity.ButtonColor))
                print("親ID:" + String(taskInfoDataEntity.ParrentId))
                print("カテゴリータイプ:" + String(taskInfoDataEntity.CategoryType))
                print("完了フラグ:" + String(taskInfoDataEntity.CompleteFlag))
                print("作成日時:" + taskInfoDataEntity.CreateDateTime)
                print("更新日時:" + taskInfoDataEntity.UpdateDateTime)
                print("-----------------------")
            #endif
            
            
        }
        
    }
    
    /// PicerView　値選択時イベント
    ///
    /// - Parameters:
    ///   - pickerView: 通知地点リスト
    ///   - row: 通知地点リスト選択行
    ///   - component: 通知地点リストコンポーネント
    override func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        // 登録地点選択処理
        setSelectedPoint(textField : self.InputPointListField, row: row)
        
    }
}


