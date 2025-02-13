//
//  Created by Jake Lin on 11/18/15.
//  Copyright © 2015 IBAnimatable. All rights reserved.
//

import UIKit

@IBDesignable
open class AnimatableView: UIView, CornerDesignable, FillDesignable, BorderDesignable,
                                   RotationDesignable, ShadowDesignable, BlurDesignable,
                                   TintDesignable, GradientDesignable, MaskDesignable,
                                   Animatable {

  // MARK: - CornerDesignable
  @IBInspectable open var cornerRadius: CGFloat = CGFloat.nan {
    didSet {
      configureCornerRadius()
    }
  }

  ///要切的边
  open var cornerSides: CornerSides  = .allSides {
    didSet {
      configureCornerRadius()
    }
  }

  ///使用字符串设置边
  @IBInspectable var _cornerSides: String? {
    didSet {
      cornerSides = CornerSides(rawValue: _cornerSides)
    }
  }

  // MARK: - FillDesignable
  ///背景色
  @IBInspectable open var fillColor: UIColor? {
    didSet {
      configureFillColor()
    }
  }

  ///背景色
  open var predefinedColor: ColorType? {
    didSet {
      configureFillColor()
    }
  }
  
  ///字符串设置背景色
  @IBInspectable var _predefinedColor: String? {
    didSet {
      predefinedColor = ColorType(string: _predefinedColor)
    }
  }

  ///设置透明度
  @IBInspectable open var opacity: CGFloat = CGFloat.nan {
    didSet {
      configureOpacity()
    }
  }

  // MARK: - BorderDesignable
  ///边框类型
  open var borderType: BorderType  = .solid {
    didSet {
      configureBorder()
    }
  }

  @IBInspectable var _borderType: String? {
    didSet {
      borderType = BorderType(string: _borderType)
    }
  }

  @IBInspectable open var borderColor: UIColor? {
    didSet {
      configureBorder()
    }
  }

  @IBInspectable open var borderWidth: CGFloat = CGFloat.nan {
    didSet {
      configureBorder()
    }
  }

  ///要设置的边框
  open var borderSides: BorderSides  = .AllSides {
    didSet {
      configureBorder()
    }
  }

  @IBInspectable var _borderSides: String? {
    didSet {
      borderSides = BorderSides(rawValue: _borderSides)
    }
  }
  // MARK: - RotationDesignable
  ///旋转
  @IBInspectable open var rotate: CGFloat = CGFloat.nan {
    didSet {
      configureRotate()
    }
  }

  // MARK: - ShadowDesignable
  @IBInspectable open var shadowColor: UIColor? {
    didSet {
      configureShadowColor()
    }
  }

  @IBInspectable open var shadowRadius: CGFloat = CGFloat.nan {
    didSet {
      configureShadowRadius()
    }
  }

  @IBInspectable open var shadowOpacity: CGFloat = CGFloat.nan {
    didSet {
      configureShadowOpacity()
    }
  }

  @IBInspectable open var shadowOffset: CGPoint = CGPoint(x: CGFloat.nan, y: CGFloat.nan) {
    didSet {
      configureShadowOffset()
    }
  }

  // MARK: - BlurDesignable
  open var blurEffectStyle: UIBlurEffect.Style? {
    didSet {
      configureBlurEffectStyle()
    }
  }
  @IBInspectable var _blurEffectStyle: String? {
    didSet {
      blurEffectStyle = UIBlurEffect.Style(string: _blurEffectStyle)
    }
  }

  open var vibrancyEffectStyle: UIBlurEffect.Style? {
    didSet {
      configureBlurEffectStyle()
    }
  }
  @IBInspectable var _vibrancyEffectStyle: String? {
    didSet {
      vibrancyEffectStyle = UIBlurEffect.Style(string: _vibrancyEffectStyle)
    }
  }

  @IBInspectable open var blurOpacity: CGFloat = CGFloat.nan {
    didSet {
      configureBlurEffectStyle()
    }
  }

  // MARK: - TintDesignable
  @IBInspectable open var tintOpacity: CGFloat = CGFloat.nan
  @IBInspectable open var shadeOpacity: CGFloat = CGFloat.nan
  @IBInspectable open var toneColor: UIColor?
  @IBInspectable open var toneOpacity: CGFloat = CGFloat.nan

  // MARK: - GradientDesignable
  open var gradientMode: GradientMode = .linear
  @IBInspectable var _gradientMode: String? {
    didSet {
      gradientMode = GradientMode(string: _gradientMode) ?? .linear
    }
  }
  @IBInspectable open var startColor: UIColor?
  @IBInspectable open var endColor: UIColor?
  open var predefinedGradient: GradientType?
  @IBInspectable var _predefinedGradient: String? {
    didSet {
      predefinedGradient = GradientType(string: _predefinedGradient)
    }
  }
  open var startPoint: GradientStartPoint = .top
  @IBInspectable var _startPoint: String? {
    didSet {
      startPoint = GradientStartPoint(string: _startPoint, default: .top)
    }
  }

  // MARK: - MaskDesignable
  open var maskType: MaskType = .none {
    didSet {
      configureMask(previousMaskType: oldValue)
      configureBorder()
      configureMaskShadow()
    }
  }

  /// The mask type used in Interface Builder. **Should not** use this property in code.
  @IBInspectable var _maskType: String? {
    didSet {
      maskType = MaskType(string: _maskType)
    }
  }

  // MARK: - Animatable
  open var animationType: AnimationType = .none
  @IBInspectable  var _animationType: String? {
    didSet {
      animationType = AnimationType(string: _animationType)
    }
  }
  @IBInspectable open var autoRun: Bool = true
  @IBInspectable open var duration: Double = Double.nan
  @IBInspectable open var delay: Double = Double.nan
  @IBInspectable open var damping: CGFloat = CGFloat.nan
  @IBInspectable open var velocity: CGFloat = CGFloat.nan
  @IBInspectable open var force: CGFloat = CGFloat.nan
  @IBInspectable var _timingFunction: String = "" {
    didSet {
      timingFunction = TimingFunctionType(string: _timingFunction)
    }
  }
  open var timingFunction: TimingFunctionType = .none

  // MARK: - Lifecycle
  open override func prepareForInterfaceBuilder() {
    super.prepareForInterfaceBuilder()
    configureInspectableProperties()
  }

  open override func awakeFromNib() {
    super.awakeFromNib()
    configureInspectableProperties()
  }

  open override func layoutSubviews() {
    super.layoutSubviews()
    configureAfterLayoutSubviews()
    autoRunAnimation()
  }

  // MARK: - Private
  fileprivate func configureInspectableProperties() {
    configureAnimatableProperties()
    configureTintedColor()
  }

  fileprivate func configureAfterLayoutSubviews() {
    configureMask(previousMaskType: maskType)
    configureCornerRadius()
    configureBorder()
    configureMaskShadow()
    configureGradient()
  }
}
