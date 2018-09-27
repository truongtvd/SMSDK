
import UIKit
import SafariServices

@objc public protocol SMBannerViewDelegate {
    @objc optional func bannerViewLoaded(bannerView:SMBannerView)
    @objc optional func bannerViewError()
    @objc optional func bannerViewDidClick()
}

public class SMBannerView: UIView {
    
    fileprivate var webView:UIWebView!
    var rootViewController:UIViewController!
    var delegate:SMBannerViewDelegate!
    var timeReload = 60
    
    
    let  network:SMNetworkOpertator = SMNetworkOpertator()
    
    
    
//    fileprivate var btWatermark:UIButton!
    fileprivate var smAds:SMAds!
    
    
    public init(frame: CGRect,adUnitID:String) {
        super.init(frame: frame)
        self.initView()
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initView()
        
    }
    
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.initView()
    }
    
    private func initView(){
       
        self.initWebview()
        self.initViewClick()
//        self.initButtonWatermark()
//        btWatermark.isHidden = true
    }
    @objc func load(){
        if rootViewController != nil{
            
            Timer.scheduledTimer(timeInterval: TimeInterval(timeReload), target: self, selector: #selector(load), userInfo: nil, repeats: false)
            //load ads
            network.getBanner(success: { (json) in
//                print(json)
                self.smAds = SMAds(json)
//                self.btWatermark.isHidden = false
                if self.smAds.html != ""{
                    self.webView.loadHTMLString(self.smAds.html, baseURL: nil)
//                     self.webView.loadRequest(URLRequest(url: URL(string: kUrl+"?package_name=gofive.hoingu&ad_format=banner&test=1")!))
                    if self.delegate != nil{
                        self.delegate.bannerViewLoaded?(bannerView: self)
                    }
                }else{
                    if self.delegate != nil{
                        self.delegate.bannerViewError?()
                    }
                }
                
            }, failure: { (error) in
                print(error)
                if self.delegate != nil{
                    self.delegate.bannerViewError?()
                }
                
            })
        }else{
            print("rootViewController is nil. Set rootViewController to start load ads")
        }
    }
    
    
    
    
    private func initWebview(){
        webView = UIWebView(frame: self.frame)
        webView.scrollView.bounces = false
//        webView.delegate = self
        webView.scrollView.isScrollEnabled = false
        webView.backgroundColor = UIColor.clear
        webView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(webView)
        
        
        
        let heightConstraint = NSLayoutConstraint(item: webView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: self.frame.height)
        let topSpaceConstraint:NSLayoutConstraint = NSLayoutConstraint(item: webView, attribute: .top  , relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        let bottomSpaceConstraint:NSLayoutConstraint = NSLayoutConstraint(item: webView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom , multiplier: 1, constant: 0)
        let leadingSpaceConstraint:NSLayoutConstraint = NSLayoutConstraint(item: webView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
        let trailingSpaceConstraint:NSLayoutConstraint = NSLayoutConstraint(item: webView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing , multiplier: 1, constant: 0)
        self.addConstraints([trailingSpaceConstraint,topSpaceConstraint,bottomSpaceConstraint,heightConstraint,leadingSpaceConstraint])
      
    }
    
    private func initViewClick(){
        let viewClick = UIView(frame: self.frame)
        let tap:UIGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(clickAds))
        viewClick.isUserInteractionEnabled = true
        viewClick.addGestureRecognizer(tap)
        viewClick.backgroundColor = UIColor.clear
        viewClick.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(viewClick)
        
        
        
        let heightConstraint = NSLayoutConstraint(item: viewClick, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: self.frame.height)
        let topSpaceConstraint:NSLayoutConstraint = NSLayoutConstraint(item: viewClick, attribute: .top  , relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        let bottomSpaceConstraint:NSLayoutConstraint = NSLayoutConstraint(item: viewClick, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom , multiplier: 1, constant: 0)
        let leadingSpaceConstraint:NSLayoutConstraint = NSLayoutConstraint(item: viewClick, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
        let trailingSpaceConstraint:NSLayoutConstraint = NSLayoutConstraint(item: viewClick, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing , multiplier: 1, constant: 0)
        self.addConstraints([trailingSpaceConstraint,topSpaceConstraint,bottomSpaceConstraint,heightConstraint,leadingSpaceConstraint])
    }
    @objc private func clickAds(sender:UITapGestureRecognizer){
        if delegate != nil{
            delegate.bannerViewDidClick?()
        }
        
        if self.smAds != nil && self.rootViewController != nil{
            //let svc = SFSafariViewController(url: NSURL(string: self.smAds.link)! as URL)
            //rootViewController.present(svc, animated: true, completion: nil)
//            UIApplication.shared.openURL(URL(string: self.smAds.link)!)
            self.openAds(url: self.smAds.link)
        }
    }
    

    private func openAds(url:String){
        network.openLink(url: url, success: { (json) in
            if let link = json["link"] as? String{
                let uri = URL.init(string: link)
                if self.rootViewController != nil && uri?.scheme == "itms"{
                    UIApplication.shared.openURL(uri!)
                }
            }
        }) { (error) in
            
        }
    }
    
    
    
//    private func initButtonWatermark(){
//        btWatermark = UIButton(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
//        btWatermark.backgroundColor = UIColor.colorWithHexString(baseHexString: "CCCCCC", alpha: 0.7)
//        btWatermark.translatesAutoresizingMaskIntoConstraints = false
//        btWatermark.addTarget(self, action: #selector(openNetworkAds), for: .touchUpInside)
//        btWatermark.setImage(UIImage(named:"ads_logo.png"), for: .normal)
//        self.addSubview(btWatermark)
//        
//        let btbottomSpaceConstraint:NSLayoutConstraint = NSLayoutConstraint(item: btWatermark, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom , multiplier: 1, constant: 0)
//        
//        let btleadingSpaceConstraint:NSLayoutConstraint = NSLayoutConstraint(item: btWatermark, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
//        
//        let heightConstraint = NSLayoutConstraint(item: btWatermark, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 15)
//        
//        let widthtConstraint = NSLayoutConstraint(item: btWatermark, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 15)
//        self.addConstraints([btleadingSpaceConstraint,btbottomSpaceConstraint,heightConstraint,widthtConstraint])
//       
//       
//    }
    
    @objc private func openNetworkAds(sender:UIButton){
        if rootViewController != nil{
            
            let svc = SFSafariViewController(url: NSURL(string: "http://smartmove.vn/")! as URL)
            rootViewController.present(svc, animated: true, completion: nil)
        }
    }
    
}
//extension SMBannerView: UIWebViewDelegate{
//    fileprivate func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
//        if (request.url?.absoluteString.contains("itunes.apple.com"))!{
//            
//            if self.smAds != nil {
//                UIApplication.shared.openURL(URL(string: self.smAds.link)!)
//                
//                self.dismiss(animated: true) {
//                }
//            }
//            
//            return false
//        }
//        return true
//    }
//}
