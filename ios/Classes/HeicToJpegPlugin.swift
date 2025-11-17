import Flutter
import UIKit


public class HeicToJpegPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "heic_to_jpeg", binaryMessenger: registrar.messenger())
        let instance = HeicToJpegPlugin()
            registrar.addMethodCallDelegate(instance, channel: channel)
        }


        public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
            switch call.method {
                case "convert":
                    guard let bytes = call.arguments as? FlutterStandardTypedData else {
                        result(FlutterError(code: "bad_args", message: "Expected bytes", details: nil))
                        return
                    }

                    guard let uiImage = UIImage(data: bytes.data) else {
                        result(FlutterError(code: "decode_error", message: "Cannot decode HEIC", details: nil))
                        return
                    }

                    guard let jpegData = uiImage.jpegData(compressionQuality: 0.9) else {
                        result(FlutterError(code: "encode_error", message: "Cannot encode JPEG", details: nil))
                        return
                    }

                    result(FlutterStandardTypedData(bytes: jpegData))


                default:
                    result(FlutterMethodNotImplemented)
        }
    }
}