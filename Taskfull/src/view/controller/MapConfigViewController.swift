//
//  MapConfigViewController.swift
//  Taskfull
//
//  Created by iSC on 2017/04/11.
//  Copyright © 2017年 isc. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import AudioToolbox

///
/// GPSリマインダー画面
///
class MapConfigViewController : BaseViewController,CLLocationManagerDelegate,MKMapViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource
{
    // Mapkit
    @IBOutlet weak var GPSMapView: MKMapView!
    @IBOutlet weak var InputPointListField: InputDisabledTextField!
    
    /**
     * 定数
     */

    /**
     * 変数
     */
    // 登録地点用要素配列
    var pointListNameArray : [String] = [""]
    // 登録地点リスト入力PickerView
    let inputPointPicker : UIPickerView! = UIPickerView()
    
    // 現在位置格納ロケーション：権限通知重複対策の為、プロパティで宣言
    var selfLocation : CLLocationManager! = CLLocationManager()

    // 更新フラグ
    var updateFlag : Bool = false
    
    
    /// viewDidLoadイベント処理
    override func viewDidLoad() {
        
        // 基底のviewDidLoadを呼び出す
        super.viewDidLoad()
        
        // 初期化
        let _ = initializeProc()
    }
    
    //PicerView　表示列
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    //PicerView　表示行（要素数）
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        // 要素数
        return pointListNameArray.count
    }
    //PicerView　表示要素
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        // PicerViewを表示要素を戻す
        return pointListNameArray[row]
        
    }
    //PicerView　値選択時イベント
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        // 選択IDの登録名をtextFieldへ反映
        setSelectedPoint(textField: InputPointListField, row: row)
        
        // 空欄以外を選択した場合(row = 0以外)
        if(row != 0){
            
            // Pickerのタイトルより、選択ID取得
            let infoLocationId = TaskInfoUtility.DefaultInstance.GetInfoLocationIndexForTitle(pointListNameArray[row])
            
            // 選択Entity取得
            let taskLocationDataEntity : TaskInfoLocationDataEntity = TaskInfoUtility.DefaultInstance.GetInfoLocationDataForId(infoLocationId)!
            
            // 選択IDの座標生成
            let coordinate : CLLocationCoordinate2D = CLLocationCoordinate2DMake(taskLocationDataEntity.Latitude,taskLocationDataEntity.Longitude)
            
            // Map表示領域指定(数字を小さくすると拡大)
            let span : MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
            
            // 生成座標より表示領域作成
            let region : MKCoordinateRegion = MKCoordinateRegion(center: coordinate, span: span)
            
            // 選択IDの表示領域をMapに設定
            GPSMapView.region = region
            
            // Pickerを閉じる
            view.endEditing(true)
            
        }
        
        
    }
    
    //キーボード「リターンキー」：タップ時イベント
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // キーボードを閉じる
        textField.resignFirstResponder()
        return false
    }
    
    //フォーカスが外れた際のイベント処理
    func missFocusView(){
        // viewを閉じる
        view.endEditing(true)
    }
    
    // 選択地点の設定
    func setSelectedPoint(textField : UITextField, row: Int) {
        
        // 選択項目をUITextFieldに設定する
        InputPointListField.text = pointListNameArray[row]
        
        // 0.1秒バイブレーション作動
        actionViblation()
    }
    
    // バイブレーション作動
    func actionViblation() {
        // 0.1秒バイブレーション作動
        AudioServicesPlaySystemSound(1003)
        AudioServicesDisposeSystemSoundID(1003)
    }
    
    /// 初期化処理
    override func initializeProc() ->Bool
    {
        // 基底のinitializeProcを呼び出す
        var ret : Bool = super.initializeProc()
        
        //　正常な場合
        if(true == ret)
        {
            
            // ナビゲーションバー表示
            navigationController?.setNavigationBarHidden(false, animated: true)
            
            //Mapkit:delegate設定
            GPSMapView.delegate = self
            
            // GPS認証ステータスを取得
            let status = CLLocationManager.authorizationStatus()
            
            // GPS認証がまだである場合(アプリ起動初回のみ)
            if(status == .notDetermined) {
                
                // 認証ダイアログ通知
                selfLocation.requestAlwaysAuthorization()
                
            }
            
            // ロングタップ時イベント作成
            let selfLongTap: UILongPressGestureRecognizer = UILongPressGestureRecognizer()
            selfLongTap.addTarget(self, action: #selector(MapConfigViewController.MapLongTap(sender:)))
            
            // MapViewへロングタップ時イベント追加
            GPSMapView.addGestureRecognizer(selfLongTap)
            
            //　view:フォーカスが外れた際のイベント
            let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(missFocusView))
            view.addGestureRecognizer(tap)
            
            //　通知場所(登録地点リスト):初期設定
            displayInputPoint(pointListField: self.InputPointListField)

            /// リスト内ピン生成処理
            displayGeneratePin()
            
            // 戻り値にtrueを設定
            ret = true
        }
        
        return ret
    }

    
    ///　通知場所(登録地点リスト):初期設定
    func displayInputPoint(pointListField: UITextField!){
        
        //登録地点リスト:要素更新処理
        // 通知地点名更新処理
        updataPointListNameArray()
        
        //登録地点リスト：Delegate,DataSource設定
        self.inputPointPicker.delegate = self
        self.inputPointPicker.dataSource = self
        
        //登録地点リスト入力欄　入力方法:PickerView
        pointListField.inputView = inputPointPicker
        pointListField.textAlignment = NSTextAlignment.center
        
        //登録地点リスト入力欄 リロード
        self.inputPointPicker.reloadAllComponents()
        
    }
    
    
    /// 通知地点名リスト用配列更新処理
    fileprivate func updataPointListNameArray(){
        
        // テキスト欄初期化
        InputPointListField.text = ""
        
        // 配列初期化
        pointListNameArray = [""]
        
        // 通知地点数
        let intLocationCount : Int = TaskInfoUtility.DefaultInstance.GetInfoLocationCount()
        
        // 通知地点が登録されている場合
        if(intLocationCount != 0){
        
            // 登録地点数分処理(ID)
            for i in 1...CommonConst.INPUT_NOTIFICATION_POINT_LIST_LIMIT{
                
                // 空番ではない場合
                if(TaskInfoUtility.DefaultInstance.GetIndexForLocation(i) != -1){
                    
                    // 空番以外のTaskInfoLocationDataEntity
                    let taskLocationDataEntity : TaskInfoLocationDataEntity  = TaskInfoUtility.DefaultInstance.GetInfoLocationDataForId(i)!
                    
                    // 通知地点名配列追加(1~)
                    pointListNameArray.append(taskLocationDataEntity.Title)
                }
                
            }

            //登録地点リスト入力欄 リロード
            self.inputPointPicker.reloadAllComponents()
            
        }
            
    }
    
    
    /// リスト内ピン生成処理
    fileprivate func displayGeneratePin(){
        
        // 通知地点数
        let intLocationCount : Int = TaskInfoUtility.DefaultInstance.GetInfoLocationCount()
        
        // 通知地点が登録されている場合
        if(intLocationCount != 0){
            
            // 登録地点数分処理(ID)
            for i in 1...CommonConst.INPUT_NOTIFICATION_POINT_LIST_LIMIT{
                
                // 空番ではない場合
                if(TaskInfoUtility.DefaultInstance.GetIndexForLocation(i) != -1){
                    
                    // TaskInfoLocationDataEntity:読込
                    let taskLocationDataEntity : TaskInfoLocationDataEntity = TaskInfoUtility.DefaultInstance.GetInfoLocationDataForId(i)!
                    
                    // ピン:生成
                    let myPin: MKPointAnnotation = MKPointAnnotation()
                    
                    // ピン:生成座標を設定
                    myPin.coordinate = CLLocationCoordinate2DMake(taskLocationDataEntity.Latitude,taskLocationDataEntity.Longitude)
                    
                    // ピン:タイトル設定
                    myPin.title = taskLocationDataEntity.Title
                    
                    // MapView:生成ピン追加
                    GPSMapView.addAnnotation(myPin)
                    
                }
                
            }
            
            // Map上のアノテーション全てにオーバーレイ描写処理
            for i in 0..<(self.GPSMapView.annotations as NSArray).count{
                
                // 円を描画(半径100m)
                let selfCircle: MKCircle = MKCircle(center: self.GPSMapView.annotations[i].coordinate, radius: CLLocationDistance(CommonConst.NOTIFICATION_GEOFENCE_RADIUS_RANGE))
                
                // mapViewへ円追加：addOverlayイベント処理開始
                self.GPSMapView.add(selfCircle)
                
            }
            
        }
    }
    
    
    /// マップ表示処理
    private func DisplayInitialMap(){
        
        //delegate設定
        selfLocation.delegate = self
        
        //　TODO：要修正
        if(CLLocationManager.locationServicesEnabled() == true){
            switch CLLocationManager.authorizationStatus() {
                
            //未設定の場合
            case CLAuthorizationStatus.notDetermined:
                selfLocation.requestWhenInUseAuthorization()
                
            //機能制限されている場合
            case CLAuthorizationStatus.restricted:
                alertMessage(message: "位置情報サービスの利用が制限されている為利用できません。")
                
            //「許可しない」に設定されている場合
            case CLAuthorizationStatus.denied:
                alertMessage(message: "位置情報の利用が許可されていないため利用できません。")
                
            //「このAppの使用中のみ許可」に設定されている場合
            case CLAuthorizationStatus.authorizedWhenInUse:
                alertMessage(message: "位置情報の利用が制限されています。")
                
            //「常に許可」に設定されている場合
            case CLAuthorizationStatus.authorizedAlways:
                //位置情報の取得を開始する。
                selfLocation.startUpdatingLocation()
            }
            
        } else {
            //位置情報サービスがOFFの場合
            alertMessage(message: "位置情報サービスがONになっていないため利用できません。")
        }
        
         /*
         //ios9.0以上
         if #available(iOS 9.0, *) {
         selfLocation.allowsBackgroundLocationUpdates = true
         } else {
         // Fallback on earlier versions
         }*/
        
        // 位置情報取得精度(10m)
        selfLocation.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        // 位置情報取得間隔(10m移動したら位置補足)
        selfLocation.distanceFilter = 10
        // 現在位置取得(位置情報更新)
        selfLocation.startUpdatingLocation()
        
        
    }
    
    
    /// メッセージ出力処理
    func alertMessage(message:String) {
        
        let aleartController = UIAlertController(title: "注意", message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title:"OK", style: .default, handler:nil)
        aleartController.addAction(defaultAction)
        
        present(aleartController, animated:true, completion:nil)
        
    }
    
    /// 位置情報取得時イベント
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // MapViewに設定された位置情報取得
        GPSMapView.centerCoordinate = CLLocationCoordinate2DMake((selfLocation.location?.coordinate.latitude)!, (selfLocation.location?.coordinate.longitude)!)
        
        // 表示領域指定(数字を小さくすると拡大)
        let span : MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        
        // MapViewで指定した中心位置とMKCoordinateSapnで宣言したspanを指定する
        let region : MKCoordinateRegion = MKCoordinateRegion(center: GPSMapView.centerCoordinate, span: span)
        
        // 位置情報をMapに設定
        GPSMapView.region = region
        
        // Map再更新防止の為、位置情報取得停止
        selfLocation.stopUpdatingLocation()
    }

    /// 画面表示直後時処理（初期表示含む）
    override func viewDidAppear(_ animated: Bool) {
        
        //マップ:表示処理
        DisplayInitialMap()
        
    }
    
    
    /// 位置情報取得失敗時イベント
    func locationManager(_ manager: CLLocationManager,didFailWithError error: Error){
        
        
        debugPrint("error")
        
        //　アラート表示
        MessageUtility.dispAlertOK(viewController: self, title: "位置情報取得エラー", message: "位置情報が取得できません")
        
        //　位置移動イベント実装
        
    }

    
    /// ロングタップ時イベント
    func MapLongTap(sender: UILongPressGestureRecognizer) {

        // 長押し時、ピンの再生成防止
        if sender.state != UIGestureRecognizerState.began {
            return
        }
        
        // 地点登録数が作成上限以内である場合
        if(TaskInfoUtility.DefaultInstance.GetInfoLocationCount() < CommonConst.INPUT_NOTIFICATION_POINT_LIST_LIMIT){
        
            // ロングタップ地点の座標を取得
            let longTapLocation = sender.location(in: GPSMapView)
            
            // 取得座標をCLLocationCoordinate2Dへ変換
            let tapLocation: CLLocationCoordinate2D = GPSMapView.convert(longTapLocation, toCoordinateFrom: GPSMapView)
            
            // アノテーション(ピン)登録イベント
            setMapPinAlert(tapLocation: tapLocation)
            
        }
        // 作成上限である場合
        else{
            
            // 制限アラート表示
            MessageUtility.dispAlertOK(
                viewController: self,
                title: "",
                message: MessageUtility.getMessage(key: "MessageStringErrorTaskCountLimit", param: (String(CommonConst.INPUT_TASK_NAME_STRING_LIMIT))))
        }
    }
    
    
    /// MapView:addAnnotation時イベント
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        //一意名
        let myPinIdentifier = "PinAnnotationIdentifier"
        
        // ピン生成
        var myPinView: MKPinAnnotationView!
        
        // MKPinAnnotationViewのインスタンスが生成されていなければ作る
        if myPinView == nil {
            
            myPinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: myPinIdentifier)
            
            // アニメーション:True
            myPinView.animatesDrop = true
            
            // コールアウト(吹き出し):True
            myPinView.canShowCallout = true
            return myPinView
            
        }
        
        // annotationを設定
        myPinView.annotation = annotation
        
        return myPinView

    }

    
    /// MapView:addOverlay時イベント
    ///
    /// - Parameters:
    ///   - mapView: MKMapView
    ///   - overlay: KOverlay
    /// - Returns:　MKOverlayRenderer
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        // renderer生成
        let selfCircleView: MKCircleRenderer = MKCircleRenderer(overlay: overlay)
        
        // 円の内部色
        selfCircleView.fillColor = UIColor.blue
        
        // 円の透過度
        selfCircleView.alpha = 0.1
        
        // 円周線の色
        selfCircleView.strokeColor = UIColor.clear
        
        // 円周線の太さ
        selfCircleView.lineWidth = 1.0
        
        return selfCircleView
        
    }
    
    
    /// didReceiveMemoryWarningイベント処理
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /// アノテーション追加時イベント
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        
        for view in views {
            
            // ボタン生成
            let pinSideBtn  = UIButton(type: UIButtonType.detailDisclosure)
            
            // Pinのバルーンにボタン追加
            view.rightCalloutAccessoryView = pinSideBtn
        }
        
    }

    
    // アノテーション:コールアウトボタンタップ時イベント
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        // 編集シート表示
        activeSheet(view: view)
    }
    

    /// アノテーション(ピン)登録イベント
    ///
    /// - Parameter tapLocation: ロングタップ箇所のロケーション(CLLocationCoordinate2D)
    func setMapPinAlert(tapLocation: CLLocationCoordinate2D) {
        
        // Alert生成
        let myAlert: UIAlertController = UIAlertController(title: "", message: "", preferredStyle: UIAlertControllerStyle.alert)

        // AlertにTextFieldを追加
        myAlert.addTextField { (textField: UITextField!) -> Void in
            
            textField.placeholder = "通知地点"
            
            // NotificationCenterを生成
            let myNotificationCenter = NotificationCenter.default
            
            
            // textFieldに値変更があればchangeTextFieldメソッドに通知
            myNotificationCenter.addObserver(self, selector: #selector(MapConfigViewController.changeTextField(sender:)), name: NSNotification.Name.UITextFieldTextDidChange, object: nil)


        }
        
        
        // OKアクション生成
        let OkAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (action: UIAlertAction!) -> Void in
            
            // ピン生成
            let pointPin: MKPointAnnotation = MKPointAnnotation()
            
            // ピン表示座標を設定
            pointPin.coordinate = tapLocation
        
            // タイトル名:前後スペース削除
            let strInputPointTrimTitle : String = (myAlert.textFields?[0].text)!.trimmingCharacters(in: NSCharacterSet.whitespaces)
            
            // 入力値が空欄でない場合
            if(false == StringUtility.isEmpty(strInputPointTrimTitle)){
                
                // 同名通知地点が存在しない場合
                if(TaskInfoUtility.DefaultInstance.GetInfoLocationIndexForTitle(strInputPointTrimTitle)  == -1){
                    
                    // タイトルを設定
                    pointPin.title = strInputPointTrimTitle
                    
                    // MapViewへピン追加:addAnotationイベント処理開始
                    self.GPSMapView.addAnnotation(pointPin)
                    
                    // 円を描画(半径100m)
                    let selfCircle: MKCircle = MKCircle(center: tapLocation, radius: CLLocationDistance(CommonConst.NOTIFICATION_GEOFENCE_RADIUS_RANGE))
                    
                    // mapViewへ円追加：addOverlayイベント処理開始
                    self.GPSMapView.add(selfCircle)
                    
                    // TODO:通知地点登録
                    self.registrationPointList(pointTitle: strInputPointTrimTitle, location: tapLocation)
                }
                // 同名通知地点が存在した場合
                else{
                    
                    // アラート表示
                    let alert = UIAlertView()
                    alert.title = ""
                    alert.message = MessageUtility.getMessage(key: "MessageStringErrorNotificationPointListSameName")
                    alert.addButton(withTitle: MessageUtility.getMessage(key: "MessageStringButtonOK"))
                    alert.show()
                }
            }
            // 入力値が空欄である場合
            else{
                
                // アラート表示
                let alert = UIAlertView()
                alert.title = ""
                alert.message = MessageUtility.getMessage(key: "MessageStringErrorNotificationPointListName")
                alert.addButton(withTitle: MessageUtility.getMessage(key: "MessageStringButtonOK"))
                alert.show()
                
            }
        }
        
        
        // Cancelアクション生成
        let CancelAction = UIAlertAction(title: MessageUtility.getMessage(key: "MessageStringButtonCancel"), style: UIAlertActionStyle.destructive) { (action: UIAlertAction!) -> Void in
            
            // Cancel時イベント記述

        }
        
        // Alertにアクションを追加
        myAlert.addAction(CancelAction)
        myAlert.addAction(OkAction)

        // Alert表示
        present(myAlert, animated: true, completion: nil)
        
    }

    ///　TextField入力値制限処理
    func changeTextField(sender: NSNotification) {
        
        //　UITextFieldへ変換
        let inputTextField = sender.object as! UITextField
        
        // 変数に代入
        if let copyText = inputTextField.text {
            
            
            // 入力制限数チェック
            if ("\(copyText)".characters.count) <= 10 {
                
                // 編集有効
                inputTextField.isEnabled = true
                
                
            } else {
                
                // 編集無効
                inputTextField.isEnabled = false
                
                // アラート表示；二重表示対策の為、UIAlertView使用
                let alert = UIAlertView()
                alert.title = ""
                alert.message = MessageUtility.getMessage(key: "MessageStringErrorTaskCountLimit", param: String(CommonConst.INPUT_TASK_NOTIFICATION_POINT_LIST_STRING_LIMIT))
                alert.addButton(withTitle: MessageUtility.getMessage(key: "MessageStringButtonOK"))
                alert.show()
                
                // 前後半角スペース削除　※スペースのみ入力時、複数通知防止の為
                inputTextField.text = inputTextField.text?.trimmingCharacters(in: NSCharacterSet.whitespaces)
                
            }
            // 再編集の為、有効化
            inputTextField.isEnabled = true
            
        }
    }

    ///　アクションシート表示
    func activeSheet(view: MKAnnotationView){
        
        //　アノテーション = ピン
        let annotation = view.annotation!
        //  選択アノテーションのインデックス取得 ※新規アノテーションインデックスは前挿入
        let index  = (self.GPSMapView.annotations as NSArray).index(of: annotation)
        
        // インスタンス生成:サブメッセージ「緯度経度」
        let myAlert = UIAlertController(title: view.annotation!.title!, message: ("緯度:" + String(self.GPSMapView.annotations[index].coordinate.latitude) + "\n" + "経度:" + String(self.GPSMapView.annotations[index].coordinate.longitude)), preferredStyle: UIAlertControllerStyle.actionSheet)

// TODO:アノテーションをインスタンス変数に格納しなければ編集不可の為[定数固定]、編集処理次フェーズ課題
//        // 編集アクション生成
//        let editAction = UIAlertAction(title: "Edit", style: UIAlertActionStyle.default, handler: {(action: UIAlertAction!) in
//            
//            // TODO:アノテーション編集処理
//            
//            
//        })
        
        // 削除アクション生成
        let deleteAction = UIAlertAction(title: "Delete", style: UIAlertActionStyle.destructive, handler: {(action: UIAlertAction!) in

            // 一致するタイトルのデータ削除
            // 一致タイトル位置情報のIDを返し、該当ID削除
            TaskInfoUtility.DefaultInstance.RemoveLocationInfo(TaskInfoUtility.DefaultInstance.GetInfoLocationIndexForTitle(self.GPSMapView.annotations[index].title!!))
            TaskInfoUtility.DefaultInstance.WriteTaskInfo()
            
            // 選択アノテーション削除(インデックス指定)
            self.GPSMapView.removeAnnotation(self.GPSMapView.annotations[index])
            // 選択オーバーレイ削除(アノテーションインデックスが前挿入である為、要ズレ回避)
            // self.GPSMapView.remove(self.GPSMapView.overlays[index])
            
            // アノテーションインデックス対策代替処理:START
            // 全オーバーレイ削除(円)
            self.GPSMapView.removeOverlays(self.GPSMapView.overlays)
            
            // Map上のアノテーション全てにオーバーレイ描写処理
            for i in 0..<(self.GPSMapView.annotations as NSArray).count{
                
                // 円を描画(半径100m)
                let selfCircle: MKCircle = MKCircle(center: self.GPSMapView.annotations[i].coordinate, radius: CLLocationDistance(CommonConst.NOTIFICATION_GEOFENCE_RADIUS_RANGE))
                
                // mapViewへ円追加：addOverlayイベント処理開始
                self.GPSMapView.add(selfCircle)

            }
            // アノテーションインデックス対策代替処理:END
            
            // 更新フラグを立てる
            self.updateFlag = true

            // 通知地点名配列更新処理
            self.updataPointListNameArray()
            
        })
        
        // キャンセルアクション生成
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: {(action: UIAlertAction!) in
            
            debugPrint("Cancel")
            
        })
        
        // アクション追加
        myAlert.addAction(deleteAction)
        myAlert.addAction(cancelAction)
        
        // ActionSheet表示
        self.present(myAlert, animated: true, completion: nil)
        
    }
    

    /// 通知地点登録処理
    ///
    /// - Parameters:
    ///   - pointTitle: 通知地点名
    ///   - location: 通知地点座標
    func registrationPointList(pointTitle :String,location: CLLocationCoordinate2D){
        
        // TaskInfoLocationDataEntity生成
        let taskLocationDataEntity : TaskInfoLocationDataEntity  = TaskInfoLocationDataEntity()
        
        
        // 1~上限まで回す
        for i in 1...CommonConst.INPUT_NOTIFICATION_POINT_LIST_LIMIT{
            
            // 空番が見つかった場合
            if(TaskInfoUtility.DefaultInstance.GetIndexForLocation(i) == -1){
                
                // 空番ID設定
                taskLocationDataEntity.Id = i
                
                break
            }
        }
        
        // タイトル設定
        taskLocationDataEntity.Title = pointTitle
        
        // 緯度
        taskLocationDataEntity.Latitude = location.latitude
        
        // 経度
        taskLocationDataEntity.Longitude = location.longitude
        
        // ロケーション情報の追加
        TaskInfoUtility.DefaultInstance.AddLocationInfo(taskLocationDataEntity)
        
        // ロケーション情報の書込み
        TaskInfoUtility.DefaultInstance.WriteTaskInfo()
        
        // 更新フラグを立てる
        self.updateFlag = true
        
        // 通知地点名配列更新処理
        updataPointListNameArray()
        
    }

    
    ///
    //　ナビゲーションバーの「戻る」ボタン押下処理
    ///
    override func onClickNavigationBackBtn() {
        // キャンセル
        setCancelFlag(cancelFlag: !self.updateFlag)
    }
}
