//
//  TaskEditViewControler.swift
//  Taskfull
//
//  Created by IscIsc on 2017/04/17.
//  Copyright © 2017年 isc. All rights reserved.
//
//TODO:変数名変更　削除ボタン処理　表示処理

import UIKit
import AudioToolbox

///
/// タスク入力画面
///
class TaskEditViewController : BaseTaskInputViewController
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
    @IBOutlet weak var InputPointListField: InputDisabledTextField!
    @IBOutlet weak var InputTaskMemoView: UIPlaceHolderTextView!
    @IBOutlet weak var InputTaskDateField: InputDisabledTextField!
    @IBOutlet weak var AddAfterTask: UICustomButton!
    @IBOutlet weak var InputImportanceSegment: UISegmentedControl!
    @IBOutlet weak var InputTaskColorBtn_1: UICustomButton!
    @IBOutlet weak var InputTaskColorBtn_2: UICustomButton!
    @IBOutlet weak var InputTaskColorBtn_3: UICustomButton!
    @IBOutlet var MainView: UICustomView!
    @IBOutlet weak var HiddenContentClearView: UIView!
    @IBOutlet weak var DeleteTaskBtn: UICustomButton!
    
    
    /// viewDidLoadイベント処理
    override func viewDidLoad() {
        
        // 基底のviewDidLoadを呼び出す
        super.viewDidLoad()
        
        // 初期化
        let _ = initializeProc()
    }
    
    // 削除ボタンタップ時動作
    @IBAction func TouchUpInside_DeleteTaskBtn(_ sender: Any) {
        
        // タスク削除確認メッセージ表示
        MessageUtility.dispAlertOKCancel(viewController: self, title: MessageUtility.MESSAGE_TITLE_STRING_CONFIRM_TASK_DELETE, message: MessageUtility.MESSAGE_MESSAGE_STRING_CONFIRM_TASK_DELETE, funcOkButton: DeleteConfirmOKAction, funcCancelButton: nil)
        
    }
    
    // タスク削除確認OKアクション
    fileprivate func DeleteConfirmOKAction(action: UIAlertAction){
        
        // OKボタン押下
        self.isOkBtn = true

        // OK時アクション
        // 読込タスク及び子タスク削除
        TaskInfoUtility.DefaultInstance.RemoveTaskInfo(self.paramTaskId)
        TaskInfoUtility.DefaultInstance.RemoveTaskInfoForChild(self.paramTaskId)
        
        // 変更内容書き込み
        TaskInfoUtility.DefaultInstance.WriteTaskInfo()
        
        // ナビゲーションバー:レイヤー追加
        self.navigationController?.view.layer.add(self.navigationTrasitionAnimate(0.7, "suckEffect", "kCATransitionFromRight"), forKey: kCATransition)
        
        //メイン画面へ遷移(TOP)
        //self.navigationController?.popViewController(animated: true)
        self.navigationController?.popToRootViewController(animated: true)
        
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
        }
        
        return ret
    }
    
    // 遷移先モード分岐処理
    override func displayTaskModeChange(){
        
        // メイン画面モード
        switch(self.paramMainViewMode){
            
        // 編集モードの場合
        case CommonConst.ActionType.edit:
            
            // 編集不可用Viewを非表示
            HiddenContentClearView.isHidden = true
            
            // 削除ボタン有効化
            DeleteTaskBtn.isHidden = false
            DeleteTaskBtn.isEnabled = true
            
            // TEST:START
            // 編集モード時後続タスク追加処理対策
            // 読込ID:後続タスクが存在しないかつ子タスクではない場合
            if(TaskInfoUtility.DefaultInstance.GetParrentIndex(self.paramTaskId) == -1 && self.paramParrentId == -1){
                
                // 後続タスク追加ボタン表示
                AddAfterTask.isEnabled = true
                AddAfterTask.isHidden = false
                
                // 後続タスク追加ボタン:タイトル再設定(登録)
                AddAfterTask.setTitle(CommonConst.AFTER_ADD_TASK_BTN_TITLE, for: UIControlState())

            }
            // 読込ID:後続タスクが存在しないかつ子タスクである場合
            else if(TaskInfoUtility.DefaultInstance.GetParrentIndex(self.paramTaskId) == -1 && self.paramParrentId != -1){
                
                // 後続タスクボタン無効化
                AddAfterTask.isEnabled = false
                AddAfterTask.isHidden = true
                
                return
                
            }
            // 読込ID:後続タスクが存在する場合
            else{
                
                // 後続タスク編集ボタン表示
                // 後続タスクボタン表示
                AddAfterTask.isEnabled = true
                AddAfterTask.isHidden = false
                
            }
            // TEST:END
            
            break;
            
        // 上記以外の場合(参照モード)
        default:
            
            // 編集不可用Viewを表示
            HiddenContentClearView.isHidden = false
            
            // 削除ボタン無効化
            DeleteTaskBtn.isHidden = true
            DeleteTaskBtn.isEnabled = false
            
            // TEST:START
            // 読込ID:後続タスクが存在しない場合
            if(TaskInfoUtility.DefaultInstance.GetParrentIndex(self.paramTaskId) == -1){
                
                //　後続タスクボタン非表示
                AddAfterTask.isEnabled = false
                AddAfterTask.isHidden = true

            }
            // 読込ID:後続タスクが存在する場合
            else{
                
                //　後続タスクボタン表示
                AddAfterTask.isEnabled = true
                AddAfterTask.isHidden = false

            }
            // TEST:END
            
            break;
            
        }
        
    }
    
    // タスク内容初期表示処理
    override func displayTaskContent(){
        
        // 読込タスク読込処理開始
        let taskInfo : TaskInfoDataEntity = TaskInfoUtility.DefaultInstance.GetTaskInfoDataForId(paramTaskId)!
        
        // 項目名入力欄 = 選択タスク項目名
        InputTaskNameField.text = taskInfo.Title
        
        // メモ入力欄 = 選択タスクメモ
        InputTaskMemoView.text = taskInfo.Memo
        
        // タスク終了日時欄 = 読込タスク終了日時
        InputTaskDateField.text = FunctionUtility.DateToyyyyMMddHHmm_JP(FunctionUtility.yyyyMMddHHmmssToDate(taskInfo.DateTime))
        // 同一日付を設定日時取得変数に格納
        inputTaskEndDate = FunctionUtility.yyyyMMddHHmmssToDate(taskInfo.DateTime)
        // DatePicker開始時刻　＝　選択タスク終了日時
        inputDatePicker.setDate(inputTaskEndDate, animated: false)
        
        
        // TEST:START
        // Datepicker制限再設定処理
        // 読込ID:子タスクが存在する場合(判定:親タスク)
        if(TaskInfoUtility.DefaultInstance.GetParrentIndex(taskInfo.Id) != -1){
            
            // 読込ID:子タスク読込処理開始
            let parrentTaskInfo : TaskInfoDataEntity = TaskInfoUtility.DefaultInstance.GetParrentTaskInfoDataForId(taskInfo.Id)!
            
            // 設定最大日 ＝ 読込ID:子タスク終了日付
            inputDatePicker.maximumDate = FunctionUtility.yyyyMMddHHmmssToDate(parrentTaskInfo.DateTime)
            
        }
        // 読込ID:親タスクが存在する場合(判定:子タスク)
        else if(TaskInfoUtility.DefaultInstance.GetIndex(taskInfo.ParrentId) != -1){
            
            // 読込ID:親タスク読込処理開始
            let parrentTaskInfo : TaskInfoDataEntity = TaskInfoUtility.DefaultInstance.GetTaskInfoDataForId(taskInfo.ParrentId)!
            
            // 親タスクが完了していない場合
            if(parrentTaskInfo.CompleteFlag != 1){
                
                // 設定最小日 ＝ 読込ID:親タスク終了日付
                inputDatePicker.minimumDate = FunctionUtility.yyyyMMddHHmmssToDate(parrentTaskInfo.DateTime)
                
            }
            // 親タスクが完了している場合 (判定:単独子タスク)
            else{
                
                // Datepicker設定制限初期化
                inputDatePicker.minimumDate = nil
                
            }
            
        }
        // 単独タスクである場合(判定:親タスク,子タスクなし)
        else{
            
            // 設定制限初期化
            inputDatePicker.minimumDate = nil
            
        }
        // TEST:END
        
        
        // 通知場所リスト欄(要変更)
        InputPointListField.text = String(taskInfo.NotifiedLocation)
        
        
        // 重要度欄
        InputImportanceSegment.selectedSegmentIndex = taskInfo.Importance
        //各セグメント分岐処理(ボタン色変更)
        didChengeImportanceSegmentValue(InputImportanceSegment.selectedSegmentIndex, btn1 : self.InputTaskColorBtn_1, btn2 : self.InputTaskColorBtn_2, btn3 : self.InputTaskColorBtn_3)
        
        // 親ID
        // 読込タスク親ID格納変数へ読込タスク親IDを格納
        self.selfParrentId = taskInfo.ParrentId
        
        
        // カラー欄
        // ボタンカラー分岐処理
        switch taskInfo.ButtonColor {
        case 0,3,6,9:
            // ボタン1.isSelected
            InputTaskColorBtn_1.isSelected = true
            InputTaskColorBtn_2.isSelected = false
            InputTaskColorBtn_3.isSelected = false
            InputTaskColorBtn_1.setBackgroundColor(UIColorUtility.rgb(102, g: 153, b: 255), forUIControlState: UIControlState())
            InputTaskColorBtn_2.setBackgroundColor(UIColor.clear, forUIControlState: UIControlState())
            InputTaskColorBtn_3.setBackgroundColor(UIColor.clear, forUIControlState: UIControlState())
            
        case 1,4,7,10:
            // ボタン2.isSelected
            InputTaskColorBtn_1.isSelected = false
            InputTaskColorBtn_2.isSelected = true
            InputTaskColorBtn_3.isSelected = false
            InputTaskColorBtn_1.setBackgroundColor(UIColor.clear, forUIControlState: UIControlState())
            InputTaskColorBtn_2.setBackgroundColor(UIColorUtility.rgb(102, g: 153, b: 255), forUIControlState: UIControlState())
            InputTaskColorBtn_3.setBackgroundColor(UIColor.clear, forUIControlState: UIControlState())
            
        case 2,5,8,11:
            // ボタン3.isSelected
            InputTaskColorBtn_1.isSelected = false
            InputTaskColorBtn_2.isSelected = false
            InputTaskColorBtn_3.isSelected = true
            InputTaskColorBtn_1.setBackgroundColor(UIColor.clear, forUIControlState: UIControlState())
            InputTaskColorBtn_2.setBackgroundColor(UIColor.clear, forUIControlState: UIControlState())
            InputTaskColorBtn_3.setBackgroundColor(UIColorUtility.rgb(102, g: 153, b: 255), forUIControlState: UIControlState())
            
        default:
            break;
        }
    }
    
    //textView:値変更確定時イベント
    override func textViewDidChange(_ textView: UITextView) {
        
        //　文字列変換完了後(== nil)かつ制限文字数を超えていた場合
        if textView.markedTextRange == nil && textView.text.characters.count > CommonConst.INPUT_TASK_MEMO_STRING_LIMIT {
            
            //　制限文字数より後ろの文字列を削除
            textView.text = textView.text.substring(to: textView.text.index(textView.text.startIndex, offsetBy: CommonConst.INPUT_TASK_MEMO_STRING_LIMIT))
            
            
            // 文字数制限アラート表示(メモ)
            MessageUtility.dispAlertOK(viewController: self, title: "", message: "".appendingFormat(MessageUtility.MESSAGE_MESSAGE_STRING_TASK_COUNT_LIMIT,(String(CommonConst.INPUT_TASK_MEMO_STRING_LIMIT))))
            
        }
    }
    
    
    
    // textField:編集完了時イベント
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
                MessageUtility.dispAlertOK(viewController: self, title: "", message: "".appendingFormat(MessageUtility.MESSAGE_MESSAGE_STRING_TASK_COUNT_LIMIT,(String(CommonConst.INPUT_TASK_NAME_STRING_LIMIT))))
                
            }
        }
    }
    
    
    //　編集内容入力欄設定
    override func displayInputField(){
        
        //項目名入力欄,メモ入力欄:初期設定
        displayInputTaskName(taskNameField: self.InputTaskNameField)
        displayInputTaskMemo(taskMemoView: self.InputTaskMemoView)
        
        //タスク終了時刻欄:初期設定
        diplayInputTaskDate(taskDateField: self.InputTaskDateField)
        
        //通知場所:初期設定
        displayInputPoint(pointListField: self.InputPointListField)
        
        //重要度:初期設定
        displayInputImportanceSegment(importanceSegment: self.InputImportanceSegment)
        
        //タスクカラーボタン:初期設定
        dispayInputTaskColorBtn(btn1 : self.InputTaskColorBtn_1, btn2 : self.InputTaskColorBtn_2, btn3 : self.InputTaskColorBtn_3, inputImportanceSegment: self.InputImportanceSegment)
        
        //後続タスクボタン:初期設定
        displayAddAfterTaskBtn(addAfterTask: self.AddAfterTask)
    }

    
    //タスクカラーボタン_1:タップ時イベント
    override func onTouchDown_btn1(_ sender:UIButton){
        changeInputTaskColorBtn(selectedBtnIndex: 0, btn1 : InputTaskColorBtn_1, btn2 : InputTaskColorBtn_2, btn3 : InputTaskColorBtn_3)
    }
    
    //タスクカラーボタン_2:タップ時イベント
    override func onTouchDown_btn2(_ sender:UIButton){
        changeInputTaskColorBtn(selectedBtnIndex : 1, btn1 : self.InputTaskColorBtn_1, btn2 : self.InputTaskColorBtn_2, btn3 : self.InputTaskColorBtn_3)
    }
    
    //タスクカラーボタン_3:タップ時イベント
    override func onTouchDown_btn3(_ sender:UIButton){
        changeInputTaskColorBtn(selectedBtnIndex : 2, btn1 : self.InputTaskColorBtn_1, btn2 : self.InputTaskColorBtn_2, btn3 : self.InputTaskColorBtn_3)
    }
    

    //重要度:セグメント値変更時イベント
    override func onTouchDown_InputImportanceSegment(_ segcon:UISegmentedControl){
        
        // 重要度:セグメント値変更時処理
        didChengeImportanceSegmentValue(segcon.selectedSegmentIndex, btn1 : self.InputTaskColorBtn_1, btn2 : self.InputTaskColorBtn_2, btn3 : self.InputTaskColorBtn_3)
        
    }
    
    // ツールバー：クリアボタンタップ時イベント
    override func onTouch_ToolBarClearBtn(){
        
        //　ツールバー：クリアボタン処理
        clearToolBarButton(taskDateField: InputTaskDateField)
    }
    
    
    //Datepicer：値変更時イベント
    override func inputDatePickerEdit(_ sender: UIDatePicker){
        
        // Datepicer：値変更処理
        updateInputDatePicker(sender, taskDateField: InputTaskDateField)
    }

    
    //後続タスクボタン：タップ時イベント
    override func onTouchDown_addAfterTaskButton(_ sender : UIButton){
        
        // TODO:タスク参照時、編集イベント不要
        // タスク編集イベント
        inputEditTask()

        // ナビゲーションバー:レイヤー追加
        self.navigationController?.view.layer.add(navigationTrasitionAnimate(0.7, "pageCurl", kCATransitionFromRight), forKey: kCATransition)
        
        // 後続タスクが存在しない場合
        let childIndex = TaskInfoUtility.DefaultInstance.GetParrentIndex(self.paramTaskId)
        if(childIndex == -1){
            // 参照モード以外の場合
            if(self.paramMainViewMode != CommonConst.ActionType.reference){

                // タスク登録画面コントローラー生成
                let vc = storyboard?.instantiateViewController(withIdentifier: "InputStoryBoard") as! TaskInputViewController
                // 読込タスクID
                vc.paramTaskId = self.paramTaskId
                // タスク登録モード
                vc.paramMainViewMode = CommonConst.ActionType.add
                // タスク:カテゴリータイプ
                vc.paramCategoryType = paramCategoryType
                
                // 後続タスク追加ボタン:編集画面遷移処理
                navigationController?.pushViewController(vc, animated: true)
                
                
            // 上記以外の場合
            } else {
                // 処理しない
                return
            }
            
        // 上記以外の場合(タスク参照)
        } else {
            
            // タスク編集画面コントローラー生成
            let vc = storyboard?.instantiateViewController(withIdentifier: "EditStoryBoard") as! TaskEditViewController
            
            // 後続タスク情報を取得
            let childTaskInfo : TaskInfoDataEntity = TaskInfoUtility.DefaultInstance.GetTaskInfoData()[childIndex]
            
            // 読込タスクID(子タスクID)
            vc.paramTaskId = childTaskInfo.Id
            // メイン画面:モード
            vc.paramMainViewMode = self.paramMainViewMode
            // 中間タスク判別用変数
            vc.paramParrentId = childTaskInfo.ParrentId
            // カテゴリータイプ
            vc.paramCategoryType = paramCategoryType
            
            // 後続タスク追加ボタン:編集画面遷移
            navigationController?.pushViewController(vc, animated: true)
        }

    }
    
    
    // 確定ボタン：タップ時イベント
    override func onTouchDown_decideEditTaskButton(){
        
        // タスク編集イベント
        inputEditTask()
        
        // ナビゲーションバー:レイヤー追加
        self.navigationController?.view.layer.add(navigationTrasitionAnimate(1.2, "rippleEffect", "false"), forKey: kCATransition)
        
        // ナビゲーションバー:最初の画面に戻る
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    /**
     タスク編集イベント
     */
    func inputEditTask(){
        
        // OKボタン押下
        self.isOkBtn = true
        
        // 編集対象タスク情報Entity(編集対象外情報格納)
        let editTaskInfo : TaskInfoDataEntity = TaskInfoUtility.DefaultInstance.GetTaskInfoDataForId(self.paramTaskId)!
        
        /// EDIT START
        // 編集対象タスク格納Entity
        let taskInfoDataEntity : TaskInfoDataEntity = TaskInfoDataEntity()
        
        // タスクID設定
        // 読込タスクIDを設定
        taskInfoDataEntity.Id = self.paramTaskId
        
        //項目名登録
        //項目名未入力時チェック
        if(false == StringUtility.isEmpty(InputTaskNameField.text)){
            // 空白の場合、代入文字
            taskInfoDataEntity.Title = CommonConst.INPUT_TASK_NAME_EMPTY_STRING
        }
        else{
            // 空白ではない場合、入力値
            taskInfoDataEntity.Title = InputTaskNameField.text! as String
        }
        
        //メモ
        taskInfoDataEntity.Memo = InputTaskMemoView.text! as String
        
        //タスク終了時刻
        taskInfoDataEntity.DateTime = FunctionUtility.DateToyyyyMMddHHmmss(inputTaskEndDate, separation: true)
        
        //通知場所(編集対象)
        taskInfoDataEntity.NotifiedLocation = 0
        
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
        
        // テキストカラー(編集対象外)
        taskInfoDataEntity.TextColor = editTaskInfo.TextColor
        
        // 親ID
        // 編集タスクの親IDを再設定
        taskInfoDataEntity.ParrentId = self.selfParrentId
        // 中間タスク判別用変数に読込IDを設定
        self.paramParrentId = taskInfoDataEntity.Id
        
        // カテゴリータイプ(編集対象外)
        taskInfoDataEntity.CategoryType = editTaskInfo.CategoryType
        
        // 作成日時(編集対象外)
        taskInfoDataEntity.CreateDateTime = editTaskInfo.CreateDateTime
        
        // 編集モードである場合
        if(self.paramMainViewMode == CommonConst.ActionType.edit){
            
            //　更新日時更新
            taskInfoDataEntity.UpdateDateTime = FunctionUtility.DateToyyyyMMddHHmmss(Date(), separation: true)
            
        }
        // 編集モード以外である場合(参照モード)
        else{
            
            //　更新日時(編集対象外)
            taskInfoDataEntity.UpdateDateTime = editTaskInfo.UpdateDateTime
            
        }
        
        // タスク更新処理
        TaskInfoUtility.DefaultInstance.SetTaskInfoDataForId(taskInfoDataEntity)
        
        // タスク情報書込み
        TaskInfoUtility.DefaultInstance.WriteTaskInfo()
        /// EDIT END
        
    }
    
    //PicerView　値選択時イベント
    override func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        // 登録地点選択処理
        setSelectedPoint(textField : self.InputPointListField, row: row)
    }
}

