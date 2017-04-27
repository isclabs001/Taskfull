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
    //登録地点用要素配列（テスト用）
    let aaa : NSArray = ["","自宅","スーパー","aaaaaaaaaaa"]
    // 登録地点リスト入力PickerView
    let inputPointPicker : UIPickerView! = UIPickerView()
    
    //ユーザ現在位置格納ロケーション：権限通知対策の為、プロパティで宣言
    var selfLocation : CLLocationManager! = CLLocationManager()
    
    /// viewDidLoadイベント処理
    override func viewDidLoad() {
        
        // 基底のviewDidLoadを呼び出す
        super.viewDidLoad()
        
        // 初期化
        initializeProc()
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
        
        // 座標移動イベント
        
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
            
            // 戻り値にtrueを設定
            ret = true
        }
        
        return ret
    }

    //　通知場所(登録地点リスト):初期設定
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
    
    /// リスト内ピン生成処理
    fileprivate func displayGeneratePin(){
        
        // 以下処理を通知場所リストでループ
        
        // ピン:生成
        let myPin: MKPointAnnotation = MKPointAnnotation()
        
        // ピン:生成座標を設定
        //myPin.coordinate = center
        
        // ピン:タイトル設定
        myPin.title = "タイトル"
        
        // MapView:生成ピン追加
        GPSMapView.addAnnotation(myPin)

        
        
    }
    
    
    //マップ:表示処理
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
    
    
    //　メッセージ出力処理
    func alertMessage(message:String) {
        
        let aleartController = UIAlertController(title: "注意", message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title:"OK", style: .default, handler:nil)
        aleartController.addAction(defaultAction)
        
        present(aleartController, animated:true, completion:nil)
        
    }
    
    //　位置情報取得時イベント
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // MapViewに設定された位置情報取得
        GPSMapView.centerCoordinate = CLLocationCoordinate2DMake((selfLocation.location?.coordinate.latitude)!, (selfLocation.location?.coordinate.longitude)!)
        
        // 表示領域指定(数字を小さくすると拡大)
        let span : MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        
        // MapViewで指定した中心位置とMKCoordinateSapnで宣言したspanを指定する
        let region : MKCoordinateRegion = MKCoordinateRegion(center: GPSMapView.centerCoordinate, span: span)
        
        // 位置情報をMapに設定
        GPSMapView.region = region
        
        // 再更新防止：位置情報取得停止
        //selfLocation.stopUpdatingLocation()
    }

    //　画面表示直後時処理（初期表示含む）
    override func viewDidAppear(_ animated: Bool) {
        
        //マップ:表示処理
        DisplayInitialMap()
        
    }
    
    
    // 位置情報取得失敗時イベント
    func locationManager(_ manager: CLLocationManager,didFailWithError error: Error){
        print("error")
    }

    
    // ロングタップ時イベント
    func MapLongTap(sender: UILongPressGestureRecognizer) {
        
        // 長押し時、ピンの再生成防止
        if sender.state != UIGestureRecognizerState.began {
            return
        }
        
        // ロングタップ地点の座標を取得
        let longTapLocation = sender.location(in: GPSMapView)
        
        // 取得座標をCLLocationCoordinate2Dへ変換
        let tapLocation: CLLocationCoordinate2D = GPSMapView.convert(longTapLocation, toCoordinateFrom: GPSMapView)
        
        // 通知地点登録イベント
        setMapPinAlert(tapLocation: tapLocation)
        

    }
    
    
    // MapView:addAnnotation時イベント
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
        selfCircleView.fillColor = UIColor.red
        
        // 円周線の色
        selfCircleView.strokeColor = UIColor.clear
        
        // 円の透過度
        selfCircleView.alpha = 0.2
        
        // 円周線の太さ
        selfCircleView.lineWidth = 1.5
        
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
    
    

    /// 通知地点登録イベント
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
            
            
            // textFieldに変更があればchangeTextFieldメソッドに通知
            myNotificationCenter.addObserver(self, selector: #selector(MapConfigViewController.changeTextField(sender:)), name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
            
        }
        
        
        // OKアクション生成
        let OkAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (action: UIAlertAction!) -> Void in
            
            // ピン生成
            let pointPin: MKPointAnnotation = MKPointAnnotation()
            
            // 座標を設定
            pointPin.coordinate = tapLocation
            
            // 入力値が空欄でない場合
            if(true == StringUtility.isEmpty(myAlert.textFields?[0].text)){
                
                // タイトルを設定(アラート入力値)
                pointPin.title = myAlert.textFields?[0].text
                
                // MapViewへピン追加:addAnotationイベント処理開始
                self.GPSMapView.addAnnotation(pointPin)
                
                // 円を描画(半径100m)
                let selfCircle: MKCircle = MKCircle(center: tapLocation, radius: CLLocationDistance(100))
                
                // mapViewへ円追加：addOverlayイベント処理開始
                self.GPSMapView.add(selfCircle)
                
                // TODO:通知地点登録

            }
            // 入力値が空欄である場合
            else{
                
                // アラート表示
                let alert = UIAlertView()
                alert.title = ""
                alert.message = "通知地点名を入力してください。"
                alert.addButton(withTitle: "OK")
                alert.show()
                
            }
        }
        
        
        // Cancelアクション生成
        let CancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.destructive) { (action: UIAlertAction!) -> Void in
            
            // Cansel時イベント
            
        }
        
        // Alertにアクションを追加
        myAlert.addAction(CancelAction)
        myAlert.addAction(OkAction)
        
        
        // Alertを発動する
        present(myAlert, animated: true, completion: nil)
        
    }

    
    func changeTextField(sender: NSNotification) {
        
        //　UITextFieldへ変換
        let inputTextField = sender.object as! UITextField
        
        // 変数に代入
        if let copyText = inputTextField.text {
            
            // 入力された文字が10文字を超えたら入力を制限.
            if ("\(copyText)".characters.count) <= 10 {
                
                inputTextField.isEnabled = true

            } else {
                
                inputTextField.isEnabled = false
                
                // アラート表示；二重表示対策の為、UIAlertView使用
                let alert = UIAlertView()
                alert.title = ""
                alert.message = "10文字以内で入力してください※操作性悪くなる為、アラート表示について備考。。"
                alert.addButton(withTitle: "OK")
                alert.show()
            }
            
            // 再編集の為、有効化
            inputTextField.isEnabled = true
            
        }
    }

    
    func activeSheet(view: MKAnnotationView){
        
        // インスタンス生成:ActionSheet
        let myAlert = UIAlertController(title: view.annotation!.title!, message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        
        
        // アクション生成_1
        let myAction_1 = UIAlertAction(title: "Edit", style: UIAlertActionStyle.default, handler: {
            
            (action: UIAlertAction!) in
            
            let annotation = view.annotation!
            
            print(String((self.GPSMapView.annotations as NSArray).index(of: annotation)))
            
            var indexCount =  (self.GPSMapView.annotations as NSArray).count
            
            
            
        })
        
        // アクション生成_2
        let myAction_2 = UIAlertAction(title: "Delete", style: UIAlertActionStyle.destructive, handler: {
            
            (action: UIAlertAction!) in

            //　アノテーション = ピン
            let annotation = view.annotation!
            // アノテーション配列のインデックス取得 ※アノテーションインデックスは前挿入
            let index  = (self.GPSMapView.annotations as NSArray).index(of: annotation)
            // 選択アノテーション削除
            self.GPSMapView.removeAnnotation(self.GPSMapView.annotations[index])
            // 選択オーバーレイ削除(アノテーションインデックスが前挿入である為、要ズレ回避)
            //self.GPSMapView.remove(self.GPSMapView.overlays[index])
            
            // アノテーションインデックス対策代替処理:START
            // 全オーバーレイ削除(円)
            self.GPSMapView.removeOverlays(self.GPSMapView.overlays)
            
            // Map上のアノテーション全てにオーバーレイ描写処理
            for i in 0..<(self.GPSMapView.annotations as NSArray).count{
                
                // 円を描画(半径100m)
                let selfCircle: MKCircle = MKCircle(center: self.GPSMapView.annotations[i].coordinate, radius: CLLocationDistance(100))
                
                // mapViewへ円追加：addOverlayイベント処理開始
                self.GPSMapView.add(selfCircle)

            }
            // アノテーションインデックス対策代替処理:END
            
            // TODO:通知地点リストから削除（座標で検索？？）
            
        })
        
        // アクション生成_3
        let myAction_3 = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: {
            
            (action: UIAlertAction!) in
            
            print("Cancel")
            
        })
        
        // アクション追加
        myAlert.addAction(myAction_1)
        myAlert.addAction(myAction_2)
        myAlert.addAction(myAction_3)
        
        // ActionSheet表示
        self.present(myAlert, animated: true, completion: nil)
        
    }
    
    

}
