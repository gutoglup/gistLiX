//
//  QRCodeViewController.swift
//  GistLiX
//
//  Created by Augusto Reis on 23/12/2017.
//  Copyright © 2017 Augusto Reis. All rights reserved.
//

import UIKit
import QRCodeReader

class QRCodeViewController: UIViewController {
    
    @IBOutlet weak var qrcodeView: QRCodeReaderView! {
        didSet {
            qrcodeView.setupComponents(showCancelButton: false, showSwitchCameraButton: false, showTorchButton: false, showOverlayView: false, reader: reader)
        }
    }
    
    lazy var reader: QRCodeReader = QRCodeReader()
    
    lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader          = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
            $0.showTorchButton = true
            
            $0.reader.stopScanningWhenCodeIsFound = false
        }
        
        return QRCodeReaderViewController(builder: builder)
    }()
    
    let viewModel = QRCodeViewModel()
    
    var resultQrcode: String = String()

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupQrcodeView()
        reader.startScanning()
    }


    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Setup View -
    
    func setupQrcodeView() {
        qrcodeView.clipsToBounds = true
        qrcodeView.layer.cornerRadius = 10
        
        reader.didFindCode = { (result) in
            self.viewModel.resultQrcode = result.value
            self.performSegue(withIdentifier: GistViewController.segueIdentifier, sender: self)
        }
    }
    
    func addActions() {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? GistViewController {
            destinationViewController.viewModel.resultQrcode = viewModel.resultQrcode
        }
    }

}

extension QRCodeViewController: QRCodeDelegate {
    
}
