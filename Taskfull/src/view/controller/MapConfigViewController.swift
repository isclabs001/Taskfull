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
class MapConfigViewController : BaseViewController,CLLocationManagerDelegate,MKMapViewDelegate
{
    // Mapkit
    @IBOutlet weak var GPSMapView: MKMapView!
    
    /**
     * 定数
     */
    
    /**
     * 変数
     */
    
    //ユーザ現在位置格納ロケーション：権限通知対策の為、プロパティで宣言
    var selfLocation : CLLocationManager! = CLLocationManager()
    
    //selfLocation = CLLocationManager()
    
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

            // ナビゲーションバー表示
            navigationController?.setNavigationBarHidden(false, animated: true)
            
            
            //ローカルで宣言した場合、権限確認通知が消える
            //selfLocation = CLLocationManager()
            
            //delegate設定
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
            
            
            // 戻り値にtrueを設定
            ret = true
        }
        
        return ret
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
        
        // ピン:サブタイトル設定
        //myPin.subtitle = "サブタイトル"
        
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
                alertMessage(message: "位置情報サービスの利用が制限されている為利用できません。「設定」⇒「一般」⇒「機能制限」")
                
            //「許可しない」に設定されている場合
            case CLAuthorizationStatus.denied:
                alertMessage(message: "位置情報の利用が許可されていないため利用できません。「設定」⇒「プライバシー」⇒「位置情報サービス」⇒「Taskfull」")
                
            //「このAppの使用中のみ許可」に設定されている場合
            case CLAuthorizationStatus.authorizedWhenInUse:
                alertMessage(message: "位置情報の利用が制限されています。「設定」⇒「プライバシー」⇒「位置情報サービス」⇒「Taskfull」")
                
            //「常に許可」に設定されている場合
            case CLAuthorizationStatus.authorizedAlways:
                //位置情報の取得を開始する。
                selfLocation.startUpdatingLocation()
            }
            
        } else {
            //位置情報サービスがOFFの場合
            alertMessage(message: "位置情報サービスがONになっていないため利用できません。「設定」⇒「プライバシー」⇒「位置情報サービス」")
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
        
        // ピン生成
        let pointPin: MKPointAnnotation = MKPointAnnotation()
        
        // 座標を設定
        pointPin.coordinate = tapLocation
        
        // タイトルを設定
        pointPin.title = "test"
        
        // サブタイトルを設定
        //pointPin.subtitle = "subtest"
        
        // MapViewへピン追加:addAnotationイベント処理開始
        GPSMapView.addAnnotation(pointPin)
        
        // 円を描画(半径100m)
        let selfCircle: MKCircle = MKCircle(center: tapLocation, radius: CLLocationDistance(100))
        
        // mapViewへ円追加：addOverlayイベント処理開始
        GPSMapView.add(selfCircle)

    }
    
    // MapView:addAnnotation時イベント
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        //一意名
        let myPinIdentifier = "PinAnnotationIdentifier"
        
        // ピンを生成.
        var myPinView: MKPinAnnotationView!
        
        // MKPinAnnotationViewのインスタンスが生成されていなければ作る
        if myPinView == nil {
            
            myPinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: myPinIdentifier)
            
            // アニメーションをつける
            myPinView.animatesDrop = true
            
            // コールアウトを表示する
            myPinView.canShowCallout = true
            return myPinView
            
        }
        
        // annotationを設定
        myPinView.annotation = annotation
        
        return myPinView

    }

    
    
    // MapView:addOverlay時イベント
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

    // アノテーションボタンタップ時イベント
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        print("ieeeei")
    }
    
    
}
