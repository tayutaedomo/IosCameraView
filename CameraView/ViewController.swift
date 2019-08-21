//
//  ViewController.swift
//  CameraView
//
//  Created by tayutaedomo on 2019/08/21.
//  Copyright © 2019 tayutaedomo.net. All rights reserved.
//

import UIKit
import AVFoundation

//
// Refer: https://qiita.com/ukandori/items/5f6bfa8c13684b0f920f
//
class ViewController: UIViewController {

    // MARK: Properties
    var capture_session: AVCaptureSession!
    var still_image_output: AVCapturePhotoOutput?
    var preview_layer: AVCaptureVideoPreviewLayer?


    // MARK: - IBOutlets
    @IBOutlet weak var camera_view: UIView!


    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        capture_session = AVCaptureSession()
        still_image_output = AVCapturePhotoOutput()

        //captureSesssion.sessionPreset = AVCaptureSessionPreset1920x1080 // 解像度の設定
        capture_session.sessionPreset = AVCaptureSession.Preset.medium

        //let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else {
            print("Failed to get capture device")
            return
        }

        do {
            let input = try AVCaptureDeviceInput(device: device)

            if capture_session.canAddInput(input) {
                capture_session.addInput(input)

                if capture_session.canAddOutput(still_image_output!) {
                    capture_session.addOutput(still_image_output!)

                    capture_session.startRunning()

                    preview_layer = AVCaptureVideoPreviewLayer(session: capture_session)

                    //previewLayer?.videoGravity = AVLayerVideoGravityResizeAspect // アスペクトフィット
                    preview_layer?.videoGravity = AVLayerVideoGravity.resizeAspectFill

                    preview_layer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait

                    camera_view.layer.addSublayer(preview_layer!)

                    preview_layer?.position = CGPoint(x: camera_view.frame.width/2, y: camera_view.frame.height/2)
                    preview_layer?.bounds = camera_view.bounds
                }
            }
        }
        catch {
            print(error)
        }
    }
}
