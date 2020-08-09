--[==[
	BoatTween (because TweenService2 was taken)
	by boatbomber (Zack Ovits)
	© 2020
	
	
	API:
	
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
	
			string EasingDirection = "In" or "Out" or "InOut" or "OutIn"
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
		
		
--]==]


local BoatTween = {}
local RunService = game:GetService("RunService")

local ValidStepTypes = {
	["Heartbeat"] = true;
	["Stepped"] = true;
	["RenderStepped"] = true;
}
if not RunService:IsClient() then
	ValidStepTypes.RenderStepped = nil
end

local RawTweenFunctions = require(script.TweenFunctions)
local TweenFunctions = {
	Linear = {
		In = RawTweenFunctions.Linear;
		Out = RawTweenFunctions.Linear;
		InOut = RawTweenFunctions.Linear;
	};
	Quad = {
		In = RawTweenFunctions.InQuad;
		Out = RawTweenFunctions.OutQuad;
		InOut = RawTweenFunctions.InOutQuad;
	};
	Cubic = {
		In = RawTweenFunctions.InCubic;
		Out = RawTweenFunctions.OutCubic;
		InOut = RawTweenFunctions.InOutCubic;
	};
	Quart = {
		In = RawTweenFunctions.InQuart;
		Out = RawTweenFunctions.OutQuart;
		InOut = RawTweenFunctions.InOutQuart;
	};
	Quint = {
		In = RawTweenFunctions.InQuint;
		Out = RawTweenFunctions.OutQuint;
		InOut = RawTweenFunctions.InOutQuint;
	};
	Sine = {
		In = RawTweenFunctions.InSine;
		Out = RawTweenFunctions.OutSine;
		InOut = RawTweenFunctions.InOutSine;
	};
	Expo = {
		In = RawTweenFunctions.InExpo;
		Out = RawTweenFunctions.OutExpo;
		InOut = RawTweenFunctions.InOutExpo;
	};
	Circ = {
		In = RawTweenFunctions.InCirc;
		Out = RawTweenFunctions.OutCirc;
		InOut = RawTweenFunctions.InOutCirc;
	};
	Elastic = {
		In = RawTweenFunctions.InElastic;
		Out = RawTweenFunctions.OutElastic;
		InOut = RawTweenFunctions.InOutElastic;
	};
	Back = {
		In = RawTweenFunctions.InBack;
		Out = RawTweenFunctions.OutBack;
		InOut = RawTweenFunctions.InOutBack;
	};
	Bounce = {
		In = RawTweenFunctions.InBounce;
		Out = RawTweenFunctions.OutBounce;
		InOut = RawTweenFunctions.InOutBounce;
	};
	Smooth = {
		In = RawTweenFunctions.InSmooth;
		Out = RawTweenFunctions.OutSmooth;
		InOut = RawTweenFunctions.InOutSmooth;
	};
	Smoother = {
		In = RawTweenFunctions.InSmoother;
		Out = RawTweenFunctions.OutSmoother;
		InOut = RawTweenFunctions.InOutSmoother;
	};
	RidiculousWiggle = {
		In = RawTweenFunctions.InRidiculousWiggle;
		Out = RawTweenFunctions.OutRidiculousWiggle;
		InOut = RawTweenFunctions.InOutRidiculousWiggle;
	};
	RevBack = {
		In = RawTweenFunctions.InRevBack;
		Out = RawTweenFunctions.OutRevBack;
		InOut = RawTweenFunctions.InOutRevBack;
	};
	Spring = {
		In = RawTweenFunctions.InSpring;
		Out = RawTweenFunctions.OutSpring;
		InOut = RawTweenFunctions.InOutSpring;
	};
	SoftSpring = {
		In = RawTweenFunctions.InSoftSpring;
		Out = RawTweenFunctions.OutSoftSpring;
		InOut = RawTweenFunctions.InOutSoftSpring;
	};
	Sharp = {
		In = RawTweenFunctions.InSharp;
		Out = RawTweenFunctions.OutSharp;
		InOut = RawTweenFunctions.InOutSharp;
	};
	Acceleration = {
		In = RawTweenFunctions.InAcceleration;
		Out = RawTweenFunctions.OutAcceleration;
		InOut = RawTweenFunctions.InOutAcceleration;
	};
	Standard = {
		In = RawTweenFunctions.InStandard;
		Out = RawTweenFunctions.OutStandard;
		InOut = RawTweenFunctions.InOutStandard;
	};
	Deceleration = {
		In = RawTweenFunctions.InDeceleration;
		Out = RawTweenFunctions.OutDeceleration;
		InOut = RawTweenFunctions.InOutDeceleration;
	};
	FabricStandard = {
		In = RawTweenFunctions.InFabricStandard;
		Out = RawTweenFunctions.OutFabricStandard;
		InOut = RawTweenFunctions.InOutFabricStandard;
	};
	FabricAccelerate = {
		In = RawTweenFunctions.InFabricAccelerate;
		Out = RawTweenFunctions.OutFabricAccelerate;
		InOut = RawTweenFunctions.InOutFabricAccelerate;
	};
	FabricDecelerate = {
		In = RawTweenFunctions.InFabricDecelerate;
		Out = RawTweenFunctions.OutFabricDecelerate;
		InOut = RawTweenFunctions.InOutFabricDecelerate;
	};
	UWPAccelerate = {
		In = RawTweenFunctions.InUWPAccelerate;
		Out = RawTweenFunctions.OutUWPAccelerate;
		InOut = RawTweenFunctions.InOutUWPAccelerate;
	};
	StandardProductive = {
		In = RawTweenFunctions.InStandardProductive;
		Out = RawTweenFunctions.OutStandardProductive;
		InOut = RawTweenFunctions.InOutStandardProductive;
	};
	EntranceProductive = {
		In = RawTweenFunctions.InEntranceProductive;
		Out = RawTweenFunctions.OutEntranceProductive;
		InOut = RawTweenFunctions.InOutEntranceProductive;
	};
	ExitProductive = {
		In = RawTweenFunctions.InExitProductive;
		Out = RawTweenFunctions.OutExitProductive;
		InOut = RawTweenFunctions.InOutExitProductive;
	};
	StandardExpressive = {
		In = RawTweenFunctions.InStandardExpressive;
		Out = RawTweenFunctions.OutStandardExpressive;
		InOut = RawTweenFunctions.InOutStandardExpressive;
	};
	EntranceExpressive = {
		In = RawTweenFunctions.InEntranceExpressive;
		Out = RawTweenFunctions.OutEntranceExpressive;
		InOut = RawTweenFunctions.InOutEntranceExpressive;
	};
	ExitExpressive = {
		In = RawTweenFunctions.InExitExpressive;
		Out = RawTweenFunctions.OutExitExpressive;
		InOut = RawTweenFunctions.InOutExitExpressive;
	};
	MozillaCurve = {
		In = RawTweenFunctions.InMozillaCurve;
		Out = RawTweenFunctions.OutMozillaCurve;
		InOut = RawTweenFunctions.InOutMozillaCurve;
	};
}

local TypeLerpers = require(script.Lerps)

function BoatTween:Create(Object,Data)
	
	-- Validate
	if not Object or typeof(Object)~= "Instance" then
		warn("Invalid object to tween:", Object)
		return
	end
	
	Data = type(Data) == "table" and Data or {}
	
	
	-- Define settings
	local EventStep = ValidStepTypes[Data.StepType] and RunService[Data.StepType] or RunService.Stepped
	local TweenFunction = TweenFunctions[Data.EasingStyle or "Quad"][Data.EasingDirection or "In"]
	local Time = math.clamp(type(Data.Time)=="number" and Data.Time or 1,0,9999999999)
	local Goal = type(Data.Goal) == "table" and Data.Goal or {}
	local DelayTime = type(Data.DelayTime)=="number" and Data.DelayTime>0.027 and Data.DelayTime
	local RepeatCount = (type(Data.RepeatCount)=="number" and math.clamp(Data.RepeatCount,-1,999999999) or 0)+1
	
	local TweenData = {}
	for Property,EndValue in pairs(Goal) do
		TweenData[Property] = TypeLerpers[typeof(EndValue)](Object[Property],EndValue)
	end
	
	-- Create instances
	local CompletedEvent = Instance.new("BindableEvent")
	local StoppedEvent = Instance.new("BindableEvent")
	local ResumedEvent = Instance.new("BindableEvent")
	
	local PlaybackConnection
	local StartTime,ElapsedTime = tick(),0
	
	local TweenObject = {
		["Instance"] = Object;
		["PlaybackState"] = Enum.PlaybackState.Begin;
		
		["Completed"] = CompletedEvent.Event;
		["Resumed"] = ResumedEvent.Event;
		["Stopped"] = StoppedEvent.Event;
	}
	
	function TweenObject:Destroy()
		if PlaybackConnection then
			PlaybackConnection:Disconnect()
			PlaybackConnection = nil
		end
		CompletedEvent:Destroy()
		StoppedEvent:Destroy()
		ResumedEvent:Destroy()
		TweenObject = nil
	end
	
	local CurrentlyReversing = false
	local CurrentLayer = 0
	
	local Lerp = TypeLerpers
	
	local function Play(Layer,Reverse)
		if PlaybackConnection then
			PlaybackConnection:Disconnect()
			PlaybackConnection = nil
		end
		
		Layer = Layer or 1
		if RepeatCount ~= 0 then
			if Layer>(RepeatCount) then
				TweenObject.PlaybackState = Enum.PlaybackState.Completed
				CompletedEvent:Fire()
				CurrentlyReversing = false
				CurrentLayer = 1
				return
			end
		end
		CurrentLayer = Layer
		
		if Reverse then
			CurrentlyReversing = true
		end
		if DelayTime then
			TweenObject.PlaybackState = Enum.PlaybackState.Delayed
			wait(DelayTime)
		end
		
		StartTime = tick()-ElapsedTime
		PlaybackConnection = EventStep:Connect(function()
			ElapsedTime = tick()-StartTime
			if ElapsedTime>=Time then
				if Reverse then
					for Property,Lerper in pairs(TweenData) do
						Object[Property] = Lerper(0)
					end
				else
					for Property,Lerper in pairs(TweenData) do
						Object[Property] = Lerper(1)
					end
				end
				PlaybackConnection:Disconnect()
				PlaybackConnection = nil
				if Reverse then
					ElapsedTime = 0
					Play(Layer+1,false)
				else
					if Data.Reverses then
						ElapsedTime = 0
						Play(Layer,true)
					else
						ElapsedTime = 0
						Play(Layer+1,false)
					end
				end
			else
				if Reverse then
					for Property,Lerper in pairs(TweenData) do
						Object[Property] = Lerper(math.clamp(TweenFunction(1-(ElapsedTime/Time)),0,1))
					end
				else
					for Property,Lerper in pairs(TweenData) do
						Object[Property] = Lerper(math.clamp(TweenFunction(ElapsedTime/Time),0,1))
					end
				end
			end
		end)
		TweenObject.PlaybackState = Enum.PlaybackState.Playing
		
	end
	
	function TweenObject:Play()
		ElapsedTime = 0
		Play(1,false)
	end
	
	function TweenObject:Stop()
		if PlaybackConnection then
			PlaybackConnection:Disconnect()
			PlaybackConnection = nil
			TweenObject.PlaybackState = Enum.PlaybackState.Cancelled
			StoppedEvent:Fire()
		end
	end
	
	function TweenObject:Resume()
		Play(CurrentLayer,CurrentlyReversing)
		ResumedEvent:Fire()
	end
	
	
	return TweenObject
end

return BoatTween
