local Bezier = require(script.Bezier)

local function RevBack(T)
	T = 1 - T
	return 1 - (math.sin(T * 1.5707963267948965579989817342720925807952880859375) +
		(math.sin(T * 3.141592653589793115997963468544185161590576171875) *
		(math.cos(T * 3.141592653589793115997963468544185161590576171875) + 1) / 2))
end

local function Linear(T) return T end

-- @specs https://material.io/guidelines/motion/duration-easing.html#duration-easing-natural-easing-curves
local Sharp = Bezier(0.4, 0, 0.6, 1)
local Standard = Bezier(0.4, 0, 0.2, 1) -- used for moving.
local Acceleration = Bezier(0.4, 0, 1, 1) -- used for exiting.
local Deceleration = Bezier(0, 0, 0.2, 1) -- used for entering.

-- @specs https://developer.microsoft.com/en-us/fabric#/styles/web/motion#basic-animations
local FabricStandard = Bezier(0.8, 0, 0.2, 1) -- used for moving.
local FabricAccelerate = Bezier(0.9, 0.1, 1, 0.2) -- used for exiting.
local FabricDecelerate = Bezier(0.1, 0.9, 0.2, 1) -- used for entering.

-- @specs https://docs.microsoft.com/en-us/windows/uwp/design/motion/timing-and-easing
local UWPAccelerate = Bezier(0.7, 0, 1, 0.5)

-- @specs https://www.ibm.com/design/language/elements/motion/basics

-- Productivity and Expression are both essential to an interface. Reserve Expressive motion for occasional, important moments to better capture user’s attention, and offer rhythmic break to the productive experience.
-- Use standard-easing when an element is visible from the beginning to end of a motion. Tiles expanding and table rows sorting are good examples.
local StandardProductive = Bezier(0.2, 0, 0.38, 0.9)
local StandardExpressive = Bezier(0.4, 0.14, 0.3, 1)

-- Use entrance-easing when adding elements to the view such as a modal or toaster appearing, or moving in response to users’ input, such as dropdown opening or toggle. An element quickly appears and slows down to a stop.
local EntranceProductive = Bezier(0, 0, 0.38, 0.9)
local EntranceExpressive = Bezier(0, 0, 0.3, 1)

-- Use exit-easing when removing elements from view, such as closing a modal or toaster. The element speeds up as it exits from view, implying that its departure from the screen is permanent.
local ExitProductive = Bezier(0.2, 0, 1, 0.9)
local ExitExpressive = Bezier(0.4, 0.14, 1, 1)

-- @specs https://design.firefox.com/photon/motion/duration-and-easing.html
local MozillaCurve = Bezier(0.07, 0.95, 0, 1)

local function Smooth(T)
	return T * T * (3 - 2 * T)
end

local function Smoother(T)
	return T * T * T * (T * (6 * T - 15) + 10)
end

local function RidiculousWiggle(T)
	return math.sin(math.sin(T * 3.141592653589793115997963468544185161590576171875) * 1.5707963267948965579989817342720925807952880859375)
end

local function Spring(T)
	return 1 + (-math.exp(-6.9 * T) * math.cos(-20.1061929829746759423869661986827850341796875 * T))
end

local function SoftSpring(T)
	return 1 + (-math.exp(-7.5 * T) * math.cos(-10.05309649148733797119348309934139251708984375 * T))
end

local function OutBounce(T)
	return T < 0.36363636363636364645657295113778673112392425537109375 and 7.5625 * T * T
		or T < 0.7272727272727272929131459022755734622478485107421875 and 3 + T * (11 * T - 12) * 0.6875
		or T < 0.90909090909090906063028114658663980662822723388671875 and 6 + T * (11 * T - 18) * 0.6875
		or 7.875 + T * (11 * T - 21) * 0.6875
end

local function InBounce(T)
	if T > 0.63636363636363635354342704886221326887607574462890625 then
		T = T - 1
		return 1 - T * T * 7.5625
	elseif T > 0.2727272727272727070868540977244265377521514892578125 then
		return (11 * T - 7) * (11 * T - 3) / -16
	elseif T > 0.0909090909090909116141432377844466827809810638427734375 then
		return (11 * (4 - 11 * T) * T - 3) / 16
	else
		return T * (11 * T - 1) * -0.6875
	end
end

return setmetatable({
	Linear = Linear;

	OutSmooth = Smooth;
	InSmooth = Smooth;
	InOutSmooth = Smooth;

	OutSmoother = Smoother;
	InSmoother = Smoother;
	InOutSmoother = Smoother;

	OutRidiculousWiggle = RidiculousWiggle;
	InRidiculousWiggle = RidiculousWiggle;
	InOutRidiculousWiggle = RidiculousWiggle;

	OutRevBack = RevBack;
	InRevBack = RevBack;
	InOutRevBack = RevBack;

	OutSpring = Spring;
	InSpring = Spring;
	InOutSpring = Spring;

	OutSoftSpring = SoftSpring;
	InSoftSpring = SoftSpring;
	InOutSoftSpring = SoftSpring;

	InSharp = Sharp;
	InOutSharp = Sharp;
	OutSharp = Sharp;

	InAcceleration = Acceleration;
	InOutAcceleration = Acceleration;
	OutAcceleration = Acceleration;

	InStandard = Standard;
	InOutStandard = Standard;
	OutStandard = Standard;

	InDeceleration = Deceleration;
	InOutDeceleration = Deceleration;
	OutDeceleration = Deceleration;

	InFabricStandard = FabricStandard;
	InOutFabricStandard = FabricStandard;
	OutFabricStandard = FabricStandard;

	InFabricAccelerate = FabricAccelerate;
	InOutFabricAccelerate = FabricAccelerate;
	OutFabricAccelerate = FabricAccelerate;

	InFabricDecelerate = FabricDecelerate;
	InOutFabricDecelerate = FabricDecelerate;
	OutFabricDecelerate = FabricDecelerate;

	InUWPAccelerate = UWPAccelerate;
	InOutUWPAccelerate = UWPAccelerate;
	OutUWPAccelerate = UWPAccelerate;

	InStandardProductive = StandardProductive;
	OutStandardProductive = StandardProductive;
	InOutStandardProductive = StandardProductive;
	
	InStandardExpressive = StandardExpressive;
	OutStandardExpressive = StandardExpressive;
	InOutStandardExpressive = StandardExpressive;

	InEntranceProductive = EntranceProductive;
	OutEntranceProductive = EntranceProductive;
	InOutEntranceProductive = EntranceProductive;
	
	InEntranceExpressive = EntranceExpressive;
	OutEntranceExpressive = EntranceExpressive;
	InOutEntranceExpressive = EntranceExpressive;

	InExitProductive = ExitProductive;
	OutExitProductive = ExitProductive;
	InOutExitProductive = ExitProductive;
	
	InExitExpressive = ExitExpressive;
	OutExitExpressive = ExitExpressive;	
	InOutExitExpressive = ExitExpressive;

	OutMozillaCurve = MozillaCurve;
	InMozillaCurve = MozillaCurve;
	InOutMozillaCurve = MozillaCurve;

	InQuad = function(T)
		return T * T
	end;

	OutQuad = function(T)
		return T * (2 - T)
	end;

	InOutQuad = function(T)
		return T < 0.5 and 2 * T * T or 2 * (2 - T) * T - 1
	end;

	InCubic = function(T)
		return T * T * T
	end;

	OutCubic = function(T)
		return 1 - (1 - T) * (1 - T) * (1 - T)
	end;

	InOutCubic = function(T)
		return T < 0.5 and 4 * T * T * T or 1 + 4 * (T - 1) * (T - 1) * (T - 1)
	end;

	InQuart = function(T)
		return T * T * T * T
	end;

	OutQuart = function(T)
		T = T - 1
		return 1 - T * T * T * T
	end;

	InOutQuart = function(T)
		if T < 0.5 then
			T = T * T
			return 8 * T * T
		else
			T = T - 1
			return 1 - 8 * T * T * T * T
		end;
	end;

	InQuint = function(T)
		return T * T * T * T * T
	end;

	OutQuint = function(T)
		T = T - 1
		return T * T * T * T * T + 1
	end;

	InOutQuint = function(T)
		if T < 0.5 then
			return 16 * T * T * T * T * T
		else
			T = T - 1
			return 16 * T * T * T * T * T + 1
		end;
	end;

	InBack = function(T)
		return T * T * (3 * T - 2)
	end;

	OutBack = function(T)
		return (T - 1) * (T - 1) * (T * 2 + T - 1) + 1
	end;

	InOutBack = function(T)
		return T < 0.5 and 2 * T * T * (2 * 3 * T - 2) or 1 + 2 * (T - 1) * (T - 1) * (2 * 3 * T - 2 - 2)
	end;

	InSine = function(T)
		return 1 - math.cos(T * 1.5707963267948965579989817342720925807952880859375)
	end;

	OutSine = function(T)
		return math.sin(T * 1.5707963267948965579989817342720925807952880859375)
	end;

	InOutSine = function(T)
		return (1 - math.cos(3.141592653589793115997963468544185161590576171875 * T)) / 2
	end;

	OutBounce = OutBounce;
	InBounce = InBounce;

	InOutBounce = function(T)
		return T < 0.5 and InBounce(2 * T) / 2 or OutBounce(2 * T - 1) / 2 + 0.5
	end;

	InElastic = function(T)
		return math.exp((T * 0.9638073641881153008625915390439331531524658203125 - 1) * 8) * T *
			0.9638073641881153008625915390439331531524658203125 *
			math.sin(4 * T * 0.9638073641881153008625915390439331531524658203125) * 1.8752275007428715891677484250976704061031341552734375
	end;

	OutElastic = function(T)
		return 1 +
			(math.exp(8 * (0.9638073641881153008625915390439331531524658203125 - 0.9638073641881153008625915390439331531524658203125 * T - 1)) *
			0.9638073641881153008625915390439331531524658203125 * (T - 1) *
			math.sin(4 * 0.9638073641881153008625915390439331531524658203125 * (1 - T))) * 1.8752275007428715891677484250976704061031341552734375
	end;

	InOutElastic = function(T)
		return T < 0.5 and (math.exp(8 * (2 * 0.9638073641881153008625915390439331531524658203125 * T - 1)) * 0.9638073641881153008625915390439331531524658203125 * T * math.sin(2 * 4 * 0.9638073641881153008625915390439331531524658203125 * T)) * 1.8752275007428715891677484250976704061031341552734375
			or 1 + (math.exp(8 * (0.9638073641881153008625915390439331531524658203125 * (2 - 2 * T) - 1)) * 0.9638073641881153008625915390439331531524658203125 * (T - 1) * math.sin(4 * 0.9638073641881153008625915390439331531524658203125 * (2 - 2 * T))) * 1.8752275007428715891677484250976704061031341552734375
	end;

	InExpo = function(T)
		return T * T * math.exp(4 * (T - 1))
	end;

	OutExpo = function(T)
		return 1 - (1 - T) * (1 - T) / math.exp(4 * T)
	end;

	InOutExpo = function(T)
		return T < 0.5 and 2 * T * T * math.exp(4 * (2 * T - 1)) or 1 - 2 * (T - 1) * (T - 1) * math.exp(4 * (1 - 2 * T))
	end;

	InCirc = function(T)
		return -(math.sqrt(1 - T * T) - 1)
	end;

	OutCirc = function(T)
		T = T - 1
		return math.sqrt(1 - T * T)
	end;

	InOutCirc = function(T)
		T = T * 2
		if T < 1 then
			return -(math.sqrt(1 - T * T) - 1) / 2
		else
			T = T - 2
			return (math.sqrt(1 - T * T) - 1) / 2
		end
	end;
}, {
	__index = function(_, Index)
		error(tostring(Index) .. " is not a valid easing style.", 2)
	end;
})
