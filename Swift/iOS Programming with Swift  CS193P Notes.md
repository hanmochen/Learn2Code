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

### 

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

