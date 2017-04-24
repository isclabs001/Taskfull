//
//  TaskInputViewControler.swift
//  Taskfull
//
//  Created by IscIsc on 2017/03/11.
//  Copyright © 2017年 isc. All rights reserved.
//
//TODO:文字の定数化,登録データ型,登録地点リスト,AutoLayout,入力方法最適化,メソッド順整理

import UIKit
import AudioToolbox

///
/// タスク入力画面
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
    
    
    /// viewDidLoadイベント処理
    override func viewDidLoad() {
        
        // 基底のviewDidLoadを呼び出す
        super.viewDidLoad()
        
        // 初期化
        initializeProc()
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
    
    
    //登録内容入力欄設定
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
        
        // タスク登録イベント
        inputRegistrationTask()
        
        // タスク登録画面コントローラー生成
        let vc = storyboard?.instantiateViewController(withIdentifier: "InputStoryBoard") as! TaskInputViewController
        vc.paramTaskId = self.paramTaskId
        
        // ナビゲーションバー:レイヤー追加
        self.navigationController?.view.layer.add(navigationTrasitionAnimate(0.7, "pageCurl", kCATransitionFromRight), forKey: kCATransition)
        
        // 後続タスク追加ボタン:編集画面遷移
        navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    
    
    // 確定ボタン：タップ時イベント
    override func onTouchDown_decideEditTaskButton(){
        
        // タスク登録イベント
        inputRegistrationTask()
        
        // ナビゲーションバー:レイヤー追加
        self.navigationController?.view.layer.add(navigationTrasitionAnimate(1.2, "rippleEffect", "false"), forKey: kCATransition)
        
        // ナビゲーションバー:最初の画面に戻る
        self.navigationController?.popToRootViewController(animated: true)
        
        
    }
    
    
    
    /**
     タスク登録イベント
     */
    func inputRegistrationTask(){
        
        /*
         **タスク登録イベント実装
         */
        
        //TEST START
        
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
        
        //通知場所
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
        
        //テキストカラー
        taskInfoDataEntity.TextColor = 0
        
        //親ID（-1 = 親（先頭）、それ以外＝親のID）
        // 親タスクである場合
        if(self.paramTaskId == -2 ){
            
            //　ParrentIdを親ID定数に設定[-1 = 親（先頭）]
            taskInfoDataEntity.ParrentId = -1
            
            // ParamTaskIdを自IDに設定
            self.paramTaskId = taskInfoDataEntity.Id
        }
        // 後続タスクである場合
        else{
            
            // ParrentIdを親IDに設定[それ以外＝親のID]
            taskInfoDataEntity.ParrentId = self.paramTaskId
            
            // ParamTaskIdを自IDに設定
            self.paramTaskId = taskInfoDataEntity.Id
        }
        
        
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
        
        
    }
    
    //PicerView　値選択時イベント
    override func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        // 登録地点選択処理
        setSelectedPoint(textField : self.InputPointListField, row: row)
    }
    
    
}


