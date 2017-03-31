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
        var imageFile: String = ""
        var title: String = ""
        var memo: String = ""
        var datetime: String = ""
        var aaa : UITaskImageButton

        x = 100
        y = 50
        width = 32
        height = 32
        imageFile = "soap001.png"
        title = "1234567890"
        memo = "memo"
        datetime = "2017/01/05 18:30:40"

        aaa = UITaskImageButton(frame: CGRect(x: x,y: y,width: width,height: height))
        aaa.btnImage.setImageInfo(UIImage(named: imageFile), width:width , height:height)
        aaa.btnImage.tag = 1
        aaa.btnImage.addTarget(self, action: #selector(MainViewController.onTouchDown_TaskCirclrImageButton(_:)), forControlEvents: .TouchDown)
        self.mArrayTaskImageButton.append(aaa)
        aaa.labelTitle = title
        aaa.labelMemo = memo
        aaa.labelDateTime = datetime
        
        x = 200
        y = 50
        width = 64
        height = 64
        imageFile = "soap002.png"
        title = "2345678901"
        memo = "memo2"
        datetime = "2017/02/15 00:10:00"

        aaa = UITaskImageButton(frame: CGRect(x: x,y: y,width: width,height: height))
        aaa.btnImage.setImageInfo(UIImage(named: imageFile), width:width , height:height)
        aaa.btnImage.tag = 2
        aaa.btnImage.addTarget(self, action: #selector(MainViewController.onTouchDown_TaskCirclrImageButton(_:)), forControlEvents: .TouchDown)
        self.mArrayTaskImageButton.append(aaa)
        aaa.labelTitle = title
        aaa.labelMemo = memo
        aaa.labelDateTime = datetime
        
        x = 200
        y = 150
        width = 128
        height = 128
        imageFile = "soap001.png"
        title = "あいおえお"
        memo = "memo3"
        datetime = "2017/01/22 09:00:00"

        aaa = UITaskImageButton(frame: CGRect(x: x,y: y,width: width,height: height))
        aaa.btnImage.setImageInfo(UIImage(named: imageFile), width:width , height:height)
        aaa.btnImage.tag = 3
        aaa.btnImage.addTarget(self, action: #selector(MainViewController.onTouchDown_TaskCirclrImageButton(_:)), forControlEvents: .TouchDown)
        self.mArrayTaskImageButton.append(aaa)
        aaa.labelTitle = title
        aaa.labelMemo = memo
        aaa.labelDateTime = datetime
        
        x = 20
        y = 250
        width = 384
        height = 384
        imageFile = "soap002.png"
        title = "あいおえおあいおえおあいおえおあいおえお"
        memo = "memo4"
        datetime = "2017/01/05 18:30:40"

        aaa = UITaskImageButton(frame: CGRect(x: x,y: y,width: width,height: height))
        aaa.btnImage.setImageInfo(UIImage(named: imageFile), width:width , height:height)
        aaa.btnImage.tag = 4
        aaa.btnImage.addTarget(self, action: #selector(MainViewController.onTouchDown_TaskCirclrImageButton(_:)), forControlEvents: .TouchDown)
        self.mArrayTaskImageButton.append(aaa)
        aaa.labelTitle = title
        aaa.labelMemo = memo
        aaa.labelDateTime = datetime
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