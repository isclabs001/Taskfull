//
//  BaseTaskInputViewController.swift
//  Taskfull
//
//  Created by IscIsc on 2017/04/24.
//  Copyright © 2017年 isc. All rights reserved.
//
//TODO:文字の定数化,登録データ型,登録地点リスト,AutoLayout,入力方法最適化,メソッド順整理

import UIKit
import AudioToolbox

///
/// タスク入力画面
///
class BaseTaskInputViewController : BaseViewController,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate,UITextViewDelegate
{
    /**
     * 定数
     */

    
    /**
     * 変数
     */
    // タスク終了時刻入力DatePiceker
    let inputDatePicker : UIDatePicker = UIDatePicker()
    // 登録地点リスト入力PickerView
    let inputPointPicker : UIPickerView! = UIPickerView()
    
    // 設定日時取得変数
    var inputTaskEndDate : Date = Date()
    
    //登録地点用要素配列（テスト用）
    let aaa : NSArray = ["","自宅","スーパー","aaaaaaaaaaa"]
    
    // パラメータ:読込タスクID,メイン画面:動作モード
    var paramTaskId : Int = -2
    // パラメータ:メイン画面動作モード
    var paramMainViewMode : CommonConst.ActionType = CommonConst.ActionType.add
    // パラメータ:中間タスク判別用変数
    var paramParrentId : Int = -1
    // パラメータ: 読込タスク親ID保存用変数
    var selfParrentId : Int = Int()
    
    // カラーボタンイメージ(全１２色)
    // 重要度：低
    let mImageTaskColorBtn_WHITE : UIImage = UIImage(named: CommonConst.TASK_BUTTON_COLOR_RESOURCE[CommonConst.TASK_BUTTON_COLOR_WHITE])!
    let mImageTaskColorBtn_LIGHT_BLUE : UIImage = UIImage(named: CommonConst.TASK_BUTTON_COLOR_RESOURCE[CommonConst.TASK_BUTTON_COLOR_LIGHT_BLUE])!
    let mImageTaskColorBtn_GLAY : UIImage = UIImage(named: CommonConst.TASK_BUTTON_COLOR_RESOURCE[CommonConst.TASK_BUTTON_COLOR_GLAY])!
    // 重要度：中
    let mImageTaskColorBtn_GREEN : UIImage = UIImage(named: CommonConst.TASK_BUTTON_COLOR_RESOURCE[CommonConst.TASK_BUTTON_COLOR_GREEN])!
    let mImageTaskColorBtn_ORANGE : UIImage = UIImage(named: CommonConst.TASK_BUTTON_COLOR_RESOURCE[CommonConst.TASK_BUTTON_COLOR_ORANGE])!
    let mImageTaskColorBtn_BLUE : UIImage = UIImage(named: CommonConst.TASK_BUTTON_COLOR_RESOURCE[CommonConst.TASK_BUTTON_COLOR_BLUE])!
    // 重要度：高
    let mImageTaskColorBtn_YELLOW : UIImage = UIImage(named: CommonConst.TASK_BUTTON_COLOR_RESOURCE[CommonConst.TASK_BUTTON_COLOR_YELLOW])!
    let mImageTaskColorBtn_PINK : UIImage = UIImage(named: CommonConst.TASK_BUTTON_COLOR_RESOURCE[CommonConst.TASK_BUTTON_COLOR_PINK])!
    let mImageTaskColorBtn_PURPLE : UIImage = UIImage(named: CommonConst.TASK_BUTTON_COLOR_RESOURCE[CommonConst.TASK_BUTTON_COLOR_PURPLE])!
    // 重要度：至急
    let mImageTaskColorBtn_DARK_YELLOW : UIImage = UIImage(named: CommonConst.TASK_BUTTON_COLOR_RESOURCE[CommonConst.TASK_BUTTON_COLOR_DARK_YELLOW])!
    let mImageTaskColorBtn_DARK_PINK : UIImage = UIImage(named: CommonConst.TASK_BUTTON_COLOR_RESOURCE[CommonConst.TASK_BUTTON_COLOR_DARK_PINK])!
    let mImageTaskColorBtn_DARK_PURPLE : UIImage = UIImage(named: CommonConst.TASK_BUTTON_COLOR_RESOURCE[CommonConst.TASK_BUTTON_COLOR_DARK_PURPLE])!

    
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
    }
    
    //キーボード「リターンキー」：タップ時イベント
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // キーボードを閉じる
        textField.resignFirstResponder()
        return false
    }
    
    // 選択地点の設定
    func setSelectedPoint(textField : UITextField, row: Int) {
        // 選択項目をUITextFieldに設定する
        textField.text = aaa[row] as? String
        
        // 0.1秒バイブレーション作動
        actionViblation()
    }
    
    // didReceiveMemoryWarningイベント処理
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //　オブザーバ解除
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
    /// 初期化処理
    func initializeMainProc(mainView : UICustomView) ->Bool
    {
        // 基底のinitializeProcを呼び出す
        var ret : Bool = super.initializeProc()
        
        //　正常な場合
        if(true == ret)
        {
            // 背景色設定
            mainView.gradationBackgroundStartColor = CommonConst.CL_BACKGROUND_GRADIATION_BLUE_2
            mainView.gradationBackgroundEndColor = CommonConst.CL_BACKGROUND_GRADIATION_BLUE_1

            //　view:フォーカスが外れた際のイベント
            let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(missFocusView))
            view.addGestureRecognizer(tap)
            
            
            // 編集画面用ナビゲーションバー：初期設定
            displayTopMenu()
            
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
    
    //フォーカスが外れた際のイベント処理
    func missFocusView(){
        // viewを閉じる
        view.endEditing(true)
    }
    
    // ナビゲーションバー：初期設定
    fileprivate func displayTopMenu(){
        
        // ナビゲーションバー表示
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        // ナビゲーションバー背景色
        self.navigationController?.navigationBar.backgroundColor = UIColorUtility.rgb(107, g: 133, b: 194)
        
        // ナビゲーションバーBACKボタンタイトル設定
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"Back",style:.plain,target:nil,action:nil)
        
        
        // メイン画面モード
        switch(self.paramMainViewMode){
        // 現在登録・編集モードの場合
        case CommonConst.ActionType.add, CommonConst.ActionType.edit:
            //編集確定ボタン生成("OK")
            let decideEditTaskButton : UIBarButtonItem = UIBarButtonItem(title:"OK",style : UIBarButtonItemStyle.plain,target: self,action:#selector(TaskEditViewController.onTouchDown_decideEditTaskButton))
            
            //ボタンをナビゲーションバー右側に配置
            self.navigationItem.setRightBarButtonItems([decideEditTaskButton], animated: true)
            break;
            
        // 上記以外の場合(参照モード)
        default:
            break;
        }
        
        // メイン画面モード
        switch(self.paramMainViewMode){
        // 現在登録モードの場合
        case CommonConst.ActionType.add:
            //タイトル名設定
            self.title = CommonConst.VIW_TITLE_INPUT_TASK
            break;
            
        // 現在編集モードの場合
        case CommonConst.ActionType.edit:
            //タイトル名設定(編集)
            self.title = CommonConst.VIW_TITLE_EDIT_TASK
            break;
            
        // 上記以外の場合(参照モード)
        default:
            //タイトル名設定(タスク内容)
            self.title = CommonConst.VIW_TITLE_CONTENT_TASK
            break;
        }
    }
    
    // 確定ボタン：タップ時イベント
    func onTouchDown_decideEditTaskButton(){}
    
    // 登録内容入力欄設定
    func displayInputField(){}
    
    // タスク内容初期表示処理
    func displayTaskContent(){}
    
    // 遷移先モード分岐処理
    func displayTaskModeChange(){}
    
    //タスクカラーボタン:初期設定
    func dispayInputTaskColorBtn(btn1 : UICustomButton!, btn2 : UICustomButton!, btn3 : UICustomButton!, inputImportanceSegment: UISegmentedControl!){
        
        //タスクカラーボタン:初期値設定
        changeColorBtn(inputImportanceSegment.selectedSegmentIndex, btn1 : btn1, btn2 : btn2, btn3 : btn3)
        
        //タスクカラーボタン_1:タップ時イベント設定
        btn1.addTarget(self, action: #selector(onTouchDown_btn1(_:)), for: .touchUpInside)
        
        //タスクカラーボタン_2:タップ時イベント設定
        btn2.addTarget(self, action: #selector(onTouchDown_btn2(_:)), for: .touchUpInside)
        
        //タスクカラーボタン_3:タップ時イベント設定
        btn3.addTarget(self, action: #selector(onTouchDown_btn3(_:)), for: .touchUpInside)
        
        //タスクカラーボタン:初期値設定
        btn1.isSelected = false
        btn2.isSelected = true
        btn3.isSelected = false
        btn1.setBackgroundColor(UIColor.clear, forUIControlState: UIControlState())
        btn2.setBackgroundColor(CommonConst.CL_TASK_BTN_BACK_GROUND_COLOR, forUIControlState: UIControlState())
        btn3.setBackgroundColor(UIColor.clear, forUIControlState: UIControlState())
    }
    
    // タスクカラーボタン変更処理
    func changeInputTaskColorBtn(selectedBtnIndex : Int, btn1 : UICustomButton!, btn2 : UICustomButton!, btn3 : UICustomButton!){
        
        switch(selectedBtnIndex) {
        case 1:
            btn1.isSelected = false
            btn2.isSelected = true
            btn3.isSelected = false
            btn1.setBackgroundColor(UIColor.clear, forUIControlState: UIControlState())
            btn2.setBackgroundColor(CommonConst.CL_TASK_BTN_BACK_GROUND_COLOR, forUIControlState: UIControlState())
            btn3.setBackgroundColor(UIColor.clear, forUIControlState: UIControlState())
            break
        case 2:
            btn1.isSelected = false
            btn2.isSelected = false
            btn3.isSelected = true
            btn1.setBackgroundColor(UIColor.clear, forUIControlState: UIControlState())
            btn2.setBackgroundColor(UIColor.clear, forUIControlState: UIControlState())
            btn3.setBackgroundColor(CommonConst.CL_TASK_BTN_BACK_GROUND_COLOR, forUIControlState: UIControlState())
            break
            
        default:
            btn1.isSelected = true
            btn2.isSelected = false
            btn3.isSelected = false
            btn1.setBackgroundColor(CommonConst.CL_TASK_BTN_BACK_GROUND_COLOR, forUIControlState: UIControlState())
            btn2.setBackgroundColor(UIColor.clear, forUIControlState: UIControlState())
            btn3.setBackgroundColor(UIColor.clear, forUIControlState: UIControlState())
            break
            
        }
    }
    
    //カラーボタン変更処理(引数:重要度)
    fileprivate func changeColorBtn(_ caseNumber : Int, btn1 : UICustomButton!, btn2 : UICustomButton!, btn3 : UICustomButton!){
        
        switch caseNumber {
            
        //"低"の場合
        case CommonConst.TASK_IMPORTANCE_VALID_LOW:
            // カラーボタン色変更(画像セット,タイトル:定数)
            btn1.setImage(mImageTaskColorBtn_WHITE, for: UIControlState())
            btn1.setTitle(String(CommonConst.TASK_BUTTON_COLOR_WHITE), for: UIControlState())
            btn2.setImage(mImageTaskColorBtn_LIGHT_BLUE, for: UIControlState())
            btn2.setTitle(String(CommonConst.TASK_BUTTON_COLOR_LIGHT_BLUE), for: UIControlState())
            btn3.setImage(mImageTaskColorBtn_GLAY, for: UIControlState())
            btn3.setTitle(String(CommonConst.TASK_BUTTON_COLOR_GLAY), for: UIControlState())
            
        //"中"の場合
        case CommonConst.TASK_COMPLETE_FLAG_VALID_MEDIUM:
            // カラーボタン色変更(画像セット,タイトル:定数)
            btn1.setImage(mImageTaskColorBtn_GREEN, for: UIControlState())
            btn1.setTitle(String(CommonConst.TASK_BUTTON_COLOR_GREEN), for: UIControlState())
            btn2.setImage(mImageTaskColorBtn_ORANGE, for: UIControlState())
            btn2.setTitle(String(CommonConst.TASK_BUTTON_COLOR_ORANGE), for: UIControlState())
            btn3.setImage(mImageTaskColorBtn_BLUE, for: UIControlState())
            btn3.setTitle(String(CommonConst.TASK_BUTTON_COLOR_BLUE), for: UIControlState())
            
        //"高"の場合
        case CommonConst.TASK_COMPLETE_FLAG_VALID_HIGH:
            // カラーボタン色変更(画像セット,タイトル:定数)
            btn1.setImage(mImageTaskColorBtn_YELLOW, for: UIControlState())
            btn1.setTitle(String(CommonConst.TASK_BUTTON_COLOR_YELLOW), for: UIControlState())
            btn2.setImage(mImageTaskColorBtn_PINK, for: UIControlState())
            btn2.setTitle(String(CommonConst.TASK_BUTTON_COLOR_PINK), for: UIControlState())
            btn3.setImage(mImageTaskColorBtn_PURPLE, for: UIControlState())
            btn3.setTitle(String(CommonConst.TASK_BUTTON_COLOR_PURPLE), for: UIControlState())
            
        //"至急"の場合
        case CommonConst.TASK_COMPLETE_FLAG_VALID_URGENT:
            // カラーボタン色変更(画像セット,タイトル:定数)
            btn1.setImage(mImageTaskColorBtn_DARK_YELLOW, for: UIControlState())
            btn1.setTitle(String(CommonConst.TASK_BUTTON_COLOR_DARK_YELLOW), for: UIControlState())
            btn2.setImage(mImageTaskColorBtn_DARK_PINK, for: UIControlState())
            btn2.setTitle(String(CommonConst.TASK_BUTTON_COLOR_DARK_PINK), for: UIControlState())
            btn3.setImage(mImageTaskColorBtn_DARK_PURPLE, for: UIControlState())
            btn3.setTitle(String(CommonConst.TASK_BUTTON_COLOR_DARK_PURPLE), for: UIControlState())
            
        default:
            break
        }
    }
    
    //タスクカラーボタン_1:タップ時イベント
    func onTouchDown_btn1(_ sender:UIButton){}
    
    //タスクカラーボタン_2:タップ時イベント
    func onTouchDown_btn2(_ sender:UIButton){}
    
    //タスクカラーボタン_3:タップ時イベント
    func onTouchDown_btn3(_ sender:UIButton){}

    //項目名入力欄,メモ入力欄:初期設定
    func displayInputTaskName(taskNameField: UITextField!){
        
        //項目名入力欄:delegate設定
        taskNameField.delegate  = self
        //項目名入力欄(透かし文字,左寄せ)要定数化
        taskNameField.placeholder = CommonConst.INPUT_TASK_NAME_PLACE_HOLDER
        taskNameField.textAlignment = NSTextAlignment.left
        //項目名入力欄:編集完了時イベント(TODO:textView同様デリゲートメソッドにて実装？)
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidChange(_:)), name: NSNotification.Name.UITextFieldTextDidChange, object: taskNameField)
    }
    
    //textView:値変更確定時イベント
    func textViewDidChange(_ textView: UITextView) {}
    
    // textField:編集完了時イベント
    func textFieldDidChange(_ nsNotification: Notification) {}
    
    //項目名入力欄,メモ入力欄:初期設定
    func displayInputTaskMemo(taskMemoView: UIPlaceHolderTextView!){
        //メモ入力欄:delegate設定
        taskMemoView.delegate = self
        //メモ入力欄(透かし文字"メモ:",左寄せ,上寄せ)
        taskMemoView.textAlignment = NSTextAlignment.left
        taskMemoView.layer.borderWidth = 1
        taskMemoView.layer.borderColor = UIColor.gray.cgColor
        taskMemoView.placeHolder = CommonConst.INPUT_TASK_MEMO_PLACE_HOLDER as NSString
    }
    
    //タスク終了時刻欄:初期設定
    func diplayInputTaskDate(taskDateField: UITextField!){
        
        // ツールバー実装:START
        // キーボードに表示するツールバーの表示
        let pickerToolBar = UIToolbar(frame: CGRect(x:0,y: self.view.frame.size.height/6, width: self.view.frame.size.width, height: 40.0))
        pickerToolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        pickerToolBar.barStyle = .blackOpaque
        pickerToolBar.tintColor = UIColor.white
        pickerToolBar.backgroundColor = UIColor.blue
        //完了ボタンを設定
        let toolBarBtn      = UIBarButtonItem(title: "Clear", style: .done, target: self, action: #selector(TaskInputViewController.onTouch_ToolBarClearBtn))
        //ツールバーにボタンを表示
        pickerToolBar.setItems([toolBarBtn], animated: true)
        pickerToolBar.sizeToFit()
        taskDateField.inputAccessoryView = pickerToolBar
        // ツールバー実装:END
        
        
        //タスク終了時刻入力欄（現在日付,中央寄せ,サイズ自動調整）
        // 親タスクである場合
        if(paramTaskId == -2){
            // タスク終了時刻入力欄を現在時刻に設定
            taskDateField.text = FunctionUtility.DateToyyyyMMddHHmm_JP(Date())
            taskDateField.textAlignment = NSTextAlignment.center
            taskDateField.sizeToFit()
            
        }
            // 子タスクである場合
        else{
            // 親タスクの終了時刻取得
            let taskInfo : TaskInfoDataEntity = TaskInfoUtility.DefaultInstance.GetTaskInfoDataForId(paramTaskId)!
            taskDateField.text = FunctionUtility.DateToyyyyMMddHHmm_JP(FunctionUtility.yyyyMMddHHmmssToDate(taskInfo.DateTime))
            // タスク終了時刻取得変数へ親タスク終了時刻格納
            inputTaskEndDate = FunctionUtility.yyyyMMddHHmmssToDate(taskInfo.DateTime)
            taskDateField.textAlignment = NSTextAlignment.center
            taskDateField.sizeToFit()
            // DatePicker開始時刻＝親タスク終了時刻
            inputDatePicker.setDate(inputTaskEndDate, animated: false)
        }
        
        
        //タスク終了時刻入力欄 入力方法：DatePicker
        taskDateField.inputView = inputDatePicker
        //DatePiceker設定（日付時刻,JP）
        inputDatePicker.datePickerMode = UIDatePickerMode.dateAndTime
        inputDatePicker.locale = Locale(identifier : "ja_JP")
        
        //DatePiceker値変更時イベント設定
        inputDatePicker.addTarget(self, action: #selector(inputDatePickerEdit(_:)), for: UIControlEvents.valueChanged)
        
    }

    // ツールバー：クリアボタンタップ時イベント
    func onTouch_ToolBarClearBtn(){}

    // ツールバー：クリアボタン処理
    func clearToolBarButton(taskDateField: UITextField!) {
        //　タスク終了時刻欄初期化
        taskDateField.text = StringUtility.EMPTY
        
        // 日時格納変数初期化
        
        // picker閉じる
        view.endEditing(true)
        
        // 0.1秒バイブレーション作動
        actionViblation()
    }
    
    
    //Datepicer：値変更時イベント
    func inputDatePickerEdit(_ sender: UIDatePicker){}

    //Datepicer：値変更時イベント
    func updateInputDatePicker(_ sender: UIDatePicker, taskDateField: UITextField!){
        // 値をタスク終了時刻入力欄に表示
        taskDateField.text = FunctionUtility.DateToyyyyMMddHHmm_JP(sender.date)
        
        //  同一値をタスク終了時刻取得変数に格納
        inputTaskEndDate = sender.date
        
        // 0.1秒バイブレーション作動
        actionViblation()
    }

    
    //通知場所(登録地点リスト):初期設定
    func displayInputPoint(pointListField: UITextField!){
        
        //登録地点リスト:要素追加イベント(未実装)
        
        
        //登録地点リスト：Delegate,DataSource設定
        self.inputPointPicker.delegate = self
        self.inputPointPicker.dataSource = self
        
        //登録地点リスト入力欄　入力方法:PickerView
        pointListField.inputView = inputPointPicker
        pointListField.textAlignment = NSTextAlignment.center
        
        //登録地点リスト入力欄 リロード
        self.inputPointPicker.reloadAllComponents()
        
    }
    
    //重要度:初期設定
    func displayInputImportanceSegment(importanceSegment: UISegmentedControl!){
        
        //重要度:セグメント値変更時イベント
        importanceSegment.addTarget(self, action: #selector(onTouchDown_InputImportanceSegment(_:)), for: .valueChanged)
        
    }

    //重要度:セグメント値変更時イベント
    func onTouchDown_InputImportanceSegment(_ segcon:UISegmentedControl){}

    // 重要度:セグメント値変更時処理
    func didChengeImportanceSegmentValue(_ importanceSegmentIndex: Int, btn1 : UICustomButton!, btn2 : UICustomButton!, btn3 : UICustomButton!){
        
        //各セグメント選択時分岐処理
        switch importanceSegmentIndex {
            
        //"低"の場合
        case CommonConst.TASK_IMPORTANCE_VALID_LOW:
            //カラーボタン変更イベント
            changeColorBtn(CommonConst.TASK_IMPORTANCE_VALID_LOW, btn1 : btn1, btn2 : btn2, btn3 : btn3)
            
        //"中"の場合
        case CommonConst.TASK_COMPLETE_FLAG_VALID_MEDIUM:
            //カラーボタン変更イベント
            changeColorBtn(CommonConst.TASK_COMPLETE_FLAG_VALID_MEDIUM, btn1 : btn1, btn2 : btn2, btn3 : btn3)
            
        //"高"の場合
        case CommonConst.TASK_COMPLETE_FLAG_VALID_HIGH:
            //カラーボタン変更イベント
            changeColorBtn(CommonConst.TASK_COMPLETE_FLAG_VALID_HIGH, btn1 : btn1, btn2 : btn2, btn3 : btn3)
            
        //"至急"の場合
        case CommonConst.TASK_COMPLETE_FLAG_VALID_URGENT:
            //カラーボタン変更イベント
            changeColorBtn(CommonConst.TASK_COMPLETE_FLAG_VALID_URGENT, btn1 : btn1, btn2 : btn2, btn3 : btn3)
            
        default:
            //要エラー対応時イベント
            break
        }
    }
    
    //後続タスク追加ボタン:初期設定
    func displayAddAfterTaskBtn(addAfterTask: UIButton!) {

        
        // メイン画面モード
        switch(self.paramMainViewMode){
        // 現在編集モードの場合
        case CommonConst.ActionType.add:
            // 後続ボタン:タイトル設定(登録)
            addAfterTask.setTitle(CommonConst.AFTER_ADD_TASK_BTN_TITLE, for: UIControlState())
            break;
        // 現在編集モードの場合
        case CommonConst.ActionType.edit:
            // 後続ボタン:タイトル設定(編集)
            addAfterTask.setTitle(CommonConst.AFTER_EDIT_TASK_BTN_TITLE, for: UIControlState())
            break;
        // 上記以外の場合(参照モード)
        default:
            // 後続ボタン:タイトル設定(表示)
            addAfterTask.setTitle(CommonConst.AFTER_DISPLAY_TASK_BTN_TITLE, for: UIControlState())
            break;
        }

        // 後続タスク追加ボタン:タップ時イベント
        addAfterTask.addTarget(self, action: #selector(onTouchDown_addAfterTaskButton(_:)), for:.touchUpInside)
        
        // TODO:後続タスク制限数の為後続ボタン隠す(4/21)
        if(self.paramTaskId != -2){
            addAfterTask.isHidden = true
            addAfterTask.isEnabled = false
        }
        else{
            addAfterTask.isHidden = false
            addAfterTask.isEnabled = true
        }
    }
    
    //後続タスクボタン：タップ時イベント
    func onTouchDown_addAfterTaskButton(_ sender : UIButton){}

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
    
    // バイブレーション作動
    func actionViblation() {
        // 0.1秒バイブレーション作動
        AudioServicesPlaySystemSound(1003)
        AudioServicesDisposeSystemSoundID(1003)
    }
}


