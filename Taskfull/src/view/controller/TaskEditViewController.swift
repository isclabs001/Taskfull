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
class TaskEditViewController : BaseViewController,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate,UITextViewDelegate
{
    /**
     * 定数
     */
    // タスク終了時刻入力DatePiceker
    let inputDatePicker : UIDatePicker = UIDatePicker()
    // 登録地点リスト入力PickerView
    let inputPointPicker : UIPickerView! = UIPickerView()
    
    // 設定日時取得変数
    var inputTaskEndDate : Date = Date()
    
    //登録地点用要素配列（テスト用）
    let aaa : NSArray = ["","自宅","スーパー","aaaaaaaaaaa"]
    
    // 受け取り用パラメータ:選択タスクID,メイン画面:動作モード
    var paramTaskId : Int = 0
    var paramMainViewMode : CommonConst.ActionType = CommonConst.ActionType.edit
    var paramParrentId : Int = -1
    
    var selfParrentId : Int = Int()
    
    /**
     * 変数
     */
    // カラーボタンイメージ(全１２色)
    // 重要度：低
    fileprivate let mImageTaskColorBtn_WHITE : UIImage = UIImage(named: CommonConst.TASK_BUTTON_COLOR_RESOURCE[CommonConst.TASK_BUTTON_COLOR_WHITE])!
    fileprivate let mImageTaskColorBtn_LIGHT_BLUE : UIImage = UIImage(named: CommonConst.TASK_BUTTON_COLOR_RESOURCE[CommonConst.TASK_BUTTON_COLOR_LIGHT_BLUE])!
    fileprivate let mImageTaskColorBtn_GLAY : UIImage = UIImage(named: CommonConst.TASK_BUTTON_COLOR_RESOURCE[CommonConst.TASK_BUTTON_COLOR_GLAY])!
    // 重要度：中
    fileprivate let mImageTaskColorBtn_GREEN : UIImage = UIImage(named: CommonConst.TASK_BUTTON_COLOR_RESOURCE[CommonConst.TASK_BUTTON_COLOR_GREEN])!
    fileprivate let mImageTaskColorBtn_ORANGE : UIImage = UIImage(named: CommonConst.TASK_BUTTON_COLOR_RESOURCE[CommonConst.TASK_BUTTON_COLOR_ORANGE])!
    fileprivate let mImageTaskColorBtn_BLUE : UIImage = UIImage(named: CommonConst.TASK_BUTTON_COLOR_RESOURCE[CommonConst.TASK_BUTTON_COLOR_BLUE])!
    // 重要度：高
    fileprivate let mImageTaskColorBtn_YELLOW : UIImage = UIImage(named: CommonConst.TASK_BUTTON_COLOR_RESOURCE[CommonConst.TASK_BUTTON_COLOR_YELLOW])!
    fileprivate let mImageTaskColorBtn_PINK : UIImage = UIImage(named: CommonConst.TASK_BUTTON_COLOR_RESOURCE[CommonConst.TASK_BUTTON_COLOR_PINK])!
    @IBOutlet weak var DeleteTaskBtn: UICustomButton!
    fileprivate let mImageTaskColorBtn_PURPLE : UIImage = UIImage(named: CommonConst.TASK_BUTTON_COLOR_RESOURCE[CommonConst.TASK_BUTTON_COLOR_PURPLE])!
    // 重要度：至急
    fileprivate let mImageTaskColorBtn_DARK_YELLOW : UIImage = UIImage(named: CommonConst.TASK_BUTTON_COLOR_RESOURCE[CommonConst.TASK_BUTTON_COLOR_DARK_YELLOW])!
    fileprivate let mImageTaskColorBtn_DARK_PINK : UIImage = UIImage(named: CommonConst.TASK_BUTTON_COLOR_RESOURCE[CommonConst.TASK_BUTTON_COLOR_DARK_PINK])!
    fileprivate let mImageTaskColorBtn_DARK_PURPLE : UIImage = UIImage(named: CommonConst.TASK_BUTTON_COLOR_RESOURCE[CommonConst.TASK_BUTTON_COLOR_DARK_PURPLE])!
    
    
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
    
    /// viewDidLoadイベント処理
    override func viewDidLoad() {
        
        // 基底のviewDidLoadを呼び出す
        super.viewDidLoad()
        
        // 初期化
        initializeProc()
    }
    
    // 削除ボタンタップ時動作
    @IBAction func TouchUpInside_DeleteTaskBtn(_ sender: Any) {
        
        // タスク完了メッセージ表示
        MessageUtility.dispAlertOKCancel(viewController: self, title: MessageUtility.MESSAGE_TITLE_STRING_CONFIRM_TASK_DELETE, message: MessageUtility.MESSAGE_MESSAGE_STRING_CONFIRM_TASK_DELETE, funcOkButton: DeleteConfirmOKAction, funcCancelButton: nil)
        
    }
    
    // タスク削除確認OKアクション
    fileprivate func DeleteConfirmOKAction(action: UIAlertAction){
        
        // OK時アクション
        // 読込タスク及び子タスク削除
        TaskInfoUtility.DefaultInstance.RemoveTaskInfo(self.paramTaskId)
        TaskInfoUtility.DefaultInstance.RemoveTaskInfoForChild(self.paramTaskId)
        
        // 変更内容書き込み
        TaskInfoUtility.DefaultInstance.WriteTaskInfo()
        
        // ナビゲーションバー:レイヤー追加
        self.navigationController?.view.layer.add(self.navigationTrasitionAnimate(0.7, "suckEffect", "kCATransitionFromRight"), forKey: kCATransition)
        
        //メイン画面へ遷移(一つ前)
        self.navigationController?.popViewController(animated: true)
        
    }
    
    

    /**
     ナビゲーションバー遷移時トランジション設定
     @param intDuration アニメーション動作速度
     @param strAnimationType メイン効果
     @param strAnimationSubType サブ効果ON:指定文字列,サブ効果OFF:"false"
     @return CATransition トランジション
     */
    func navigationTrasitionAnimate(_ intDuration: CFTimeInterval ,_ strAnimationType : String,_ strAnimationSubType : String) ->  CATransition{
        
        // 既存のアニメーション削除
        self.view.layer.removeAllAnimations()
        
        // ナビゲーションバー遷移用アニメーション設定
        let transition = CATransition()
        
        // アニメーション動作速度
        transition.duration = intDuration
        
        // メイン効果
        transition.type = strAnimationType
        
        // サブ効果有効の場合
        if(strAnimationSubType != "false"){
            
            // サブ効果指定
            transition.subtype = strAnimationSubType
        }
        
        // アニメーションを返す
        return transition
        
    }
    
    
    /// 初期化処理
    override func initializeProc() ->Bool
    {
        // 基底のinitializeProcを呼び出す
        var ret : Bool = super.initializeProc()
        
        //　正常な場合
        if(true == ret)
        {
            // 背景色設定
            self.MainView.gradationBackgroundStartColor = CommonConst.CL_BACKGROUND_GRADIATION_BLUE_2
            self.MainView.gradationBackgroundEndColor = CommonConst.CL_BACKGROUND_GRADIATION_BLUE_1
            
            //view:フォーカスが外れた際のイベント
            let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TaskInputViewController.missFocusView))
            view.addGestureRecognizer(tap)
            
            // 編集画面用ナビゲーションバー：初期設定
            displayEditTopMenu()
            
            // 編集内容入力欄を設定
            displayInputField()
            
            // 編集内容:初期表示処理
            displayTaskContent()
            
            // 遷移先モード分岐処理
            displayTaskModeChange()
            
            // 戻り値にtrueを設定
            ret = true
        }
        
        return ret
    }
    
    // 遷移先モード分岐処理
    fileprivate func displayTaskModeChange(){
        
        // メイン画面モード
        switch(self.paramMainViewMode){
            
        // 現在編集モードの場合
        case CommonConst.ActionType.edit:
            
            // 編集不可用Viewを非表示
            HiddenContentClearView.isHidden = true
            
            // 削除ボタン有効化
            DeleteTaskBtn.isHidden = false
            DeleteTaskBtn.isEnabled = true
            break;
            
        // 上記以外の場合(参照)
        default:
            
            // 編集不可用Viewを表示
            HiddenContentClearView.isHidden = false
            
            // 削除ボタン無効化
            DeleteTaskBtn.isHidden = true
            DeleteTaskBtn.isEnabled = false
            break;
            
        }
        
        // 後続タスクが存在しない場合
        if(TaskInfoUtility.DefaultInstance.GetParrentIndex(self.paramTaskId) == -1){
            
            //　後続タスクボタン非表示
            AddAfterTask.isEnabled = false
            AddAfterTask.isHidden = true
            
        }
        else{
            
            //　後続タスクボタン表示
            AddAfterTask.isEnabled = true
            AddAfterTask.isHidden = false
        }
        
    }
    
    // タスク内容初期表示処理
    func displayTaskContent(){
            
        // 選択タスク読込処理開始
        var taskInfo : TaskInfoDataEntity = TaskInfoDataEntity()
        
        // 親もしくは、選択始めタスクである場合
        if(paramParrentId == -1){
            
            // 親タスク(自身)読込処理
            taskInfo  = TaskInfoUtility.DefaultInstance.GetTaskInfoDataForId(paramTaskId)!
            
        }
        // 後続タスクである場合
        else{
            
            // 子タスク読込処理
            taskInfo = TaskInfoUtility.DefaultInstance.GetParrentTaskInfoDataForId(paramTaskId)!
            
            // 子タスクIDを読込IDに設定
            self.paramTaskId = taskInfo.Id
        }
        
        
        // 項目名入力欄 = 選択タスク項目名
        InputTaskNameField.text = taskInfo.Title

        // メモ入力欄 = 選択タスクメモ
        InputTaskMemoView.text = taskInfo.Memo
        
        // タスク終了日時欄 = 選択タスク終了日時
        InputTaskDateField.text = FunctionUtility.DateToyyyyMMddHHmm_JP(FunctionUtility.yyyyMMddHHmmssToDate(taskInfo.DateTime))
        // 同一日付を設定日時取得変数に格納
        inputTaskEndDate = FunctionUtility.yyyyMMddHHmmssToDate(taskInfo.DateTime)
        // DatePicker開始時刻　＝　選択タスク終了日時
        inputDatePicker.setDate(inputTaskEndDate, animated: false)
        
        // 通知場所リスト欄(要変更)
        InputPointListField.text = String(taskInfo.NotifiedLocation)
        
        
        // 重要度欄
        InputImportanceSegment.selectedSegmentIndex = taskInfo.Importance
        //各セグメント分岐処理(ボタン色変更)
        didChengeImportanceSegmentValue(InputImportanceSegment.selectedSegmentIndex)

        // 親ID
        // 親ID格納変数へ親IDを格納
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
    func textViewDidChange(_ textView: UITextView) {
        
        //　文字列変換完了後(== nil)かつ制限文字数を超えていた場合
        if textView.markedTextRange == nil && textView.text.characters.count > CommonConst.INPUT_TASK_MEMO_STRING_LIMIT {
            
            //　制限文字数より後ろの文字列を削除
            textView.text = textView.text.substring(to: textView.text.index(textView.text.startIndex, offsetBy: CommonConst.INPUT_TASK_MEMO_STRING_LIMIT))
            
            
            // 文字数制限アラート生成
            let stringLimitAlert: UIAlertController = UIAlertController(title: "", message: "\(CommonConst.INPUT_TASK_MEMO_STRING_LIMIT)文字以内で入力して下さい",preferredStyle: .alert)
            
            // OKActionタップ時処理
            let OkAlertAction = UIAlertAction(title: "OK", style: .default) {
                //UIAlertを閉じる(不要？？)
                action in stringLimitAlert.dismiss(animated: true, completion: nil)
            }
            
            // OKActionをUIAlertに追加
            stringLimitAlert.addAction(OkAlertAction)
            
            // UIAlert表示処理
            present(stringLimitAlert, animated: true, completion: nil)
            
        }
    }
    
    
    
    // textField:編集完了時イベント
    func textFieldDidChange(_ nsNotification: Notification) {
        
        //　UITextFieldへ変換
        let inputTextField = nsNotification.object as! UITextField
        
        // 変数に代入
        if let copyText = inputTextField.text {
            
            //　文字列変換完了後(== nil)かつ制限文字数を超えていた場合
            if inputTextField.markedTextRange == nil && copyText.characters.count > CommonConst.INPUT_TASK_NAME_STRING_LIMIT {
                
                //　制限文字数より後ろの文字列を削除
                inputTextField.text = copyText.substring(to: copyText.characters.index(copyText.startIndex, offsetBy: CommonConst.INPUT_TASK_NAME_STRING_LIMIT))
                
                
                // 文字数制限アラート生成
                let stringLimitAlert: UIAlertController = UIAlertController(title: "", message: "\(CommonConst.INPUT_TASK_NAME_STRING_LIMIT)文字以内で入力して下さい",preferredStyle: .alert)
                
                // OKActionタップ時処理
                let OkAlertAction = UIAlertAction(title: "OK", style: .default) {
                    //UIAlertを閉じる(不要？？)
                    action in stringLimitAlert.dismiss(animated: true, completion: nil)
                }
                
                // OKActionをUIAlertに追加
                stringLimitAlert.addAction(OkAlertAction)
                
                // UIAlert表示処理
                present(stringLimitAlert, animated: true, completion: nil)
                
            }
        }
    }
    
    
    
    // 編集画面用ナビゲーションバー：初期設定
    fileprivate func displayEditTopMenu(){
        
        // ナビゲーションバー表示
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        // ナビゲーションバー背景色
        self.navigationController?.navigationBar.backgroundColor = UIColorUtility.rgb(107, g: 133, b: 194)
        //self.navigationController?.navigationBar.tintColor = UIColor.white
        //self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]

        // メイン画面モード
        switch(self.paramMainViewMode){
        // 現在編集モードの場合
        case CommonConst.ActionType.edit:
            
            //タイトル名設定(編集)
            self.title = CommonConst.VIW_TITLE_EDIT_TASK
            
            //編集確定ボタン生成("OK")
            let addEditTaskButton : UIBarButtonItem = UIBarButtonItem(title:"OK",style : UIBarButtonItemStyle.plain,target: self,action:#selector(TaskEditViewController.onTouchDown_addEditTaskButton))
            
            //ボタンをナビゲーションバー右側に配置
            self.navigationItem.setRightBarButtonItems([addEditTaskButton], animated: true)
            
            break;
        // 上記以外の場合(参照モード)
        default:
            
            //タイトル名設定(タスク内容)
            self.title = CommonConst.VIW_TITLE_CONTENT_TASK
            
            break;
        }

        
    }
    
    //　編集内容入力欄設定
    fileprivate func displayInputField(){
        
        //項目名入力欄,メモ入力欄:初期設定
        displayInputTaskNameMemo()
        
        //タスク終了時刻欄:初期設定
        diplayInputTaskDate()
        
        //通知場所:初期設定
        displayInputPoint()
        
        //重要度:初期設定
        displayInputImportanceSegment()
        
        //タスクカラーボタン:初期設定
        dispayInputTaskColorBtn()
        
        //後続タスクボタン:初期設定
        displayAddAfterTaskBtn()
        
    }
    
    //タスクカラーボタン:初期設定
    fileprivate func dispayInputTaskColorBtn(){
        
        //タスクカラーボタン:初期値設定
        changeColorBtn(InputImportanceSegment.selectedSegmentIndex)
        
        //タスクカラーボタン_1:タップ時イベント設定
        InputTaskColorBtn_1.addTarget(self, action: #selector(TaskInputViewController.onTouchDown_InputTaskColorBtn_1(_:)), for: .touchUpInside)
        
        //タスクカラーボタン_2:タップ時イベント設定
        InputTaskColorBtn_2.addTarget(self, action: #selector(TaskInputViewController.onTouchDown_InputTaskColorBtn_2(_:)), for: .touchUpInside)
        
        //タスクカラーボタン_3:タップ時イベント設定
        InputTaskColorBtn_3.addTarget(self, action: #selector(TaskInputViewController.onTouchDown_InputTaskColorBtn_3(_:)), for: .touchUpInside)
        
        //タスクカラーボタン:初期値設定
        InputTaskColorBtn_1.isSelected = false
        InputTaskColorBtn_2.isSelected = true
        InputTaskColorBtn_3.isSelected = false
        InputTaskColorBtn_1.setBackgroundColor(UIColor.clear, forUIControlState: UIControlState())
        InputTaskColorBtn_2.setBackgroundColor(CommonConst.CL_TASK_BTN_BACK_GROUND_COLOR, forUIControlState: UIControlState())
        InputTaskColorBtn_3.setBackgroundColor(UIColor.clear, forUIControlState: UIControlState())
        
        
    }
    
    //タスクカラーボタン_1:タップ時イベント
    func onTouchDown_InputTaskColorBtn_1(_ sender:UIButton){
        InputTaskColorBtn_1.isSelected = true
        InputTaskColorBtn_2.isSelected = false
        InputTaskColorBtn_3.isSelected = false
        InputTaskColorBtn_1.setBackgroundColor(CommonConst.CL_TASK_BTN_BACK_GROUND_COLOR, forUIControlState: UIControlState())
        InputTaskColorBtn_2.setBackgroundColor(UIColor.clear, forUIControlState: UIControlState())
        InputTaskColorBtn_3.setBackgroundColor(UIColor.clear, forUIControlState: UIControlState())
        
    }
    
    //タスクカラーボタン_2:タップ時イベント
    func onTouchDown_InputTaskColorBtn_2(_ sender:UIButton){
        InputTaskColorBtn_1.isSelected = false
        InputTaskColorBtn_2.isSelected = true
        InputTaskColorBtn_3.isSelected = false
        InputTaskColorBtn_1.setBackgroundColor(UIColor.clear, forUIControlState: UIControlState())
        InputTaskColorBtn_2.setBackgroundColor(CommonConst.CL_TASK_BTN_BACK_GROUND_COLOR, forUIControlState: UIControlState())
        InputTaskColorBtn_3.setBackgroundColor(UIColor.clear, forUIControlState: UIControlState())
        
    }
    
    //タスクカラーボタン_3:タップ時イベント
    func onTouchDown_InputTaskColorBtn_3(_ sender:UIButton){
        InputTaskColorBtn_1.isSelected = false
        InputTaskColorBtn_2.isSelected = false
        InputTaskColorBtn_3.isSelected = true
        InputTaskColorBtn_1.setBackgroundColor(UIColor.clear, forUIControlState: UIControlState())
        InputTaskColorBtn_2.setBackgroundColor(UIColor.clear, forUIControlState: UIControlState())
        InputTaskColorBtn_3.setBackgroundColor(CommonConst.CL_TASK_BTN_BACK_GROUND_COLOR, forUIControlState: UIControlState())
        
    }
    
    
    //重要度:初期設定
    fileprivate func displayInputImportanceSegment(){
        
        //重要度:セグメント値変更時イベント
        InputImportanceSegment.addTarget(self, action: #selector(TaskEditViewController.onTouchDown_InputImportanceSegment(_:)), for: .valueChanged)
        
    }
    
    // 重要度:セグメント値変更時処理
    fileprivate func didChengeImportanceSegmentValue(_ importanceSegmentIndex: Int){
        
        //各セグメント選択時分岐処理
        switch importanceSegmentIndex {
            
        //"低"の場合
        case CommonConst.TASK_IMPORTANCE_VALID_LOW:
            //カラーボタン変更イベント
            changeColorBtn(CommonConst.TASK_IMPORTANCE_VALID_LOW)
            
        //"中"の場合
        case CommonConst.TASK_COMPLETE_FLAG_VALID_MEDIUM:
            //カラーボタン変更イベント
            changeColorBtn(CommonConst.TASK_COMPLETE_FLAG_VALID_MEDIUM)
            
        //"高"の場合
        case CommonConst.TASK_COMPLETE_FLAG_VALID_HIGH:
            //カラーボタン変更イベント
            changeColorBtn(CommonConst.TASK_COMPLETE_FLAG_VALID_HIGH)
            
        //"至急"の場合
        case CommonConst.TASK_COMPLETE_FLAG_VALID_URGENT:
            //カラーボタン変更イベント
            changeColorBtn(CommonConst.TASK_COMPLETE_FLAG_VALID_URGENT)
            
        default:
            //要エラー対応時イベント
            break
        }
        
    }
    
    //重要度:セグメント値変更時イベント
    func onTouchDown_InputImportanceSegment(_ segcon:UISegmentedControl){
        
        // 重要度:セグメント値変更時処理
        didChengeImportanceSegmentValue(segcon.selectedSegmentIndex)
        
    }
    
    //カラーボタン変更処理(引数:重要度)
    fileprivate func changeColorBtn(_ caseNumber : Int){
        
        switch caseNumber {
            
        //"低"の場合
        case CommonConst.TASK_IMPORTANCE_VALID_LOW:
            // カラーボタン色変更(画像セット,タイトル:定数)
            InputTaskColorBtn_1.setImage(mImageTaskColorBtn_WHITE, for: UIControlState())
            InputTaskColorBtn_1.setTitle(String(CommonConst.TASK_BUTTON_COLOR_WHITE), for: UIControlState())
            InputTaskColorBtn_2.setImage(mImageTaskColorBtn_LIGHT_BLUE, for: UIControlState())
            InputTaskColorBtn_2.setTitle(String(CommonConst.TASK_BUTTON_COLOR_LIGHT_BLUE), for: UIControlState())
            InputTaskColorBtn_3.setImage(mImageTaskColorBtn_GLAY, for: UIControlState())
            InputTaskColorBtn_3.setTitle(String(CommonConst.TASK_BUTTON_COLOR_GLAY), for: UIControlState())

        //"中"の場合
        case CommonConst.TASK_COMPLETE_FLAG_VALID_MEDIUM:
            // カラーボタン色変更(画像セット,タイトル:定数)
            InputTaskColorBtn_1.setImage(mImageTaskColorBtn_GREEN, for: UIControlState())
            InputTaskColorBtn_1.setTitle(String(CommonConst.TASK_BUTTON_COLOR_GREEN), for: UIControlState())
            InputTaskColorBtn_2.setImage(mImageTaskColorBtn_ORANGE, for: UIControlState())
            InputTaskColorBtn_2.setTitle(String(CommonConst.TASK_BUTTON_COLOR_ORANGE), for: UIControlState())
            InputTaskColorBtn_3.setImage(mImageTaskColorBtn_BLUE, for: UIControlState())
            InputTaskColorBtn_3.setTitle(String(CommonConst.TASK_BUTTON_COLOR_BLUE), for: UIControlState())

        //"高"の場合
        case CommonConst.TASK_COMPLETE_FLAG_VALID_HIGH:
            // カラーボタン色変更(画像セット,タイトル:定数)
            InputTaskColorBtn_1.setImage(mImageTaskColorBtn_YELLOW, for: UIControlState())
            InputTaskColorBtn_1.setTitle(String(CommonConst.TASK_BUTTON_COLOR_YELLOW), for: UIControlState())
            InputTaskColorBtn_2.setImage(mImageTaskColorBtn_PINK, for: UIControlState())
            InputTaskColorBtn_2.setTitle(String(CommonConst.TASK_BUTTON_COLOR_PINK), for: UIControlState())
            InputTaskColorBtn_3.setImage(mImageTaskColorBtn_PURPLE, for: UIControlState())
            InputTaskColorBtn_3.setTitle(String(CommonConst.TASK_BUTTON_COLOR_PURPLE), for: UIControlState())
            
        //"至急"の場合
        case CommonConst.TASK_COMPLETE_FLAG_VALID_URGENT:
            // カラーボタン色変更(画像セット,タイトル:定数)
            InputTaskColorBtn_1.setImage(mImageTaskColorBtn_DARK_YELLOW, for: UIControlState())
            InputTaskColorBtn_1.setTitle(String(CommonConst.TASK_BUTTON_COLOR_DARK_YELLOW), for: UIControlState())
            InputTaskColorBtn_2.setImage(mImageTaskColorBtn_DARK_PINK, for: UIControlState())
            InputTaskColorBtn_2.setTitle(String(CommonConst.TASK_BUTTON_COLOR_DARK_PINK), for: UIControlState())
            InputTaskColorBtn_3.setImage(mImageTaskColorBtn_DARK_PURPLE, for: UIControlState())
            InputTaskColorBtn_3.setTitle(String(CommonConst.TASK_BUTTON_COLOR_DARK_PURPLE), for: UIControlState())
            
        default:
            break
        }
        
    }
    
    
    //項目名入力欄,メモ入力欄:初期設定
    fileprivate func displayInputTaskNameMemo(){
        
        //項目名入力欄:delegate設定
        InputTaskNameField.delegate  = self
        //項目名入力欄(透かし文字,左寄せ)要定数化
        InputTaskNameField.placeholder = CommonConst.INPUT_TASK_NAME_PLACE_HOLDER
        InputTaskNameField.textAlignment = NSTextAlignment.left
        //項目名入力欄:編集完了時イベント(TODO:textView同様デリゲートメソッドにて実装？)
        NotificationCenter.default.addObserver(self, selector: #selector(TaskInputViewController.textFieldDidChange(_:)), name: NSNotification.Name.UITextFieldTextDidChange, object: InputTaskNameField)
        
        //メモ入力欄:delegate設定
        InputTaskMemoView.delegate = self
        //メモ入力欄(透かし文字"メモ:",左寄せ,上寄せ)
        InputTaskMemoView.textAlignment = NSTextAlignment.left
        InputTaskMemoView.layer.borderWidth = 1
        InputTaskMemoView.layer.borderColor = UIColor.gray.cgColor
        InputTaskMemoView.placeHolder = CommonConst.INPUT_TASK_MEMO_PLACE_HOLDER as NSString
        
    }
    
    //タスク終了時刻欄:初期設定
    fileprivate func diplayInputTaskDate(){
        
        
        // ツールバー実装:START
        // キーボードに表示するツールバーの表示
        let pickerToolBar = UIToolbar(frame: CGRect(x:0,y: self.view.frame.size.height/6, width: self.view.frame.size.width, height: 40.0))
        pickerToolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        pickerToolBar.barStyle = .blackOpaque
        pickerToolBar.tintColor = UIColor.white
        pickerToolBar.backgroundColor = UIColor.blue
        //完了ボタンを設定
        let toolBarBtn      = UIBarButtonItem(title: "Clear", style: .done, target: self, action: #selector(TaskEditViewController.onTouch_ToolBarClearBtn))
        //ツールバーにボタンを表示
        pickerToolBar.setItems([toolBarBtn], animated: true)
        pickerToolBar.sizeToFit()
        InputTaskDateField.inputAccessoryView = pickerToolBar
        // ツールバー実装:END
        
        
        //タスク終了時刻入力欄（現在日付,中央寄せ,サイズ自動調整）
        InputTaskDateField.text = FunctionUtility.DateToyyyyMMddHHmm_JP(Date())
        InputTaskDateField.textAlignment = NSTextAlignment.center
        InputTaskDateField.sizeToFit()
        
        //タスク終了時刻入力欄 入力方法：DatePicker
        InputTaskDateField.inputView = inputDatePicker
        //DatePiceker設定（日付時刻,JP）
        inputDatePicker.datePickerMode = UIDatePickerMode.dateAndTime
        inputDatePicker.locale = Locale(identifier : "ja_JP")
        
        //DatePiceker値変更時イベント
        inputDatePicker.addTarget(self, action: #selector(TaskInputViewController.inputDatePickerEdit(_:)), for: UIControlEvents.valueChanged)
        
    }
    
    // ツールバー：クリアボタンタップ時イベント
    func onTouch_ToolBarClearBtn(){
        
        //　タスク終了時刻欄初期化
        InputTaskDateField.text = ""
        
        // 日時格納変数初期化
        
        // picker閉じる
        view.endEditing(true)
        
        // 0.1秒バイブレーション作動
        AudioServicesPlaySystemSound(1003)
        AudioServicesDisposeSystemSoundID(1003)
    }
    
    //通知場所(登録地点リスト):初期設定
    fileprivate func displayInputPoint(){
        
        //登録地点リスト:要素追加イベント(未実装)
        
        
        //登録地点リスト：Delegate,DataSource設定
        inputPointPicker.delegate = self
        inputPointPicker.dataSource = self
        
        //登録地点リスト入力欄　入力方法:PickerView
        InputPointListField.inputView = inputPointPicker
        InputPointListField.textAlignment = NSTextAlignment.center
        
        //登録地点リスト入力欄 リロード
        inputPointPicker.reloadAllComponents()
        
    }
    
    
    //後続タスク追加ボタン:初期設定
    fileprivate func displayAddAfterTaskBtn() {
        
        // メイン画面モード
        switch(self.paramMainViewMode){
        // 現在編集モードの場合
        case CommonConst.ActionType.edit:
            // 後続ボタン:タイトル設定(編集)
            AddAfterTask.setTitle(CommonConst.AFTER_EDIT_TASK_BTN_TITLE, for: UIControlState())
            break;
        // 上記以外の場合(参照モード)
        default:
            // 後続ボタン:タイトル設定(表示)
            AddAfterTask.setTitle(CommonConst.AFTER_DISPLAY_TASK_BTN_TITLE, for: UIControlState())
            break;
        }
        
        //後続タスクボタン:タップ時イベント
        AddAfterTask.addTarget(self, action: #selector(TaskEditViewController.onTouchDown_addAfterTaskButton(_:)), for:.touchUpInside)
        
    }
    
    
    //DatePicker：値変更時イベント
    func inputDatePickerEdit(_ sender: UIDatePicker){
        
        //値をタスク終了時刻入力欄に表示
        InputTaskDateField.text = FunctionUtility.DateToyyyyMMddHHmm_JP(sender.date)
        
        //同一の日付を変数に格納
        inputTaskEndDate = sender.date
        
        // 0.1秒バイブレーション作動
        AudioServicesPlaySystemSound(1003)
        AudioServicesDisposeSystemSoundID(1003)
        
        
    }
    
    
    //後続タスクボタン：タップ時イベント
    func onTouchDown_addAfterTaskButton(_ sender : UIButton){
        
        // タスク編集イベント
        inputEditTask()
        
        // タスク編集画面コントローラー生成
        let vc = storyboard?.instantiateViewController(withIdentifier: "EditStoryBoard") as! TaskEditViewController
        vc.paramTaskId = self.paramTaskId
        vc.paramMainViewMode = self.paramMainViewMode
        vc.paramParrentId = self.paramParrentId
        
        // ナビゲーションバー:レイヤー追加
        self.navigationController?.view.layer.add(navigationTrasitionAnimate(0.7, "pageCurl", kCATransitionFromRight), forKey: kCATransition)
        
        // 後続タスク追加ボタン:編集画面遷移
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    //フォーカスが外れた際、viewを閉じる
    func missFocusView(){
        view.endEditing(true)
    }
    
    
    //編集確定ボタン：タップ時イベント
    func onTouchDown_addEditTaskButton(){
        
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
        
        // EDIT START
        // タスクEntity
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
        
        // テキストカラー
        //taskInfoDataEntity.TextColor = 0
        
        // 親ID
        // 読込タスクの親IDを再設定
        taskInfoDataEntity.ParrentId = self.selfParrentId
        // 中間タスク判別用変数に読込IDを設定
        self.paramParrentId = taskInfoDataEntity.Id
        
        
        // 編集モードである場合
        if(self.paramMainViewMode == CommonConst.ActionType.edit){
            //更新日時
            taskInfoDataEntity.UpdateDateTime = FunctionUtility.DateToyyyyMMddHHmmss(Date(), separation: true)

        }
        
        // タスク更新処理
        TaskInfoUtility.DefaultInstance.SetTaskInfoDataForId(taskInfoDataEntity)
        
        // タスク情報書込み
        TaskInfoUtility.DefaultInstance.WriteTaskInfo()
        
    }
    
    //キーボード「リターンキー」：タップ時イベント
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // キーボードを閉じる
        textField.resignFirstResponder()
        return false
    }
    
    //PicerView　表示列
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    //PicerView　表示行（要素数）
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //要素数(仮　要)
        return aaa.count
    }
    //PicerView　表示要素
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return aaa[row] as? String
    }
    //PicerView　値選択時イベント
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        InputPointListField.text = aaa[row] as? String
        
        // 0.1秒バイブレーション作動
        AudioServicesPlaySystemSound(1003)
        AudioServicesDisposeSystemSoundID(1003)
    }
    
    /// didReceiveMemoryWarningイベント処理
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //オブザーバ解除
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
    
}

