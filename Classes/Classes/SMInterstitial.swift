

import UIKit
import SafariServices
@objc protocol SMInterstitialDelegate {
    @objc optional func interstitialLoaded(interstitial:SMInterstitial)
    @objc optional func interstitialError()
    @objc optional func interstitialDidClick()
    @objc optional func interstitialCloseClick()
}
class SMInterstitial: NSObject {
    var rootViewController:UIViewController!
    fileprivate var smAds:SMAds!
    let  network:SMNetworkOpertator = SMNetworkOpertator()
    var isLoad:Bool = false
    var slider = false
    var delegate:SMInterstitialDelegate!
    override init() {
        super.init()
        
    }
    
    @objc private func adsClose(){
        if delegate != nil{
            delegate.interstitialCloseClick?()
            NotificationCenter.default.removeObserver(self)
        }
    }
    
    @objc private func adsDidClick(){
        if self.delegate != nil{
            self.delegate.interstitialDidClick?()
            NotificationCenter.default.removeObserver(self)
        }
    }
    
    func load(){
        if rootViewController != nil{
            
            network.getFull(type: slider ? "slider_list":"full", success: { (json) in
                //                print(json)
                if json["msg"] as? String == "Cross is not running." || json["error"] as? NSNumber == 1{
                    print("Tắt Quảng Cáo Chéo")
                }else{
                    self.smAds = SMAds(json)
                    self.isLoad = true
                    
                    if self.delegate != nil{
                        self.delegate.interstitialLoaded?(interstitial: self)
                    }
                    NotificationCenter.default.addObserver(self, selector: #selector(self.adsClose), name: NSNotification.Name(rawValue: "smads_close"), object: nil)
                    
                    NotificationCenter.default.addObserver(self, selector: #selector(self.adsDidClick), name: NSNotification.Name(rawValue: "smads_click"), object: nil)
                }
            }, failure: { (error) in
                print(error)
                self.isLoad = false
                
                if self.delegate != nil{
                    self.delegate.interstitialError?()
                }
                
            })
        }else{
            print("rootViewController is nil. Set rootViewController to start load ads")
            if self.delegate != nil{
                self.delegate.interstitialError?()
            }
        }
    }
    
    func show() {
        if rootViewController != nil && self.smAds != nil && self.isLoad == true{
            let smFullVC = SMFullController()
            smFullVC.modalPresentationStyle = .overCurrentContext
            smFullVC.smAds = self.smAds
            smFullVC.hidesBottomBarWhenPushed = true
            if let appdelete = UIApplication.shared.delegate as? AppDelegate{
                appdelete.window?.rootViewController?.present(smFullVC, animated: true, completion: nil)
            }
            //            rootViewController.present(smFullVC, animated: true, completion: nil)
        }else{
            print("Ads cannot show")
            if self.delegate != nil{
                self.delegate.interstitialError?()
            }
            
        }
    }
    
}

fileprivate class SMFullController : UIViewController,UIWebViewDelegate{
    fileprivate var webView:UIWebView!
    //    fileprivate var btWatermark:UIButton!
    fileprivate var smAds:SMAds!
    fileprivate var loading:UIActivityIndicatorView!
    
    fileprivate var network:SMNetworkOpertator = SMNetworkOpertator()
    fileprivate override func viewDidLoad() {
        self.view.backgroundColor = UIColor.clear
        self.view.isOpaque = false
        
        self.initView()
        if smAds != nil{
            //            print(self.smAds.html)
            //            self.webView.all
            //            self.webView.loadHTMLString(self.smAds.html, baseURL: nil)
            if let url = URL(string:self.smAds.link) {
                self.webView.loadRequest(URLRequest(url: url))
            }
            //            self.webView.loadRequest(URLRequest(url: URL(string: self.smAds.link)!))
        }
        
    }
    
    //    override func viewWillAppear(_ animated: Bool) {
    //        UIApplication.shared.isStatusBarHidden = true
    //    }
    //    override func viewWillDisappear(_ animated: Bool) {
    //        UIApplication.shared.isStatusBarHidden = false
    //
    //    }
    
    private func initView(){
        //        self.view.backgroundColor = UIColor.black
        self.initWebview()
        //        self.initViewClick()
        //        self.initButtonWatermark()
        self.initCloseButton()
        self.initIndicator()
    }
    func initIndicator(){
        loading = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        loading.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        loading.center = self.view.center
        loading.hidesWhenStopped = true
        loading.startAnimating()
        loading.color = UIColor.white
        self.view.addSubview(loading)
        
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        if !webView.isLoading {
            self.loading.stopAnimating()
        }
    }
    
    
    
    private func initWebview(){
        webView = UIWebView(frame: self.view.frame)
        webView.scrollView.bounces = false
        webView.scrollView.isScrollEnabled = false
        webView.backgroundColor = UIColor.black
        webView.isOpaque = false
        webView.delegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(webView)
        
        //        let heightConstraint = NSLayoutConstraint(item: webView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: self.view.frame.height)
        var topPadding:CGFloat = 0
        var bottomPadding:CGFloat = 0
        if #available(iOS 11.0, *) {
            if UIDevice().userInterfaceIdiom == .phone {
                if UIScreen.main.nativeBounds.height == 2436{
                    let window = UIApplication.shared.keyWindow
                    topPadding = (window?.safeAreaInsets.top)!
                    bottomPadding = (window?.safeAreaInsets.bottom)!
                }else{
                    topPadding = 20
                }
            }
        }else{
            topPadding = 20
        }
        let topSpaceConstraint:NSLayoutConstraint = NSLayoutConstraint(item: webView, attribute: .top  , relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: -topPadding)
        let bottomSpaceConstraint:NSLayoutConstraint = NSLayoutConstraint(item: webView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom , multiplier: 1, constant: bottomPadding)
        let leadingSpaceConstraint:NSLayoutConstraint = NSLayoutConstraint(item: webView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 0)
        let trailingSpaceConstraint:NSLayoutConstraint = NSLayoutConstraint(item: webView, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing , multiplier: 1, constant: 0)
        self.view.addConstraints([trailingSpaceConstraint,topSpaceConstraint,bottomSpaceConstraint,leadingSpaceConstraint])
        
        
    }
    func getQueryStringParameter(url: String, param: String) -> String? {
        guard let url = URLComponents(string: url) else { return nil }
        return url.queryItems?.first(where: { $0.name == param })?.value
    }
    
    //    fileprivate func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
    //        if self.smAds != nil {
    //            if (getQueryStringParameter(url: self.smAds.link, param: "slider_list") != nil){
    //                let url:URL = URL.init(string: self.smAds.link)!
    //                if url.scheme == "itms"{
    //                    UIApplication.shared.openURL(url)
    //
    //                }
    //            }else{
    //                self.openAds(url: self.smAds.link)
    //                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "smads_click"), object: nil)
    //
    //            }
    //            return false
    //        }
    //        return true
    //    }
    private func openAds(url:String){
        network.openLink(url: url, success: { (json) in
            if let link = json["link"] as? String{
                let uri = URL.init(string: link)
                if  uri?.scheme == "itms"{
                    UIApplication.shared.openURL(uri!)
                    
                }
                self.dismiss(animated: true) {
                }
            }
        }) { (error) in
            self.dismiss(animated: true) {
            }
        }
    }
    
    private func initViewClick(){
        let viewClick = UIView(frame: self.view.frame)
        let tap:UIGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(clickAds))
        viewClick.isUserInteractionEnabled = true
        viewClick.addGestureRecognizer(tap)
        viewClick.backgroundColor = UIColor.clear
        viewClick.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(viewClick)
        let heightConstraint = NSLayoutConstraint(item: viewClick, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: self.view.frame.height)
        let topSpaceConstraint:NSLayoutConstraint = NSLayoutConstraint(item: viewClick, attribute: .top  , relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 0)
        let bottomSpaceConstraint:NSLayoutConstraint = NSLayoutConstraint(item: viewClick, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom , multiplier: 1, constant: 0)
        let leadingSpaceConstraint:NSLayoutConstraint = NSLayoutConstraint(item: viewClick, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 0)
        let trailingSpaceConstraint:NSLayoutConstraint = NSLayoutConstraint(item: viewClick, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing , multiplier: 1, constant: 0)
        self.view.addConstraints([trailingSpaceConstraint,topSpaceConstraint,bottomSpaceConstraint,heightConstraint,leadingSpaceConstraint])
    }
    
    
    
    
    @objc private func clickAds(sender:UITapGestureRecognizer){
        
        if self.smAds != nil {
            self.openAds(url: self.smAds.link)
            
        }
    }
    
    
    
    
    private func initCloseButton(){
        let btClose = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        btClose.backgroundColor = UIColor.colorWithHexString(baseHexString: "FFFFFF", alpha: 1.0)
        btClose.layer.cornerRadius = 15.0
        btClose.translatesAutoresizingMaskIntoConstraints = false
        btClose.addTarget(self, action: #selector(actionCloseAds), for: .touchUpInside)
        btClose.setImage(UIImage(named:"smads_close.png"), for: .normal)
        btClose.layer.shadowColor = UIColor.black.cgColor
        btClose.layer.shadowOpacity = 0.3
        btClose.layer.shadowOffset = CGSize.zero
        btClose.layer.shadowRadius = 15
        btClose.layer.shadowPath = UIBezierPath(rect: btClose.bounds).cgPath
        btClose.layer.shouldRasterize = true
        self.view.addSubview(btClose)
        var topPadding:CGFloat = 0
        //        var bottomPadding:CGFloat = 0
        if #available(iOS 11.0, *) {
            if UIScreen.main.nativeBounds.height == 2436{
                let window = UIApplication.shared.keyWindow
                topPadding = (window?.safeAreaInsets.top)!
            }else{
                topPadding = 20
            }
        }else{
            topPadding = 20
        }
        let btbottomSpaceConstraint:NSLayoutConstraint = NSLayoutConstraint(item: btClose, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top , multiplier: 1, constant: topPadding)
        
        let btleadingSpaceConstraint:NSLayoutConstraint = NSLayoutConstraint(item: btClose, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: -16.0)
        
        let heightConstraint = NSLayoutConstraint(item: btClose, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 30)
        
        let widthtConstraint = NSLayoutConstraint(item: btClose, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 30)
        self.view.addConstraints([btleadingSpaceConstraint,btbottomSpaceConstraint,heightConstraint,widthtConstraint])
    }
    
    @objc private func actionCloseAds(sender:UIButton){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "smads_close"), object: nil)
        
        self.dismiss(animated: true) {
        }
    }
    
    @objc private func openNetworkAds(sender:UIButton){
        
        let svc = SFSafariViewController(url: NSURL(string: "http://smartmove.vn/")! as URL)
        self.present(svc, animated: true, completion: nil)
        
    }
    
}
