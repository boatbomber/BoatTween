local ipairs = ipairs
local BLACK_COLOR3 = Color3.new()

-- Generic Roblox DataType lerp function.
local function RobloxLerp(V0, V1)
	return function(Alpha)
		return V0:Lerp(V1, Alpha)
	end
end

local function Lerp(Start, Finish, Alpha)
	return Start + Alpha * (Finish - Start)
end

local function SortByTime(A, B)
	return A.Time < B.Time
end

local function Color3Lerp(C0, C1)
	local L0, U0, V0
	local R0, G0, B0 = C0.R, C0.G, C0.B
	R0 = R0 < 0.0404482362771076 and R0 / 12.92 or 0.87941546140213 * (R0 + 0.055) ^ 2.4
	G0 = G0 < 0.0404482362771076 and G0 / 12.92 or 0.87941546140213 * (G0 + 0.055) ^ 2.4
	B0 = B0 < 0.0404482362771076 and B0 / 12.92 or 0.87941546140213 * (B0 + 0.055) ^ 2.4

	local Y0 = 0.2125862307855956 * R0 + 0.71517030370341085 * G0 + 0.0722004986433362 * B0
	local Z0 = 3.6590806972265883 * R0 + 11.4426895800574232 * G0 + 4.1149915024264843 * B0
	local _L0 = Y0 > 0.008856451679035631 and 116 * Y0 ^ (1 / 3) - 16 or 903.296296296296 * Y0

	if Z0 > 1E-15 then
		local X = 0.9257063972951867 * R0 - 0.8333736323779866 * G0 - 0.09209820666085898 * B0
		L0, U0, V0 = _L0, _L0 * X / Z0, _L0 * (9 * Y0 / Z0 - 0.46832)
	else
		L0, U0, V0 = _L0, -0.19783 * _L0, -0.46832 * _L0
	end

	local L1, U1, V1
	local R1, G1, B1 = C1.R, C1.G, C1.B
	R1 = R1 < 0.0404482362771076 and R1 / 12.92 or 0.87941546140213 * (R1 + 0.055) ^ 2.4
	G1 = G1 < 0.0404482362771076 and G1 / 12.92 or 0.87941546140213 * (G1 + 0.055) ^ 2.4
	B1 = B1 < 0.0404482362771076 and B1 / 12.92 or 0.87941546140213 * (B1 + 0.055) ^ 2.4

	local Y1 = 0.2125862307855956 * R1 + 0.71517030370341085 * G1 + 0.0722004986433362 * B1
	local Z1 = 3.6590806972265883 * R1 + 11.4426895800574232 * G1 + 4.1149915024264843 * B1
	local _L1 = Y1 > 0.008856451679035631 and 116 * Y1 ^ (1 / 3) - 16 or 903.296296296296 * Y1

	if Z1 > 1E-15 then
		local X = 0.9257063972951867 * R1 - 0.8333736323779866 * G1 - 0.09209820666085898 * B1
		L1, U1, V1 = _L1, _L1 * X / Z1, _L1 * (9 * Y1 / Z1 - 0.46832)
	else
		L1, U1, V1 = _L1, -0.19783 * _L1, -0.46832 * _L1
	end

	return function(Alpha)
		local L = (1 - Alpha) * L0 + Alpha * L1
		if L < 0.0197955 then
			return BLACK_COLOR3
		end

		local U = ((1 - Alpha) * U0 + Alpha * U1) / L + 0.19783
		local V = ((1 - Alpha) * V0 + Alpha * V1) / L + 0.46832

		local Y = (L + 16) / 116
		Y = Y > 0.206896551724137931 and Y * Y * Y or 0.12841854934601665 * Y - 0.01771290335807126
		local X = Y * U / V
		local Z = Y * ((3 - 0.75 * U) / V - 5)

		local R = 7.2914074 * X - 1.5372080 * Y - 0.4986286 * Z
		local G = -2.1800940 * X + 1.8757561 * Y + 0.0415175 * Z
		local B = 0.1253477 * X - 0.2040211 * Y + 1.0569959 * Z

		if R < 0 and R < G and R < B then
			R, G, B = 0, G - R, B - R
		elseif G < 0 and G < B then
			R, G, B = R - G, 0, B - G
		elseif B < 0 then
			R, G, B = R - B, G - B, 0
		end

		R = R < 3.1306684425E-3 and 12.92 * R or 1.055 * R ^ (1 / 2.4) - 0.055 -- 3.1306684425E-3
		G = G < 3.1306684425E-3 and 12.92 * G or 1.055 * G ^ (1 / 2.4) - 0.055
		B = B < 3.1306684425E-3 and 12.92 * B or 1.055 * B ^ (1 / 2.4) - 0.055

		R = R > 1 and 1 or R < 0 and 0 or R
		G = G > 1 and 1 or G < 0 and 0 or G
		B = B > 1 and 1 or B < 0 and 0 or B

		return Color3.new(R, G, B)
	end
end

local Lerps = setmetatable({
	boolean = function(V0, V1)
		return function(Alpha)
			if Alpha < 0.5 then
				return V0
			else
				return V1
			end
		end
	end;

	number = function(V0, V1)
		local Delta = V1 - V0
		return function(Alpha)
			return V0 + Delta * Alpha
		end
	end;

	string = function(V0, V1)
		local RegularString = false

		local N0, D do
			local Sign0, H0, M0, S0 = string.match(V0, "^([+-]?)(%d*):[+-]?(%d*):[+-]?(%d*)$")
			local Sign1, H1, M1, S1 = string.match(V1, "^([+-]?)(%d*):[+-]?(%d*):[+-]?(%d*)$")
			if Sign0 and Sign1 then
				N0 = 3600 * (tonumber(H0) or 0) + 60 * (tonumber(M0) or 0) + (tonumber(S0) or 0)
				local N1 = 3600 * (tonumber(H1) or 0) + 60 * (tonumber(M1) or 0) + (tonumber(S1) or 0)
				if Sign0 == "-" then
					N0 = -N0
				end

				D = (43200 + (Sign1 ~= "-" and N1 or -N1) - N0) % 86400 - 43200
			else
				RegularString = true
			end
		end

		if RegularString then
			local Length = #V1
			return function(Alpha)
				Alpha = 1 + Length * Alpha
				return string.sub(V1, 1, Alpha < Length and Alpha or Length)
			end
		else
			return function(Alpha)
				local FS = (N0 + D * Alpha) % 86400
				local S = math.abs(FS)
				return string.format(
					FS < 0 and "-%.2u:%.2u:%.2u" or "%.2u:%.2u:%.2u",
					(S - S % 3600) / 3600,
					(S % 3600 - S % 60) / 60,
					S % 60
				)
			end
		end
	end;

	CFrame = RobloxLerp;
	Color3 = Color3Lerp;
	NumberRange = function(V0, V1)
		local Min0, Max0 = V0.Min, V0.Max
		local DeltaMin, DeltaMax = V1.Min - Min0, V1.Max - Max0

		return function(Alpha)
			return NumberRange.new(Min0 + Alpha * DeltaMin, Max0 + Alpha * DeltaMax)
		end
	end;

	NumberSequenceKeypoint = function(V0, V1)
		local T0, Value0, E0 = V0.Time, V0.Value, V0.Envelope
		local DT, DV, DE = V1.Time - T0, V1.Value - Value0, V1.Envelope - E0

		return function(Alpha)
			return NumberSequenceKeypoint.new(T0 + Alpha * DT, Value0 + Alpha * DV, E0 + Alpha * DE)
		end
	end;

	PhysicalProperties = function(V0, V1)
		local D0, E0, EW0, F0, FW0 =
			V0.Density, V0.Elasticity,
			V0.ElasticityWeight, V0.Friction,
			V0.FrictionWeight

		local DD, DE, DEW, DF, DFW =
			V1.Density - D0, V1.Elasticity - E0,
			V1.ElasticityWeight - EW0, V1.Friction - F0,
			V1.FrictionWeight - FW0

		return function(Alpha)
			return PhysicalProperties.new(
				D0 + Alpha * DD,
				E0 + Alpha * DE, EW0 + Alpha * DEW,
				F0 + Alpha * DF, FW0 + Alpha * DFW
			)
		end
	end;

	Ray = function(V0, V1)
		local O0, D0, O1, D1 = V0.Origin, V0.Direction, V1.Origin, V1.Direction
		local OX0, OY0, OZ0, DX0, DY0, DZ0 = O0.X, O0.Y, O0.Z, D0.X, D0.Y, D0.Z
		local DOX, DOY, DOZ, DDX, DDY, DDZ = O1.X - OX0, O1.Y - OY0, O1.Z - OZ0, D1.X - DX0, D1.Y - DY0, D1.Z - DZ0

		return function(Alpha)
			return Ray.new(
				Vector3.new(OX0 + Alpha * DOX, OY0 + Alpha * DOY, OZ0 + Alpha * DOZ),
				Vector3.new(DX0 + Alpha * DDX, DY0 + Alpha * DDY, DZ0 + Alpha * DDZ)
			)
		end
	end;

	UDim = function(V0, V1)
		local SC, OF = V0.Scale, V0.Offset
		local DSC, DOF = V1.Scale - SC, V1.Offset - OF

		return function(Alpha)
			return UDim.new(SC + Alpha * DSC, OF + Alpha * DOF)
		end
	end;

	UDim2 = RobloxLerp;
	Vector2 = RobloxLerp;
	Vector3 = RobloxLerp;
	Rect = function(V0, V1)
		return function(Alpha)
			return Rect.new(
				V0.Min.X + Alpha * (V1.Min.X - V0.Min.X), V0.Min.Y + Alpha * (V1.Min.Y - V0.Min.Y),
				V0.Max.X + Alpha * (V1.Max.X - V0.Max.X), V0.Max.Y + Alpha * (V1.Max.Y - V0.Max.Y)
			)
		end
	end;

	Region3 = function(V0, V1)
		return function(Alpha)
			local imin = Lerp(V0.CFrame * (-V0.Size / 2), V1.CFrame * (-V1.Size / 2), Alpha)
			local imax = Lerp(V0.CFrame * (V0.Size / 2), V1.CFrame * (V1.Size / 2), Alpha)

			local iminx = imin.X
			local imaxx = imax.X
			local iminy = imin.Y
			local imaxy = imax.Y
			local iminz = imin.Z
			local imaxz = imax.Z

			return Region3.new(
				Vector3.new(iminx < imaxx and iminx or imaxx, iminy < imaxy and iminy or imaxy, iminz < imaxz and iminz or imaxz),
				Vector3.new(iminx > imaxx and iminx or imaxx, iminy > imaxy and iminy or imaxy, iminz > imaxz and iminz or imaxz)
			)
		end
	end;

	NumberSequence = function(V0, V1)
		return function(Alpha)
			local keypoints = {}
			local addedTimes = {}
			local keylength = 0

			for _, ap in ipairs(V0.Keypoints) do
				local closestAbove, closestBelow

				for _, bp in ipairs(V1.Keypoints) do
					if bp.Time == ap.Time then
						closestAbove, closestBelow = bp, bp
						break
					elseif bp.Time < ap.Time and (closestBelow == nil or bp.Time > closestBelow.Time) then
						closestBelow = bp
					elseif bp.Time > ap.Time and (closestAbove == nil or bp.Time < closestAbove.Time) then
						closestAbove = bp
					end
				end

				local bValue, bEnvelope
				if closestAbove == closestBelow then
					bValue, bEnvelope = closestAbove.Value, closestAbove.Envelope
				else
					local p = (ap.Time - closestBelow.Time) / (closestAbove.Time - closestBelow.Time)
					bValue = (closestAbove.Value - closestBelow.Value) * p + closestBelow.Value
					bEnvelope = (closestAbove.Envelope - closestBelow.Envelope) * p + closestBelow.Envelope
				end

				keylength += 1
				keypoints[keylength] = NumberSequenceKeypoint.new(ap.Time, (bValue - ap.Value) * Alpha + ap.Value, (bEnvelope - ap.Envelope) * Alpha + ap.Envelope)
				addedTimes[ap.Time] = true
			end

			for _, bp in ipairs(V1.Keypoints) do
				if not addedTimes[bp.Time] then
					local closestAbove, closestBelow

					for _, ap in ipairs(V0.Keypoints) do
						if ap.Time == bp.Time then
							closestAbove, closestBelow = ap, ap
							break
						elseif ap.Time < bp.Time and (closestBelow == nil or ap.Time > closestBelow.Time) then
							closestBelow = ap
						elseif ap.Time > bp.Time and (closestAbove == nil or ap.Time < closestAbove.Time) then
							closestAbove = ap
						end
					end

					local aValue, aEnvelope
					if closestAbove == closestBelow then
						aValue, aEnvelope = closestAbove.Value, closestAbove.Envelope
					else
						local p = (bp.Time - closestBelow.Time) / (closestAbove.Time - closestBelow.Time)
						aValue = (closestAbove.Value - closestBelow.Value) * p + closestBelow.Value
						aEnvelope = (closestAbove.Envelope - closestBelow.Envelope) * p + closestBelow.Envelope
					end

					keylength += 1
					keypoints[keylength] = NumberSequenceKeypoint.new(bp.Time, (bp.Value - aValue) * Alpha + aValue, (bp.Envelope - aEnvelope) * Alpha + aEnvelope)
				end
			end

			table.sort(keypoints, SortByTime)
			return NumberSequence.new(keypoints)
		end
	end;

	ColorSequence = function(V0, V1)
		return function(Alpha)
			local keypoints = {}
			local addedTimes = {}
			local keylength = 0

			for _, ap in ipairs(V0.Keypoints) do
				local closestAbove, closestBelow

				for _, bp in ipairs(V1.Keypoints) do
					if bp.Time == ap.Time then
						closestAbove, closestBelow = bp, bp
						break
					elseif bp.Time < ap.Time and (closestBelow == nil or bp.Time > closestBelow.Time) then
						closestBelow = bp
					elseif bp.Time > ap.Time and (closestAbove == nil or bp.Time < closestAbove.Time) then
						closestAbove = bp
					end
				end

				local bValue
				if closestAbove == closestBelow then
					bValue = closestAbove.Value
				else
					bValue = Color3Lerp(closestBelow.Value, closestAbove.Value)((ap.Time - closestBelow.Time) / (closestAbove.Time - closestBelow.Time))
				end

				keylength += 1
				keypoints[keylength] = ColorSequenceKeypoint.new(ap.Time, Color3Lerp(ap.Value, bValue)(Alpha))
				addedTimes[ap.Time] = true
			end

			for _, bp in ipairs(V1.Keypoints) do
				if not addedTimes[bp.Time] then
					local closestAbove, closestBelow

					for _, ap in ipairs(V0.Keypoints) do
						if ap.Time == bp.Time then
							closestAbove, closestBelow = ap, ap
							break
						elseif ap.Time < bp.Time and (closestBelow == nil or ap.Time > closestBelow.Time) then
							closestBelow = ap
						elseif ap.Time > bp.Time and (closestAbove == nil or ap.Time < closestAbove.Time) then
							closestAbove = ap
						end
					end

					local aValue
					if closestAbove == closestBelow then
						aValue = closestAbove.Value
					else
						aValue = Color3Lerp(closestBelow.Value, closestAbove.Value)((bp.Time - closestBelow.Time) / (closestAbove.Time - closestBelow.Time))
					end

					keylength += 1
					keypoints[keylength] = ColorSequenceKeypoint.new(bp.Time, Color3Lerp(bp.Value, aValue)(Alpha))
				end
			end

			table.sort(keypoints, SortByTime)
			return ColorSequence.new(keypoints)
		end
	end;
}, {
	__index = function(_, Index)
		error("No lerp function is defined for type " .. tostring(Index) .. ".", 4)
	end;

	__newindex = function(_, Index)
		error("No lerp function is defined for type " .. tostring(Index) .. ".", 4)
	end;
})

return Lerps