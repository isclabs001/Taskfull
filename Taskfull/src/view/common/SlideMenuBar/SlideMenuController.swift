//
//  SlideMenuController.swift
//  Taskfull
//
//  Created by IscIsc on 2017/04/26.
//  Copyright © 2017年 isc. All rights reserved.
//

import UIKit

//
// SlideMenuControllerデリゲート
//
@objc public protocol SlideMenuControllerDelegate {
    // 左メニューバーの表示前イベント
    @objc optional func leftWillOpen()
    // 左メニューバーの表示後イベント
    @objc optional func leftDidOpen()
    // 左メニューバーの非表示前イベント
    @objc optional func leftWillClose()
    // 左メニューバーの非表示後イベント
    @objc optional func leftDidClose()
    // 右メニューバーの表示前イベント
    @objc optional func rightWillOpen()
    // 右メニューバーの表示後イベント
    @objc optional func rightDidOpen()
    // 右メニューバーの非表示前イベント
    @objc optional func rightWillClose()
    // 右メニューバーの非表示後イベント
    @objc optional func rightDidClose()
}

//
// SlideMenuOptions構造体
//
public struct SlideMenuOptions {
    public static var leftViewWidth: CGFloat = 270.0
    public static var leftBezelWidth: CGFloat? = 64.0
    public static var contentViewScale: CGFloat = 0.96
    public static var contentViewOpacity: CGFloat = 0.5
    public static var contentViewDrag: Bool = false
    public static var shadowOpacity: CGFloat = 0.0
    public static var shadowRadius: CGFloat = 0.0
    public static var shadowOffset: CGSize = CGSize(width: 0,height: 0)
    public static var panFromBezel: Bool = true
    public static var animationDuration: CGFloat = 0.4
    public static var animationOptions: UIViewAnimationOptions = []
    public static var rightViewWidth: CGFloat = 270.0
    public static var rightBezelWidth: CGFloat? = 64.0
    public static var rightPanFromBezel: Bool = true
    public static var hideStatusBar: Bool = true
    public static var pointOfNoReturnWidth: CGFloat = 44.0
    public static var simultaneousGestureRecognizers: Bool = true
	public static var opacityViewBackgroundColor: UIColor = UIColor.black
    public static var panGesturesEnabled: Bool = true
    public static var tapGesturesEnabled: Bool = true
}

//
// SlideMenuControllerクラス
//
open class SlideMenuController: UIViewController, UIGestureRecognizerDelegate {

    /**
     * 定数
     */
    //
    // SlideAction定数
    //
    public enum SlideAction {
        case open
        case close
    }
    
    //
    // TrackAction定数
    //
    public enum TrackAction {
        case leftTapOpen
        case leftTapClose
        case leftFlickOpen
        case leftFlickClose
        case rightTapOpen
        case rightTapClose
        case rightFlickOpen
        case rightFlickClose
    }
    
    //
    // PanInfo構造体
    //
    struct PanInfo {
        var action: SlideAction
        var shouldBounce: Bool
        var velocity: CGFloat
    }

    
    /**
     * 変数
     */
    //
    // SlideMenuControllerDelegateデリゲート
    //
    open weak var delegate: SlideMenuControllerDelegate?
    
    open var opacityView = UIView()
    open var mainContainerView = UIView()
    open var leftContainerView = UIView()
    open var rightContainerView =  UIView()
    open var mainViewController: UIViewController? = nil
    open var leftViewController: UIViewController? = nil
    open var leftPanGesture: UIPanGestureRecognizer? = nil
    open var leftTapGesture: UITapGestureRecognizer? = nil
    open var rightViewController: UIViewController? = nil
    open var rightPanGesture: UIPanGestureRecognizer? = nil
    open var rightTapGesture: UITapGestureRecognizer? = nil
    
    ///
    ///　初期化処理（Storyboard/xibから）
    ///　- parameter aDecoder:NSCoder
    ///
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    ///
    ///　初期化処理
    ///　- parameter nibNameOrNil:String
    ///　- parameter nibBundleOrNil:Bundle
    ///
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    ///
    ///　初期化処理
    ///　- parameter mainViewController:メイン画面のコントローラー
    ///
    public convenience init(mainViewController: UIViewController) {
        // 基底の初期化処理を呼び出す
        self.init()
        // メンバ変数にmainViewControllerを保持する
        self.mainViewController = mainViewController
        // 初期表示処理を呼び出す
        initView()
    }
    
    ///
    ///　初期化処理
    ///　- parameter mainViewController:メイン画面のコントローラー
    ///　- parameter leftMenuViewController:左メニューバー画面のコントローラー
    ///
    public convenience init(mainViewController: UIViewController, leftMenuViewController: UIViewController) {
        // 基底の初期化処理を呼び出す
        self.init()
        // メンバ変数にmainViewControllerを保持する
        self.mainViewController = mainViewController
        // メンバ変数にleftMenuViewControllerを保持する
        self.leftViewController = leftMenuViewController
        // 初期表示処理を呼び出す
        initView()
    }
    
    ///
    ///　初期化処理
    ///　- parameter mainViewController:メイン画面のコントローラー
    ///　- parameter rightMenuViewController:右メニューバー画面のコントローラー
    ///
    public convenience init(mainViewController: UIViewController, rightMenuViewController: UIViewController) {
        self.init()
        // メンバ変数にmainViewControllerを保持する
        self.mainViewController = mainViewController
        // メンバ変数にrightMenuViewControllerを保持する
        self.rightViewController = rightMenuViewController
        // 初期表示処理を呼び出す
        initView()
    }
    
    ///
    ///　初期化処理
    ///　- parameter mainViewController:メイン画面のコントローラー
    ///　- parameter leftMenuViewController:左メニューバー画面のコントローラー
    ///　- parameter rightMenuViewController:右メニューバー画面のコントローラー
    ///
    public convenience init(mainViewController: UIViewController, leftMenuViewController: UIViewController, rightMenuViewController: UIViewController) {
        self.init()
        // メンバ変数にmainViewControllerを保持する
        self.mainViewController = mainViewController
        // メンバ変数にleftMenuViewControllerを保持する
        self.leftViewController = leftMenuViewController
        // メンバ変数にrightMenuViewControllerを保持する
        self.rightViewController = rightMenuViewController
        // 初期表示処理を呼び出す
        initView()
    }
    
    ///
    ///　awakeFromNibイベント
    ///
    open override func awakeFromNib() {
        // 初期表示処理を呼び出す
        initView()
    }
    
    ///
    ///　初期表示処理
    ///
    open func initView() {
        // メインコンテンツを生成する
        self.mainContainerView = UIView(frame: view.bounds)
        self.mainContainerView.backgroundColor = UIColor.clear
        self.mainContainerView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        // メインコンテンツの０番目にメイン画面を挿入する
        view.insertSubview(self.mainContainerView, at: 0)

        // 透明画面を作成
        var opacityframe: CGRect = view.bounds
        let opacityOffset: CGFloat = 0
        opacityframe.origin.y = opacityframe.origin.y + opacityOffset
        opacityframe.size.height = opacityframe.size.height - opacityOffset
        self.opacityView = UIView(frame: opacityframe)
        self.opacityView.backgroundColor = SlideMenuOptions.opacityViewBackgroundColor
        self.opacityView.autoresizingMask = [UIViewAutoresizing.flexibleHeight, UIViewAutoresizing.flexibleWidth]
        self.opacityView.layer.opacity = 0.0
        // メインコンテンツの１番目に透明画面を挿入する
        view.insertSubview(self.opacityView, at: 1)
      
        // 左メニューバー画面が有効な場合
        if self.leftViewController != nil {
            // 左メニューバー画面を作成
            var leftFrame: CGRect = view.bounds
            leftFrame.size.width = SlideMenuOptions.leftViewWidth
            leftFrame.origin.x = leftMinOrigin()
            let leftOffset: CGFloat = 0
            leftFrame.origin.y = leftFrame.origin.y + leftOffset
            leftFrame.size.height = leftFrame.size.height - leftOffset
            self.leftContainerView = UIView(frame: leftFrame)
            self.leftContainerView.backgroundColor = UIColor.clear
            self.leftContainerView.autoresizingMask = UIViewAutoresizing.flexibleHeight
            // メインコンテンツの２番目に左メニューバー画面を挿入する
            view.insertSubview(self.leftContainerView, at: 2)
            addLeftGestures()
        }
      
        // 右メニューバー画面が有効な場合
        if self.rightViewController != nil {
            // 右メニューバー画面を作成
            var rightFrame: CGRect = view.bounds
            rightFrame.size.width = SlideMenuOptions.rightViewWidth
            rightFrame.origin.x = rightMinOrigin()
            let rightOffset: CGFloat = 0
            rightFrame.origin.y = rightFrame.origin.y + rightOffset
            rightFrame.size.height = rightFrame.size.height - rightOffset
            self.rightContainerView = UIView(frame: rightFrame)
            self.rightContainerView.backgroundColor = UIColor.clear
            self.rightContainerView.autoresizingMask = UIViewAutoresizing.flexibleHeight
            // メインコンテンツの３番目に右メニューバー画面を挿入する
            view.insertSubview(self.rightContainerView, at: 3)
            addRightGestures()
        }
    }
  
    ///
    ///　viewWillTransitionイベント処理
    ///　- parameter size:CGSize
    ///　- parameter coordinator:UIViewControllerTransitionCoordinator
    ///
    open override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        mainContainerView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        leftContainerView.isHidden = true
        rightContainerView.isHidden = true
      
        coordinator.animate(alongsideTransition: nil, completion: { (context: UIViewControllerTransitionCoordinatorContext!) -> Void in
            self.closeLeftNonAnimation()
            self.closeRightNonAnimation()
            self.leftContainerView.isHidden = false
            self.rightContainerView.isHidden = false
      
            if self.leftPanGesture != nil && self.leftPanGesture != nil {
                self.removeLeftGestures()
                self.addLeftGestures()
            }
            
            if self.rightPanGesture != nil && self.rightPanGesture != nil {
                self.removeRightGestures()
                self.addRightGestures()
            }
        })
    }
  
    ///
    ///　viewDidLoadイベント処理
    ///
    open override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = UIRectEdge()
    }

    ///
    ///　viewWillAppearイベント処理
    ///　- parameter:animated:true:アニメーションする false:アニメーションしない
    ///
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    ///
    ///　画面の向きを取得
    ///　- returns UIInterfaceOrientationMask
    ///
    open override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        if let mainController = self.mainViewController{
            return mainController.supportedInterfaceOrientations
        }
        return UIInterfaceOrientationMask.all
    }
    
    ///
    ///　画面の回転制御を取得
    ///　- returns Bool
    ///
    open override var shouldAutorotate : Bool {
        return mainViewController?.shouldAutorotate ?? false
    }
        
    ///
    ///　viewWillLayoutSubviewsイベント処理
    ///
    open override func viewWillLayoutSubviews() {
        // topLayoutGuideの値が確定するこのタイミングで各種ViewControllerをセットする
        setUpViewController(mainContainerView, targetViewController: mainViewController)
        if(nil != self.leftViewController){
            setUpViewController(leftContainerView, targetViewController: leftViewController)
        }
        if(nil != self.rightViewController){
            setUpViewController(rightContainerView, targetViewController: rightViewController)
        }
    }
    
    ///
    ///　スタイル指定を取得
    ///　- returns UIStatusBarStyle
    ///
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.mainViewController?.preferredStatusBarStyle ?? .default
    }
    
    ///
    /// MainViewController取得処理
    ///　- returns nil以外:MainViewController nil:取得できなかった
    ///
    func getMainViewController() -> MainViewController? {
        // navigationControllerが有効な場合
        if let navigationController = self.mainViewController as? UINavigationController {
            // navigationControllerのview数分処理する
            for cntl : UIViewController in navigationController.viewControllers {
                // MainViewControllerの場合
                if let parrentMainViewController = cntl as? MainViewController {
                    // MainViewControllerを返す
                    return parrentMainViewController
                }
            }
        }
        
        // nilを返す
        return nil
    }
    
    ///
    /// 右メニューバー利用可/不可判断
    ///　- returns true:利用可 false:利用不可
    ///
    func isValidRightMenuBar() -> Bool {
        // MainViewControllerが有効な場合
        if let mainViewController = getMainViewController() {
            // 右メニューバー利用可/不可判断を取得
            return mainViewController.isValidRightMenuBar
        // 上記以外の場合
        } else {
            // 利用不可を返す
            return false
        }
    }
    
    ///
    /// 左メニューバー利用可/不可判断
    ///　- returns true:利用可 false:利用不可
    ///
    func isValidLeftMenuBar() -> Bool {
        // MainViewControllerが有効な場合
        if let mainViewController = getMainViewController() {
            // 左メニューバー利用可/不可判断を取得
            return mainViewController.isValidLeftMenuBar
        // 上記以外の場合
        } else {
            // 利用不可を返す
            return false
        }
    }
    
    ///
    /// 左メニューバー表示処理
    ///
    open override func openLeft() {
        // leftViewControllerが無効な場合
        guard let _ = leftViewController else { // If leftViewController is nil, then return
            // 処理しない
            return
        }
        
        // 左メニューバーオープンイベントを通知
        self.delegate?.leftWillOpen?()
        
        // WindowLevelを設定する
        setOpenWindowLevel()
        // 左メニューバーのviewWillAppearを実行
        leftViewController?.beginAppearanceTransition(isLeftHidden(), animated: true)
        // 左メニューバーの表示
        openLeftWithVelocity(0.0)

        // 左メニューバーオープン通知
        track(.leftTapOpen)
    }
    
    ///
    /// 右メニューバー表示処理
    ///
    open override func openRight() {
        // rightViewControllerが無効な場合
        guard let _ = rightViewController else { // If rightViewController is nil, then return
            // 処理しない
            return
        }

        // 右メニューバーオープンイベントを通知
        self.delegate?.rightWillOpen?()
        
        setOpenWindowLevel()
        rightViewController?.beginAppearanceTransition(isRightHidden(), animated: true)
        openRightWithVelocity(0.0)
        
        track(.rightTapOpen)
    }
    
    ///
    /// 左メニューバー非表示処理
    ///
    open override func closeLeft() {
        guard let _ = leftViewController else { // If leftViewController is nil, then return
            return
        }
        
        self.delegate?.leftWillClose?()
        
        leftViewController?.beginAppearanceTransition(isLeftHidden(), animated: true)
        closeLeftWithVelocity(0.0)
        setCloseWindowLevel()
    }
    
    ///
    /// 右メニューバー非表示処理
    ///
    open override func closeRight() {
        guard let _ = rightViewController else { // If rightViewController is nil, then return
            return
        }
        
        self.delegate?.rightWillClose?()
        
        rightViewController?.beginAppearanceTransition(isRightHidden(), animated: true)
        closeRightWithVelocity(0.0)
        setCloseWindowLevel()
    }
    
    ///
    /// 左メニューバー追加処理
    ///
    open func addLeftGestures() {
    
        if leftViewController != nil {
            if SlideMenuOptions.panGesturesEnabled {
                if leftPanGesture == nil {
                    leftPanGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handleLeftPanGesture(_:)))
                    leftPanGesture!.delegate = self
                    view.addGestureRecognizer(leftPanGesture!)
                }
            }
            
            if SlideMenuOptions.tapGesturesEnabled {
                if leftTapGesture == nil {
                    leftTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.toggleLeft))
                    leftTapGesture!.delegate = self
                    view.addGestureRecognizer(leftTapGesture!)
                }
            }
        }
    }
    
    ///
    /// 右メニューバー追加処理
    ///
    open func addRightGestures() {
        
        if rightViewController != nil {
            if SlideMenuOptions.panGesturesEnabled {
                if rightPanGesture == nil {
                    rightPanGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handleRightPanGesture(_:)))
                    rightPanGesture!.delegate = self
                    view.addGestureRecognizer(rightPanGesture!)
                }
            }
            
            if SlideMenuOptions.tapGesturesEnabled {
                if rightTapGesture == nil {
                    rightTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.toggleRight))
                    rightTapGesture!.delegate = self
                    view.addGestureRecognizer(rightTapGesture!)
                }
            }
        }
    }
    
    ///
    /// 左メニューバー削除処理
    ///
    open func removeLeftGestures() {
        
        if leftPanGesture != nil {
            view.removeGestureRecognizer(leftPanGesture!)
            leftPanGesture = nil
        }
        
        if leftTapGesture != nil {
            view.removeGestureRecognizer(leftTapGesture!)
            leftTapGesture = nil
        }
    }
    
    ///
    /// 右メニューバー削除処理
    ///
    open func removeRightGestures() {
        
        if rightPanGesture != nil {
            view.removeGestureRecognizer(rightPanGesture!)
            rightPanGesture = nil
        }
        
        if rightTapGesture != nil {
            view.removeGestureRecognizer(rightTapGesture!)
            rightTapGesture = nil
        }
    }
    
    ///
    /// 指定ビューの判定処理
    ///　- returns Bool
    ///
    open func isTagetViewController() -> Bool {
        return true
    }
    
    ///
    /// TrackAction処理
    ///　- parameter:trackAction:TrackAction
    ///
    open func track(_ trackAction: TrackAction) {
    }
    
    ///
    /// LeftPanState構造体
    ///
    struct LeftPanState {
        static var frameAtStartOfPan: CGRect = CGRect.zero
        static var startPointOfPan: CGPoint = CGPoint.zero
        static var wasOpenAtStartOfPan: Bool = false
        static var wasHiddenAtStartOfPan: Bool = false
        static var lastState : UIGestureRecognizerState = .ended
    }
    
    ///
    /// 左メニューバーのスライドイベントによる表示処理
    ///　- parameter:panGesture:UIPanGestureRecognizer
    ///
    func handleLeftPanGesture(_ panGesture: UIPanGestureRecognizer) {
        
        if !isTagetViewController() {
            return
        }
        
        if !isValidLeftMenuBar() {
            return
        }
        
        if isRightOpen() {
            return
        }
        
        switch panGesture.state {
            case UIGestureRecognizerState.began:
                if LeftPanState.lastState != .ended &&  LeftPanState.lastState != .cancelled &&  LeftPanState.lastState != .failed {
                    return
                }
                
                if isLeftHidden() {
                    self.delegate?.leftWillOpen?()
                } else {
                    self.delegate?.leftWillClose?()
                }
                
                LeftPanState.frameAtStartOfPan = leftContainerView.frame
                LeftPanState.startPointOfPan = panGesture.location(in: view)
                LeftPanState.wasOpenAtStartOfPan = isLeftOpen()
                LeftPanState.wasHiddenAtStartOfPan = isLeftHidden()
                
                leftViewController?.beginAppearanceTransition(LeftPanState.wasHiddenAtStartOfPan, animated: true)
                addShadowToView(leftContainerView)
                setOpenWindowLevel()
            case UIGestureRecognizerState.changed:
                if LeftPanState.lastState != .began && LeftPanState.lastState != .changed {
                    return
                }
                
                let translation: CGPoint = panGesture.translation(in: panGesture.view!)
                leftContainerView.frame = applyLeftTranslation(translation, toFrame: LeftPanState.frameAtStartOfPan)
                applyLeftOpacity()
                applyLeftContentViewScale()
            case UIGestureRecognizerState.ended, UIGestureRecognizerState.cancelled:
                if LeftPanState.lastState != .changed {
                    setCloseWindowLevel()
                    return
                }
                
                let velocity:CGPoint = panGesture.velocity(in: panGesture.view)
                let panInfo: PanInfo = panLeftResultInfoForVelocity(velocity)
                
                if panInfo.action == .open {
                    if !LeftPanState.wasHiddenAtStartOfPan {
                        leftViewController?.beginAppearanceTransition(true, animated: true)
                    }
                    openLeftWithVelocity(panInfo.velocity)
                    
                    track(.leftFlickOpen)
                } else {
                    if LeftPanState.wasHiddenAtStartOfPan {
                        leftViewController?.beginAppearanceTransition(false, animated: true)
                    }
                    closeLeftWithVelocity(panInfo.velocity)
                    setCloseWindowLevel()
                    
                    track(.leftFlickClose)

                }
            case UIGestureRecognizerState.failed, UIGestureRecognizerState.possible:
                break
        }
        
        LeftPanState.lastState = panGesture.state
    }
    
    ///
    /// RightPanState構造体
    ///
    struct RightPanState {
        static var frameAtStartOfPan: CGRect = CGRect.zero
        static var startPointOfPan: CGPoint = CGPoint.zero
        static var wasOpenAtStartOfPan: Bool = false
        static var wasHiddenAtStartOfPan: Bool = false
        static var lastState : UIGestureRecognizerState = .ended
    }
    
    ///
    /// 右メニューバーのスライドイベントによる表示処理
    ///　- parameter:panGesture:UIPanGestureRecognizer
    ///
    func handleRightPanGesture(_ panGesture: UIPanGestureRecognizer) {
        
        if !isTagetViewController() {
            return
        }
        
        if !isValidRightMenuBar() {
            return
        }
        
        if isLeftOpen() {
            return
        }
        
        switch panGesture.state {
        case UIGestureRecognizerState.began:
            if RightPanState.lastState != .ended &&  RightPanState.lastState != .cancelled &&  RightPanState.lastState != .failed {
                return
            }
            
            if isRightHidden() {
                self.delegate?.rightWillOpen?()
            } else {
                self.delegate?.rightWillClose?()
            }
            
            RightPanState.frameAtStartOfPan = rightContainerView.frame
            RightPanState.startPointOfPan = panGesture.location(in: view)
            RightPanState.wasOpenAtStartOfPan =  isRightOpen()
            RightPanState.wasHiddenAtStartOfPan = isRightHidden()
            
            rightViewController?.beginAppearanceTransition(RightPanState.wasHiddenAtStartOfPan, animated: true)
            
            addShadowToView(rightContainerView)
            setOpenWindowLevel()
        case UIGestureRecognizerState.changed:
            if RightPanState.lastState != .began && RightPanState.lastState != .changed {
                return
            }
            
            let translation: CGPoint = panGesture.translation(in: panGesture.view!)
            rightContainerView.frame = applyRightTranslation(translation, toFrame: RightPanState.frameAtStartOfPan)
            applyRightOpacity()
            applyRightContentViewScale()
            
        case UIGestureRecognizerState.ended, UIGestureRecognizerState.cancelled:
            if RightPanState.lastState != .changed {
                setCloseWindowLevel()
                return
            }
            
            let velocity: CGPoint = panGesture.velocity(in: panGesture.view)
            let panInfo: PanInfo = panRightResultInfoForVelocity(velocity)
            
            if panInfo.action == .open {
                if !RightPanState.wasHiddenAtStartOfPan {
                    rightViewController?.beginAppearanceTransition(true, animated: true)
                }
                openRightWithVelocity(panInfo.velocity)
                
                track(.rightFlickOpen)
            } else {
                if RightPanState.wasHiddenAtStartOfPan {
                    rightViewController?.beginAppearanceTransition(false, animated: true)
                }
                closeRightWithVelocity(panInfo.velocity)
                setCloseWindowLevel()
                
                track(.rightFlickClose)
            }
        case UIGestureRecognizerState.failed, UIGestureRecognizerState.possible:
            break
        }
        
        RightPanState.lastState = panGesture.state
    }
    
    ///
    /// 左メニューバーの表示処理
    ///　- parameter:velocity:表示速度
    ///
    open func openLeftWithVelocity(_ velocity: CGFloat) {
        let xOrigin: CGFloat = leftContainerView.frame.origin.x
        let finalXOrigin: CGFloat = 0.0
        
        var frame = leftContainerView.frame
        frame.origin.x = finalXOrigin
        
        var duration: TimeInterval = Double(SlideMenuOptions.animationDuration)
        if velocity != 0.0 {
            duration = Double(fabs(xOrigin - finalXOrigin) / velocity)
            duration = Double(fmax(0.1, fmin(1.0, duration)))
        }
        
        addShadowToView(leftContainerView)
        
        UIView.animate(withDuration: duration, delay: 0.0, options: SlideMenuOptions.animationOptions, animations: { [weak self]() -> Void in
            if let strongSelf = self {
                strongSelf.leftContainerView.frame = frame
                strongSelf.opacityView.layer.opacity = Float(SlideMenuOptions.contentViewOpacity)
              
                SlideMenuOptions.contentViewDrag == true ? (strongSelf.mainContainerView.transform = CGAffineTransform(translationX: SlideMenuOptions.leftViewWidth, y: 0)) : (strongSelf.mainContainerView.transform = CGAffineTransform(scaleX: SlideMenuOptions.contentViewScale, y: SlideMenuOptions.contentViewScale))
                
            }
            }) { [weak self](Bool) -> Void in
                if let strongSelf = self {
                    strongSelf.disableContentInteraction()
                    strongSelf.leftViewController?.endAppearanceTransition()
                    strongSelf.delegate?.leftDidOpen?()
                }
        }
    }
    
    ///
    /// 右メニューバーの表示処理
    ///　- parameter:velocity:表示速度
    ///
    open func openRightWithVelocity(_ velocity: CGFloat) {
        let xOrigin: CGFloat = rightContainerView.frame.origin.x
    
        //	CGFloat finalXOrigin = SlideMenuOptions.rightViewOverlapWidth
        let finalXOrigin: CGFloat = view.bounds.width - rightContainerView.frame.size.width
        
        var frame = rightContainerView.frame
        frame.origin.x = finalXOrigin
    
        var duration: TimeInterval = Double(SlideMenuOptions.animationDuration)
        if velocity != 0.0 {
            duration = Double(fabs(xOrigin - view.bounds.width) / velocity)
            duration = Double(fmax(0.1, fmin(1.0, duration)))
        }
    
        addShadowToView(rightContainerView)
    
        UIView.animate(withDuration: duration, delay: 0.0, options: SlideMenuOptions.animationOptions, animations: { [weak self]() -> Void in
            if let strongSelf = self {
                strongSelf.rightContainerView.frame = frame
                strongSelf.opacityView.layer.opacity = Float(SlideMenuOptions.contentViewOpacity)
            
                SlideMenuOptions.contentViewDrag == true ? (strongSelf.mainContainerView.transform = CGAffineTransform(translationX: -SlideMenuOptions.rightViewWidth, y: 0)) : (strongSelf.mainContainerView.transform = CGAffineTransform(scaleX: SlideMenuOptions.contentViewScale, y: SlideMenuOptions.contentViewScale))
            }
            }) { [weak self](Bool) -> Void in
                if let strongSelf = self {
                    strongSelf.disableContentInteraction()
                    strongSelf.rightViewController?.endAppearanceTransition()
                    strongSelf.delegate?.rightDidOpen?()
                }
        }
    }
    
    ///
    /// 左メニューバーの非表示処理
    ///　- parameter:velocity:表示速度
    ///
    open func closeLeftWithVelocity(_ velocity: CGFloat) {
        
        let xOrigin: CGFloat = leftContainerView.frame.origin.x
        let finalXOrigin: CGFloat = leftMinOrigin()
        
        var frame: CGRect = leftContainerView.frame
        frame.origin.x = finalXOrigin
    
        var duration: TimeInterval = Double(SlideMenuOptions.animationDuration)
        if velocity != 0.0 {
            duration = Double(fabs(xOrigin - finalXOrigin) / velocity)
            duration = Double(fmax(0.1, fmin(1.0, duration)))
        }
        
        UIView.animate(withDuration: duration, delay: 0.0, options: SlideMenuOptions.animationOptions, animations: { [weak self]() -> Void in
            if let strongSelf = self {
                strongSelf.leftContainerView.frame = frame
                strongSelf.opacityView.layer.opacity = 0.0
                strongSelf.mainContainerView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }
            }) { [weak self](Bool) -> Void in
                if let strongSelf = self {
                    strongSelf.removeShadow(strongSelf.leftContainerView)
                    strongSelf.enableContentInteraction()
                    strongSelf.leftViewController?.endAppearanceTransition()
                    strongSelf.delegate?.leftDidClose?()
                }
        }
    }
    
    ///
    /// 右メニューバーの非表示処理
    ///　- parameter velocity:表示速度
    ///
    open func closeRightWithVelocity(_ velocity: CGFloat) {
    
        let xOrigin: CGFloat = rightContainerView.frame.origin.x
        let finalXOrigin: CGFloat = view.bounds.width
    
        var frame: CGRect = rightContainerView.frame
        frame.origin.x = finalXOrigin
    
        var duration: TimeInterval = Double(SlideMenuOptions.animationDuration)
        if velocity != 0.0 {
            duration = Double(fabs(xOrigin - view.bounds.width) / velocity)
            duration = Double(fmax(0.1, fmin(1.0, duration)))
        }
    
        UIView.animate(withDuration: duration, delay: 0.0, options: SlideMenuOptions.animationOptions, animations: { [weak self]() -> Void in
            if let strongSelf = self {
                strongSelf.rightContainerView.frame = frame
                strongSelf.opacityView.layer.opacity = 0.0
                strongSelf.mainContainerView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }
            }) { [weak self](Bool) -> Void in
                if let strongSelf = self {
                    strongSelf.removeShadow(strongSelf.rightContainerView)
                    strongSelf.enableContentInteraction()
                    strongSelf.rightViewController?.endAppearanceTransition()
                    strongSelf.delegate?.rightDidClose?()
                }
        }
    }
    
    ///
    /// 左メニューバーのトグル処理
    ///
    open override func toggleLeft() {
        if isLeftOpen() {
            closeLeft()
            setCloseWindowLevel()
            
            track(.leftTapClose)
        } else {
            openLeft()
        }
    }
    
    ///
    /// 左メニューバーの表示判定
    ///　- returns true:表示中 false:非表示
    ///
    open func isLeftOpen() -> Bool {
        // 左メニューバーがが有効、かつ、左メニューバーのX座標が表示座標である場合
        return leftViewController != nil && leftContainerView.frame.origin.x == 0.0
    }
    
    ///
    /// 左メニューバーの非表示判定
    ///　- returns true:非表示 false:表示中
    ///
    open func isLeftHidden() -> Bool {
        return leftContainerView.frame.origin.x <= leftMinOrigin()
    }
    
    ///
    /// 右メニューバーのトグル処理
    ///
    open override func toggleRight() {
        if isRightOpen() {
            closeRight()
            setCloseWindowLevel()
            
            // Tracking of close tap is put in here. Because closeMenu is due to be call even when the menu tap.
            track(.rightTapClose)
        } else {
            openRight()
        }
    }
    
    ///
    /// 右メニューバーの表示判定
    ///　- returns true:表示中 false:非表示
    ///
    open func isRightOpen() -> Bool {
        // 右メニューバーがが有効、かつ、右メニューバーのX座標が表示座標である場合
        return rightViewController != nil && rightContainerView.frame.origin.x == view.bounds.width - rightContainerView.frame.size.width
    }
    
    ///
    /// 右メニューバーの非表示判定
    ///　- returns true:非表示 false:表示中
    ///
    open func isRightHidden() -> Bool {
        return rightContainerView.frame.origin.x >= view.bounds.width
    }
    
    ///
    /// メイン画面に切り替える
    ///　- parameter mainViewController:メイン画面
    ///　- parameter close:true:メニューバーを閉じる false:メニューバーはそのままにする
    ///
    open func changeMainViewController(_ mainViewController: UIViewController,  close: Bool) {
        
        removeViewController(self.mainViewController)
        self.mainViewController = mainViewController
        setUpViewController(mainContainerView, targetViewController: mainViewController)
        if close {
            closeLeft()
            closeRight()
        }
    }
    
    ///
    /// 左メニューバーの幅変更処理
    ///　- parameter width:幅
    ///
    open func changeLeftViewWidth(_ width: CGFloat) {
        
        SlideMenuOptions.leftViewWidth = width
        var leftFrame: CGRect = view.bounds
        leftFrame.size.width = width
        leftFrame.origin.x = leftMinOrigin()
        let leftOffset: CGFloat = 0
        leftFrame.origin.y = leftFrame.origin.y + leftOffset
        leftFrame.size.height = leftFrame.size.height - leftOffset
        leftContainerView.frame = leftFrame
    }
    
    ///
    /// 右メニューバーの幅変更処理
    ///　- parameter width:幅
    ///
    open func changeRightViewWidth(_ width: CGFloat) {
        
        SlideMenuOptions.rightBezelWidth = width
        var rightFrame: CGRect = view.bounds
        rightFrame.size.width = width
        rightFrame.origin.x = rightMinOrigin()
        let rightOffset: CGFloat = 0
        rightFrame.origin.y = rightFrame.origin.y + rightOffset
        rightFrame.size.height = rightFrame.size.height - rightOffset
        rightContainerView.frame = rightFrame
    }

    ///
    /// 左メニューバーの最小マージン取得
    ///　- returns 左メニューバーの最小マージン
    ///
    fileprivate func leftMinOrigin() -> CGFloat {
        return  -SlideMenuOptions.leftViewWidth
    }
    
    ///
    /// 右メニューバーの最小マージン取得
    ///　- returns 右メニューバーの最小マージン
    ///
    fileprivate func rightMinOrigin() -> CGFloat {
        return view.bounds.width
    }
    
    ///
    /// 左メニューバーの表示動作情報取得
    ///　- parameter velocity:表示速度
    ///　- returns PanInfo
    ///
    fileprivate func panLeftResultInfoForVelocity(_ velocity: CGPoint) -> PanInfo {
        
        let thresholdVelocity: CGFloat = 1000.0
        let pointOfNoReturn: CGFloat = CGFloat(floor(leftMinOrigin())) + SlideMenuOptions.pointOfNoReturnWidth
        let leftOrigin: CGFloat = leftContainerView.frame.origin.x
        
        var panInfo: PanInfo = PanInfo(action: .close, shouldBounce: false, velocity: 0.0)
        
        panInfo.action = leftOrigin <= pointOfNoReturn ? .close : .open
        
        if velocity.x >= thresholdVelocity {
            panInfo.action = .open
            panInfo.velocity = velocity.x
        } else if velocity.x <= (-1.0 * thresholdVelocity) {
            panInfo.action = .close
            panInfo.velocity = velocity.x
        }
        
        return panInfo
    }
    
    ///
    /// 右メニューバーの表示動作情報取得
    ///　- parameter velocity:表示速度
    ///　- returns PanInfo
    ///
    fileprivate func panRightResultInfoForVelocity(_ velocity: CGPoint) -> PanInfo {
        
        let thresholdVelocity: CGFloat = -1000.0
        let pointOfNoReturn: CGFloat = CGFloat(floor(view.bounds.width) - SlideMenuOptions.pointOfNoReturnWidth)
        let rightOrigin: CGFloat = rightContainerView.frame.origin.x
        
        var panInfo: PanInfo = PanInfo(action: .close, shouldBounce: false, velocity: 0.0)
        
        panInfo.action = rightOrigin >= pointOfNoReturn ? .close : .open
        
        if velocity.x <= thresholdVelocity {
            panInfo.action = .open
            panInfo.velocity = velocity.x
        } else if velocity.x >= (-1.0 * thresholdVelocity) {
            panInfo.action = .close
            panInfo.velocity = velocity.x
        }
        
        return panInfo
    }
    
    ///
    /// 左メニューバーの適正化した画面サイズ取得
    ///　- parameter translation:表示位置
    ///　- parameter toFrame:画面サイズ
    ///　- returns 表示画面位置・サイズ
    ///
    fileprivate func applyLeftTranslation(_ translation: CGPoint, toFrame:CGRect) -> CGRect {
        
        var newOrigin: CGFloat = toFrame.origin.x
        newOrigin += translation.x
        
        let minOrigin: CGFloat = leftMinOrigin()
        let maxOrigin: CGFloat = 0.0
        var newFrame: CGRect = toFrame
        
        if newOrigin < minOrigin {
            newOrigin = minOrigin
        } else if newOrigin > maxOrigin {
            newOrigin = maxOrigin
        }
        
        newFrame.origin.x = newOrigin
        return newFrame
    }
    
    ///
    /// 右メニューバーの適正化した画面サイズ取得
    ///　- parameter translation:表示位置
    ///　- parameter toFrame:画面サイズ
    ///　- returns 表示画面位置・サイズ
    ///
    fileprivate func applyRightTranslation(_ translation: CGPoint, toFrame: CGRect) -> CGRect {
        
        var  newOrigin: CGFloat = toFrame.origin.x
        newOrigin += translation.x
        
        let minOrigin: CGFloat = rightMinOrigin()
        let maxOrigin: CGFloat = rightMinOrigin() - rightContainerView.frame.size.width
        var newFrame: CGRect = toFrame
        
        if newOrigin > minOrigin {
            newOrigin = minOrigin
        } else if newOrigin < maxOrigin {
            newOrigin = maxOrigin
        }
        
        newFrame.origin.x = newOrigin
        return newFrame
    }
    
    ///
    /// 左メニューバー幅の係数を取得
    ///　- returns 幅の係数
    ///
    fileprivate func getOpenedLeftRatio() -> CGFloat {
        
        let width: CGFloat = leftContainerView.frame.size.width
        let currentPosition: CGFloat = leftContainerView.frame.origin.x - leftMinOrigin()
        return currentPosition / width
    }
    
    ///
    /// 右メニューバー幅の係数を取得
    ///　- returns 幅の係数
    ///
    fileprivate func getOpenedRightRatio() -> CGFloat {
        
        let width: CGFloat = rightContainerView.frame.size.width
        let currentPosition: CGFloat = rightContainerView.frame.origin.x
        return -(currentPosition - view.bounds.width) / width
    }
    
    ///
    /// 左メニューバーの不透明度を設定
    ///
    fileprivate func applyLeftOpacity() {
        
        let openedLeftRatio: CGFloat = getOpenedLeftRatio()
        let opacity: CGFloat = SlideMenuOptions.contentViewOpacity * openedLeftRatio
        opacityView.layer.opacity = Float(opacity)
    }
    
    ///
    /// 右メニューバーの不透明度を設定
    ///
    fileprivate func applyRightOpacity() {
        let openedRightRatio: CGFloat = getOpenedRightRatio()
        let opacity: CGFloat = SlideMenuOptions.contentViewOpacity * openedRightRatio
        opacityView.layer.opacity = Float(opacity)
    }
    
    ///
    /// 左メニューバーのサイズを設定
    ///
    fileprivate func applyLeftContentViewScale() {
        let openedLeftRatio: CGFloat = getOpenedLeftRatio()
        let scale: CGFloat = 1.0 - ((1.0 - SlideMenuOptions.contentViewScale) * openedLeftRatio)
        let drag: CGFloat = SlideMenuOptions.leftViewWidth + leftContainerView.frame.origin.x
        
        SlideMenuOptions.contentViewDrag == true ? (mainContainerView.transform = CGAffineTransform(translationX: drag, y: 0)) : (mainContainerView.transform = CGAffineTransform(scaleX: scale, y: scale))
    }
    
    ///
    /// 右メニューバーのサイズを設定
    ///
    fileprivate func applyRightContentViewScale() {
        let openedRightRatio: CGFloat = getOpenedRightRatio()
        let scale: CGFloat = 1.0 - ((1.0 - SlideMenuOptions.contentViewScale) * openedRightRatio)
        let drag: CGFloat = rightContainerView.frame.origin.x - mainContainerView.frame.size.width
        
        SlideMenuOptions.contentViewDrag == true ? (mainContainerView.transform = CGAffineTransform(translationX: drag, y: 0)) : (mainContainerView.transform = CGAffineTransform(scaleX: scale, y: scale))
    }
    
    ///
    /// ビューに影を設定
    ///
    fileprivate func addShadowToView(_ targetContainerView: UIView) {
        targetContainerView.layer.masksToBounds = false
        targetContainerView.layer.shadowOffset = SlideMenuOptions.shadowOffset
        targetContainerView.layer.shadowOpacity = Float(SlideMenuOptions.shadowOpacity)
        targetContainerView.layer.shadowRadius = SlideMenuOptions.shadowRadius
        targetContainerView.layer.shadowPath = UIBezierPath(rect: targetContainerView.bounds).cgPath
    }
    
    ///
    /// ビューの影を削除
    ///
    fileprivate func removeShadow(_ targetContainerView: UIView) {
        targetContainerView.layer.masksToBounds = true
        mainContainerView.layer.opacity = 1.0
    }
    
    ///
    /// 不透明度を削除
    ///
    fileprivate func removeContentOpacity() {
        opacityView.layer.opacity = 0.0
    }
    
    ///
    /// 不透明度を設定
    ///
    fileprivate func addContentOpacity() {
        opacityView.layer.opacity = Float(SlideMenuOptions.contentViewOpacity)
    }
    
    ///
    /// メイン画面を使用不可にする
    ///
    fileprivate func disableContentInteraction() {
        mainContainerView.isUserInteractionEnabled = false
    }
    
    ///
    /// メイン画面を可能にする
    ///
    fileprivate func enableContentInteraction() {
        mainContainerView.isUserInteractionEnabled = true
    }
    
    ///
    /// 画面の表示順を手前に表示
    ///
    fileprivate func setOpenWindowLevel() {
        if SlideMenuOptions.hideStatusBar {
            DispatchQueue.main.async(execute: {
                if let window = UIApplication.shared.keyWindow {
                    window.windowLevel = UIWindowLevelStatusBar + 1
                }
            })
        }
    }
    
    ///
    /// 画面の表示順を元に戻す
    ///
    fileprivate func setCloseWindowLevel() {
        if SlideMenuOptions.hideStatusBar {
            DispatchQueue.main.async(execute: {
                if let window = UIApplication.shared.keyWindow {
                    window.windowLevel = UIWindowLevelNormal
                }
            })
        }
    }
    
    ///
    /// ビューコントローラの設定
    ///　- parameter targetView:UIView
    ///　- parameter targetViewController:UIViewController
    ///
    fileprivate func setUpViewController(_ targetView: UIView, targetViewController: UIViewController?) {
        if let viewController = targetViewController {
            viewController.view.frame = targetView.bounds
            
            if (!childViewControllers.contains(viewController)) {
                addChildViewController(viewController)
                targetView.addSubview(viewController.view)
                viewController.didMove(toParentViewController: self)
            }
        }
    }
    
    ///
    /// ビューコントローラの削除
    ///　- parameter viewController:UIViewController
    ///
    fileprivate func removeViewController(_ viewController: UIViewController?) {
        if let _viewController = viewController {
            _viewController.view.layer.removeAllAnimations()
            _viewController.willMove(toParentViewController: nil)
            _viewController.view.removeFromSuperview()
            _viewController.removeFromParentViewController()
        }
    }
    
    ///
    /// 左メニューバーを閉じる（閉じる際のアニメーションなし）
    ///
    open func closeLeftNonAnimation(){
        setCloseWindowLevel()
        let finalXOrigin: CGFloat = leftMinOrigin()
        var frame: CGRect = leftContainerView.frame
        frame.origin.x = finalXOrigin
        leftContainerView.frame = frame
        opacityView.layer.opacity = 0.0
        mainContainerView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        removeShadow(leftContainerView)
        enableContentInteraction()
    }
    
    ///
    /// 右メニューバーを閉じる（閉じる際のアニメーションなし）
    ///
    open func closeRightNonAnimation(){
        setCloseWindowLevel()
        let finalXOrigin: CGFloat = view.bounds.width
        var frame: CGRect = rightContainerView.frame
        frame.origin.x = finalXOrigin
        rightContainerView.frame = frame
        opacityView.layer.opacity = 0.0
        mainContainerView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        removeShadow(rightContainerView)
        enableContentInteraction()
    }
    
    ///
    /// gestureRecognizerイベント
    ///　- parameter gestureRecognizer:UIGestureRecognizer
    ///　- parameter touch:UITouch
    ///　- returns Bool
    ///
    open func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        let point: CGPoint = touch.location(in: view)
        
        if gestureRecognizer == leftPanGesture {
            return slideLeftForGestureRecognizer(gestureRecognizer, point: point)
        } else if gestureRecognizer == rightPanGesture {
            return slideRightViewForGestureRecognizer(gestureRecognizer, withTouchPoint: point)
        } else if gestureRecognizer == leftTapGesture {
            return isLeftOpen() && !isPointContainedWithinLeftRect(point)
        } else if gestureRecognizer == rightTapGesture {
            return isRightOpen() && !isPointContainedWithinRightRect(point)
        }
        
        return true
    }
    
    ///
    /// gestureRecognizerイベント
    ///　- parameter gestureRecognizer:UIGestureRecognizer
    ///　- parameter otherGestureRecognizer:UIGestureRecognizer
    ///　- returns Bool
    ///
    open func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return SlideMenuOptions.simultaneousGestureRecognizers
    }
    
    ///
    /// 左メニューバーのgestureRecognizerイベント
    ///　- parameter gestureRecognizer:UIGestureRecognizer
    ///　- parameter point:座標
    ///　- returns Bool
    ///
    fileprivate func slideLeftForGestureRecognizer( _ gesture: UIGestureRecognizer, point:CGPoint) -> Bool{
        return isLeftOpen() || SlideMenuOptions.panFromBezel && isLeftPointContainedWithinBezelRect(point)
    }
    
    ///
    /// 左メニューバーのオープン時のスライド判定
    ///　- parameter point:座標
    ///　- returns true:オープンする false:オープンしない
    ///
    fileprivate func isLeftPointContainedWithinBezelRect(_ point: CGPoint) -> Bool{
        if let bezelWidth = SlideMenuOptions.leftBezelWidth {
            var leftBezelRect: CGRect = CGRect.zero
            let tuple = view.bounds.divided(atDistance: bezelWidth, from: CGRectEdge.minXEdge)
            leftBezelRect = tuple.slice
            return leftBezelRect.contains(point)
        } else {
            return true
        }
    }
    
    ///
    /// 左メニューバーのクローズ時のスライド判定
    ///　- parameter point:座標
    ///　- returns true:クローズする false:クローズしない
    ///
    fileprivate func isPointContainedWithinLeftRect(_ point: CGPoint) -> Bool {
        return leftContainerView.frame.contains(point)
    }
    
    ///
    /// 右メニューバーのgestureRecognizerイベント
    ///　- parameter gestureRecognizer:UIGestureRecognizer
    ///　- parameter point:座標
    ///　- returns Bool
    ///
    fileprivate func slideRightViewForGestureRecognizer(_ gesture: UIGestureRecognizer, withTouchPoint point: CGPoint) -> Bool {
        return isRightOpen() || SlideMenuOptions.rightPanFromBezel && isRightPointContainedWithinBezelRect(point)
    }
    
    ///
    /// 右メニューバーのオープン時のスライド判定
    ///　- parameter point:座標
    ///　- returns true:オープンする false:オープンしない
    ///
    fileprivate func isRightPointContainedWithinBezelRect(_ point: CGPoint) -> Bool {
        if let rightBezelWidth = SlideMenuOptions.rightBezelWidth {
            var rightBezelRect: CGRect = CGRect.zero
            let bezelWidth: CGFloat = view.bounds.width - rightBezelWidth
            let tuple = view.bounds.divided(atDistance: bezelWidth, from: CGRectEdge.minXEdge)
            rightBezelRect = tuple.remainder
            return rightBezelRect.contains(point)
        } else {
            return true
        }
    }
    
    ///
    /// 右メニューバーのクローズ時のスライド判定
    ///　- parameter point:座標
    ///　- returns true:クローズする false:クローズしない
    ///
    fileprivate func isPointContainedWithinRightRect(_ point: CGPoint) -> Bool {
        return rightContainerView.frame.contains(point)
    }
    
}

//
// UIViewControllerの拡張
//
extension UIViewController {
    ///
    /// SlideMenuControllerの取得
    ///　- returns nil以外:SlideMenuController nil:画面にSlideMenuControllerは存在しない
    ///
    public func slideMenuController() -> SlideMenuController? {
        var viewController: UIViewController? = self
        while viewController != nil {
            if viewController is SlideMenuController {
                return viewController as? SlideMenuController
            }
            viewController = viewController?.parent
        }
        return nil
    }
    
    ///
    /// 左メニューバーのトグル処理
    ///
    public func toggleLeft() {
        slideMenuController()?.toggleLeft()
    }

    ///
    /// 右メニューバーのトグル処理
    ///
    public func toggleRight() {
        slideMenuController()?.toggleRight()
    }
    
    ///
    /// 左メニューバー表示処理
    ///
    public func openLeft() {
        slideMenuController()?.openLeft()
    }
    
    ///
    /// 右メニューバー表示処理
    ///
    public func openRight() {
        slideMenuController()?.openRight()    }
    
    ///
    /// 左メニューバー非表示処理
    ///
    public func closeLeft() {
        slideMenuController()?.closeLeft()
    }
    
    ///
    /// 右メニューバー非表示処理
    ///
    public func closeRight() {
        slideMenuController()?.closeRight()
    }
}
