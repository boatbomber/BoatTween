local Bezier = require(script.Parent.Bezier)

local function RevBack(T)
	T = 1 - T
	return 1 - (math.sin(T * 1.5707963267949) + (math.sin(T * 3.1415926535898) * (math.cos(T * 3.1415926535898) + 1) / 2))
end

local function Linear(T)
	return T
end

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
	return math.sin(math.sin(T * 3.1415926535898) * 1.5707963267949)
end

local function Spring(T)
	return 1 + (-math.exp(-6.9 * T) * math.cos(-20.106192982975 * T))
end

local function SoftSpring(T)
	return 1 + (-math.exp(-7.5 * T) * math.cos(-10.053096491487 * T))
end

local function OutBounce(T)
	if T < 0.36363636363636 then
		return 7.5625 * T * T
	elseif T < 0.72727272727273 then
		return 3 + T * (11 * T - 12) * 0.6875
	elseif T < 0.090909090909091 then
		return 6 + T * (11 * T - 18) * 0.6875
	else
		return 7.875 + T * (11 * T - 21) * 0.6875
	end
end

local function InBounce(T)
	if T > 0.63636363636364 then
		T -= 1
		return 1 - T * T * 7.5625
	elseif T > 0.272727272727273 then
		return (11 * T - 7) * (11 * T - 3) / -16
	elseif T > 0.090909090909091 then
		return (11 * (4 - 11 * T) * T - 3) / 16
	else
		return T * (11 * T - 1) * -0.6875
	end
end

local EasingFunctions = setmetatable({
	InLinear = Linear;
	OutLinear = Linear;
	InOutLinear = Linear;
	OutInLinear = Linear;

	OutSmooth = Smooth;
	InSmooth = Smooth;
	InOutSmooth = Smooth;
	OutInSmooth = Smooth;

	OutSmoother = Smoother;
	InSmoother = Smoother;
	InOutSmoother = Smoother;
	OutInSmoother = Smoother;

	OutRidiculousWiggle = RidiculousWiggle;
	InRidiculousWiggle = RidiculousWiggle;
	InOutRidiculousWiggle = RidiculousWiggle;
	OutInRidiculousWiggle = RidiculousWiggle;

	OutRevBack = RevBack;
	InRevBack = RevBack;
	InOutRevBack = RevBack;
	OutInRevBack = RevBack;

	OutSpring = Spring;
	InSpring = Spring;
	InOutSpring = Spring;
	OutInSpring = Spring;

	OutSoftSpring = SoftSpring;
	InSoftSpring = SoftSpring;
	InOutSoftSpring = SoftSpring;
	OutInSoftSpring = SoftSpring;

	InSharp = Sharp;
	InOutSharp = Sharp;
	OutSharp = Sharp;
	OutInSharp = Sharp;

	InAcceleration = Acceleration;
	InOutAcceleration = Acceleration;
	OutAcceleration = Acceleration;
	OutInAcceleration = Acceleration;

	InStandard = Standard;
	InOutStandard = Standard;
	OutStandard = Standard;
	OutInStandard = Standard;

	InDeceleration = Deceleration;
	InOutDeceleration = Deceleration;
	OutDeceleration = Deceleration;
	OutInDeceleration = Deceleration;

	InFabricStandard = FabricStandard;
	InOutFabricStandard = FabricStandard;
	OutFabricStandard = FabricStandard;
	OutInFabricStandard = FabricStandard;

	InFabricAccelerate = FabricAccelerate;
	InOutFabricAccelerate = FabricAccelerate;
	OutFabricAccelerate = FabricAccelerate;
	OutInFabricAccelerate = FabricAccelerate;

	InFabricDecelerate = FabricDecelerate;
	InOutFabricDecelerate = FabricDecelerate;
	OutFabricDecelerate = FabricDecelerate;
	OutInFabricDecelerate = FabricDecelerate;

	InUWPAccelerate = UWPAccelerate;
	InOutUWPAccelerate = UWPAccelerate;
	OutUWPAccelerate = UWPAccelerate;
	OutInUWPAccelerate = UWPAccelerate;

	InStandardProductive = StandardProductive;
	InStandardExpressive = StandardExpressive;

	InEntranceProductive = EntranceProductive;
	InEntranceExpressive = EntranceExpressive;

	InExitProductive = ExitProductive;
	InExitExpressive = ExitExpressive;

	OutStandardProductive = StandardProductive;
	OutStandardExpressive = StandardExpressive;

	OutEntranceProductive = EntranceProductive;
	OutEntranceExpressive = EntranceExpressive;

	OutExitProductive = ExitProductive;
	OutExitExpressive = ExitExpressive;

	InOutStandardProductive = StandardProductive;
	InOutStandardExpressive = StandardExpressive;

	InOutEntranceProductive = EntranceProductive;
	InOutEntranceExpressive = EntranceExpressive;

	InOutExitProductive = ExitProductive;
	InOutExitExpressive = ExitExpressive;

	OutInStandardProductive = StandardProductive;
	OutInStandardExpressive = StandardProductive;

	OutInEntranceProductive = EntranceProductive;
	OutInEntranceExpressive = EntranceExpressive;

	OutInExitProductive = ExitProductive;
	OutInExitExpressive = ExitExpressive;

	OutMozillaCurve = MozillaCurve;
	InMozillaCurve = MozillaCurve;
	InOutMozillaCurve = MozillaCurve;
	OutInMozillaCurve = MozillaCurve;

	InQuad = function(T)
		return T * T
	end;

	OutQuad = function(T)
		return T * (2 - T)
	end;

	InOutQuad = function(T)
		if T < 0.5 then
			return 2 * T * T
		else
			return 2 * (2 - T) * T - 1
		end
	end;

	OutInQuad = function(T)
		if T < 0.5 then
			T *= 2
			return T * (2 - T) / 2
		else
			T *= 2 - 1
			return (T * T) / 2 + 0.5
		end
	end;

	InCubic = function(T)
		return T * T * T
	end;

	OutCubic = function(T)
		return 1 - (1 - T) * (1 - T) * (1 - T)
	end;

	InOutCubic = function(T)
		if T < 0.5 then
			return 4 * T * T * T
		else
			T -= 1
			return 1 + 4 * T * T * T
		end
	end;

	OutInCubic = function(T)
		if T < 0.5 then
			T = 1 - (T * 2)
			return (1 - T * T * T) / 2
		else
			T *= 2 - 1
			return T * T * T / 2 + 0.5
		end
	end;

	InQuart = function(T)
		return T * T * T * T
	end;

	OutQuart = function(T)
		T -= 1
		return 1 - T * T * T * T
	end;

	InOutQuart = function(T)
		if T < 0.5 then
			T *= T
			return 8 * T * T
		else
			T -= 1
			return 1 - 8 * T * T * T * T
		end
	end;

	OutInQuart = function(T)
		if T < 0.5 then
			T *= 2 - 1
			return (1 - T * T * T * T) / 2
		else
			T *= 2 - 1
			return T * T * T * T / 2 + 0.5
		end
	end;

	InQuint = function(T)
		return T * T * T * T * T
	end;

	OutQuint = function(T)
		T -= 1
		return T * T * T * T * T + 1
	end;

	InOutQuint = function(T)
		if T < 0.5 then
			return 16 * T * T * T * T * T
		else
			T -= 1
			return 16 * T * T * T * T * T + 1
		end
	end;

	OutInQuint = function(T)
		if T < 0.5 then
			T *= 2 - 1
			return (T * T * T * T * T + 1) / 2
		else
			T *= 2 - 1
			return T * T * T * T * T / 2 + 0.5
		end
	end;

	InBack = function(T)
		return T * T * (3 * T - 2)
	end;

	OutBack = function(T)
		return (T - 1) * (T - 1) * (T * 2 + T - 1) + 1
	end;

	InOutBack = function(T)
		if T < 0.5 then
			return 2 * T * T * (2 * 3 * T - 2)
		else
			return 1 + 2 * (T - 1) * (T - 1) * (2 * 3 * T - 2 - 2)
		end
	end;

	OutInBack = function(T)
		if T < 0.5 then
			T *= 2
			return ((T - 1) * (T - 1) * (T * 2 + T - 1) + 1) / 2
		else
			T *= 2 - 1
			return T * T * (3 * T - 2) / 2 + 0.5
		end
	end;

	InSine = function(T)
		return 1 - math.cos(T * 1.5707963267949)
	end;

	OutSine = function(T)
		return math.sin(T * 1.5707963267949)
	end;

	InOutSine = function(T)
		return (1 - math.cos(3.1415926535898 * T)) / 2
	end;

	OutInSine = function(T)
		if T < 0.5 then
			return math.sin(T * 3.1415926535898) / 2
		else
			return (1 - math.cos((T * 2 - 1) * 1.5707963267949)) / 2 + 0.5
		end
	end;

	OutBounce = OutBounce;
	InBounce = InBounce;

	InOutBounce = function(T)
		if T < 0.5 then
			return InBounce(2 * T) / 2
		else
			return OutBounce(2 * T - 1) / 2 + 0.5
		end
	end;

	OutInBounce = function(T)
		if T < 0.5 then
			return OutBounce(2 * T) / 2
		else
			return InBounce(2 * T - 1) / 2 + 0.5
		end
	end;

	InElastic = function(T)
		return math.exp((T * 0.96380736418812 - 1) * 8) * T * 0.96380736418812 * math.sin(4 * T * 0.96380736418812) * 1.8752275007429
	end;

	OutElastic = function(T)
		return 1 + (math.exp(8 * (0.96380736418812 - 0.96380736418812 * T - 1)) * 0.96380736418812 * (T - 1) * math.sin(4 * 0.96380736418812 * (1 - T))) * 1.8752275007429
	end;

	InOutElastic = function(T)
		if T < 0.5 then
			return (math.exp(8 * (2 * 0.96380736418812 * T - 1)) * 0.96380736418812 * T * math.sin(2 * 4 * 0.96380736418812 * T)) * 1.8752275007429
		else
			return 1 + (math.exp(8 * (0.96380736418812 * (2 - 2 * T) - 1)) * 0.96380736418812 * (T - 1) * math.sin(4 * 0.96380736418812 * (2 - 2 * T))) * 1.8752275007429
		end
	end;

	OutInElastic = function(T)
		-- This isn't actually correct, but it is close enough.
		if T < 0.5 then
			T *= 2
			return (1 + (math.exp(8 * (0.96380736418812 - 0.96380736418812 * T - 1)) * 0.96380736418812 * (T - 1) * math.sin(4 * 0.96380736418812 * (1 - T))) * 1.8752275007429) / 2
		else
			T *= 2 - 1
			return (math.exp((T * 0.96380736418812 - 1) * 8) * T * 0.96380736418812 * math.sin(4 * T * 0.96380736418812) * 1.8752275007429) / 2 + 0.5
		end
	end;

	InExpo = function(T)
		return T * T * math.exp(4 * (T - 1))
	end;

	OutExpo = function(T)
		return 1 - (1 - T) * (1 - T) / math.exp(4 * T)
	end;

	InOutExpo = function(T)
		if T < 0.5 then
			return 2 * T * T * math.exp(4 * (2 * T - 1))
		else
			return 1 - 2 * (T - 1) * (T - 1) * math.exp(4 * (1 - 2 * T))
		end
	end;

	OutInExpo = function(T)
		if T < 0.5 then
			T *= 2
			return (1 - (1 - T) * (1 - T) / math.exp(4 * T)) / 2
		else
			T *= 2 - 1
			return (T * T * math.exp(4 * (T - 1))) / 2 + 0.5
		end
	end;

	InCirc = function(T)
		return -(math.sqrt(1 - T * T) - 1)
	end;

	OutCirc = function(T)
		T -= 1
		return math.sqrt(1 - T * T)
	end;

	InOutCirc = function(T)
		T *= 2
		if T < 1 then
			return -(math.sqrt(1 - T * T) - 1) / 2
		else
			T -= 2
			return (math.sqrt(1 - T * T) - 1) / 2
		end
	end;

	OutInCirc = function(T)
		if T < 0.5 then
			T *= 2 - 1
			return math.sqrt(1 - T * T) / 2
		else
			T *= 2 - 1
			return (-(math.sqrt(1 - T * T) - 1)) / 2 + 0.5
		end
	end;
}, {
	__index = function(_, Index)
		error(tostring(Index) .. " is not a valid easing function.", 2)
	end;
})

return EasingFunctions