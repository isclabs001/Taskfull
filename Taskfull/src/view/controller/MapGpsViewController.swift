//
//  MapGpsViewController.swift
//  SchoolCafeteriaMap
//
//  Created by IscIsc on 2016/07/12.
//  Copyright © 2016年 IscIsc. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

class MapGpsViewController: BaseTabChildViewController, IndicatorInfoProvider, CLLocationManagerDelegate, GMSMapViewDelegate {

    /**
     * GMSMapViewコントロール
     */
    @IBOutlet weak var mapView: GMSMapView!
    
    /**
     * 現在位置の緯度経度
     */
    var m_CurrentLocation : CLLocationCoordinate2D? = nil;

    /**
     * 地図を現在位置を維持する
     */
    var m_IsMapCurrentPosition : Bool = false;

    /**
     * CameraChangeロックフラグ
     */
    var m_IsLockForCameraChange : Bool = false;
    
    /**
     * 初期時のズームフラグ
     */
    var m_IsInitZoom : Bool = false;
    
    /**
     * 位置ズームフラグ
     */
    var m_IsLocationZoom : Bool = true;
    
    var m_LocationClient : CLLocationManager?
    
    /**
     * 現在の方角
     */
    var m_CurrentDirection : CLLocationDirection = 0;
    
    
    /// init処理
    /// - parameter nibNameOrNil:Storyboad上の画面定義名
    /// - parameter nibBundleOrNil:画面引数
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    /// init処理
    /// - parameter aDecoder:NSCoderオブジェクト
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /// viewDidLoadイベント処理
    override func viewDidLoad() {
        //　基底クラスのviewDidLoadイベント処理
        super.viewDidLoad()

        // viewDidLoad用初期化処理
        initForViewDidLoad()
    }
    
    /// didReceiveMemoryWarningイベント処理
    override func didReceiveMemoryWarning() {
        //　基底クラスのdidReceiveMemoryWarningイベント処理
        super.didReceiveMemoryWarning()
    }
    
    /// viewWillAppearイベント処理（画面初期表示イベント）
    /// - parameter animated:true：アニメーションして画面を表示する false：アニメーションせずに画面を表示する
    override func viewWillAppear(animated: Bool) {
        
        // 地図設定
        updateMapSettings(self.mapView);

        //　基底クラスのviewWillAppearイベント処理
        super.viewWillAppear(animated)
    }

    /// タブコントローラー　インジケータに表示する項目取得処理
    /// - parameter pagerTabStripController:PagerTabStripViewControllerコントロール
    /// - returns:IndicatorInfoクラス
    func indicatorInfoForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Map")
    }
    
    /// viewDidLoad用初期化処理
    func initForViewDidLoad()
    {
        // GMSMapViewコントロールのイベント受け取り先をMapGpsViewControllerとする
        self.mapView.delegate = self
        
        // 位置情報サービスCLLocationManagerを生成
        m_LocationClient = CLLocationManager()
        // 正常な場合
        if(nil != m_LocationClient)
        {
            // 指定距離移動したら通知（100m）
            m_LocationClient?.distanceFilter = 100
            // 「アプリ使用時のみ許可」でない場合
            if(CLAuthorizationStatus.AuthorizedWhenInUse != CLLocationManager.authorizationStatus())
            {
                // 確認ダイアログを表示
                m_LocationClient?.requestWhenInUseAuthorization()
            }
            // CLLocationManagerコントロールのイベント受け取り先をMapGpsViewControllerとする
            m_LocationClient?.delegate = self
            
            // 位置情報取得処理開始
            m_LocationClient?.startUpdatingLocation()
        }
    }
    
    /// 地図コントロールの設定更新処理
    /// - parameter map:GMSMapViewコントロール
    func updateMapSettings(map: GMSMapView)
    {
        // 地図形式設定
        map.mapType = kGMSTypeNormal
        // 渋滞情報設定
        map.trafficEnabled = true
        // 屋内表示設定
        map.indoorEnabled = false
        // 現在の位置情報設定
        map.myLocationEnabled = true
    }
    
    /// 地図コントロールの設定更新処理（俯瞰角度）
    func updateMapSettingsForTilt()
    {
        // 俯瞰角度設定
        //builder.tilt(SettingsUtility.getMapTypeTiltMode(getApplicationContext()));
    
        // 地図に反映する
        self.mapView.moveCamera(GMSCameraUpdate.setCamera(self.mapView.camera))
    }
    
    /// 地図コントロールの初期設定処理
    /// - parameter map:GMSMapViewコントロール
    func initMap(map: GMSMapView)
    {
        // 地図設定更新
        updateMapSettings(map);
        
        // 設定の取得
        let settings : GMSUISettings = map.settings;
        // コンパスの有効化
        settings.compassButton = true;
        // 現在位置に移動するボタンの有効化
        settings.myLocationButton = true
        // すべてのジェスチャーの有効化
        settings.setAllGesturesEnabled(true)
        // 回転ジェスチャーの有効化
        settings.rotateGestures = true
        // スクロールジェスチャーの有効化
        settings.scrollGestures = true;
        // Tlitジェスチャー(立体表示)の有効化
        settings.tiltGestures = true;
        // ズームジェスチャー(ピンチイン・アウト)の有効化
        settings.zoomGestures = true
        
        // 現在位置を設定する
        setMyLocationMap(false);
    }
    
    /// 現在位置に地図を移動する
    /// - parameter isInit:true：初期化する　false：初期化しない
    func setMyLocationMap(isInit : Bool)
    {
        let location : CLLocationCoordinate2D? = getLastLocation();
        if(nil != location)
        {
            // 現在位置に地図を移動する
            setMyLocationMap(location!, isInit: isInit);
    
            // 進捗ビューの非表示
            hideProgress();
    
        // 上記以外の場合
        } else {
            // 位置情報設定チェック
            checkLocationPreference();
        }
    }
    
    /// 最新の現在地を取得
    /// - returns:緯度経度
    func getLastLocation() -> CLLocationCoordinate2D?
    {
        if(nil != m_LocationClient)
        {
            // 位置情報を取得。
            m_LocationClient?.startUpdatingLocation()
            
            return m_CurrentLocation;
    
        } else {
            return nil;
        }
    }
    
    
    /// 位置情報設定チェック
    func checkLocationPreference()
    {
    }
    
    /// 地図表示完了イベント
    /// - parameter mapView:GMSMapViewコントロール
    func mapViewSnapshotReady(mapView: GMSMapView)
    {
        // 地図情報初期化
        initMap(mapView);
    }
    
    /// 現在位置表示ボタン押下イベント
    /// - parameter mapView:GMSMapViewコントロール
    func didTapMyLocationButtonForMapView(mapView: GMSMapView) -> Bool {
        // 進捗ビューの表示
        showProgress();
        
        // 現在位置を設定する
        m_IsMapCurrentPosition = true;
        setMyLocationMap(m_IsLocationZoom);
        m_IsLocationZoom = false;
        
        // 処理済のためtrueを返す
        return true;
    }
    
    /// 地図コントロールwillMoveイベント
    /// - parameter mapView:GMSMapViewコントロール
    /// - parameter gesture:ジェスチャー情報
    func mapView(mapView: GMSMapView, willMove gesture: Bool) {
        
    }
    
    /// 地図コントロールdidTapOverlayイベント
    /// - parameter mapView:GMSMapViewコントロール
    /// - parameter overlay:GMSOverlayクラス
    func mapView(mapView: GMSMapView, didTapOverlay overlay: GMSOverlay) {
        
    }
    
    /// 地図コントロールdidChangeCameraPositionイベント
    /// - parameter mapView:GMSMapViewコントロール
    /// - parameter position:GMSCameraPositionクラス
    func mapView(mapView: GMSMapView, didChangeCameraPosition position: GMSCameraPosition)
    {
        // イベントロックされていない場合
        if(false == m_IsLockForCameraChange) {
            // 現在位置を維持しない
            m_IsMapCurrentPosition = false;
            
        } else {
            m_IsLockForCameraChange = false;
        }
    }
    
    /// 位置情報サービスクラスdidUpdateLocationsイベント
    /// - parameter manager:位置情報サービスクラス
    /// - parameter locations:CLLocationクラス配列
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        // 現在位置が有効な場合
        if let loc = locations.last
        {
            // 現在位置をメンバ変数に設定
            m_CurrentLocation = CLLocationCoordinate2D(latitude: loc.coordinate.latitude, longitude: loc.coordinate.longitude)
            // 地図に反映する
            setMyLocationMap(m_CurrentLocation, isInit: m_IsLocationZoom);
        }
    }
    
    /// 位置情報サービスクラスdidFailWithErrorイベント
    /// - parameter manager:位置情報サービスクラス
    /// - parameter error:NSErrorオブジェクト
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError)
    {
        print(error.description)
    }
    
    /// 現在位置に地図を移動する
    /// - parameter latLng:CLLocationCoordinate2Dクラス
    /// - parameter isInit:true：初期化する　false：初期化しない
    func setMyLocationMap(latLng : CLLocationCoordinate2D?, isInit : Bool)
    {
        latLng?.latitude
        // 緯度経度が有効、かつ、地図が有効な場合
        if(nil != latLng && nil != mapView)
        {
            // カメラ変更イベントロック
            m_IsLockForCameraChange = true;
    
            // カメラ設定情報を取得
            var cameraPosition : GMSCameraPosition = mapView.camera
    
            // 俯瞰角度設定
            let viewingAngle : Double = CommonConst.MAP_TILT_NORMAL
    
            // 初期化の場合
            if (true == isInit)
            {
                // 初期化ズームがまだの場合
                if (false == m_IsInitZoom)
                {
                    // 緯度経度設定
                    // 現在の方向を追従させる
                    // 初期ズーム設定
                    // 俯瞰角度設定
                    cameraPosition = GMSCameraPosition.cameraWithTarget(latLng!, zoom: CommonConst.MAP_ZOOM_INIT, bearing: m_CurrentDirection, viewingAngle: viewingAngle)
    
                    // 初期のズーム完了
                    m_IsInitZoom = true;
    
                    // 現在位置を維持する
                    m_IsMapCurrentPosition = true;
    
                // 上記以外の場合
                } else {
                    // 初期ズーム設定
                    cameraPosition = GMSCameraPosition.cameraWithTarget(mapView.camera.target, zoom: CommonConst.MAP_ZOOM_INIT, bearing: mapView.camera.bearing, viewingAngle: viewingAngle)

                    // 現在位置を維持する場合
                    if (true == isMapCurrentPosition()) {
                        // 緯度経度設定
                        cameraPosition = GMSCameraPosition.cameraWithTarget(latLng!, zoom: CommonConst.MAP_ZOOM_INIT, bearing: mapView.camera.bearing, viewingAngle: viewingAngle)
/*
                        // 方向を追従する場合
                        if (SettingsUtility.getMapTypeBearingFlattery(getApplicationContext())) {
                            // 現在の方向を追従させる
                            cameraPosition = GMSCameraPosition.cameraWithTarget(latLng, zoom: CommonConst.MAP_ZOOM_INIT, bearing: m_CurrentDirection, viewingAngle: viewingAngle)
                        }
*/
                    }
                }
    
                // 地図設定を反映する
                mapView.moveCamera(GMSCameraUpdate.setCamera(cameraPosition));
    
            // 上記以外の場合
            } else {
                // 現在位置を維持する場合
                if (true == isMapCurrentPosition()) {
                    // 緯度経度設定
                    cameraPosition = GMSCameraPosition.cameraWithTarget(latLng!, zoom: mapView.camera.zoom, bearing: mapView.camera.bearing, viewingAngle: viewingAngle)
/*
                    // 方向を追従する場合
                    if (SettingsUtility.getMapTypeBearingFlattery(getApplicationContext())) {
                        // 現在の方向を追従させる
                        cameraPosition = GMSCameraPosition.cameraWithTarget(latLng, zoom: mapView.camera.zoom, bearing: m_CurrentDirection, viewingAngle: viewingAngle)
                    }
 */
                }
    
                // 地図設定を反映する
                mapView.moveCamera(GMSCameraUpdate.setCamera(cameraPosition));
            }
        }
    }
    
    /// 地図を現在位置を維持するかの判断
    /// - parameter latLng:CLLocationCoordinate2Dクラス
    /// - returns:true:維持する false:維持しない
    func isMapCurrentPosition() -> Bool
    {
        return m_IsMapCurrentPosition;
    }
}