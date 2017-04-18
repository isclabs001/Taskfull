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
class TaskInputViewController : BaseViewController,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate,UITextViewDelegate
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
    fileprivate let mImageTaskColorBtn_PURPLE : UIImage = UIImage(named: CommonConst.TASK_BUTTON_COLOR_RESOURCE[CommonConst.TASK_BUTTON_COLOR_PURPLE])!
    // 重要度：至急
    fileprivate let mImageTaskColorBtn_DARK_YELLOW : UIImage = UIImage(named: CommonConst.TASK_BUTTON_COLOR_RESOURCE[CommonConst.TASK_BUTTON_COLOR_DARK_YELLOW])!
    fileprivate let mImageTaskColorBtn_DARK_PINK : UIImage = UIImage(named: CommonConst.TASK_BUTTON_COLOR_RESOURCE[CommonConst.TASK_BUTTON_COLOR_DARK_PINK])!
    fileprivate let mImageTaskColorBtn_DARK_PURPLE : UIImage = UIImage(named: CommonConst.TASK_BUTTON_COLOR_RESOURCE[CommonConst.TASK_BUTTON_COLOR_DARK_PURPLE])!
    
    
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
            // 背景色設定（緑のグラデーション）
            self.MainView.gradationBackgroundStartColor = UIColorUtility.rgb(222, g: 255, b: 255)
            self.MainView.gradationBackgroundEndColor = UIColorUtility.rgb(10, g: 209, b: 47)
            //self.MainView.gradationBackgroundEndColor = UIColorUtility.rgb(0, g: 30, b: 183)

            // 登録内容入力欄の初期化(不要？)

            
            //view:フォーカスが外れた際のイベント
            let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TaskInputViewController.missFocusView))
            view.addGestureRecognizer(tap)
            
            // 登録画面用ナビゲーションバー：初期設定
            displayInputTopMenu()
            
            // 登録内容入力欄を設定　※詳細表示画面との要分岐処理
            displayInputField()

            // 戻り値にtrueを設定
            ret = true
        }
        
        return ret
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

    
    
    // 登録画面用ナビゲーションバー：初期設定
    fileprivate func displayInputTopMenu(){

        // ナビゲーションバー表示
        navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.backgroundColor = UIColor.green
        
        
        //登録確定ボタン生成("OK")
        let addInputTaskButton : UIBarButtonItem = UIBarButtonItem(title:"OK",style : UIBarButtonItemStyle.plain,target: self,action:#selector(TaskInputViewController.onTouchDown_addInputTaskButton))
        
        //タイトル名設定
        self.title = CommonConst.VIW_TITLE_INPUT_TASK

        //ボタンをナビゲーションバー右側に配置
        self.navigationItem.setRightBarButtonItems([addInputTaskButton], animated: true)
        
    }
    
    //登録内容入力欄設定
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
        InputImportanceSegment.addTarget(self, action: #selector(TaskInputViewController.onTouchDown_InputImportanceSegment(_:)), for: .valueChanged)

    }
    
    //重要度:セグメント値変更時イベント
    func onTouchDown_InputImportanceSegment(_ segcon:UISegmentedControl){
        
        //各セグメント選択時分岐処理
        switch segcon.selectedSegmentIndex {
            
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
    
    //カラーボタン変更処理(引数:重要度)
    fileprivate func changeColorBtn(_ caseNumber : Int){
    
        switch caseNumber {
            
        //"低"の場合
        case CommonConst.TASK_IMPORTANCE_VALID_LOW:
            // カラーボタン色変更
            InputTaskColorBtn_1.setImage(mImageTaskColorBtn_WHITE, for: UIControlState())
            InputTaskColorBtn_1.setTitle(String(CommonConst.TASK_BUTTON_COLOR_WHITE), for: UIControlState())
            InputTaskColorBtn_2.setImage(mImageTaskColorBtn_LIGHT_BLUE, for: UIControlState())
            InputTaskColorBtn_2.setTitle(String(CommonConst.TASK_BUTTON_COLOR_LIGHT_BLUE), for: UIControlState())
            InputTaskColorBtn_3.setImage(mImageTaskColorBtn_GLAY, for: UIControlState())
            InputTaskColorBtn_3.setTitle(String(CommonConst.TASK_BUTTON_COLOR_GLAY), for: UIControlState())
            
        //"中"の場合
        case CommonConst.TASK_COMPLETE_FLAG_VALID_MEDIUM:
            // カラーボタン色変更
            InputTaskColorBtn_1.setImage(mImageTaskColorBtn_GREEN, for: UIControlState())
            InputTaskColorBtn_1.setTitle(String(CommonConst.TASK_BUTTON_COLOR_GREEN), for: UIControlState())
            InputTaskColorBtn_2.setImage(mImageTaskColorBtn_ORANGE, for: UIControlState())
            InputTaskColorBtn_2.setTitle(String(CommonConst.TASK_BUTTON_COLOR_ORANGE), for: UIControlState())
            InputTaskColorBtn_3.setImage(mImageTaskColorBtn_BLUE, for: UIControlState())
            InputTaskColorBtn_3.setTitle(String(CommonConst.TASK_BUTTON_COLOR_BLUE), for: UIControlState())
            
        //"高"の場合
        case CommonConst.TASK_COMPLETE_FLAG_VALID_HIGH:
            // カラーボタン色変更
            InputTaskColorBtn_1.setImage(mImageTaskColorBtn_YELLOW, for: UIControlState())
            InputTaskColorBtn_1.setTitle(String(CommonConst.TASK_BUTTON_COLOR_YELLOW), for: UIControlState())
            InputTaskColorBtn_2.setImage(mImageTaskColorBtn_PINK, for: UIControlState())
            InputTaskColorBtn_2.setTitle(String(CommonConst.TASK_BUTTON_COLOR_PINK), for: UIControlState())
            InputTaskColorBtn_3.setImage(mImageTaskColorBtn_PURPLE, for: UIControlState())
            InputTaskColorBtn_3.setTitle(String(CommonConst.TASK_BUTTON_COLOR_PURPLE), for: UIControlState())
            
        //"至急"の場合
        case CommonConst.TASK_COMPLETE_FLAG_VALID_URGENT:
            // カラーボタン色変更
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
        // タイトル設定
        AddAfterTask.setTitle(CommonConst.AFTER_ADD_TASK_BTN_TITLE, for: UIControlState())
        
        // 後続タスク追加ボタン:タップ時イベント
        AddAfterTask.addTarget(self, action: #selector(TaskInputViewController.onTouchDown_addAfterTaskButton(_:)), for:.touchUpInside)
        
    }
    
    
    //Datepicer：値変更時イベント
    func inputDatePickerEdit(_ sender: UIDatePicker){
        //値をタスク終了時刻入力欄に表示
        InputTaskDateField.text = FunctionUtility.DateToyyyyMMddHHmm_JP(sender.date)
        
        //同一の日付を変数に格納
        inputTaskEndDate = sender.date
        
        
    }
    
    
    //後続タスクボタン：タップ時イベント
    func onTouchDown_addAfterTaskButton(_ sender : UIButton){
        /*
        let AddAfterTaskInputView = TESTViewController()
        AddAfterTaskInputView.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
self.presentViewController(AddAfterTaskInputView, animated: true, completion: nil)
 */
    }
    
    
    //フォーカスが外れた際、viewを閉じる
    func missFocusView(){
        view.endEditing(true)
    }

    
    //登録確定ボタン：タップ時イベント
    func onTouchDown_addInputTaskButton(){
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
        taskInfoDataEntity.ParrentId = -1
        
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
        
        // TODO:押下時の処理を記述する
        // タスク入力画面を表示
        //self.performSegueWithIdentifier(MainViewController.SEGUE_IDENTIFIER_TASK_INPUT, sender: self)
        
        // バイブレーション作動：テスト実装
        //AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        
        //メイン画面へ遷移
        self.navigationController?.popViewController(animated: true)

        
    }
    
    
    //キーボード「リターンキー」：タップ時イベント
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //キーボードを閉じる
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


