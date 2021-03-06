# iOS Programming with Swift : CS193P Notes

[TOC]

## iOS

### Layer

- Core OS
- Core Services
- Media
- Cocoa Touch

###  Platform Components

- Tools
- Language
- Frameworks: foundation, UIKit, 
- Design Strategy: MVC

## MVC

- model : What your application is (but not how it is displayed) UI independent  **What**
- view: Your Controller’s minions
- controller: How your Model is presented to the user (UI logic) **How**

It’s all about managing communication between them

- Controllers can always talk directly to their Model.
- Controllers can also talk directly to their View.
- The Model and View should never speak to each other.
- The Controller can drop a target on itself.
  - Then hand out an action to the View.
- The View sends the action when things happen in the UI.
- Sometimes the View needs to synchronize with the Controller.
  - The Controller sets itself as the View’s delegate.
  - The delegate is set via a protocol (i.e. it’s “blind” to class).
- Views do not own the data they display.
  - So, if needed, they have a protocol to acquire it.
  - Controllers are almost always that data source (not Model!)
- Controllers interpret/format Model information for the View.
- Can the Model talk directly to the Controller?
  - No. The Model is (should be) UI independent.
- So what if the Model has information to update or something?
  - It uses a “radio station”-like broadcast mechanism.
  - Controllers (or other Model) “tune in” to interesting stuff.

![image-20190705155722954](assets/image-20190705155722954.png)



![image-20190705155757200](assets/image-20190705155757200.png)



## Xcode Usage

### Shortcuts

- ⌘+0
- ⌘+⌥+0
- ⌘+1, 2, 3, 4, 5
- ⌘+⌥+1, 2, 3, 4, 5
- ⌘+ enter / ⌘+⌥+enter
- ⌃+ I

## Swift

### Range

- `1..<5`
- `stride(from:,through:,by:)`

### tuple 



### Access Control

- internal 
- private
- private(set)
- fileprivate

### Extensions

### mutating

### Protocol

- protocols are a way to express an API more concisely

####  Delegation

#### Other Protocols

- CountableRange
- Sequence
- Collection

#### Using extension to provide protocol implementation



### String



#### NSAttributedString 



### Other Classes

#### NSObject

#### NSNumber

#### Date

#### Data



## Views

A view (i.e. UIView subclass) represents a rectangular area

- Deﬁnes a coordinate space 
- For drawing 
- And for handling touch events

Hierarchical

- A view has only one superview … var superview: UIView?
- But it can have many (or zero) subviews … var subviews: [UIView]
- The order in the subviews array matters: those later in the array are on top of those earlier 
- A view can clip its subviews to its own bounds or not (the default is not to)

UIWindow

- The UIView at the very, very top of the view hierarchy (even includes status bar)
-  Usually only one UIWindow in an entire iOS application … it’s all about views, not windows

**The hierarchy is most often constructed in Xcode graphically**

But it can be done in code as well

```swift
func addSubview(_ view: UIView)// sent to view’s (soon to be) superview 
func removeFromSuperview() // sent to the view you want to remove (not its superview)
```

**Where does the view hierarchy start?**

The top of the (useable) view hierarchy is the Controller’s var view: UIView.

### Initializing a view

- As always, try to avoid an initializer if possible

- **A UIView’s initializer is different if it comes out of a storyboard**

```swift
init(frame: CGRect) // initializer if the UIView is created in code 
init(coder: NSCoder) // initializer if the UIView comes out of a storyboard
```

- **If you need an initializer, implement them both …**

```swift
func setup() { … }

override init(frame: CGRect) {
super.init(frame: frame) setup() 
} 
// a designated initializer
// might have to be before super.init 

required init?(coder aDecoder: NSCoder) {
// a required, failable initializer
super.init(coder: aDecoder)
setup() }
```

- Another alternative to initializers in UIView

```swift
awakeFromNib()
```



### Coordinate System Data Structures

#### CGFloat

- Always use this instead of Double or Float for anything to do with a UIView’s coordinate system 
- You can convert to/from a Double or Float using initializers, e.g., `let cgf = CGFloat(aDouble)`

#### CGPoint

Simply a struct with two CGFloats in it: x and y.

```swift
var point = CGPoint(x: 37.0, y: 55.2) 
point.y -= 30 
point.x += 20.0
```



#### CGSize

Also a struct with two CGFloats in it: width and height.

```swift
var size = CGSize(width: 100.0, height: 50.0) 
size.width += 42.5 
size.height += 75
```



#### CGRect

**A struct with a CGPoint and a CGSize in it …**

```swift
struct CGRect { 

var origin: CGPoint 

var size: CGSize 

} 

let rect = CGRect(origin: aCGPoint, size: aCGSize)// there are other inits as well
```

Lots of convenient properties and functions on CGRect like …

```swift
var minX: CGFloat // left edge 
var midY: CGFloat // midpoint vertically 
intersects(CGRect) -> Bool // does this CGRect intersect this other one?
intersect(CGRect) // clip the CGRect to the intersection with the other one
contains(CGPoint) -> Bool  // does the CGRect contain the given CGPoint?
```



### View Coordinate System

- Origin is upper left
- Units are points, not pixels
  - Pixels are the minimum-sized unit of drawing your device is capable of 
  - Points are the units in the coordinate system 
  - Most of the time there are 2 pixels per point, but it could be only 1 or even 3 
  - How many pixels per point are there? UIView’s `var contentScaleFactor: CGFloat`

- The boundaries of where drawing happens

  - `var bounds: CGRect` // a view’s internal drawing space’s origin and size This is the rectangle containing the drawing space in its own coordinate system It is up to your view’s implementation to interpret what bounds.origin means (often nothing)

- Where is the UIView?

  ```swift
  var center: CGPoint // the center of a UIView in its superview’s coordinate system 
  var frame: CGRect // the rect containing a UIView in its superview’s coordinate system
  ```

  

#### Bounds vs Frame 

- Views can be rotated (and scaled and translated)
- Use frame and/or center to position a UIView



### Creating views

- Most often your views are created via your storyboard
- On rare occasion, you will create a UIView via code
- Example

```swift
let labelRect = CGRect(x: 20, y: 20, width: 100, height: 50) 
let label = UILabel(frame: labelRect) // UILabel is a subclass of UIView 
label.text = “Hello”
```



### Custom Views

- To draw, just create a UIView subclass and override draw(CGRect)

  - `override func draw(_ rect: CGRect)`

- So how do I implement my draw(CGRect)?

  - You can either get a drawing context and tell it what to draw, or … 
  - You can create a path of drawing using UIBezierPath class

- Core Graphics Concepts

  1. You get a context to draw into (other contexts include printing, off-screen buffer, etc.) The function `UIGraphicsGetCurrentContext()` gives a context you can use in `draw(CGRect)`

  2. Create paths (out of lines, arcs, etc.)
  3. Set drawing attributes like colors, fonts, textures, linewidths, linecaps, etc.
  4. Stroke or ﬁll the above-created paths with the given attributes

- `UIBezierPath`

  - Same as above, but captures all the drawing with a `UIBezierPath` instance 
  - `UIBezierPath` automatically draws in the “current” context (preset up for you in `draw(CGRect))` 
  - `UIBezierPath` has methods to draw (lineto, arcs, etc.) and to set attributes (linewidth, etc.) 
  - Use `UIColor` to set stroke and ﬁll colors
  -  `UIBezierPath` has methods to stroke and/or fill

#### Defining a Path

- Create a `UIBezierPath` 

```swift
let path = UIBezierPath() 
```

- Move around, add lines or arcs to the path

```swift
path.move(to: CGPoint(80, 50))
path.addLine(to: CGPoint(140, 150)) 
path.addLine(to: CGPoint(10, 150))
```

- Close the path (if you want)

```swift
path.close()
```

- Now that you have a path, set attributes and stroke/ﬁll

```swift
UIColor.green.setFill() // note setFill is a method in UIColor, not UIBezierPath
UIColor.red.setStroke()  // note setStroke is a method in UIColor, not UIBezierPath
path.linewidth = 3.0 // linewidth is a property in UIBezierPath, not UIColor
path.fill() // fill is a method in UIBezierPath
path.stroke() // stroke method in UIBezierPath
```

- You can also draw common shapes with UIBezierPath

```swift
let roundedRect = UIBezierPath(roundedRect: CGRect, cornerRadius: CGFloat) 
let oval = UIBezierPath(ovalIn: CGRect)
```

- Clipping your drawing to a UIBezierPath’s path

```swift
addClip()
```

For example, you could clip to a rounded rect to enforce the edges of a playing card

- Hit detection

```swift
func contains(_ point: CGPoint) -> Bool // returns whether the point is inside the path. The path must be closed. The winding rule can be set with usesEvenOddFillRule property.
```



#### UI Color

- Colors are set using UIColor
  - There are type (aka static) vars for standard colors, e.g. `let green = UIColor.green` 
  - You can also create them from RGB, HSB or even a pattern (using UIImage)

- Background color of a UIView
- Colors can have alpha (transparency)

```swift
let semitransparentYellow = UIColor.yellow.withAlphaComponent(0.5)
//Alpha is between 0.0 (fully transparent) and 1.0 (fully opaque)
```

- If you want to draw in your view with transparency …

  - You must let the system know by setting the UIView `var opaque = false`

  - You can make your entire UIView transparent `var alpha: CGFloat`



#### Layers

- Underneath UIView is a drawing mechanism called `CALayer`

  - You usually do not care about this.

  - But there is some useful API there.

  - You access a UIView’s “layer” using this `var layer: CALayer`

  -  The CA in CALayer stands for “Core Animation”.

  - Mostly we can do animation in a UIView without accessing this layer directly. But it is where the actual animation functionality of UIView is coming from. 

  - But `CALayer` can do some cool non-animation oriented things as well, for example 

    ```swift
    var cornerRadius: CGFloat // make the background a rounded rect
    var borderWidth: CGFloat // draw a border around the view 
    var borderColor: CGColor? // the color of the border (if any)
    ```

  -  You can get a CGColor from a UIColor using UIColor’s cgColor var.



#### View Transparency

- What happens when views overlap and have transparency?
  - As mentioned before, subviews list order determines who is in front Lower ones (earlier in the array) can “show through” transparent views on top of them
  - Transparency is not cheap, by the way, so use it wisely

- Completely hiding a view without removing it from hierarchy
  - `var isHidden: Bool` 
  - An isHidden view will draw nothing on screen and get no events either
  -  Not as uncommon as you might think to temporarily hide a view



#### Drawing Text

- Usually we use a UILabel to put text on screen
  - But there are certainly occasions where we want to draw text in our draw(CGRect)
- To draw in `draw(CGRect`), use `NSAttributedString`

```swift
let text = NSAttributedString(string: “hello”) // probably would set some attributes too 
text.draw(at: aCGPoint) // or draw(in: CGRect) 
let textSize: CGSize = text.size // how much space the string will take up
```

- Accessing a range of characters in an NSAttributedString

  ```swift
  //NSRange has an init which can handle the String vs. NSString weirdness … let pizzaJoint = “café pesto”
  var attrString = NSMutableAttributedString(string: pizzaJoint) 
  let firstWordRange = pizzaJoint.startIndex..<pizzaJoint.indexOf(“ “)!
  let nsrange = NSRange(firstWordRange, in: pizzaJoint) // convert Range<String.Index> 
  attrString.addAttribute(.strokeColor, value: UIColor.orange, range: nsrange)
  ```

  

#### Fonts

- Usually you set fonts in UI elements like UIButton, UILabel,

- Simple way to get a font in code

  - Get preferred font for a given text style (e.g. body, etc.) using this UIFont type method …

    `static func preferredFont(forTextStyle: UIFontTextStyle) -> UIFont`

  - Some of the styles (see `UIFontDescriptor` documentation for more) … 

    ```swift
    UIFontTextStyle.headline
    								.body 
    								.footnote
    ```

  - Importantly, the size of the font you get is determined by user settings (esp. for Accessibility).

- More advanced way …

  - Choose a speciﬁc font by name …

  ```swift
  let font = UIFont(name: “Helvetica”, size: 36.0) 
  //You can also use the UIFontDescriptor class to get the font you want.
  
  //Now get metrics for the text style you want and scale font to the user’s desired size … 
  let metrics = UIFontMetrics(forTextStyle: .body) // or UIFontMetrics.default
  let fontToUse = metrics.scaledFont(for: font)
  ```

- There are also “system fonts”

  - These appear usually on things like buttons.

  ```swift
  static func systemFont(ofSize: CGFloat) -> UIFont 
  static func boldSystemFont(ofSize: CGFloat) -> UIFont
  ```



#### Drawing Images

**`UIImageView`**

- Creating a `UIImage` object

  - ```swift
    let image: UIImage? = UIImage(named: “foo”) // note that its an Optional 
    ```

    - You add foo.jpg to your project in the Assets.xcassets ﬁle (we’ve ignored this so far)
    - Images will have different resolutions for different devices (all managed in Assets.xcassets)

- You can also create one from ﬁles in the ﬁle system

  - ```swift
    let image: UIImage? = UIImage(contentsOfFile: pathString) 
    let image: UIImage? = UIImage(data: aData) // raw jpg, png, tiff, etc. image data
    ```

- You can even create one by drawing with Core Graphics （See documentation for `UIGraphicsBeginImageContext(CGSize)`）

- Once you have a UIImage, you can blast its bits on screen

  ```swift
  let image: UIImage = …
  image.draw(at point: aCGPoint) // the upper left corner put at aCGPoint
  image.draw(in rect: aCGRect)  // scales the image to ﬁt aCGRect 
  image.drawAsPattern(in rect: aCGRect)// tiles the image into aCGRect
  ```

  

#### Bound Change

- Redraw on bounds change?
  - By default, when a UIView’s bounds changes, there is no redraw
  - Instead, the “bits” of the existing image are scaled to the new bounds size
  - Luckily, there is a UIView property to control this! It can be set in Xcode too. `var contentMode: UIViewContentMode`

- **`UIViewContentMode`**
  - Don’t scale the view, just place the bits (intact) somewhere …
    - .left/.right/.top/.bottom/.topRight/.topLeft/.bottomRight/.bottomLeft/.center
  - Scale the “bits” of the view …
    - .scaleToFill/.scaleAspectFill/.scaleAspectFit 
    - .scaleToFill is the default
  - Redraw by calling draw(CGRect) again (costly, but for certain content, better results)
    - .redraw

- Layout on bounds change?

  - What about your subviews on a bounds change?

  - If your bounds change, you may want to reposition some of your subviews 

    - Usually you would set this up using Autolayout constraints 
    - Or you can manually reposition your views when your bounds change by overriding …

    ```Swift
    override func layoutSubviews() {
    super.layoutSubviews() // reposition my subviews’s frames based on my new bounds 
    }
    ```




## Gestures

- Gestures are recognized by instances of UIGestureRecognizer
- There are two sides to using a gesture recognizer
  - Adding a gesture recognizer to a UIView (asking the UIView to “recognize” that gesture)
  - Providing a method to “handle” that gesture (not necessarily handled by the UIView)
- Usually the ﬁrst is done by a Controller
- The second is provided either by the UIView or a Controller



### Adding a gesture recognizer to a UIView

Imagine we wanted a UIView in our Controller’s View to recognize a “pan” gesture. We can conﬁgure it to do so in the property observer for the outlet to that UIView …

```swift
@IBOutlet weak var pannableView: UIView {
	didSet { 
		let panGestureRecognizer = UIPanGestureRecognizer( 
      target: self, action:#selector(ViewController.pan(recognizer:))
		) 
    pannableView.addGestureRecognizer(panGestureRecognizer) 
  }
}
```



- The property observer’s didSet code gets called when iOS hooks up this outlet at runtime 
- Here we are creating an instance of a concrete subclass of UIGestureRecognizer (for pans)
- The **target** gets notiﬁed when the gesture is recognized (here it’s the Controller itself)
- The **action** is the method invoked on recognition (that method’s argument? the recognizer)

### Handler for Gestures

- A handler for a gesture needs gesture-speciﬁc information
- For example, UIPanGestureRecognizer provides 3 methods

```swift
func translation(in: UIView?) -> CGPoint // cumulative since start of recognition 
func velocity(in: UIView?) -> CGPoint // how fast the ﬁnger is moving (points/s)
func setTranslation(CGPoint, in: UIView?)//This last one is interesting because it allows you to reset the translation so far By resetting the translation to zero all the time, you end up getting “incremental” translation
```

- The abstract superclass also provides state information

```swift
var state: UIGestureRecognizerState { get } 
```

- - This sits around in `.possible` until recognition starts
  - For a continuous gesture (e.g. pan), it moves from `.began` thru `repeated` `.changed` to `.ended` 
  - For a discrete (e.g. a swipe) gesture, it goes straight to `.ended` or `.recognized`.
  - It can go to `.failed` or `.cancelled` too, so watch out for those!

#### Example of Handler

```swift
func pan(recognizer: UIPanGestureRecognizer) {

switch recognizer.state { 
  	case .changed: fallthrough 
  	case .ended:
  		let translation = recognizer.translation(in: pannableView) // update anything that depends on the pan gesture using translation.x and .y 
  		recognizer.setTranslation(CGPoint.zero, in: pannableView) 					default: break
}
  
// We are only going to do anything when the ﬁnger moves or lifts up off the device’s surface
```

- Here we get the location of the pan in the pannableView’s coordinate system
- By resetting the translation, the next one we get will be incremental movement



### Other Gestures

#### UIPinchGestureRecognizer

```swift
var scale: CGFloat // not read-only (can reset) 
var velocity: CGFloat { get } // scale factor per second
```



#### UIRotationGestureRecognizer

```swift
var rotation: CGFloat // not read-only (can reset); in radians 
var velocity: CGFloat { get } // radians per second
```



#### UISwipeGestureRecognizer

Set up the direction and number of ﬁngers you want

```swift
var direction: UISwipeGestureRecoginzerDirection // which swipe directions you want 
var numberOfTouchesRequired: Int // ﬁnger count
```



#### UITapGestureRecognizer

```swift
//This is discrete, but you should check for .ended to actually do something. Set up the number of taps and ﬁngers you want …

var numberOfTapsRequired: Int // single tap, double tap, etc.
var numberOfTouchesRequired: Int // ﬁnger count
```



#### UILongPressRecognizer

```swift
This is a continuous (not discrete) gesture (i.e. you’ll get .changed if the ﬁnger moves) You still conﬁgure it up-front …

var minimumPressDuration: TimeInterval // how long to hold before its recognized 
var numberOfTouchesRequired: Int // ﬁnger count 
var allowableMovement: CGFloat // how far ﬁnger can move and still recognize Very important to pay attention to .cancelled because of drag and drop
```



## Multiple MVCs

### MVC working together

iOS provides some Controllers whose View is “other MVCs”

#### UITabBarController

- It lets the user choose between different MVCs

- The icon, title and even a “badge value” on these is determined by the MVCs themselves via their property:

  `var tabBarItem: UITabBarItem!`

  But usually you just set them in your storyboard.

- If there are too many tabs to ﬁt here, the `UITabBarController` will automatically present a UI for the user to manage the overﬂow!

#### UISplitViewController

- Puts two MVCs side-by-side
  - Master
  - Detail

#### UINavigationController

- Pushes and pops MVCs off of a stack (like a stack of cards)



### Accessing the sub-MVCs

You can get the sub-MVCs via the viewControllers property

```swift
var viewControllers: [UIViewController]? { get set } // can be optional (e.g. for tab bar)

// for a tab bar, they are in order, left to right, in the array 
// for a split view, [0] is the master and [1] is the detail 
// for a navigation controller, [0] is the root and the rest are in order on the stack
// even though this is settable, usually setting happens via storyboard, segues, or other 
// for example, navigation controller’s push and pop methods
```

But how do you get ahold of the SVC, TBC or NC itself?

```swift
//Every UIViewController knows the Split View, Tab Bar or Navigation Controller it is currently in These are UIViewController properties …

var tabBarController: UITabBarController? { get } 
var splitViewController: UISplitViewController? { get } 
var navigationController: UINavigationController? { get }

//So, for example, to get the detail (right side) of the split view controller you are in …

if let detail: UIViewController? = splitViewController?.viewControllers[1] { … }
```

Adding (or removing) MVCs from a UINavigationController

```swift
func pushViewController(_ vc: UIViewController, animated: Bool) func popViewController(animated: Bool) 

```


But we usually don’t do this. Instead we use Segues. More on this in a moment.



### Wiring up MVCs

- Just drag out a `splitViewController` (and delete all the extra VCs it brings with it)
- But split view can only do its thing properly on iPad/iPhone+
  - So we need to put some Navigation Controllers in there so it will work on iPhone 
  - The Navigation Controllers will be good for iPad too because the MVCs will get titles 
  - The simplest way to wrap a Navigation Controller around an MVC is with `Editor->Embed In`



### Segues

- We’ve built up our Controllers of Controllers,
  - Now we need to make it so that one MVC can cause another to appear We call that a “segue”
- Kinds of segues
  - Show Segue: will push in a Navigation Controller, else Modal
  - Show Detail Segue: will show in Detail of a Split View or will push in a Navigation Controller
  - Modal Segue: take over the entire screen while the MVC is up
  - Popover Segue: make the MVC appear in a little popover window
- **Segues always create a new instance of an MVC**
  - Going “back” in a Navigation Controller is NOT a segue though (so no new instance there)
- How do we make these segues happen?
  - Ctrl-drag in a storyboard from an instigator (like a button) to the MVC to segue to 
  - Can be done in code as well



#### Create a Segue

- Ctrl-drag from the button  that causes the graph to appear to the MVC of the graph.
- Select the kind of segue you want. Usually Show or Show Detail.
- Now click on the segue and open the Attributes Inspector
- Give the segue a unique identiﬁer here.  It should describe what the segue does.

#### Prepraring for a Segue

```swift
func prepare(for segue: UIStoryboardSegue, sender: Any?) {
	if let identifier = segue.identifier { 
		switch identifier { 
			case “Show Graph”:
				if let vc = segue.destination as? GraphController { 					
						vc.property1 = …
						vc.callMethodToSetItUp(…)
        }
      default: break
    }
  }
}
```

The segue passed in contains important information about this segue:


1. the identiﬁer from the storyboard


2. the Controller of the MVC you are segueing to (which was just created for you)

The sender is either the instigating object from a storyboard (e.g. a UIButton)
 or the sender you provided (see last slide) if you invoked the segue manually in code



#### Preventing Segues

You can prevent a segue from happening too

Just return false from this method your UIViewController …

```swift
func shouldPerformSegue(withIdentifier identifier: String?, sender: Any?) -> Bool 
```

The identifier is the one in the storyboard.

The sender is the instigating object (e.g. the button that is causing the segue).



## Animation

### Timer

- Used to execute code periodically

- Fire one off with this method …

  ```swift
  class func scheduledTimer( 
  	withTimeInterval: TimeInterval, 
    repeats: Bool, 
    block: (Timer) -> Void 
  ) -> Timer
  ```

  

#### Start

```swift
private weak var timer: Timer?
timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { timer in
	// your code here 
} 
```

Every 2 seconds (approximately), the closure will be executed.

Note that the var we stored the timer in is weak.

That’s okay because the run loop will keep a strong pointer to this as long as it’s scheduled.



#### Stop

`timer.invalidate()`



#### Tolerance

It might help system performance to set a tolerance for “late ﬁring”.

For example, if you have timer that goes off once a minute, a tolerance of 10s might be ﬁne. 

```swift
myOneMinuteTimer.tolerance = 10 // in seconds 
```

The ﬁring time is relative to the start of the timer (not the last time it ﬁred), i.e. no “drift”.



### Kinds of Animation

- Animating UIView properties

  - Changing things like the frame or transparency.

- Animating Controller transitions (as in a UINavigationController)

  - Beyond the scope of this course, but fundamental principles are the same.

- Core Animation

  - Underlying powerful animation framework (also beyond the scope of this course).

- OpenGL and Metal

  - 3D

- SpriteKit

  - “2.5D” animation (overlapping images moving around over each other, etc.)

- Dynamic Animation

  - “Physics”-based animation.

  



#### UIView Animation

- Changes to certain UIView properties can be animated over time
  - frame/center 
  - bounds (transient size, does not conﬂict with animating center) 
  - transform (translation, rotation and scale) 
  - alpha (opacity)
  - backgroundColor

- Done with `UIViewPropertyAnimator` using closures



### UIViewPropertyAnimator

Easiest way to use a UIViewPropertyAnimator

```swift
class func runningPropertyAnimator(
	withDuration: TimeInterval, 
  delay: TimeInterval, 
  options: UIViewAnimationOptions, 
  animations: () -> Void, 
  completion: ((position: UIViewAnimatingPosition) -> Void)? = nil

)
```

Note that this is a static (class) function. You send it to the `UIViewPropertyAnimator` type. The animations argument is a closure containing code that changes center, transform, etc. The completion argument will get executed when the animation ﬁnishes or is interrupted.



#### Example

```swift
if myView.alpha == 1.0 {
	UIViewPropertyAnimator.runningPropertyAnimator( 
    withDuration: 3.0, 
    delay: 2.0, 
    options: [.allowUserInteraction],
    animations: { myView.alpha = 0.0 },
    completion: { if $0 == .end { myView.removeFromSuperview() } }
  ) 
  print(“alpha = \(myView.alpha)”)
}
```

#### UIViewAnimationOptions

```swift
beginFromCurrentState // pick up from other, in-progress animations of these properties
allowUserInteraction // allow gestures to get processed while animation is in progress 
layoutSubviews // animate the relayout of subviews with a parent’s animation
repeat  // repeat indeﬁnitely
autoreverse  // play animation forwards, then backwards 
overrideInheritedDuration // if not set, use duration of any in-progress animation
overrideInheritedCurve // if not set, use curve (e.g. ease-in/out) of in-progress animation
allowAnimatedContent // if not set, just interpolate between current and end “bits”
curveEaseInEaseOut // slower at the beginning, normal throughout, then slow at end
curveEaseIn // slower at the beginning, but then constant through the rest
curveLinear// same speed throughout
```



- Sometimes you want to make an entire view modiﬁcation at once
  - In this case you are not limited to special properties like alpha, frame and transform 
  - Flip the entire view over `UIViewAnimationOptions.transitionFlipFrom{Left,Right,Top,Bottom}`
  - Dissolve from old to new state `.transitionCrossDissolve` 
  - Curling up or down `.transitionCurl{Up,Down}`

#### Example

Flipping a playing card over

```swift
UIView.transition(
  with: myPlayingCardView, 
  duration: 0.75, 
  options: [.transitionFlipFromLeft], 
  animations: { cardIsFaceUp = !cardIsFaceUp } 
  completion: nil) 
```



### Dynamic Animation

- A little different approach to animation
  - Set up physics relating animatable objects and let them run until they resolve to stasis.
  - Easily possible to set it up so that stasis never occurs, but that could be performance problem.

1. Create a `UIDynamicAnimator`

```swift
var animator = UIDynamicAnimator(referenceView: UIView)
```

If animating views, all views must be in a view hierarchy with referenceView at the top.

2. Create and add UIDynamicBehavior instances

```swift
//e.g., 
let gravity = UIGravityBehavior() 
animator.addBehavior(gravity) 
//e.g., 
let collider = UICollisionBehavior()
animator.addBehavior(collider)
```



3. Add UIDynamicItems to a UIDynamicBehavior

```swift
let item1: UIDynamicItem = ... // usually a UIView 
let item2: UIDynamicItem = ... // usually a UIView 
gravity.addItem(item1) 
collider.addItem(item1)
gravity.addItem(item2)

//item1 and item2 will both be affect by gravity item1 will collide with collider’s other items or boundaries, but not with item2
```

#### UIDynamicItem protocol

```swift
Any animatable item must implement this …

protocol UIDynamicItem { 
  var bounds: CGRect { get } // essentially the size 
  var center: CGPoint { get set } // and the position 
  var transform: CGAffineTransform { get set } // rotation usually 
  var collisionBoundsType: UIDynamicItemCollisionBoundsType { get set} 
  var collisionBoundingPath: UIBezierPath { get set }

} 
//UIViewimplements this protocol If you change center or transform while the animator is running, you must call this method in UIDynamicAnimator …

func updateItemUsingCurrentState(item: UIDynamicItem)
```



#### Behaviors

`UIGravityBehavior`

```swift
var angle: CGFloat // in radians; 0 is to the right; positive numbers are clockwise 
var magnitude: CGFloat // 1.0 is 1000 points/s/s
```

`UIAttachmentBehavior`

```swift
init(item: UIDynamicItem, attachedToAnchor: CGPoint) 
init(item: UIDynamicItem, attachedTo: UIDynamicItem) 
init(item: UIDynamicItem, offsetFromCenter: CGPoint, attachedTo[Anchor]…) 
var length: CGFloat // distance between attached things (this is settable while animating!) var anchorPoint: CGPoint // can also be set at any time, even while animating

//The attachment can oscillate (i.e. like a spring) and you can control frequency and damping
```



`UICollisionBehavior`

```swift
var collisionMode: UICollisionBehaviorMode // .items, .boundaries, or .everything

//If .items, then any items you add to a UICollisionBehavior will bounce off of each other

//If .boundaries, then you add UIBezierPath boundaries for items to bounce off of … 
func addBoundary(withIdentifier: NSCopying, for: UIBezierPath)
func addBoundary(withIdentifier: NSCopying, from: CGPoint, to: CGPoint) func removeBoundary(withIdentifier: NSCopying) 
var translatesReferenceBoundsIntoBoundary: Bool // referenceView’s edges NSCopying means NSString or NSNumber, but remember you can as to String, Int, etc.
```

How do you ﬁnd out when a collision happens?

`var collisionDelegate: UICollisionBehaviorDelegate`

… this delegate will be sent methods like …

```swift
func collisionBehavior( 
  behavior: UICollisionBehavior, 
  began/endedContactFor: UIDynamicItem, 
  withBoundaryIdentifier: NSCopying // with:UIDynamicItem too 
  at: CGPoint)
```

The `withBoundaryIdentifier` is the one you pass to `addBoundary(withIdentifier:)`.



`UISnapBehavior`

```swift
init(item: UIDynamicItem, snapTo: CGPoint)
```

Imagine four springs at four corners around the item in the new spot.

You can control the damping of these “four springs” with `var damping: CGFloat`



`UIPushBehavior`

```swift
var mode: UIPushBehaviorMode // .continuous or .instantaneous 
var pushDirection: CGVector

//… or …

var angle: CGFloat // in radians and positive numbers are clockwise 
var magnitude: CGFloat // magnitude 1.0 moves a 100x100 view at 100 pts/s/s
```

Interesting aspect to this behavior If you push `.instantaneous`, what happens after it’s done? It just sits there wasting memory.



`UIDynamicItemBehavior`

Sort of a special “meta” behavior.

Controls the behavior of items as they are affected by other behaviors. 

Any item added to this behavior (with addItem) will be affected by …

```swift
var allowsRotation: Bool 
var friction: CGFloat 
var elasticity: CGFloat
```

… and others, see documentation.

Can also get information about items with this behavior ...

```swift
func linearVelocity(for: UIDynamicItem) -> CGPoint 
func addLinearVelocity(CGPoint, for: UIDynamicItem) 
func angularVelocity(for: UIDynamicItem) -> CGFloat
```

Multiple `UIDynamicItemBehaviors` affecting the same item(s) is “advanced”



**Superclass of behaviors.**

You can create your own subclass which is a combination of other behaviors. Usually you override `init` method(s) and addItem and removeItem to call …

`func addChildBehavior(UIDynamicBehavior)`

This is a good way to encapsulate a physics behavior that is a composite of other behaviors.

 You might also add some API which helps your subclass conﬁgure its children.



All behaviors know the `UIDynamicAnimator` they are part of

They can only be part of one at a time.

```swift
var dynamicAnimator: UIDynamicAnimator? { get }
```

And the behavior will be sent this message when its animator changes …

```swift
func willMove(to: UIDynamicAnimator?)
```



Every time the behavior acts on items, this block of code that you can set is executed …

```swift
var action: (() -> Void)?
```

(i.e. it’s called action, it takes no arguments and returns nothing) You can set this to do anything you want.

But it will be called a lot, so make it very efﬁcient.

 If the action refers to properties in the behavior itself, watch out for memory cycles.



#### Stasis

`UIDynamicAnimator`’s delegate tells you when animation pauses

Just set the delegate …

```swift
var delegate: UIDynamicAnimatorDelegate 
//… and you’ll ﬁnd out when stasis is reached and when animation will resume …

func dynamicAnimatorDidPause(UIDynamicAnimator) 
func dynamicAnimatorWillResume(UIDynamicAnimator)
```



### Memory Cycle Avoidance

Example of using action and avoiding a memory cycle

Let’s go back to the case of an .instantaneous UIPushBehavior When it is done acting on its items, it would be nice to remove it from its animator We can do this with the action var which takes a closure …

```swift
if let pushBehavior = UIPushBehavior(items: […], mode: .instantaneous) { 
  pushBehavior.magnitude = …
  pushBehavior.angle = …
  pushBehavior.action = {
    pushBehavior.dynamicAnimator!.removeBehavior(pushBehavior) 
  } 
  animator.addBehavior(pushBehavior) // will push right away
}


```

But the above has a memory cycle because its action captures a pointer back to itself. 

So neither the action closure nor the pushBehavior can ever leave the heap!



#### Closure Capturing

- You can deﬁne local variables on the ﬂy at the start of a closure
- These locals can be declared `weak/unowned`

```swift
var foo = { [unowned/weak x = someInstanceOfaClass, y = “hello”] in // use x and y here }
```

- This is all primarily used to prevent a memory cycle



```swift
class Zerg { 
  private var foo = { 
    self.bar() 
  } 
  private func bar() {
    . . . 
  }
}
```

We can break this with the local variable trick 

```swift
class Zerg { 
  private var foo = { [weak weakSelf = self] in 
  	weakSelf?.bar() // need Optional chaining now because weakSelf is an Optional 
    } 
 private func bar() { . . . } }
```



- There are two different “self” variables here.
  - The yellow one is local to the closure and is a weak Optional.
  - The green one is the instance of Zerg itself (and is obviously not weak, nor an Optional).

- You don’t even need the “= self”. By default, local closure vars are set equal to the var of the same name in their surroundings.



#### Example

```swift
if let pushBehavior = UIPushBehavior(items: […], mode: .instantaneous) { 
  pushBehavior.magnitude = …
  pushBehavior.angle = …
  pushBehavior.action = { [unowned pushBehavior] in 
                      pushBehavior.dynamicAnimator!.removeBehavior(pushBehavior) 
                        } 
  animator.addBehavior(pushBehavior) // will push right away
}
```



## View Controller Lifecycle

The start of the lifecycle

- Creation.
- MVCs are most often instantiated out of a storyboard (as you’ve seen).
- Then:
  - Preparation if being segued to.
  - Outlet setting.
  - Appearing and disappearing. 
  - Geometry changes. 
  - Low-memory situations.

### Primary Setup

```swift
override func viewDidLoad() {

super.viewDidLoad() // always let super have a chance in lifecycle methods

// do the primary setup of my MVC here 
// good time to update my View using my Model, for example, because my outlets are set 
}

```

**Do not do geometry-related setup here! Your bounds are not yet set!**



### Will Appear

This method will be sent just before your MVC appears (or re-appears) on screen …

```swift
override func viewWillAppear(_ animated: Bool) {
  super.viewWillAppear(animated)
// catch my View up to date with what went on while I was off-screen 
} 
```

**Note that this method can be called repeatedly (vs. viewDidLoad which is only called once).**



### Did Appear

You also ﬁnd out after your MVC has ﬁnished appearing on screen …

```swift
override func viewDidAppear(_ animated: Bool) {
	super.viewDidAppear(animated)
	// maybe start a timer or an animation or start observing something (e.g. GPS position)?
}
```



This is also a good place to **start something expensive** (e.g. network fetch) going.

- Why kick off expensive things here instead of in viewDidLoad?
- Because we know we’re on screen so it won’t be a waste.
- By “expensive” we usually mean “time consuming” but could also mean battery or storage.

We must never block our UI from user interaction (thus background fetching, etc.).

- Our UI might need to come up incomplete and later ﬁll in when expensive operation is done. 
- We use “**spinning wheels**” and such to let the user know we’re fetching something expensive.



### Did Disappear



Your MVC went off screen.

Somewhat rare to do something here, but occasionally you might want to “clean up” your MVC. For example, you could save some state or release some large, recreatable resource.

```swift
override func viewDidDisappear(_ animated: Bool) {
  super.viewDidDisappear(animated)
  //clean up MVC
}
```



### Others

#### Geometry

You get notiﬁed when your top-level view’s bounds change (or otherwise needs a re-layout). In other words, when it receives layoutSubviews, you get to ﬁnd out (before and after).

```swift
override func viewWillLayoutSubviews() 

override func viewDidLayoutSubviews()
```

**Usually you don’t need to do anything here because of Autolayout.**

**But if you do have geometry-related setup to do, this is the place to do it (not in viewDidLoad!).**

These can be called often (just as `layoutSubviews()` in UIView can be called often). Be prepared for that.

Don’t do anything here that can’t be properly (and efﬁciently) done repeatedly.

It doesn’t always mean your view’s bounds actually changed.



#### Autorotation

When your device rotates, there’s a lot going on.

Of course your view’s bounds change (and thus you’ll get `viewWill/DidLayoutSubviews`). But the resultant changes are also automatically animated.

You get to ﬁnd out about that and even participate in the animation if you want …

```swift
override func viewWillTransition( 
	to size: CGSize, 
	with coordinator: UIViewControllerTransitionCoordinator 
) 
```

You join in using the coordinator’s animate(alongsideTransition:) methods.

We don’t have time to talk about how to do this, unfortunately! Check the documentation !

#### Low Memory

It is rare, but occasionally your device will run low on memory.

This usually means a buildup of very large videos, images or maybe sounds.

If your app keeps strong pointers to these things in your heap, you might be able to help! When a low-memory situation occurs, iOS will call this method in your Controller …

```swift
override func didReceiveMemoryWarning() {
  super.didReceiveMemoryWarning()
  // stop pointing to any large-memory things (i.e. let them go from my heap) 
  // that I am not currently using (e.g. displaying on screen or processing somehow) 
  // and that I can recreate as needed (by refetching from network, for example)
}
```

If your application persists in using an unfair amount of memory, you can get killed by iOS.



#### Waking up from an storyboard

This method is sent to all objects that come out of a storyboard (including your Controller) …

```swift
override func awakeFromNib() { 
  super.awakeFromNib()
  // can initialize stuff here, but it’s VERY early 
  // it happens way before outlets are set and before you’re prepared as part of a segue
}
```

This is pretty much a place of last resort.

Use the other View Controller Lifecycle methods ﬁrst if at all possible.

It’s primarily for situations where code has to be executed VERY EARLY in the lifecycle.



### Summary

- Instantiated (from storyboard usually) 
- `awakeFromNib` (only if instantiated from a storyboard) segue preparation happens outlets get set
- `viewDidLoad`
- These pairs will be called each time your Controller’s view goes on/off screen …
  - `viewWillAppear` and `viewDidAppear`
  -  `viewWillDisappear` and `viewDidDisappear`
- These “geometry changed” methods might be called at any time after `viewDidLoad` 
  - `viewWillLayoutSubviews` and `viewDidLayoutSubviews`

- At any time, if memory gets low, you might get …
  - `didReceiveMemoryWarning`

## Scroll View



### Create a UIScrollView

- Just like any other UIView. Drag out in a storyboard or use UIScrollView(frame:).

- Or select a UIView in your storyboard and choose “Embed In -> Scroll View” from Editor menu.

### Adding subviews to a UIScrollView

```swift
scrollView.contentSize = CGSize(width: 3000, height: 2000) 
logo.frame = CGRect(x: 2700, y: 50, width: 120, height: 180) scrollView.addSubview(logo)
aerial.frame = CGRect(x: 150, y: 200, width: 2500, height: 1600) scrollView.addSubview(aerial)
```



### Positioning subviews in a UIScrollView

```swift
aerial.frame = CGRect(x: 0, y: 0, width: 2500, height: 1600) 
logo.frame = CGRect(x: 2300, y: 50, width: 120, height: 180)
scrollView.contentSize = CGSize(width: 2500, height: 1600)
```



### Get Current View

#### Current Position

```swift
let upperLeftOfVisible: CGPoint = scrollView.contentOffset
```

#### Current Frame

```swift
let visibleRect: CGRect = aerial.convert(scrollView.bounds, from: scrollView)
```

#### Scrolling programmatically

```swift
 func scrollRectToVisible(CGRect, animated: Bool)
```



### Zoom

All UIView’s have a property (transform) which is an afﬁne transform (translate, scale, rotate). Scroll view simply modiﬁes this transform when you zoom.

Zooming is also going to affect the scroll view’s contentSize and contentOffset.

#### Set minimum/maximum zoom scale

```swift
scrollView.minimumZoomScale = 0.5 // 0.5 means half its normal size
scrollView.maximumZoomScale = 2.0 // 2.0 means twice its normal size
```

#### Delegate method

```swift
func viewForZooming(in scrollView: UIScrollView) -> UIView
```

If your scroll view only has one subview, you return it here. More than one? Up to you.

The scroll view will keep you up to date with what’s going on.

**Example: delegate method will notify you when zooming ends**

```swift

func scrollViewDidEndZooming(UIScrollView,
																with view: UIView, 
																atScale: CGFloat)
// from delegate method above
```

If you redraw your view at the new scale, be sure to reset the transform back to identity.

#### Zooming programatically

```swift
var zoomScale: CGFloat 
func setZoomScale(CGFloat, animated: Bool) 
func zoom(to rect: CGRect, animated: Bool)
```



### Other things you can control in a scroll view

- Whether scrolling is enabled.
- Locking scroll direction to user’s ﬁrst “move”.
- The style of the scroll indicators (call flashScrollIndicators when your scroll view appears).
- Whether the actual content is “inset” from the content area (contentInset property).



## Multithreading

### Queues

- Multithreading is mostly about “queues” in iOS.
- Functions (usually closures) are simply lined up in a queue (like at the movies!).
- Then those functions are pulled off the queue and executed on an associated thread(s).
- Queues can be “serial” (one closure a time) or “concurrent” (multiple threads servicing it).



#### Main Queue

- There is a very special serial queue called the “main queue.”
- All UI activity MUST occur on this queue and this queue only.
- And, conversely, non-UI activity that is at all time consuming must NOT occur on that queue.
- We do this because we want our UI to be highly responsive!
- And also because we want things that happen in the UI to happen predictably (serially). Functions are pulled off and worked on in the main queue only when it is “quiet”.



#### Global Queues

- For non-main-queue work, you’re usually going to use a shared, global, concurrent queue.



### Use Queue

#### Getting a Queue

Getting the main queue (where all UI activity must occur).

```swift
let mainQueue = DispatchQueue.main
```

Getting a global, shared, concurrent “background” queue.

This is almost always what you will use to get activity off the main queue.

```swift
let backgroundQueue = DispatchQueue.global(qos: DispatchQoS) // high priority, only do something short and quick DispatchQoS.userInitiated
DispatchQoS.userInteractive  // high priority, but might take a little bit of time
DispatchQoS.background // not directly initiated by user, so can run as slow as needed
DispatchQoS.utility// long-running background processes, low priority
```



#### Putting a block of code on the queue

Multithreading is simply the process of putting closures into these queues.

There are two primary ways of putting a closure onto a queue.

You can just plop a closure onto a queue and keep running on the current queue … 

```swift
queue.async { . . . }
```

 … or you can block the current queue waiting until the closure ﬁnishes on that other queue … 

```swift
queue.sync { . . . } 
```

We almost always do the former.

#### Getting a non-global queue

Very rarely you might need a queue other than main or global.

Your own serial queue (use this only if you have multiple, serially dependent activities) …

```swift
let serialQueue = DispatchQueue(label: “MySerialQ”)
```

Your own concurrent queue (rare that you would do this versus global queues) …

```swift
let concurrentQueue = DispatchQueue(label: “MyConcurrentQ”, attributes: .concurrent)
```



**We are only seeing the tip of the iceberg**

There is a lot more to GCD (Grand Central Dispatch) You can do locking, protect critical sections, readers and writers, synchronous dispatch, etc. Check out the documentation if you are interested

**There is also another API to all of this**

`OperationQueue` and `Operation` Usually we use the DispatchQueue API, however.

This is because the “nesting” of dispatching reads very well in the code But the Operation API is also quite useful (especially for more complicated multithreading)



### Multithreading API

Quite a few places in iOS will do what they do off the main queue 

They might even afford you the opportunity to do something off the main queue 

iOS might ask you for a function (a closure, usually) that executes off the main thread 

**Don’t forget that if you want to do UI stuff there, you must dispatch back to the main queue!**



#### Example of a multithreaded iOS API

This API lets you fetch the contents of an http URL into a Data off the main queue!

```swift
let session = URLSession(configuration: .default) 
if let url = URL(string: "http://stanford.edu/...") { 
  let task = session.dataTask(with: url) { (data: Data?, response, error) in 
   //Do Something with the data                                      
	DispatchQueue.main.async {
		// do UI stuff here
  	}
  	print(“did some stuff with the data, but UI part hasn’t happened yet”)                   
	} 
  task.resume()
}
print(“done firing off the request for the url’s contents”)
```



- 1->2->3->10->12
- 4->5->8
- 6





## More about Autolayout

What we have learned about auto-layout

- Using the dashed blue lines to try to tell Xcode what you intend
-  Reset to Suggested Constraints in lower right corner if blue lines were good enough 
- Ctrl-dragging to the edges and to other views 
- Size Inspector to look at and edit simple details of the constraints on a view 
- Clicking on a constraint directly in the storyboard and inspecting it
-  The “pin” menu in the lower right corner (there’s an “arrange” button there too) 
- The Document Outline is an awesome place to view/edit and resolve problem constraints

**Mastering Autolayout requires experience**

**Autolayout can be done from code as well**

All that is not always enough

Sometimes the geometry changes so drastically that simple autolayout cannot cope. You actually need to reposition the views entirely to make them ﬁt properly.

**Solution? We can vary our UI based on its “size class”**



### Size Class

A view controller’s current size class says what sort of room it has to lay out in.

It’s not an exact number or dimension, it’s just either “compact” or “regular” width or height.



#### iPhone

- All iPhones in portrait are compact in width and regular in height 

- All non-Plus iPhones in landscape are compact in both dimensions



#### iPhone Plus

- iPhone Plus is also compact in width and regular in height in portrait 
- But in landscape, the iPhone Plus is only compact in height (i.e. it’s regular in width)



#### iPad

- Always regular in both dimensions 
- But depending on the environment an MVC is in, it might be compact (e.g. split view master)



![image-20190718110254034](assets/image-20190718110254034.png)

![image-20190718110308230](assets/image-20190718110308230.png)

**What can we do based on our size class?**

- You can vary many properties in UIView …

- Fonts, background color, isHidden, even whether a view is installed in the view hierarchy. 
- Most importantly though, you can also include or exclude any constraint based on size class. 
- By doing this, we can rearrange our UI completely differently in different size class situations.
-  InterfaceBuilder has full support for doing this.

**Using Size Class information**

You can ﬁnd out your current “size class” in code using this method in UIViewController …

```swift
let myHorizSizeClass: UIUserInterfaceSizeClass = traitCollection.horizontalSizeClass
```

 The return value is an enum … either `.compact` or `.regular` (or .`unspecified`).

However, it is rare to look at our size class in code.

Again, we’re almost always going to do this in InterfaceBuilder.



## Drag and Drop

- Very interoperable way to move data around

Between apps on iPad and within an app on all iOS 11 devices.

Your app continues to work normally while drag and drop is going on.

Multitouch allows some ﬁngers to be doing drag and drop and other ﬁngers working your app. 

New mulittasking UI in iOS 11 makes drag and drop really useful.



### Interactions

A view “signs up” to participate in drag and/or drop using an interaction.

It’s kind of like a “gesture recognizer” for drag and drop.

```swift
let drag/dropInteraction = UIDrag/DropInteraction(delegate: theDelegate) 
view.addInteraction(drag/dropInteraction)
```

Now the theDelegate will get involved if a drag or drop occurs in the view.



#### Starting a drag

Now, when the user makes a dragging gesture, the delegate gets …

```swift
func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession ) -> [UIDragItem]
```

… and can return the items it is willing to have dragged from the view.

Returning an empty array means “don’t drag anything after all.”

A `UIDragItem` is created like this …

```swift
let dragItem = UIDragItem(itemProvider: NSItemProvider(object: provider)) 
```

Providers: `NSAttributedString`, `NSString`, `UIImage`, `NSURL`, `UIColor,` `MKMapItem`, `CNContact`. You can drag your own types of data, but that’s beyond the scope of this course.

Note that some of these types start with NS … you might have to use `as?` to cast them.

You can also provide an object that will be passed to drop targets inside your own app …

`dragItem.localObject = someObject`





#### Adding to a drag

Even in the middle of a drag, users can add more to their drag if you implement …

```swift
func dragInteraction(_ interaction: UIDragInteraction, itemsForAddingTo session: UIDragSession ) -> [UIDragItem]
```

… and returns more items to drag.



#### Accepting a drop

When a drag moves over a view with a UIDropInteraction, the delegate gets …

```swift
func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDragSession ) -> Bool
```

… at which point the delegate can refuse the drop before it even gets started. 

To ﬁgure that out, the delegate can ask what kind of objects can be provided …

```swift
let stringAvailable = session.canLoadObjects(ofClass: NSAttributedString.self) let imageAvailable = session.canLoadObjects(ofClass: UIImage.self)
```

… and refuse the drop if it isn’t to your liking.



If you don’t refuse it in canHandle:, then as the drag progresses, you’ll start getting …

```swift
func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDragSession ) -> UIDropProposal 
```

… to which you will respond with `UIDropProposal(operation: .copy\.move\ .cancel).` 

- `.cancel` means the drop would be refused
-  `.copy` means drop would be accepted
-  `.move` means drop would be accepted and would move the item (only for drags within an app)

If it matters, you can ﬁnd out where the touch is with `session.location(in: view)`.



If all that goes well and the user let’s go of the drop, you get to go fetch the data …

```swift
func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession )
```

You will implement this method by calling loadObjects(ofClass:) on the session. This will go and fetch the data asynchronously from whomever the drag source is.

```swift
session.loadObjects(ofClass: NSAttributedString.self) { theStrings in 
 // do something with the dropped NSAttributedStrings 
 }
```

The passed closure will be executed some time later on the main thread.

 You can call multiple `loadObjects(ofClass:)` for different classes.

You don’t usually do anything else in `dropInteraction(performDrop:).`



## Table and Collection Views

These are UIScrollView subclasses used to display unbounded amounts of information. 

- Table View presents the information in a long (possibly sectioned) list.

- Collection View presents the information in a 2D format (usually “ﬂowing” like text ﬂows). They are very similar in their API, so we will learn about them at the same time.

### UITableView

- The list can be very simple or dividen into sections
- It can show simple ancillary information (Subtitle Style/Left Detail Style/Right Detail Style)
- Basic Style / Custom Style
- The rows can also be Grouped …

  - (but usually only when the information in the table is ﬁxed)



### UICollectionView

Is conﬁgurable to show information in any 2D arrangement. 

But by default it “ﬂows” the items it shows like text ﬂows. 

There is only “custom” layout of information.

Like Table View, can also be divided into sections …



### Using Table and Collection View

#### Get one

As usual, we drag them into our storyboard

- Table View / Collection View

There are also “prepackaged” MVCs whose entire view is the table or collection view …

- Table View Controller / Collection View Controller



#### Data 

The most important thing to understand is where they get their data. 

Remember that, per MVC, “views are not allowed to own their data”.

So we can’t just somehow set the data in some var.

Instead, we set a var called `dataSource`.

The type of the dataSource var is a protocol with methods that supply the data.

`dataSource` is exactly like a delegate in how it works.

Table View and Collection View also have a delegate.

Their delegate controls how they look, not what data they display (that’s the dataSource).



#### Setting the dataSource and delegate

In UITableView …

```swift
var dataSource: UITableViewDataSource 
var delegate: UITableViewDelegate 
```

In UICollectionView …

```swift
var dataSource: UICollectionViewDataSource 
var delegate: UICollectionViewDelegate
```

These are automatically set for you if you use the prepackaged MVCs.

If you drag out a UITableView or UICollectionView, you must set these vars yourself. 

99.99% of the time, these vars will want to be set to the Controller of the MVC.



#### The UITableView/CollectionViewDataSource protocol

The “data retrieving” protocol has many methods.

But these 3 are the core (UITableView abbreviated to UITV and UICollectionView to UICV)

```swift
func numberOfSections(in tableView: UITV) -> Int 
func tableView(_ tv: UITV, numberOfRowsInSection section: Int) -> Int 
func tableView(_ tv: UITV, cellForRowAt indexPath: IndexPath) -> UITableViewCell UICollectionView

func numberOfSections(in collectionView: UICV) -> Int 
func collectionView(_ cv: UICV, numberOfItemsInSection section: Int) -> Int 
func collectionView(_ cv: UICV, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
```



IndexPath speciﬁes which row (in TV) or item (in CV) we’re talking about.

In both, you get the section the row or item is in from indexPath.section.

In TV, you get which row from `indexPath.row`; in CV you get which item from `indexPath.item`. CV might seem like rows and columns, but it’s not, it’s just items “ﬂowing” like text.



### Loading up Cells

#### Putting data into the UI



```swift
func tableView(_ tv: UITV, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
	let cell = tv.dequeueReusableCell(withIdentifier: “MyCellId”, for: indexPath)
  
}
```



This gets the `UITableViewCell` we are going to load up with our Model data and return.

The `UITableView` will then use that `UITableViewCell` to draw the row at the given indexPath.



#### Cell Reuse

A UITableView might have 1000s of rows. 

If it had to create a UIView for all of them, it would be very inefﬁcient.

So it reuses the cells.

When a UITableViewCell scrolls off the screen, it gets put in a pool to be reused.

The `dequeueReusableCell(withIdentifier:)` method grabs one out of that reuse pool. 

But what if the reuse pool is empty (like when the table ﬁrst appears)?



#### Cell Creation

How do new (non-reused) cells get created?
 They get created by copying a prototype cell you conﬁgure in your storyboard.

Each prototype has an identiﬁer you set in the Inspector.



#### Implementing cellForRowAt

It is reusing a UITableViewCell with the given identiﬁer if possible.

Otherwise it is making a copy of the prototype in the storyboard.

The fact that cells are reused has serious implications for multithreading!

By the time something returns from another thread, a cell might have been reused.



```swift
func tableView(_ tv: UITV, cellForRowAt indexPath: IndexPath) -> UITableViewCell { 
 let prototype = decision ? “FoodCell” : “CustomFoodCell” 
  let cell = tv.dequeueReusableCell(withIdentifier: prototype , for: indexPath)
  cell.textLabel?.text = food(at: indexPath) cell.detailTextLabel?.text = emoji(at: indexPath)

}
```



So what API can we use to conﬁgure this cell that we just reused/created?

Well, for UITableView only, the default UITableViewCell has a few basic things …

textLabel, detailTextLabel and imageView

But for UICollectionView and for custom UITableViewCells, WE have to provide the API



#### Custom UITableViewCell subclass

When we put custom UI into a UITableViewCell prototype, we probably need outlets to it.

```swift
class MyTVC: UITableViewCell{
@IBOutlet var name: UILabel 
@IBOutlet var emoji: UILabel 
@IBOutlet var category: UILabel
@IBOutlet var details: UILabel
}
```

Can we hook them up directly to our Controller?

No, we can’t, because there might be multiple rows with that type of cell. They can’t all be hooked up to the same single outlet!

Instead, we have to subclass UITableViewCell and put the outlets in there.



Let’s focus on how we implement that last method.


We’ll look at it in the context of UITableView, but it’s the same for UICollectionView.

```swift
func tableView(_ tv: UITV, cellForRowAt indexPath: IndexPath) -> UITableViewCell { 
	let prototype = decision ? “FoodCell” : “CustomFoodCell” 
  let cell = tv.dequeueReusableCell(withIdentifier: prototype, for: indexPath)
	if let myTVCell = cell as? MyTVC {
		myTVC.name = food(at: indexPath)
    myTVC.emoji = emoji(at: indexPath)
  }
}
```




In order to get at those outlets, we need to cast our UITableViewCell to our subclass.

Then we can access its outlets (or any other API it wants to make public).

In Collection View, we always have to do this (there are only “Custom” cells).

In Table View, we do it when the simple Basic, Subtitle, etc. styles aren’t enough.



### Static Table View

#### Using Table View purely for UI layout

Sometimes we just use a table view to lay out UI elements.

A fantastic example of this is the iOS Settings app.

In this case, you do not need to do any of the `UITableViewDataSource` stuff.

And you can connect outlets directly to your Controller (because there’s only one of each cell). 

To do this, just set your UITableView to have Static Cells instead of Dynamic Prototypes. Usually static table views are Style Grouped.

Then pick the section in the Document Outline you want to add cells to and add them.



### Table View Segues

#### Detail Disclosure Accessory

We can segue from the row and/or from the Detail Disclosure Accssory.

Just ctrl-drag as usual!

#### Preparing to segue from a row in a table view


The sender argument to prepareForSegue is the UITableViewCell of that row …

```swift
func prepare(for segue: UIStoryboardSegue, sender: Any?) { 
  if let identifier = segue.identifier { 
    switch identifier { 
      case “XyzSegue”: // handle XyzSegue here 
      case “AbcSegue”:
      	if let cell = sender as? MyTableViewCell,
        	let indexPath = tableView.indexPath(for: cell),
      		let seguedToMVC = segue.destination as? MyVC{
            seguedToMVC.publicAPI = data[indexPath.section][indexPath.row]
        }
      default: break 
    }
  }
}
```

You can see now why sender is Any
 Sometimes it’s a UIButton, sometimes it’s a UITableViewCell



#### Seguing from Collection View Cells

Probably best done from this UICollectionViewDelegate method …

```swift
func collectionView(collectionView: UICV, didSelectItemAtIndexPath indexPath: IndexPath)
```

 Use `performSegue(withIdentifier:)` from there.

This strategy could also be used for UITableView.



### Table and Collection View

#### Model changes

`func reloadData()` Causes it to call numberOfSectionsInTableView and numberOfRows/ItemsInSection all over again and then cellForRow/ItemAt on each visible row or item

Relatively heavyweight, but if your entire data structure changes, that’s what you need If only part of your Model changes, there are lighter-weight reloaders, for example ...

```swift
func reloadRows(at indexPaths: [IndexPath], with animation: UITableViewRowAnimation)
```

… among others and of course similar methods for Collection View.



#### Controlling the height of rows in a Table View

Row height can be ﬁxed (UITableView’s `var rowHeight: CGFloat`) 

Or it can be determined using autolayout (`rowHeight = UITableViewAutomaticDimension`)

If you do automatic, help the table view out by setting `estimatedRowHeight` to something The UITableView’s delegate can also control row heights …

```swift
func tableView(UITableView, {estimated}heightForRowAt indexPath: IndexPath) -> CGFloat 
```

Beware: the non-estimated version of this could get called A LOT if you have a big table



#### Controlling the size of cells in a Collection View

Cell size can be ﬁxed in the storyboard.

You can also drive it from autolayout similar to table view.

 Or you can return the size from this delegate method …

```swift
func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath ) -> CGSize
```



#### Setting a header for each section

If you have a multiple-section table view, you can set a header (or footer) for each. 

There are methods to set this to be a custom UIView.

But usually we just supply a String for the header using this method …

```swift
func tableView(_ tv: UITV, titleForHeaderInSection section: Int) -> String?
```



Headers and footers are a bit more difﬁcult in Collection View

You can’t just specify them as Strings.

First you have to “turn them on” in the storyboard.

They are reusable (like cells are), so you have to make a `UICollectionReusableView` subclass. You put your UILabel or whatever for your header, then hook up an outlet.

Then you implement this dataSource method to dequeue and provide a header.

```swift
func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath ) -> UICollectionReusableView
```

 Use `dequeueReusableSupplementaryView(ofKind:withReuseIdentifier:for:)` in there. kind will be UICollectionElementKindSectionHeader or Footer.



There are dozens of other methods in these classes

- Controlling the look (separator style and color, default row height, etc.).
- Getting cell information (cell for index path, index path for cell, visible cells, etc.).
- Scrolling to a row (UITableView/UICollectionView are subclasses of UIScrollView).
- Selection management (allows multiple selection, getting the selected row, etc.). 
- Moving, inserting and deleting rows, etc.

As always, part of learning the material in this course is studying the documentation





## UITextField



**Like UILabel, but editable**

- Typing things in on an iPhone is secondary UI (keyboard is tiny).
- More of a mainstream UI element on iPad.
- Don’t be fooled by your UI in the simulator (because you can use physical keyboard!).
- You can set attributed text, text color, alignment, font, etc., just like a UILabel.



**Keyboard appears when UITextField becomes “ﬁrst responder”**

- It will do this automatically when the user taps on it.
- Or you can make it the ﬁrst responder by sending it the become `FirstResponder` message. 
- To make the keyboard go away, send resign `FirstResponder` to the UITextField.



**Delegate can get involved with Return key, etc.**

- ```swift
  func textFieldShouldReturn(sender: UITextField) -> Bool // when “Return” is pressed 
  ```

  Oftentimes, you will `sender.resignFirstResponder()` in this method.

  Returns whether to do normal processing when Return key is pressed (e.g. target/action).



**Finding out when editing has ended**

Another delegate method ...

```swift
func textFieldDidEndEditing(sender: UITextField)
```

Sent when the text ﬁeld resigns being ﬁrst responder.

**UITextField is a UIControl**

So you can also set up target/action to notify you when things change.

Just like with a button, there are different `UIControlEvents` which can kick off an action. Right-click on a UITextField in a storyboard to see the options available.



### Keyboard

**Controlling the appearance of the keyboard**

Remember, whether keyboard is showing is a function of whether its ﬁrst responder.

You can also control what kind of keyboard comes up.

Set the properties deﬁned in the `UITextInputTraits` protocol (UITextField implements).

```swift
var autocapitalizationType: UITextAutocapitalizationType // words, sentences, etc.
var autocorrectionType: UITextAutocorrectionType // .yes or .no 
var returnKeyType: UIReturnKeyType // Go, Search, Google, Done, etc.
var isSecureTextEntry: Bool  // for passwords, for example
var keyboardType: UIKeyboardType // ASCII, URL, PhonePad, etc.
```

**Other Keyboard functionality**

Keyboards can have accessory views that appear above the keyboard (custom toolbar, etc.). 

```swift
var inputAccessoryView: UIView // UITextField method
```

 

**The keyboard comes up over other views**

So you may need to adjust your view positioning (especially to keep the text ﬁeld itself visible). You do this by reacting to the `UIKeyboard{Will,Did}{Show,Hide}` Notifications sent by `UIWindow`. We have not talked about what a Notification is yet, but it’s pretty simple.

You register a method to get called when a named “event” occurs like this …

```swift
NotificationCenter.default.addObserver(self,
                                    selector: #selector(theKeyboardAppeared(_:)), 
                                       name: Notification.Name.UIKeyboardDidShow, 
                                       object: view.window)
```

 The event here is `Notification.Name.UIKeyboardDidShow`.

The object is the one who is causing the even to happen (our MVC’s view’s window).

`func theKeyboardAppeared(_ notification: Notification)` will get called when it happens. The `notification.userInfo` is a Dictionary that will have details about the appearance.

Almost always the reaction to the keyboard appearing over your text ﬁeld is to scroll it visible. If the ﬁrst responder is not in a scroll view, then position it so the keyboard never covers it. UITableViewController listens for this & scrolls table automatically if a row has a UITextField.



**Other UITextField properties**

```swift
var clearsOnBeginEditing: Bool 
var adjustsFontSizeToFitWidth: Bool 
var minimumFontSize: CGFloat // always set this if you set adjustsFontSizeToFitWidth 
var placeholder: String? // drawn in gray when text ﬁeld is empty 
var background/disabledBackground: UIImage?
var defaultTextAttributes: [String:Any] // applies to entire text
```

**Other UITextField functionality**

UITextFields have a “left” and “right” overlays.

You can control in detail the layout of the text ﬁeld (border, left/right view, clear button).



## Persistence



### UserDefaults

#### **A very lightweight and limited database**

UserDefaults is essentially a very tiny database that persists between launchings of your app. Great for things like “settings” and such. Do not use it for anything big!

#### What can you store there?

You are limited in what you can store in UserDefaults: it only stores `Property List` data.

A Property List is any combo of `Array, Dictionary, String, Date, Data` or a number (Int, etc.). This is an old Objective-C API with no type that represents all those, so this API uses Any.

If this were a new, Swift-style API, it would almost certainly not use Any.

(Likely there would be a protocol or some such that those types would implement.)

#### What does the API look like?

It’s “core” functionality is simple. It just stores and retrieves Property Lists by key … 

```swift
func set(Any?, forKey: String) // the Any has to be a Property List (or crash)
func object(forKey: String) -> Any? // the Any is guaranteed to be a Property List
```



#### Reading and Writing

You don’t usually create one of these databases with UserDefaults(). Instead, you use the static (type) var called standard …

```swift
let defaults = UserDefaults.standard
```

Setting a value in the database is easy since the set method takes an Any?. 

```swift
defaults.set(3.1415, forKey: “pi”) // 3.1415 is a Double which is a Property List type 
defaults.set([1,2,3,4,5], forKey: “My Array”) // Array and Int are both Property Lists
defaults.set(nil, forKey: “Some Setting”) // removes any data at that key
```

You can pass anything as the ﬁrst argument as long as it’s a combo of Property List types.

`UserDefaults` also has convenience API for getting many of the Property List types. 

```swift
func double(forKey: String) -> Double
func array(forKey: String) -> [Any]? // returns nil if non-Array at that key
func dictionary(forKey: String) -> [String:Any]? // note that keys in return are Strings 
```

The Any in the returned values will, of course, be a Property List type.



#### Saving the database

Your changes will be occasionally autosaved.

But you can force them to be saved at any time with synchronize …

```swift
if !defaults.synchronize() { // failed! but not clear what you can do about it }
```

 (it’s not “free” to synchronize, but it’s not that expensive either)



### Archiving

There are two mechanisms for making ANY object persistent

#### `NSCoder` mechanism

Requires all objects in an object graph to implement these two methods …

```swift
func encode(with aCoder: NSCoder) 
init(coder: NSCoder)
```

Essentially you store all of your object’s data in the coder’s dictionary.

Then you have to be able to initialize your object from a coder’s dictionary. 

References within the object graph are handled automatically.

You can then take an object graph and turn it into a `Data` (via `NSKeyedArchiver`). And then turn a Data back into an object graph (via `NSKeyedUnarchiver`).

Once you have a Data, you can easily write it to a ﬁle or otherwise pass it around.



#### `Codable` mechanism

Once your object graph is all Codable, you can convert it to either JSON or a Property List.

```swift
let object: MyType = …
let jsonData: Data? = try? JSONEncoder().encode(object) 
```

Note that this encode throws. You can catch and ﬁnd errors easily (next slide).

By the way, you can make a String object out of this Data like this …

```swift
let jsonString = String(data: jsonData!, encoding: .utf8) // JSON is always utf8
```

To get your object graph back from the JSON …

```swift
if let myObject: MyType = try? JSONDecoder().decode(MyType.self, from: jsonData!) { }
```

JSON is not “strongly typed.” So things like Date or URL are just strings. Swift handles all this automatically and is even conﬁgurable, for example …

```swift
let decoder = JSONDecoder() 
decoder.dateDecodingStrategy = .iso8601 // or .secondsSince1970, etc.
```

Here’s what it might look like to catch errors during a decoding.

The thing decode throws is an enum of type DecodingError.

Note how we can get the associated values of the enum similar to how we do with switch.

```swift
do {
  let object = try JSONDecoder().decode(MyType.self, from: jsonData!)
  // success, do something with object 
} catch DecodingError.keyNotFound(let key, let context) { 
  print(“couldn’t find key \(key) in JSON: \(context.debugDescription)”) 
} catch DecodingError.valueNotFound(let type, let context) {

} catch DecodingError.typeMismatch(let type, let context) {

} catch DecodingError.
```



So how do you make your data types `Codable`? Usually you just say so …

```swift
struct MyType : Codable { 
  var someDate: Date 
  var someString: String 
  var other: SomeOtherType // SomeOtherType has to be Codable too!
}
```

If your vars are all also Codable (standard types all are), then you’re done!

The JSON for this might look like ..

```json
{
  “someDate” : “2017-11-05T16:30:00Z”, 
  “someString” : “Hello”,
  “other” : <whatever SomeOtherType looks like in JSON>}
```

Sometimes JSON keys might have different names than your var names (or not be included). For example, someDate might be some_date.

You can conﬁgure this by adding a private enum to your type called CodingKeys like this …

```swift
struct MyType : Codable {
  var someDate: Date 
  var someString: String 
  var other: SomeOtherType// SomeOtherType has to be Codable too!

  private enum CodingKeys : String, CodingKey {
    case someDate = “some_date” // note that the someString var will now not be included in the JSON 
    case other // this key is also called “other” in JSON
  }
}
```

You can participate directly in the decoding by implementing the decoding initializer

```swift
struct MyType : Codable {
  var someDate: Date 
  var someString: String 
  var other: SomeOtherType // SomeOtherType has to be Codable too!
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    someDate = try container.decode(Date.self, forKey: .someDate) 
    //process rest of vars, perhaps validating input, etc. …
  }
}
```

Note that this init throws, so we don’t need do { } inside it (it will just rethrow).

Also note the “keys” are from the CodingKeys enum on the previous slide (e.g. .someDate).

```swift
class MyType : Codable {
  var someDate: Date 
  var someString: String 
  var other: SomeOtherType // SomeOtherType has to be Codable too!
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    someDate = try container.decode(Date.self, forKey: .someDate) 
    // process rest of vars, perhaps validating input, etc.
    let superDecoder = try container.superDecoder() 
    try super.init(from: superDecoder) // only if class
  }
}
```



### File System

**Your application sees iOS ﬁle system like a normal Unix ﬁlesystem**

It starts at /.

There are ﬁle protections, of course, like normal Unix, so you can’t see everything. 

In fact, you can only read and write in your application’s “sandbox”.

**Why sandbox?**

- Security (so no one else can damage your application) 
- Privacy (so no other applications can view your application’s data) 
- Cleanup (when you delete an application, everything it has ever written goes with it)

**So what’s in this “sandbox”?**

- Application directory — Your executable, .storyboards, .jpgs, etc.; not writeable. 
- Documents directory — Permanent storage created by and always visible to the user. 
- Application Support directory — Permanent storage not seen directly by the user. 
- Caches directory — Store temporary ﬁles here (this is not backed up by iTunes). Other directories (see documentation) …

#### Getting a path to these special sandbox directories

`FileManager` (along with URL) is what you use to ﬁnd out about what’s in the ﬁle system. You can, for example, ﬁnd the URL to these special system directories like this ...

```swift
let url: URL = FileManager.default.url(
  for directory: FileManager.SearchPathDirectory.documentDirectory,// for example
  in domainMask: .userDomainMask // always .userDomainMask on iOS 
  appropriateFor: nil, // only meaningful for “replace” ﬁle operations 
  create: true // whether to create the system directory if it doesn’t already exist
)
```

**Examples of SearchPathDirectory values**

`.documentDirectory, .applicationSupportDirectory, .cachesDirectory`, etc.



#### URL

**Building on top of these system paths**

URL methods:

```swift
func appendingPathComponent(String) -> URL 
func appendingPathExtension(String) -> URL
```

// e.g. “jpg”

**Finding out about what’s at the other end of a URL**

```swift
var isFileURL: Bool // is this a ﬁle URL (whether ﬁle exists or not) or something else?
func resourceValues(for keys: [URLResourceKey]) throws -> [URLResourceKey:Any]?
```

Example keys: `.creationDateKey, .isDirectoryKey, .fileSizeKey`



#### Data 

Reading binary data from a URL …

```swift
init(contentsOf: URL, options: Data.ReadingOptions) throws
```

Writing binary data to a URL …

```swift
func write(to url: URL, options: Data.WritingOptions) throws -> Bool 
```

The options can be things like .atomic (write to tmp ﬁle, then swap) or .withoutOverwriting.

Notice that this function throws.



#### FileManager

Provides utility operations.

e.g., `fileExists(atPath: String) -> Bool`

Can create and enumerate directories; move, copy, delete ﬁles; etc.

Thread safe (as long as a given instance is only ever used in one thread).

Also has a delegate with lots of “should” methods (to do an operation or proceed after an error). And plenty more. Check out the documentation.

### Core Data

#### Database

Sometimes you need to store large amounts of data locally in a database. And you need to search through it in an efﬁcient, sophisticated manner.

#### Enter Core Data

Object-oriented database.

Very, very powerful framework in iOS (unfortunately no time to cover it this quarter). Check out Winter of 2016-17’s iTunesU for a full pair of lectures on it!

#### It’s a way of creating an object graph backed by a database

Usually backed by SQL (but also can do XML or just in memory).

#### How does it work?

Create a visual mapping (using Xcode tool) between database and objects. Create and query for objects using object-oriented API.

Access the “columns in the database table” using vars on those objects.

**So how do you access all of this stuff in your code?**

- Core Data is access via an `NSManagedObjectContext`.

- It is the hub around which all Core Data activity turns.

- The code that the Use Core Data button adds creates one for you in your AppDelegate.

#### Create/update objects in the database

```swift
let context: NSManagedObjectContext = ... 
if let tweet = Tweet(context: context) {
  tweet.text = “140 characters of pure joy” 
  tweet.created = Date() 
  let joe = TwitterUser(context: tweet.managedObjectContext) 
  tweet.tweeter = joe 
  tweet.tweeter.name = “Joe Schmo”
}
```



Deleting objects

```swift
context.delete(tweet)
```



#### Saving changes

You must explicitly save any changes to a context, but note that this throws.

```swift
do {
  try context.save() 
} 
catch {
// deal with error 
} 
```

However, we usually use a UIManagedDocument which autosaves for us. More on UIDocument-based code in a few slides …



#### Querying

Searching for objects in the database

Let’s say we want to query for all TwitterUsers ...

```swift
let request: NSFetchRequest<TwitterUser> = TwitterUser.fetchRequest()
//... who have created a tweet in the last 24 hours ...
let yesterday = Date(timeIntervalSinceNow:-24*60*60) as NSDate request.predicate = NSPredicate(format: “any tweets.created > %@”, yesterday) 
//... sorted by the TwitterUser’s name ...
request.sortDescriptors = [NSSortDescriptor(key: “name”, ascending: true)]
let context: NSManagedObjectContext = ...
let recentTweeters = try? context.fetch(request) 
//Returns an empty Array (not nil) if it succeeds and there are no matches in the database.
//Returns an Array of NSManagedObjects (or subclasses thereof) if there were any matches. And obviously the try fails if the fetch fails.
```



### Cloud Kit

- A database in the cloud. Simple to use, but with very basic “database” operations.

- Since it’s on the network, accessing the database could be slow or even impossible.

- This requires some thoughtful programming.

- No time for this one either this quarter, but check Spring of 2015-16’s iTunesU for full demo.

 **Important Components**

- Record Type - like a class or struct 
- Fields - like vars in a class or struct 
- Record - an “instance” of a Record Type 
- Reference - a “pointer” to another Record 
- Database - a place where Records are stored 
- Zone - a sub-area of a Database 
- Container - collection of Databases 
- Query - an Database search Subscription - a “standing Query” which sends push notiﬁcations when changes occur

**You must enable iCloud in your Project Settings**


Under Capabilities tab, turn on iCloud (On/Off switch). Then, choose CloudKit from the Services.
Then, choose CloudKit from the Services.
You’ll also see a CloudKit Dashboard button which will take you to the Cloud Kit Dashboard.

#### Cloud Kit Dashboard
A web-based UI to look at everything you are storing.

Shows you all your Record Types and Fields as well as the data in Records.

You can add new Record Types and Fields and also turn on/off indexes for various Fields.

#### Dynamic Schema Creation

But you don’t have to create your schema in the Dashboard.

You can create it “organically” by simply creating and storing things in the database.

When you store a record with a new, never-before-seen Record Type, it will create that type. Or if you add a Field to a Record, it will automatically create a Field for it in the database. This only works during Development, not once you deploy to your users.

#### Create a record

```swift
let db = CKContainer.default.publicCloudDatabase 
let tweet = CKRecord(“Tweet”) 
tweet[“text”] = “140 characters of pure joy” 
let tweeter = CKRecord(“TwitterUser”) 
tweet[“tweeter”] = CKReference(record: tweeter, action: .deleteSelf) 
db.save(tweet) { (savedRecord: CKRecord?, error: NSError?) -> Void in
                if error == nil {
                  // hooray!
                } else if error?.errorCode == CKErrorCode.NotAuthenticated.rawValue { 
                  // tell user he or she has to be logged in to iCloud for this to work!
                } else {
                  // report other errors (there are 29 different CKErrorCodes!)
                }
}
```



#### Query for records in a database



```swift
let db = CKContainer.default.publicCloudDatabase 
let predicate = NSPredicate(format: “text contains %@“, searchString) let query = CKQuery(recordType: “Tweet”, predicate: predicate) 
db.perform(query) { (records: [CKRecord]?, error: NSError?) in
                   if error == nil { 
                     // records will be an array of matching CKRecords 
                   } else if error?.errorCode == CKErrorCode.NotAuthenticated.rawValue {
                       // tell user he or she has to be logged in to iCloud for this to work! 
                   } else { 
                     // report other errors (there are 29 different CKErrorCodes!)
                   }
}
```



**Standing Queries** (aka Subscriptions)

One of the coolest features of Cloud Kit is its ability to send push notiﬁcations on changes.

 All you do is register an `NSPredicate` and whenever the database changes to match it, boom! 

Unfortunately, we don’t have time to discuss push notiﬁcations this quarter.

If you’re interested, check out the UserNotifications framework.

### UIDocument

#### About UIDocument

**When to use UIDocument**

- If your application stores user information in a way the user perceives as a “document”.
-  If you just want iOS to manage the primary storage of user information.

**What does UIDocument do?**

- Manages all interaction with storage devices (not just ﬁlesystem, but also iCloud, Box, etc.). 
- Provides asynchronous opening, writing, reading and closing of ﬁles.
- Autosaves your document data.
- Makes integration with iOS 11’s new Files application essentially free.

**What do you need to do to make UIDocument work?**

- Subclass UIDocument to add vars to hold the Model of your MVC that shows your “document”.
-  Then implement one method that writes the Model to a Data and one that reads it from a Data. That’s it.
- Now you can use UIDocument’s opening, saving and closing methods as needed.
- You can also use its “document has changed” method (or implement undo) to get autosaving.

#### Using UIDocument

**Subclassing UIDocument**

For simple documents, there’s nothing to do here except add your Model as a var …

```swift
class EmojiArtDocument: UIDocument { 
  var emojiArt: EmojiArt?
}
```

There are, of course, methods you can override, but usually you don’t need to.

**Creating a UIDocument**

Figure out where you want your document to be stored in the ﬁlesystem …

```swift
var url = FileManager.urls(for: .documentDirectory, in: .userDomainMask).first! 
url = url.appendingPathComponent(“Untitled.foo”)
//Instantiate your subclass by passing that url to UIDocument’s only initializer …
let myDocument = EmojiArtDocument(fileURL: url) 
//… then (eventually) set your Model var(s) on your newly created UIDocument subclass …
myDocument.emojiArt = …
```



**Turning a Data into a Model**

Override this method in your UIDocument subclass to a Data into an instance of your Model. 

```swift
override func load(fromContents contents: Any, ofType typeName: String?) throws { 
  emojiArt = contents converted into an EmojiArt
}
```

Again, you can throw here if you can’t create a document from the passed contents.



**Ready to go!**

Now you can open your document (i.e. get your Model) …

```swift
myDocument.open { success in
   if success { 
     // your Model var(s) (e.g. emojiArt) is/are ready to use
   } else {
     // there was a problem, check documentState
   }
}
```

This method is asynchronous!

The closure is called on the same thread you call open from (the main thread usually). We’ll see more about documentState in a couple of slides.



**Saving your document**

You can let your document know that the Model has changed with this method … `myDocument.updateChangeCount(.done) …` or you can use UIDocument’s undoManager (no time to cover that, unfortunately!) UIDocument will save your changes automatically at the next best opportunity.

Or you can force a save using this method …

```swift
let url = myDocument.fileURL // or something else if you want “save as”
myDocument.save(to url: URL, for: UIDocumentSaveOperation) { success in 
    if success {
      // your Model has successfully been saved } else { // there was a problem, check documentState
    } else {
    
    }
}
```

 `UIDocumentSaveOperation` is either `.forCreating` or `.forOverwriting.`



Closing your document

When you are ﬁnished using a document for now, close it …

```swift
myDocument.close { success in 
   if success {
     // your Model has successfully been saved and closed // use the open method again if you want to use it
   } else {
     // there was a problem, check documentState
   }
}
```



#### Document State

As all this goes on, your document transitions to various states. 

You can ﬁnd out what state it is in using this var …

```swift
var documentState: UIDocumentState
```

Possible values

- .normal — document is open and ready for use!

- .closed — document is closed and must be opened to be used 
- .savingError — document couldn’t be saved (override handleError if you want to know why) 
- .editingDisabled — the document cannot currently be edited (so don’t let your UI do that) 
- .progressAvailable — how far a large document is in getting loaded (check progress var) 
- .inConflict — someone edited this document somewhere else (iCloud) 

To resolve conﬂicts, you access the conﬂicting versions with …

```swift
NSFileVersion.unresolvedConflictVersionsOfItem(at url: URL) -> [NSFileVersion]?
```

For the best UI, you could give your user the choice of which version to use.

Or, if your document’s contents are “mergeable”, you could even do that.

documentState can be “observed” using the `UIDocumentStateChanged` notiﬁcation (more later).



#### Thumbnail

You can specify a thumbnail image for your UIDocument.

It can make it much easier for users to ﬁnd the document they want in Files, for example. Essentially you are going to override the UIDocument method which sets ﬁle attributes. The attributes are returned as a dictionary.

One of the keys is for the thumbnail (it’s a convoluted key) …

```swift
override func fileAttributesToWrite(to url: URL, for operation: UIDocumentSaveOperation) throws -> [AnyHashable : Any] { 
  var attributes = try super.fileAttributesToWrite(to: url, for: saveOperation) 
  if let thumbnail: UIImage = … { 
    attributes[URLResourceKey.thumbnailDictionaryKey] = [URLThumbnailDictionaryItem.NSThumbnail1024x1024SizeKey:thumbnail] 
  } 
  return attributes
}
```

It does not have to be 1024x1024 (it seems to have a minimum size, not sure what).



Other

```swift
var localizedName: String 
var hasUnsavedChanges: Bool 
var fileModificationDate: Date? 
var userActivity: NSUserActivity?// iCloud documents only
```



### UIDocumentBrowserViewController

#### Managing user documents

You probably want users to be able to easily manage their documents in a document-based app. Choosing ﬁles to open, renaming ﬁles, moving them, accessing iCloud drive, etc.

The `UIDocumentBrowserViewController` (UIDBVC) does all of this for you. Using UIDocument to store your document makes leveraging this UIDBVC easy.

#### Using the UIDocumentBrowserViewController

- It has to be the root view controller in your storyboard (i.e. the arrow points to it).
- Your document-editing MVC will then be presented modally on top of (i.e. takes over the screen).

**What document types can you open?**

- To use the UIDBVC, you have to register which types your application uses. 
- You do this in the Project Settings in the Info tab with your Target selected.
-  In the Document Types area, add the types you support.
- The Types ﬁeld is the UTI of the type you want to support (e.g. public.json, public.image). 
- The CFBundleTypeRole and LSHandlerRank say how you handle this kind of document. Are you the primary editor and owner of this type or is it just something you can open?

**Declaring your own document type**

- You might have a custom document type that your application edits 
- You can add this under Exported UTIs in the same place in Project Settings

**Opening documents at the request of other apps (including Files)**

A user can now click on a document of your type in Files (or another app can ask to open one) When this happens, your AppDelegate gets a message sent to it …

```swift
func application(UIApplication, open: URL, options: [UIApplicationOpenURLOptionsKey:Any]) -> Bool 
```

We haven’t discussed the AppDelegate yet, but it’s just a swift ﬁle with some methods in it. Inside here, you can ask your UIDocumentBrowserViewController to show this document …

```swift
let uidbvc = window?.rootViewController as? UIDBVC // since it’s “arrowed” in storyboard 
uidbvc.revealDocument(at: URL, importIfNeeded: true) { (url, error) in
   	if error != nil { 
      // present a UIDocument at url modally (more on how to do this in a moment)
    } else {
      // handle the error
    }
}
```



#### Xcode Template

Setting up a UIDocumentBrowserViewController-based application requires a bit of setup Mostly an entry in your Info.plist, a little bit of AppDelegate code and some stubbed-out code We don’t usually use an Xcode template in this course, but in this case it make sense.

**What is in the template?**

- A stub for Document Types in Project Settings (supports public.image ﬁle types)
-  An Info.plist entry Supports Document Browser = YES
- A bit of code in AppDelegate to allow other apps (like Files) to get your app to open a ﬁle 
- A stubbed out UIDocument subclass (with empty contents and load(fromContents) methods) 
- A stubbed out MVC to display a document (just calls UIDocument’s open and close methods) 
- A subclass of `UIDocumentBrowserViewController` (with almost everything implemented)

**What you need to do to personalize this template …**

1. Use your UIDocument subclass instead of the stubbed out one
2. Use your document-viewing MVC code (already using UIDocument) instead of stub
3. Add code to UIDBVC subclass to …
   1. conﬁgure the UIDBVC (allow multiple selection? creation of new documents? etc.)
   2. specify the url of a template document to copy to create new documents
   3.  present your document-viewing MVC modally given the url of a document

4. Update the Document Types in Project Settings to be your types (instead of public.image)

**Steps 1 and 2**

As long as you properly implement UIDocument in your MVC, this is no extra work

**Step 3a: Conﬁguring the UIDBVC**

This happens in its viewDidLoad …

```swift
override func viewDidLoad() {
  super.viewDidLoad() 
  delegate = self // the guts of making UIDBVC work are in its delegate methods
  allowsDocumentCreation = true 
  allowsPickingMultipleItems = true 
  browserUserInterfaceStyle = .dark 
  view.tintColor = .white
}
```

Set these as you wish.

**Steps 3b: Specifying the “new document” template URL**

This happens in this UIDBVC delegate method …

```swift
func documentBrowser(_ controller: UIDBVC, didRequestDocumentCreationWithHandler handler: @escaping (URL?, UIDBVC.ImportMode) -> Void ) {
  let url: URL? = … // where your blank, template document can be found
  importHandler(url, .copy or .move)
}
```

Usually you would specify `.copy`, but you could create a new template each time and .move. Likely you would have some code here that creates that blank template (or ship with your app).



**Steps 3c: Presenting your document MVC modally**

The Xcode template stubs out a function called `presentDocument(at: URL)` to do this …

```swift
func presentDocument(at url: URL) {
  let story = UIStoryboard(name: “Main”, bundle: nil) 
  if let docvc = story.instantiateViewController(withIdentifier: “DocVC”) as? DocVC {
    docvc.document = MyDocument(fileURL: url)
    present(docvc, animated: true) 
  }
}
```

You can call this function anything you want.

But the point is that it takes a URL to one of your documents and you show it.

The Xcode template then calls this from the appropriate delegate methods in UIDBVC. That’s all you have to do to get UIDBVC working.



**Step 4: Specifying your types**

Unless your app opens public.image ﬁles, you’ll need to change that in Project Settings For your homework, for example, you’ll probably need to invent a new type for Image Gallery



#### Aside: Presenting an MVC without segueing

We haven’t covered how to present MVCs in any other way except by segueing.

So let’s cover it now!

It’s very easy. You present a new MVC from an existing MVC using `present(animated:) …`

 

```swift
let newVC: UIViewController = …
existingVC.present(newVC, animated: true) {
  // completion handler called when the presentation completes animating 
  // (can be left out entirely if you don’t need to do anything upon completion)
}

//The real trick is “where do I get newMVC from?” 
//Answer: you get it from your storyboard using its identiﬁer which you set in Identity Inspector 
let storyboard = UIStoryboard(name: “Main”, bundle: nil) // Main.storyboard
if let newVC = storyboard.instantiateViewController(withIdentifier: “foo”) as? MyDocVC { 
  // “prepare” newMVC and then present(animated:) it 
}
```



## Alerts & Action Sheets



### Intro

Two kinds of “pop up and ask the user something” mechanisms

- Alerts 
- Action Sheets



#### Alerts

- Pop up in the middle of the screen.

- Usually ask questions with only two answers (e.g. OK/Cancel, Yes/No, etc.).
- Can be disruptive to your user-interface, so use carefully.
- Often used for “asynchronous” problems (“connection reset” or “network fetch failed”). 
- Can have a text ﬁeld to get a quick answer (e.g. password)



#### Action Sheets

- Usually slides in from the bottom of the screen on iPhone/iPod Touch, and in a popover on iPad. 
- Can be displayed from bar button item or from any rectangular area in a view.
- Generally asks questions that have more than two answers.
- Think of action sheets as presenting “branching decisions” to the user (i.e. what next?).



### Using Alerts and Action Sheets



#### Example: Action Sheet



```swift
var alert = UIAlertController(
  title: “Redeploy Cassini”, 
  message: “Issue commands to Cassini’s guidance system.”, 
  preferredStyle: .actionSheet 
)

alert.addAction(UIAlertAction( 
  title: “Orbit Saturn”, 
  style: UIAlertActionStyle.default) 
  { (action: UIAlertAction) -> Void in 
   // go into orbit around saturn 
  } 
)

alert.addAction(UIAlertAction( 
  title: “Explore Titan”, 
  style: .default) 
  { (action: UIAlertAction) -> Void in 
   if !self.loggedIn { self.login() } 
   // if loggedIn go to titan 
  } 
)

alert.addAction( UIAlertAction( 
  title: “Closeup of Sun”, 
  style: .destructive) 
  { (action: UIAlertAction) -> Void in 
   if !loggedIn { self.login() } 
   // if loggedIn destroy Cassini by going to Sun 
  } 
)

alert.addAction(
  UIAlertAction( 
    title: “Cancel”, 
    style: .cancel) 
  	{ (action: UIAlertAction) -> Void in 
     // do nothing 
    } 
)

alert.modalPresentationStyle = .popover 
let ppc = alert.popoverPresentationController 
ppc?.barButtonItem = redeployBarButtonItem

present(alert, animated: true, completion: nil)
```



#### Example: Alert



```swift
var alert = UIAlertController(
  title: “Login Required”, 
  message: “Please enter your Cassini guidance system...”, 
  preferredStyle: .alert 
)

alert.addAction(
  UIAlertAction( 
    title: “Cancel”, 
    style: .cancel
  ) { (action: UIAlertAction) -> Void in 
     // do nothing 
    } 
)

alert.addAction(
  UIAlertAction(
    title: “Login”, 
    style: .default
  ) { (action: UIAlertAction) -> Void in
     // get password and log in
     if let tf = self.alert.textFields?.first {
       self.loginWithPassword(tf.text)
     } 
    }
)

alert.addTextField( configurationHandler: { textField in 
                 textField.placeholder = “Guidance System Password” 
                 textField.isSecureTextEntry = true }
)

present(alert, animated: true, completion: nil)
```



## Notification



### Notification Center

![image-20190731160112237](assets/image-20190731160112237.png)

Get the default “notiﬁcation center” via `NotificationCenter.default` Then send it the following message if you want to “listen to a radio station” …

```swift
var observer: NSObjectProtocol? // a cookie to later “stop listening” with 
observer = NotificationCenter.default.addObserver(
  forName: Notification.Name, // the name of the radio station
  object: Any?, // the broadcaster (or nil for “anyone”) 
  queue: OperationQueue? // the queue on which to dispatch the closure below 
) { (notification: Notification) -> Void in // closure executed when broadcasts occur
   let info: Any? = notification.userInfo 
   // info is usually a dictionary of notiﬁcation-speciﬁc information
  }
```



#### Notification.Name

Look this up in the documentation to see what iOS system radio stations you can listen to. There are a lot.

You will see them as static vars on `Notification.Name`.

You can make your own radio station name with Notification.Name(String).

More on broadcasting on your own station in a couple of slides …





### Example



Watching for changes in the size of preferred fonts (user can change this in Settings) ...

```swift
let center = NotificationCenter.default 
var observer = center.addObserver(
  forName: Notification.Name.UIContentSizeCategoryDidChange
  object: UIApplication.shared, // or nil
  queue: OperationQueue.main // or nil 
) { notification in
   // re-set the fonts of objects using preferred fonts 
   // or look at the size category and do something with it …
   let c = notification.userInfo?[UIContentSizeCategoryNewValueKey]
   // c might be UIContentSizeCategorySmall, for example
  } 
center.removeObserver(observer) // when you’re done listening
```



#### Posting a Notification

```swift
NotificationCenter.default.post( 
  name: Notification.Name, // name of the “radio station” 
  object: Any?, // who is sending this notiﬁcation (usually self)
  userInfo: [AnyHashable:Any]? = nil  // any info you want to pass to station listeners
)
```

Any closures added with `addObserver` will be executed.

Either immediately on the same queue as post (if queue was nil).

Or asynchronously by posting the block onto the queue speciﬁed with addObserver.





### KVO



**Watching the properties of `NSObject` subclasses**

- The basic idea of KVO is to register a closure to invoke when a property value changes 
- There is some “mechanism” required to make this work 
- We’re not going to talk about that, but NSObject implements this mechanism 
- Thus objects that inherit from NSObject can participate



**What’s it good for?**

- Usually used by a Controller to observe either its Model or its View 
- Not every property works with KVO 
- A property has to be Key Value Coding-compliant to work 
- There are a few properties scattered throughout the iOS frameworks that are compliant 
  - For example, UIView’s frame and center work with KVO 
  - So does most of CALayer underneath UIView 
- Of course, you can make properties in your own NSObject subclasses compliant
  -  (though we don’t have time to talk about how to do any of that right now
-  You’re unlikely to use KVO much, but it’s something that’s good to know it exists



**How does it work?**

```swift
var observation = observed.observe(keyPath: KeyPath) { (observed, change) in 
    // code to execute when the property described by keyPath changes
}
```

As long as the observation remains in the heap, the closure will stay active. 

The change argument to the closure is an `NSKeyValueObservedChange`. NSKeyValueObservedChange has the old value and the new value in it.

The syntax for a KeyPath is `\Type.property` or even `\Type.prop1.prop2.prop3`.

Swift can infer the Type (since that Type has to make sense for `observed`).



## Application Lifecycle



![image-20190731173431471](assets/image-20190731173431471.png)



![image-20190731173456192](assets/image-20190731173456192.png)

![image-20190731173517889](assets/image-20190731173517889.png)

![image-20190731173534314](assets/image-20190731173534314.png)



![image-20190731173608950](assets/image-20190731173608950.png)



![image-20190731173630911](assets/image-20190731173630911.png)



![image-20190731173703874](assets/image-20190731173703874.png)



### From Not Running to Inactive

![image-20190731174033148](assets/image-20190731174033148.png)

Your AppDelegate will receive …

```swift
func application(UIApplication,
                 will/didFinishLaunchingWithOptions:
                 [UIApplicationLaunchOptionsKey:Any]? = nil)
```

… and you can observe …

`UIApplicationDidFinishLaunching`

The passed dictionary (also in `notification.userInfo`) tells you why your application was launched.

**Some examples …** 

- Someone wants you to open a URL
- You entered a certain place in the world

- You are continuing an activity started on another device
-  A notiﬁcation arrived for you (push or local)

- Bluetooth attached device wants to interact with you





### From  Active to Inactive

![image-20190731174043161](assets/image-20190731174043161.png)



Your AppDelegate will receive …

```swift
func applicationWillResignActive(UIApplication)
```

… and you can observe …

`UIApplicationWillResignActive`

You will want to “pause” your UI here.

For example, Asteroids would want to pause the asteroids. 

- This might happen because a phone call comes in.

- Or you might be on your way to the background.



### From Inactive to Active



![image-20190731174214924](assets/image-20190731174214924.png)



Your AppDelegate will receive …

```swift
func applicationDidBecomeActive(UIApplication)
```

… and you can observe …

`UIApplicationDidBecomeActive`

If you have “paused” your UI previously here’s where you would reactivate things.



### From Inactive to Background

![image-20190731174404094](assets/image-20190731174404094.png)



Your AppDelegate will receive …

```sw
func applicationDidEnterBackground(UIApplication)
```

… and you can observe …

`UIApplicationDidEnterBackground`

Here you want to (quickly) batten down the hatches. You only get to run for 30s or so.

You can request more time, but don’t abuse this (or the system will start killing you instead). 

Prepare yourself to be eventually killed here(probably won’t happen, but be ready anyway



### From Background to Inactive



![image-20190731174521970](assets/image-20190731174521970.png)

Your AppDelegate will receive …

```swift
func applicationWillEnterForeground(UIApplication)
```

… and you can observe …

`UIApplicationWillEnterForeground`

Whew! You were not killed from background state! Time to un-batten the hatches.

Maybe undo what you did in `DidEnterBackground`. You will likely soon be made Active.



### Other UIApplicationDelegate

Other AppDelegate items of interest …

- State Restoration (saving the state of your UI so that you can restore it even if you are killed). 
- Data Protection (ﬁles can be set to be protected when a user’s device’s screen is locked).
- Open URL (in Xcode’s Info tab of Project Settings, you can register for certain URLs). 
- Background Fetching (you can fetch and receive results while in the background).



### UIApplication



#### Shared instance

There is a single UIApplication instance in your application

```swift
let myApp = UIApplication.shared
```

It manages all global behavior 

You never need to subclass it 

It delegates everything you need to be involved in to its UIApplicationDelegate 

However, it does have some useful functionality …

**Opening a URL in another application**

```swift
func open(URL)
func canOpenURL(URL) -> Bool
```

 **Registering to receive Push Notiﬁcations**

```swift
func (un)registerForRemoteNotifications()
```

Notiﬁcations, both local and push, are handled by the UNNotification framework.



**Setting the fetch interval for background fetching**

You must set this if you want background fetching to work …

`func setMinimumBackgroundFetchInterval(TimeInterval)` 

Usually you will set this to UIApplicationBackgroundFetchIntervalMinimum

**Asking for more time when backgrounded**

`func beginBackgroundTask(withExpirationHandler: (() -> Void)?) -> UIBackgroundTaskIdentifier`

 Do NOT forget to call `endBackgroundTask(UIBackgroundTaskIdentifier)` when you’re done!

**Turning on the “network in use” spinner (status bar upper left)**

`var isNetworkActivityIndicatorVisible: Bool // unfortunately just a Bool, be careful`

**Finding out about things**

```swift
var backgroundTimeRemaining: TimeInterval { get } // until you are suspended 
var preferredContentSizeCategory: UIContentSizeCategory { get } // big fonts or small fonts
var applicationState: UIApplicationState { get } // foreground, background, active
```



### Info.plist

**Many of your application’s settings are in Info.plist**

- You can edit this ﬁle (in Xcode’s property list editor) by clicking on Info.plist
- Or you can even edit it as raw XML!



#### Capabilities

Some features require enabling

- These are server and interoperability features Like iCloud, Game Center, etc.

Switch on in Capabilities tab

- Inside your Project Settings

Not enough time to cover these!

- But check them out!
- Many require full Developer Program membership 
- Familiarize yourself with their existence



## Segue



### Model View Controllers

- A way of segueing that takes over the screen
  - This is not a push.
  - Notice, no back button (only Cancel).
- Considerations
  - The view controller we segue to using a Modal segue will take over the entire screen 
  - This can be rather disconcerting to the user, so use this carefully



#### Set up a Modal segue

Just ctrl-drag from a button to another View Controller & pick segue type “Modal” If you need to present a Modal VC not from a button, use a manual segue …

```swift
func performSegue(withIdentifier: String, sender: Any?)
```

… or, if you have the view controller itself (e.g. Alerts or from instantiateViewController) …

```swift
func present(UIViewController, animated: Bool, completion: (() -> Void)?= nil)
```



#### Preparing for a Model segue

You prepare for a Modal segue just like any other segue ...

```swift
func prepare(for: UIStoryboardSegue, sender: Any?) { 
  if segue.identifier == “GoToMyModalVC” { 
    let vc = segue.destination as MyModalVC
    // set up the vc to run here
  }
}
```

**Hearing back from a Modally segued-to View Controller**

- When the Modal View Controller is “done”, how does it communicate results back to presenter?
- If there’s nothing to be said, just dismiss the segued-to MVC (next slide).
- To communicate results, generally you would Unwind (more on that in a moment).



#### Dismiss a view controller

The presenting view controller is responsible for dismissing (not the presented). You do this by sending the presenting view controller this message …

```swift
func dismiss(animated: Bool, completion: (() -> Void)? = nil)
```

… which will dismiss whatever MVC it has presented (if any).

You can get at your presenting view controller with this UIViewController property …

```swift
var presentingViewController: UIViewController?
```

If you send this to a presented view controller, for convenience, it will forward to its presenter (unless it itself has presented an MVC, in which case it will dismiss that MVC).

But to reduce confusion in your code, only send dismiss to the presenting controller.

Unwind Segues (coming up soon) automatically dismiss (you needn’t call the above method).



**Controlling the appearance of the presented view controller**

In horizontally regular environments, this var determines what a presented VC looks like …

```swift
var modalPresentationStyle: UIModalPresentationStyle 
```

In addition to the default, `.fullScreen`, there’s `.overFullScreen` (presenter visible behind)

On iPad, if full screen is “too much real estate”, there’s `.formSheet` and `.pageSheet` (these two use a smaller space and with a “grayed out” presenting view controller behind) In horizontally compact environments, these will all adapt to always be full screen!

**How is the modal view controller animated onto the screen?**

Depends on this property in the view controller that is being presented …

```swift
var modalTransitionStyle: UIModalTransitionStyle 
.coverVertical // slides the presented modal VC up from bottom of screen (the default)
.flipHorizontal // ﬂips the presenting view controller over to show the presented modal VC 
.crossDissolve // presenting VC fades out as the presented VC fades in 
.partialCurl // only if presenting VC is full screen (& no more modal presentations coming) 
```

The presentation & transition styles can be set in the storyboard by inspecting the segue.



### Popover



Popovers pop an entire MVC over the rest of the screen

- Popover’s arrow pointing to what caused it to appear
- The grayed out area here is inactive. Touching in it will dismiss the popover.



#### Preparing a Popover

- All segues are managed via a `UIPresentationController` (but we’re not going to cover that) 
- But we are going to talk about a popover’s `UIPopoverPresentationController`
- It notes what caused the popover to appear (a bar button item or just a rectangle in a view) 
- You can also control what direction the popover’s arrow is allowed to point 
- Or you can control how a popover adapts to different sizes classes (e.g. iPad vs iPhone)



```swift
func prepare(for segue: UIStoryboardSegue, sender: Any?) {
  if let identifier = segue.identifier { 
    switch identifier { 
      case “Do Something in a Popover Segue”:
      		if let vc = segue.destination as? MyController { 
            if let ppc = vc.popoverPresentationController { 
              ppc.permittedArrowDirections = UIPopoverArrowDirection.any ppc.delegate = self 
            }
            // more preparation here
          } default: break
    }
  }
}
```



- One thing that is different is that we are retrieving the popover’s presentation controller
- We can use it to set some properties that will control how the popover pops up
- And we can control the presentation by setting ourself (the Controller) as the delegate



#### Adaptation to different size classes

- One very interesting thing is how a popover presentation can “adapt” to different size classes. 
- When a popover is presenting itself in a horizontally compact environment (e.g. iPhone),there might not be enough room to show a popover window comfortably, 
- so by default it “adapts” and shows the MVC in full screen modal instead.

But the popover presentation controller’s delegate can control this “adaptation” behavior. 

Either by preventing it entirely …

```swift
func adaptivePresentationStyle( for controller: UIPresentationController, traitCollection: UITraitCollection ) -> UIModalPresentationStyle {
  return UIModalPresentationStyle.none // don’t adapt
  // the default in horizontally compact environments (iPhone) is .fullScreen
}
```

You can control the view controller that is used to present in the adapted environment 

Best example: wrapping a `UINavigationController` around the MVC that is presented

```swift
func presentationController(controller: UIPresentationController, viewControllerForAdaptivePresentationStyle: UIModalPresentationStyle) -> UIViewController?{
  // return a UIViewController to use (e.g. wrap a Navigation Controller around your MVC) 
}
```



#### Important Popover Issue: Size

A popover will be made pretty large unless someone tells it otherwise.

The MVC being presented knows best what it’s “preferred” size inside a popover would be.

It expresses that via this property in itself (i.e. in the Controller of the MVC being presented) …

```swift
var preferredContentSize: CGSize
```

The MVC is not guaranteed to be that size, but the system will try its best. You can set or override the var to always return an appropriate size.



### Unwind Segue

The only segue that does NOT create a new MVC

- It can only segue to other MVCs that (directly or indirectly) presented the current MVC

What’s it good for?

- Jumping up the stack of cards in a navigation controller (other cards are considered presenters) 
- Dismissing a Modally segued-to MVC while reporting information back to the presenter



#### How does it work?

- Instead of ctrl-dragging to another MVC, you ctrl-drag to the “Exit” button in the same MVC
- Then you can choose a special @IBAction method you’ve created in another MVC
- This means “segue by exiting me and ﬁnding a presenter who implements that method” 
  - This method must be marked @IBAction.
  - And it must have a `UIStoryboardSegue` as its only argument.
- If no presenter (directly or indirectly) implements that method, the segue will not happen
- If the @IBAction can be found, you (i.e. the presented MVC) will get to prepare as normal
- Then the special @IBAction will be called in the other MVC and that MVC will be shown on screen
- You will be dismissed in the process (i.e. you’ll be “unpresented” and thrown away)

### Embed Segue

Putting a VC’s self.view in another VC’s view hierarchy!

- This can be a very powerful encapsulation technique.

Xcode makes this easy

- Drag out a Container View from the object palette into the scene you want to embed it in. 
- Automatically sets up an “Embed Segue” from container VC to the contained VC.

Embed Segue

- Works just like other segues.

- prepare(for segue:, sender:), et. al.

View Loading Timing

- Don’t forget, though, that just like other segued-to VCs, the embedded VC’s outlets are not set at the time prepare(for segue:, sender:) is called. 
- So often we will just grab a pointer to the embedded VC in prepare.





## Core Motion



### About it

- API to access motion sensing hardware on your device
- Primary inputs: Accelerometer, Gyro, Magnetometer
  - Not all devices have all inputs (e.g. only later model devices have a gyro)
- Class used to get this input is `CMMotionManager`
  - Use only one instance per application (else performance hit)
  - It is a “global resource,” so getting one via a class method somewhere is okay



### Usage

1. Check to see what hardware is available
2. Start the sampling going and poll the motion manager for the latest sample it has ... or ...
3. Check to see what hardware is available
4. Set the rate at which you want data to be reported from the hardware
5. Register a closure (and a queue to run it on) to call each time a sample is taken



**Checking availability of hardware sensors**

- `var {accelerometer,gyro,magnetometer,deviceMotion}Available: Bool`
- The “device motion” is a combination of all available (accelerometer, magnetometer, gyro).



**Starting the hardware sensors collecting data**

- You only need to do this if you are going to poll for data.

- Generally used when some architecture in your app is already periodic (e.g. animation frames).

  ```swift
  func start{Accelerometer,Gyro,Magnetometer,DeviceMotion}Updates()
  ```

    

**Is the hardware currently collecting data?**

```swift
var {accelerometer,gyro,magnetometer,deviceMotion}Active: Bool
```



**Stop the hardware collecting data**


It is a performance hit to be collecting data, so stop during times you don’t need the data.

```swift
func stop{Accelerometer,Gyro,Magnetometer,DeviceMotion}Updates()
```



### Getting Data

Checking the data (from existing periodic mechanism)

#### from accelerometer

```swift
var accelerometerData: CMAccelerometerData?
//CMAccelerometerData object provides 
var acceleration: CMAcceleration 
struct CMAcceleration {
  var x: Double // in g (9.8 m/s/s)
  var y: Double // in g
  var z: Double // in g 
}

//This raw data includes acceleration due to gravity
// So, if the device were laid ﬂat, z would be 1.0 and x and y would be 0.0
```



#### from Gyro

```swift
var gyroData: CMGyroData?

//CMGyroData object provides 
var rotationRate: CMRotationRate 
struct CMRotationRate {
  var x: Double // in radians/s
  var y: Double // in radians/s
  var z: Double // in radians/s 
}

//Sign of the rotation data follows right hand rule
//The data above will be biased
```



#### from magnetometer

```swift
var magnetometerData: CMMagnetometerData?
//CMMagnetometerData object provides 
var magneticField: CMMagneticField 
struct CMMagneticField {
  var x: Double // in microteslas
  var y: Double // in microteslas
  var z: Double // in microteslas 
}

//The data above will be biased
```



#### CMDeviceMotion

**CMDeviceMotion is a “combined” motion data source**

It uses information from all the hardware to improve the data from each.

```swift
 var deviceMotion: CMDeviceMotion? 
```

**Acceleration Data in CMDeviceMotion**

```swift
var gravity: CMAcceleration 
var userAcceleration: CMAcceleration// gravity factored out using gyro
```

**Other information in CMDeviceMotion**

```swift
var rotationRate: CMRotationRate // bias removed from raw data using accelerometer 
var attitude: CMAttitude // device’s attitude (orientation) in 3D space
class CMAttitude: NSObject{ // roll, pitch and yaw are in radians 
  var roll: Double // around longitudinal axis passing through top/bottom 
  var pitch: Double // around lateral axis passing through sides 
  var yaw: Double // around axis with origin at CofG and ⊥ to screen directed down
} 
var heading: Double // in degrees, where 0 is north (true or magnetic depending on frame)
```



**Reference Frame**

Magnetometer use in CMDeviceMotion can be controlled by setting its reference frame.
 Specify this when calling `startDeviceMotionUpdates`.

```swift
xArbitraryZVertical // the default, does not use magnetometer
 xArbitraryCorrectedZVertical // uses magnetometer (if available) to correct yaw over time
xMagnetic/TrueNorthZVertical // uses magnetometer for device position/heading in world
```


 These last two may require the user to calibrate the magnetometer.


And for TrueNorth, location information (e.g. GPS/Wiﬁ/Cellular) will also be required.
 North frames are necessary for apps that use things like Augmented Reality.


To get `heading`, for example, you must use a `MagneticNorth` or `TrueNorth` reference frame.


Always check to make sure the reference frame you want is available on the device …

```swift
static func availableAttitudeReferenceFrames() -> CMAttitudeReferenceFrame
```



### Using Core Motion

#### Registering a block

**Registering a block to receive Accelerometer data**

```swift
func startAccelerometerUpdatesToQueue(
  queue: OperationQueue, 
  withHandler: CMAccelerometerHandler) 
typealias CMAccelerationHandler = (CMAccelerometerData?, Error?) -> Void 
//queue can be an OperationQueue() you create or Operation.main (or current)
```

**Registering a block to receive Gyro data**

```swift
func startGyroUpdatesToQueue(
  queue: OperationQueue, 
  withHandler: CMGyroHandler) 
typealias CMGyroHandler = (CMGyroData?, Error?) -> Void
```

**Registering a block to receive Magnetometer data**

```swift
func startMagnetometerUpdatesToQueue(
  queue: OperationQueue, 
  withHandler: CMMagnetometerHandler) 
typealias CMMagnetometerHandler = (CMMagnetometerData?, Error?) -> Void
```

**Registering a block to receive DeviceMotion data**

```swift
func startDeviceMotionUpdates(
  using: CMAttitudeReferenceFrame, 
  queue: OperationQueue, 
  withHandler: (CMDeviceMotion?, Error?) -> Void) 
```

queue can be an `OperationQueue()` you create or `Operation.mainQueue` (or currentQueue)
 Errors 

- CMErrorDeviceRequiresMovement

- CMErrorTrueNorthNotAvailable

- CMErrorMotionActivityNotAvailable

- CMErrorMotionActivityNotAuthorized

**Setting the rate at which your block gets executed**

```swift
var accelerometerUpdateInterval: TimeInterval 
var gyroUpdateInterval: TimeInterval 
var magnetometerUpdateInterval: TimeInterval 
var deviceMotionUpdateInterval: TimeInterval
```

It is okay to add multiple handler blocks



#### Accelerometer Over Time

**Historical Accelerometer Data**

- Sometimes you don’t need to look at the accelerometer in real time.

- You just want to know what happened over a period of time in the past.

- For example, if you want an idea of the user’s physical movement pattern.


The class `CMSensorRecorder` can record (at 50hz) and then play back accelerometer data.

Not all devices are capable of this (iPhone 7 and later, Apple Watch).

```swift
isAccelerometerRecordingAvailable() -> Bool // whether this device can record
```


Start recording data …

```swift
func recordAccelerometer(forDuration: TimeInterval) // keep this short for performance
```


Retrieving the recorded data …

```swift
func accelerometerData(from: Date, to: Date) -> CMSensorDataList // 3 day max
```

You enumerate over the `CMAccelerometerData` objects in a `CMSensorDataList` with for in …

```swift
for dataPoint: CMRecordedAccelerometerData in sensorDataList { . . . }
```



#### Activity Monitoring

**Rough estimate of what the user is doing**


For example, stationary, walking, running, automotive, or cycling.


You track this with a `CMMotionActivityManager` (not a `CMMotionManager`!).

```swift
func startActivityUpdates(to: OperationQueue, withHandler: (CMMotionActivity?) -> Void) 
```


 CMMotionActivity is one of the above activities.


You can also query historical activity with …

```swift
func queryActivityStarting(from: Date, to: Date, to: OperationQueue, withHandler: …)
```



### Pedometer

#### Pedometer

Getting the user’s “step” information only makes sense over time.
 Create a `CMPedometer` and then send it the message …

```swift
func startUpdates(from: Date, withHandler: (CMPedometerData?, Error?) -> Void)
```

The from Date is allowed to be in the past (but only last 7 days are recorded).

Your handler will be called periodically with the struct `CMPedometerData` which has …
 `startDate` and `endDate` of the data `numberOfSteps`, `distance`, `averageActivePace`, and `currentPace` during the time also`floorsAscended` and `floorsDescended`

#### Altimeter


Get relative altitude changes.

```swift
func startRelativeAltitudeUpdates(to: OperationQueue, withHandler: (CMAltitudeData?, Error?)) 
```

`CMAltitudeData` has both change in altitude in meters and raw atmospheric pressure data.



### Checking the authorization status of hardware sensors


Some information is considered “private” to the user (e.g. ﬁtness data).


Speciﬁcally `CMPedometer`, `CMSensorRecorder`, `CMMotionActivityManager` and `CMAltimeter`.


iOS will automatically ask the user (once) for permission to access this information.

You can ﬁnd out what the status is at any time with this static func on each of these.

```swift
static func authorizationStatus() -> CMAuthorizationStatus 

struct CMAuthorizationStatus { 
  case notDetermined // user has not yet been asked 
  case restricted // ﬁtness data access disabled in Settings
  case denied // user has explicitly denied your app access
  case authorized // ready to go!

```


 Lack of authorization may also show up as an error when you request data.



## Camera



### `UIImagePickerController`



#### About it

Modal view controller to get media from camera or photo library

**Usage**


1. Create it & set its delegate (it can’t do anything without its delegate)

2. Conﬁgure it (source, kind of media, user edibility, etc.)

3. Present it

4. Respond to delegate methods when user is done/cancels picking the media



**What the user can do depends on the platform**

Almost all devices have cameras, but some can record video, some can not
 You can only offer camera or photo library on iPad (not both together at the same time) 

As with all device-dependent API, we want to start by check what’s available …

```swift
static func isSourceTypeAvailable(sourceType: UIImagePickerControllerSourceType) -> Bool
```

Source type is

.`photoLibrary` or .`camera` or .`savedPhotosAlbum` (camera roll)



**But don’t forget that not every source type can give video**


So, you then want to check ...

```swift
static func availableMediaTypes(for: UIImagePickerControllerSourceType) -> [String]?
```

Depending on device, will return one or more of these ...

```swift
kUTTypeImage // pretty much all sources provide this, hardly worth checking for even
kUTTypeLivePhoto // must also say kUTTypeImage for this one to work
kUTTypeMovie // audio and video together, only some sources provide this
```

These speciﬁc are declared about in the  `MobileCoreServices` framework.



**You can get even more These speciﬁc are declared about in the cameras**

```swift
static func isCameraDeviceAvailable(UIImagePickerControllerCameraDevice) -> Bool 
```

returns `.rear` or `.front`

There are other camera-speciﬁc interrogations too, for example …

```swift
static func isFlashAvailableForCameraDevice(UIImagePickerControllerCameraDevice) -> Bool
```

### Use it

**Set the source and media type you want in the picker**


Example setup of a picker for capturing video (`kUTTypeMovie`) …


(From here out, `UIImagePickerController` will be abbreviated UIIPC for space reasons.)

```swift
let picker = UIImagePickerController() 
let mediaTypeMovie = kUTTypeMovie as String 
picker.delegate = self // self must implement UINavigationControllerDelegate too 
if UIIPC.isSourceTypeAvailable(.camera) {
  picker.sourceType = .camera
  if let availableTypes = UIIPC.availableMediaTypesForSourceType(.camera) {
    if availableTypes.contains(mediaTypeMovie) { 
      picker.mediaTypes = [mediaTypeMovie]
      // proceed to put the picker up
    }
  }
}
```



**Editability**

`var allowsEditing: Bool`

- If true, then the user will have opportunity to edit the image/video inside the picker. 
- When your delegate is notiﬁed that the user is done, you’ll get both raw and edited versions.



**Limiting Video Capture**

`var videoQuality: UIImagePickerControllerQualityType` 

- .typeMedium // default 
- .typeHigh 
- .type640x480 
- .typeLow 
- .typeIFrame1280x720 // native on some devices 
- .typeIFrame960x540 // native on some devices

`var videoMaximumDuration: TimeInterval // defaults to 10 minutes`



**Present the picker**

```swift
present(picker, animated: true, completion: nil)
```

On iPad, if you are not offering Camera (just photo library), you must present with popover.
 If you are offering the Camera on iPad, then full-screen is preferred.

**Remember: on iPad, it’s Camera OR Photo Library (not both at the same time).**



**Delegate will be notiﬁed when user is done**

```swift
func imagePickerController( UIIPC, didFinishPickingMediaWithInfo info: [String:Any]) { 
  // extract image/movie data/metadata here from info, more on the next slide
  picker.presentingViewController?.dismiss(animated: true) { }
}
```

**Also dismiss it when cancel happens**

```swift
func imagePickerControllerDidCancel(UIIPC) { 
  picker.presentingViewController?.dismiss(animated: true) { } 
}
```



**What is in that info dictionary?**

- `UIImagePickerControllerMediaType` // kUTTypeImage, kUTTypeMovie
- `UIImagePickerControllerOriginalImage`  // UIImage
- `UIImagePickerControllerEditedImage`  // UIImage
- `UIImagePickerControllerImageURL` // URL (in a temp location, so move it to keep it)
- `UIImagePickerControllerCropRect` // CGRect (in an NSValue)
- `UIImagePickerControllerMediaMetadata` // Dictionary of info about the image
- `UIImagePickerControllerLivePhoto` // a PHLivePhoto
- `UIImagePickerControllerPHAsset`  // a PHAsset (see PHPhotoLibrary)
- `UIImagePickerControllerMediaURL`  // URL of the video if kUTTypeMovie



**Saving taken images or video into the device’s photo library**


You can save to the user’s Camera Roll … 

```swift
func UIImageWriteToSavedPhotosAlbum( 
  _ image: UIImage, 
  _ target: Any?, // the object to send selector to when ﬁnished writing
  _ selector: Selector? // selector to send to target when ﬁnished writing
  _ context: UnsafeMutableRawPointer?// passed to the selector
)
```

- It’s a bummer that this isn’t closure-based, but it is what it is. 

- This is a very simple and convenient way to do this.
- But this only makes sense if the user only occasionally would want to save an image.
- Otherwise, you’ll want to integrate with the Photos application: checkout `PHPhotoLibrary`.
- Of course, you could also save the image into your own sandbox.
- You’d do that if the captured images only make sense inside your own app.
- In general, much more sophisticated media capture is available
- This `UIImagePickerController` API is pretty simple, but more powerful API exists.
   Check out both `PHPhotoLibrary` and `AVCaptureDevice`.



**Overlay View**

`var cameraOverlayView: UIView` 

Be sure to set this view’s frame properly.

Camera is always full screen, so use `UIScreen.main`’s bounds property.

If you use the built-in controls at the bottom, you might want your view to be smaller.



**Hiding the normal camera controls (at the bottom)**

`var showsCameraControls: Bool`

- Will leave a blank area at the bottom of the screen (camera’s aspect 4:3, not same as screen’s). 
- With no controls, you’ll need an overlay view with a “take picture” (at least) button.

- That button should send `takePicture()` or (`startVideoCapture()`) to the picker.

- Don’t forget to dismiss when you are done taking pictures.

**You can zoom or translate the image while capturing**

`var cameraViewTransform: CGAffineTransform`

For example, you might want to scale the image up to full screen (some of it will get clipped).



### Core Image and Vision



- Core Image is a powerful and efﬁcient framework for applying ﬁlters to your images.

- Has a couple of hundred ﬁlters to choose from (blur, depth, comparison, colors, smoothing, etc.).

- Vision framework provides powerful feature detection in images (e.g. faces, barcodes, etc.).
-  Core Image also has some feature detection API.
- Check out Core Image and Vision in the documentation.


 





