//
//  StoreScan.swift
//  OstomyScan
//
//  Created by Lucas Cauthen on 2/11/17.
//  Copyright © 2017 OstomyTech. All rights reserved.
//

import Foundation
import ImageIO


class StoreScanImage {
    
    static let FILENAME = "LatestScreenshot.jpg"
    var width: Int32 = 640
    var height: Int32 = 320
    
    func storeScreenshot(renderer: MeshRenderer?, mesh: STMesh?, projectionMatrix: inout GLKMatrix4?, modelViewMatrix: inout GLKMatrix4?, viewport: [GLfloat], frameBufferSize: CGSize) {
        
        
        let screenshotPath = FileMgr.sharedInstance.full(type(of: self).FILENAME)
        var currentFrameBuffer: GLint = 0
        
        FileMgr.sharedInstance.del(screenshotPath) //Delete any previous file stroed here
        
        glGetIntegerv( GLenum(GL_FRAMEBUFFER_BINDING), &currentFrameBuffer)
        
        // Create temp texture, framebuffer, renderbuffer
        glViewport(0, 0, width, height)
        
        var outputTexture: GLuint = 0
        glActiveTexture( GLenum(GL_TEXTURE0))
        glGenTextures(1, &outputTexture)
        glBindTexture( GLenum(GL_TEXTURE_2D), outputTexture)
        glTexParameteri( GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MIN_FILTER), GL_NEAREST)
        glTexParameteri( GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MAG_FILTER), GL_NEAREST)
        glTexParameteri( GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_WRAP_S), GL_CLAMP_TO_EDGE)
        glTexParameteri( GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_WRAP_T), GL_CLAMP_TO_EDGE)
        glTexImage2D( GLenum(GL_TEXTURE_2D), 0, GL_RGBA, width, height, 0, GLenum(GL_RGBA), GLenum(GL_UNSIGNED_BYTE), nil)
        
        var colorFrameBuffer: GLuint = 0
        var depthRenderBuffer: GLuint = 0
        
        glGenFramebuffers(1, &colorFrameBuffer)
        glBindFramebuffer( GLenum(GL_FRAMEBUFFER), colorFrameBuffer)
        glGenRenderbuffers(1, &depthRenderBuffer)
        glBindRenderbuffer( GLenum(GL_RENDERBUFFER), depthRenderBuffer)
        
        glRenderbufferStorage( GLenum(GL_RENDERBUFFER), GLenum(GL_DEPTH_COMPONENT16), width, height)
        glFramebufferRenderbuffer( GLenum(GL_FRAMEBUFFER), GLenum(GL_DEPTH_ATTACHMENT), GLenum(GL_RENDERBUFFER), depthRenderBuffer)
        glFramebufferTexture2D( GLenum(GL_FRAMEBUFFER), GLenum(GL_COLOR_ATTACHMENT0), GLenum(GL_TEXTURE_2D), outputTexture, 0)
        
        // Keep the current render mode
        let previousRenderingMode: MeshRenderer.RenderingMode = renderer!.getRenderingMode()
        
        let meshToRender: STMesh = mesh!
        
        // Screenshot rendering mode, always use colors if possible.
        if meshToRender.hasPerVertexUVTextureCoords() && meshToRender.meshYCbCrTexture() != nil {
            
            renderer!.setRenderingMode(.textured)
            
        } else if meshToRender.hasPerVertexColors() {
            
            renderer!.setRenderingMode(.perVertexColor)
            
        } else {
            // meshToRender can be nil if there is no available color mesh.
            renderer!.setRenderingMode(.lightedGray)
        }
        
        // Render from the initial viewpoint for the screenshot.
        renderer!.clear()
        
        withUnsafePointer(to: &projectionMatrix) { (one) -> () in
            withUnsafePointer(to: &modelViewMatrix, { (two) -> () in
                
                one.withMemoryRebound(to: GLfloat.self, capacity: 16, { (onePtr) -> () in
                    two.withMemoryRebound(to: GLfloat.self, capacity: 16, { (twoPtr) -> () in
                        
                        renderer!.render(onePtr,modelViewMatrix: twoPtr)
                    })
                })
            })
        }
        
        // Back to current render mode
        renderer!.setRenderingMode(previousRenderingMode)
        
        var screenShotRgbaBuffer = [UInt32](repeating: 0, count: Int(width*height))
        
        var screenTopRowBuffer = [UInt32](repeating: 0, count: Int(width))
        
        var screenBottomRowBuffer = [UInt32](repeating: 0, count: Int(width))
        
        glReadPixels(0, 0, width, height, GLenum(GL_RGBA), GLenum(GL_UNSIGNED_BYTE), &screenShotRgbaBuffer)
        
        // flip the buffer
        for h in 0..<height/2 {
            
            glReadPixels(0, h, width, 1, UInt32(GL_RGBA), UInt32(GL_UNSIGNED_BYTE), &screenTopRowBuffer)
            
            glReadPixels(0, (height - h - 1), width, 1, UInt32(GL_RGBA), UInt32(GL_UNSIGNED_BYTE), &screenBottomRowBuffer)
            
            let topIdx = Int(width * h)
            let bottomIdx = Int(width * (height - h - 1))
            
            withUnsafeMutablePointer(to: &screenShotRgbaBuffer[topIdx]) { (one) -> () in
                withUnsafePointer(to: &screenBottomRowBuffer[0], { (two) -> () in
                    
                    one.withMemoryRebound(to: UInt32.self, capacity: Int(width), { (onePtr) -> () in
                        two.withMemoryRebound(to: UInt32.self, capacity: Int(width), { (twoPtr) -> () in
                            
                            memcpy(onePtr, twoPtr, Int(width) * Int(MemoryLayout<UInt32>.size))
                        })
                    })
                })
            }
            
            withUnsafeMutablePointer(to: &screenShotRgbaBuffer[bottomIdx]) { (one) -> () in
                withUnsafePointer(to: &screenTopRowBuffer[0], { (two) -> () in
                    
                    one.withMemoryRebound(to: UInt32.self, capacity: Int(width), { (onePtr) -> () in
                        two.withMemoryRebound(to: UInt32.self, capacity: Int(width), { (twoPtr) -> () in
                            
                            memcpy(onePtr, twoPtr, Int(width) * Int(MemoryLayout<UInt32>.size))
                        })
                    })
                })
            }
        }
        
        saveJpegFromRGBABuffer(screenshotPath, src_buffer: &screenShotRgbaBuffer, width: Int(width), height: Int(height))
        
        // Back to the original frame buffer
        glBindFramebuffer( GLenum(GL_FRAMEBUFFER), GLenum(currentFrameBuffer))
        glViewport( GLint(viewport[0]), GLint(viewport[1]), GLint(viewport[2]), GLint(viewport[3]))
        
        // Free the data
        glDeleteTextures(1, &outputTexture)
        glDeleteFramebuffers(1, &colorFrameBuffer)
        glDeleteRenderbuffers(1, &depthRenderBuffer)
    }
    
    // create preview image from current viewpoint
    
    func prepareScreenShotCurrentViewpoint (screenshotPath: String, framebufferSize: CGSize) {
        
        let width: Int32 = Int32.init(framebufferSize.width)
        let height: Int32 = Int32.init(framebufferSize.height)
        
        var screenShotRgbaBuffer = [UInt32](repeating: 0, count: Int(width*height))
        
        var screenTopRowBuffer = [UInt32](repeating: 0, count: Int(width))
        
        var screenBottomRowBuffer = [UInt32](repeating: 0, count: Int(width))
        
        // tell glReadPixels to read from front buffer
        glReadBuffer(GLuint(GL_FRONT))
        glReadPixels(0, 0, width, height, GLenum(GL_RGBA), GLenum(GL_UNSIGNED_BYTE), &screenShotRgbaBuffer)
        
        // flip the buffer
        for h in 0..<height/2 {
            
            glReadPixels(0, h, width, 1, UInt32(GL_RGBA), UInt32(GL_UNSIGNED_BYTE), &screenTopRowBuffer)
            
            glReadPixels(0, (height - h - 1), width, 1, UInt32(GL_RGBA), UInt32(GL_UNSIGNED_BYTE), &screenBottomRowBuffer)
            
            let topIdx = Int(width * h)
            let bottomIdx = Int(width * (height - h - 1))
            
            withUnsafeMutablePointer(to: &screenShotRgbaBuffer[topIdx]) { (one) -> () in
                withUnsafePointer(to: &screenBottomRowBuffer[0], { (two) -> () in
                    
                    one.withMemoryRebound(to: UInt32.self, capacity: Int(width), { (onePtr) -> () in
                        two.withMemoryRebound(to: UInt32.self, capacity: Int(width), { (twoPtr) -> () in
                            
                            memcpy(onePtr, twoPtr, Int(width) * Int(MemoryLayout<UInt32>.size))
                        })
                    })
                })
            }
            
            withUnsafeMutablePointer(to: &screenShotRgbaBuffer[bottomIdx]) { (one) -> () in
                withUnsafePointer(to: &screenTopRowBuffer[0], { (two) -> () in
                    
                    one.withMemoryRebound(to: UInt32.self, capacity: Int(width), { (onePtr) -> () in
                        two.withMemoryRebound(to: UInt32.self, capacity: Int(width), { (twoPtr) -> () in
                            
                            memcpy(onePtr, twoPtr, Int(width) * Int(MemoryLayout<UInt32>.size))
                        })
                    })
                })
            }
        }
        
        
        saveJpegFromRGBABuffer(screenshotPath, src_buffer: &screenShotRgbaBuffer, width: Int(width), height: Int(height))
        

    }
    
    func saveJpegFromRGBABuffer( _ filename: String, src_buffer: UnsafeMutableRawPointer, width: Int, height: Int)
    {
        var colorSpace: CGColorSpace?
        var alphaInfo: CGImageAlphaInfo!
        var bmcontext: CGContext?
        colorSpace = CGColorSpaceCreateDeviceRGB()
        alphaInfo = .noneSkipLast
        
        bmcontext = CGContext(data: src_buffer, width: width, height: height, bitsPerComponent: 8, bytesPerRow: width * 4, space: colorSpace!, bitmapInfo: alphaInfo.rawValue)!
        let rgbImage: CGImage? = bmcontext!.makeImage()
        let uiImage = UIImage(cgImage: rgbImage!)
        if let data = UIImageJPEGRepresentation(uiImage, 1.0) {
            UserDefaults.standard.setValue(data, forKey: "LatestScreenshot")
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
}

protocol StoreScanImageCallback {
    func onSuccess()
    func onFailure(error: String)
}
