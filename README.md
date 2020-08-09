Before we begin, credit where credit is due. @howmanysmaII gave me various lerping and tweening algorithms, and they credit Fractality for various Lua functions, IBM + Google + Microsoft + Mozilla for the bezier curves, and Validark for rewriting certain equations.

Now, into the module.

# Why use this over Roblox’s TweenService?
## Customization and power.
This module offers 32 easing styles (compared to Roblox’s 11) and they all have the 3 easing directions as well, allowing you to find exactly the tween timing you desire.

This module allows you to choose what event the tween runs on, so you can use Stepped, RenderStepped, or Heartbeat depending on your needs instead of being locked to Heartbeat with Roblox’s service.

This module allows you to tween nearly any value, including NumberRanges and PhysicalProperties, which makes it far more useful and versatile.

This module has more accurate color lerping than TweenService’s Color3:Lerp() method.

This module has events for Stopped, Completed, and Resumed on Tween objects but Roblox only has Completed which doesn’t differentiate between finishing and stopping.

This module offers all the usual tween features like reversing, repeating, and PlaybackState as well, so there are only gained features, not sacrifices.

## Easier API.
It takes a dictionary (instead of a TweenInfo object) so you don’t need to make a new object and remember the parameter order every time you make a tween.

# API:

```plain
-- BoatTween

function BoatTween:Create(Object,Data)
	returns a Tween object
	
	Params:
	- Object
	The instance that is having it's properties tweened
	- Data
	A dictionary of the various settings of the tween
	{
		number Time = Any positive number
			How long the tween should take to complete
		
		string EasingStyle = Any TweenStyle from the list below
			The style that the tween follows
			(Note: Uses strings instead of Enum.EasingStyle to allow us to add styles that Roblox doesn't support)
			
		List of available styles:
				Linear				Quad					Cubic
				Quart				Quint					Sine
				Expo				Circ					Elastic
				Back				Bounce					Smooth
				Smoother			RidiculousWiggle		RevBack
				Spring				SoftSpring				Standard
				Sharp				Acceleration			Deceleration
				StandardProductive	EntranceProductive		ExitProductive
				StandardExpressive	EntranceExpressive		ExitExpressive
				FabricStandard		FabricAccelerate		FabricDecelerate
				UWPAccelerate		MozillaCurve

		string EasingDirection = "In" or "Out" or "InOut"
			The direction for the TweenStyle to adhere to
			
		number DelayTime = 0 -> math.huge
			The amount of time before the tween begins playback after calling :Play() on the tween
			(Note: doesn't affect :Resume() calls)
		
		number RepeatCount = -1 -> math.huge
			How many times the tween should repeat with -1 being infinity
			(Note: will wait the DelayTime in between replaying)
		
		boolean Reverses = false or true
			Whether the tween should reverse itself after completion
			(note: Waits the DelayTime before reversing)
			
		table Goal = dictionary
			A dictionary where the keys are properties to tween and the values are the end goals of said properties
			You may tween any property with value of the following types:
					number				boolean					CFrame
					Color3				UDim2					UDim
					Ray					NumberRange				NumberSequenceKeypoint
					PhysicalProperties	NumberSequence			Region3
					Rect				Vector2					Vector3
					
			
		string StepType = "Stepped" or "Heartbeat" or "RenderStepped"
			The event of RunService for the tween to move on
		}

-- Tween

function Tween:Play()
	Plays the tween, starting from the beginning
function Tween:Stop()
	Stops the tween, freezing it in its current state
function Tween:Resume()
	Plays the tween, starting from current position and time
function TweenObject:Destroy()
	Clears connections, stops playback, destroys objects

property Tween.Instance
	The object being tweened
property Tween.PlaybackState
	An Enum.PlaybackState representing the Tween's current state
	
event Tween.Stopped
	Fired when a Tween ends from the :Stop() function
event Tween.Completed
	Fired when a Tween ends due to :Play() being completed
event Tween.Resumed
	Fired when a Tween is played through the :Resume() function
```

## Example:

```Lua
local BoatTween = require(script.BoatTween)

local Tween = BoatTween:Create(workspace:WaitForChild("Part"),{
	Time = 4;
	EasingStyle = "EntranceExpressive";
	EasingDirection = "In";
	
	Reverses = true;
	DelayTime = 1;
	RepeatCount = 3;
	
	StepType = "Heartbeat";
	
	Goal = {
		Color = Color3.new(0.5,0.2,0.9);
		Position = Vector3.new(4,10,7);
		Transparency = 0.5;
	};
})
Tween:Play()
```

*Note: I didn’t test error cases carefully, because if you input invalid types and such that’s just your fault. TweenService would break too. Just don’t tell it to tween a Color3 to a Vector3 or something like that and you’ll be fine.*

Remember to :Destroy() your tweens after usage!
