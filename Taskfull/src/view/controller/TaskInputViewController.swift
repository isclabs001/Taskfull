//
//  TaskInputViewControler.swift
//  Taskfull
//
//  Created by IscIsc on 2017/03/11.
//  Copyright © 2017年 isc. All rights reserved.
//


import UIKit

///
/// タスク入力画面
///
class TaskInputViewController : BaseViewController,UIPickerViewDelegate,UIPickerViewDataSource
{
/**
 * 定数
 */
    // タスク終了時刻入力DatePiceker
    let inputDatePicker : UIDatePicker = UIDatePicker()
    // 登録地点リスト入力PickerView
    let inputPointPicker : UIPickerView! = UIPickerView()
    
    //登録地点用要素配列（テスト用）
    let aaa : NSArray = ["","自宅","スーパー","aaaaaaaaaaa"]
/**
 * 変数
 */

    /**
     * 登録内容入力欄
     */
    @IBOutlet weak var InputTaskNameField: UITextField!
    @IBOutlet weak var InputPointListField: UITextField!
    @IBOutlet weak var lblInputPointList: UILabel!
    @IBOutlet weak var InputTaskMemoView: UITextView!
    @IBOutlet weak var InputTaskDateField: UITextField!
    @IBOutlet weak var AddAfterTask: UIButton!
    @IBOutlet weak var btnInputImportanceLow: UICustomButton!
    @IBOutlet weak var btnInputImportanceMedium: UICustomButton!
    @IBOutlet weak var btnInputImportanceHigh: UICustomButton!
    @IBOutlet weak var btnInputImportanceUrgent: UICustomButton!
   
    
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
            // 登録内容入力欄の初期化
            
            

            //viewからフォーカスが外れた際の動作
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
    
    
    // 登録画面用ナビゲーションバー：初期設定
    private func displayInputTopMenu(){

        //登録確定ボタン生成("OK")
        let addInputTaskButton : UIBarButtonItem = UIBarButtonItem(title:"OK",style : UIBarButtonItemStyle.Plain,target: self,action:#selector(TaskInputViewController.onTouchDown_addInputTaskButton))
        
        //タイトル名設定
        self.title = CommonConst.VIW_TITLE_INPUT_TASK

        //ボタンをナビゲーションバー右側に配置
        self.navigationItem.setRightBarButtonItems([addInputTaskButton], animated: true)
        
        
    }
    
    //登録内容入力欄設定
    private func displayInputField(){
        
        //項目名入力欄,メモ入力欄:初期設定
        displayInputTaskNameMemo()
        
        //タスク終了時刻欄:初期設定
        diplayInputTaskDate()
        
        //通知場所:初期設定
        displayInputPoint()
        
        //重要度:初期設定
        displayInputImportanceBtn()
        
        //後続タスクボタン:初期設定
        displayAddAfterTaskBtn()
        
    }
    
    //重要度:初期設定
    private func displayInputImportanceBtn(){
        //重要度ボタン:低
        btnInputImportanceLow.setTitle("低", forState: .Normal)
        //重要度ボタン:中
        btnInputImportanceMedium.setTitle("中", forState: .Normal)
        //重要度ボタン:高
        btnInputImportanceHigh.setTitle("高", forState: .Normal)
        //重要度ボタン:至急
        btnInputImportanceUrgent.setTitle("至急", forState: .Normal)
    }
    
    //項目名入力欄,メモ入力欄:初期設定
    private func displayInputTaskNameMemo(){
        
        //項目名入力欄(透かし文字,左寄せ)要定数化
        InputTaskNameField.placeholder = "項目名:"
        InputTaskNameField.textAlignment = NSTextAlignment.Left
        
        //メモ入力欄(透かし文字,左寄せ,上寄せ)
        //InputTaskMemoView.placeholder = "メモ:"
        InputTaskMemoView.textAlignment = NSTextAlignment.Left
        InputTaskMemoView.layer.borderWidth = 1
        InputTaskMemoView.layer.borderColor = UIColor.grayColor().CGColor
        //InputTaskMemoView.layer.shadowOpacity = 0.1
        //InputTaskMemoView.layer.masksToBounds = false
        
        //InputTaskMemoView.contentVerticalAlignment = UIControlContentVerticalAlignment.Top
        
    }
    
    //タスク終了時刻欄:初期設定
    private func diplayInputTaskDate(){
        
        //タスク終了時刻入力欄（現在日付,中央寄せ,サイズ自動調整）
        InputTaskDateField.text = FunctionUtility.DateToyyyyMMddHHmm_JP(NSDate())
        InputTaskDateField.textAlignment = NSTextAlignment.Center
        InputTaskDateField.sizeToFit()
        
        //タスク終了時刻入力欄 入力方法：DatePicker
        InputTaskDateField.inputView = inputDatePicker
        
        //DatePiceker設定（日付時刻,JP）
        inputDatePicker.datePickerMode = UIDatePickerMode.DateAndTime
        inputDatePicker.locale = NSLocale(localeIdentifier : "ja_JP")
        
        //DatePiceker値変更時イベント
        inputDatePicker.addTarget(self, action: #selector(TaskInputViewController.inputDatePickerEdit(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
    }
    
    //通知場所(登録地点リスト):初期設定
    private func displayInputPoint(){
        
        //通知場所名ラベル
        lblInputPointList.text = "通知場所"
        lblInputPointList.font = UIFont.systemFontOfSize(15)
        //lblInputPointList.sizeToFit()
        
        //登録地点リスト:要素追加イベント(未実装)
        
        
        //登録地点リスト：Delegate,DataSource設定
        inputPointPicker.delegate = self
        inputPointPicker.dataSource = self
        
        //登録地点リスト入力欄　入力方法:PickerView
        InputPointListField.inputView = inputPointPicker
        InputPointListField.textAlignment = NSTextAlignment.Center
        
        //登録地点リスト入力欄 リロード
        inputPointPicker.reloadAllComponents()
        
    }
    
    //後続タスク追加ボタン:初期設定
    private func displayAddAfterTaskBtn() {
        AddAfterTask.setTitle("後続タスク追加", forState: UIControlState.Normal)
        //各プロパティ: 後でカスタムボタンにて設定
        AddAfterTask.layer.cornerRadius = 10.0
        AddAfterTask.layer.masksToBounds = true
        AddAfterTask.backgroundColor = UIColor.orangeColor()
        //AddAfterTask.setBackgroundColor(UIColor.blackColor(), forUIControlState: .Highlighted)
        
        
        AddAfterTask.addTarget(self, action: #selector(TaskInputViewController.onTouchDown_addAfterTaskButton(_:)), forControlEvents:.TouchUpInside)
        
    }
    
    //後続タスクボタン：タップ時イベント
    func onTouchDown_addAfterTaskButton(sender : UIButton){
        
        //let AddAfterTaskInputView = TaskInputViewController()
        //AddAfterTaskInputView.modalTransitionStyle = UIModalTransitionStyle.PartialCurl
        //self.navigationController?.pushViewController(AddAfterTaskInputView, animated: true)
        
        //後続タスク作成イベント
        
    }

    //Datepicer：値変更時イベント
    func inputDatePickerEdit(sender: UIDatePicker){
        //値をタスク終了時刻入力欄に表示
        InputTaskDateField.text = FunctionUtility.DateToyyyyMMddHHmm_JP(sender.date)

    }
    
    //フォーカスが外れた際、viewを閉じる
    func missFocusView(){
        view.endEditing(true)
    }

    
    //登録確定ボタン：タップ時イベント
    func onTouchDown_addInputTaskButton(){
        //タスク登録イベント実装
        
    }
    

    //PicerView　表示列
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    //PicerView　表示行（要素数）
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //要素数(仮　要)
        return aaa.count
    }
    //PicerView　表示要素
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return aaa[row] as? String
    }
    //PicerView　値選択時イベント
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        InputPointListField.text = aaa[row] as? String
    }
 
    
    /// didReceiveMemoryWarningイベント処理
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


