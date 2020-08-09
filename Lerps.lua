local ipairs = ipairs

local BLACK_COLOR3 = Color3.new()

-- Generic Roblox DataType lerp function.
local function RobloxLerp(V0, V1)
	return function(DeltaTime)
		return V0:Lerp(V1, DeltaTime)
	end
end

local function Lerp(Start, Finish, Alpha)
	return Start + Alpha * (Finish - Start)
end

local function SortByTime(a, b)
	return a.Time < b.Time
end

local Lerps = setmetatable({
	boolean = function(V0, V1)
		return function(DeltaTime)
			if DeltaTime < 0.5 then
				return V0
			else
				return V1
			end
		end
	end;

	number = function(V0, V1)
		local Delta = V1 - V0
		return function(DeltaTime)
			return V0 + Delta * DeltaTime
		end
	end;

	CFrame = RobloxLerp;
	Color3 = function(C0, C1)
		local L0, U0, V0
		local R0, G0, B0 = C0.R, C0.G, C0.B
		R0 = R0 < 0.0404482362771076 and R0 / 12.92 or 0.87941546140213 * (R0 + 0.055) ^ 2.4
		G0 = G0 < 0.0404482362771076 and G0 / 12.92 or 0.87941546140213 * (G0 + 0.055) ^ 2.4
		B0 = B0 < 0.0404482362771076 and B0 / 12.92 or 0.87941546140213 * (B0 + 0.055) ^ 2.4

		local Y0 = 0.2125862307855956 * R0 + 0.71517030370341085 * G0 + 0.0722004986433362 * B0
		local Z0 = 3.6590806972265883 * R0 + 11.4426895800574232 * G0 + 4.1149915024264843 * B0
		local _L0 = Y0 > 0.008856451679035631 and 116 * Y0 ^ (1 / 3) - 16 or 903.296296296296 * Y0

		if Z0 > 0.0000000000000010000000000000001 then
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

		if Z1 > 0.0000000000000010000000000000001 then -- 1E-15
			local X = 0.9257063972951867 * R1 - 0.8333736323779866 * G1 - 0.09209820666085898 * B1
			L1, U1, V1 = _L1, _L1 * X / Z1, _L1 * (9 * Y1 / Z1 - 0.46832)
		else
			L1, U1, V1 = _L1, -0.19783 * _L1, -0.46832 * _L1
		end

		return function(DeltaTime)
			local L = (1 - DeltaTime) * L0 + DeltaTime * L1
			if L < 0.0197955 then
				return BLACK_COLOR3
			end

			local U = ((1 - DeltaTime) * U0 + DeltaTime * U1) / L + 0.19783
			local V = ((1 - DeltaTime) * V0 + DeltaTime * V1) / L + 0.46832

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

			R = R < 0.0031306684424999998 and 12.92 * R or 1.055 * R ^ (1 / 2.4) - 0.055 -- 3.1306684425E-3
			G = G < 0.0031306684424999998 and 12.92 * G or 1.055 * G ^ (1 / 2.4) - 0.055
			B = B < 0.0031306684424999998 and 12.92 * B or 1.055 * B ^ (1 / 2.4) - 0.055

			return Color3.new(
				R > 1 and 1 or R < 0 and 0 or R,
				G > 1 and 1 or G < 0 and 0 or G,
				B > 1 and 1 or B < 0 and 0 or B
			)
		end
	end;

	NumberRange = function(V0, V1)
		local Min0, Max0 = V0.Min, V0.Max
		local DeltaMin, DeltaMax = V1.Min - Min0, V1.Max - Max0

		return function(DeltaTime)
			return NumberRange.new(Min0 + DeltaTime * DeltaMin, Max0 + DeltaTime * DeltaMax)
		end
	end;

	NumberSequenceKeypoint = function(Start, End)
		local T0, V0, E0 = Start.Time, Start.Value, Start.Envelope
		local DT, DV, DE = End.Time - T0, End.Value - V0, End.Envelope - E0

		return function(DeltaTime)
			return NumberSequenceKeypoint.new(T0 + DeltaTime * DT, V0 + DeltaTime * DV, E0 + DeltaTime * DE)
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

		return function(DeltaTime)
			return PhysicalProperties.new(
				D0 + DeltaTime * DD,
				E0 + DeltaTime * DE, EW0 + DeltaTime * DEW,
				F0 + DeltaTime * DF, FW0 + DeltaTime * DFW
			)
		end
	end;

	Ray = function(V0, V1)
		local O0, D0, O1, D1 = V0.Origin, V0.Direction, V1.Origin, V1.Direction
		local OX0, OY0, OZ0, DX0, DY0, DZ0 = O0.X, O0.Y, O0.Z, D0.X, D0.Y, D0.Z
		local DOX, DOY, DOZ, DDX, DDY, DDZ = O1.X - OX0, O1.Y - OY0, O1.Z - OZ0, D1.X - DX0, D1.Y - DY0, D1.Z - DZ0

		return function(DeltaTime)
			return Ray.new(
				Vector3.new(OX0 + DeltaTime * DOX, OY0 + DeltaTime * DOY, OZ0 + DeltaTime * DOZ),
				Vector3.new(DX0 + DeltaTime * DDX, DY0 + DeltaTime * DDY, DZ0 + DeltaTime * DDZ)
			)
		end
	end;

	UDim = function(V0, V1)
		local SC, OF = V0.Scale, V0.Offset
		local DSC, DOF = V1.Scale - SC, V1.Offset - OF

		return function(DeltaTime)
			return UDim.new(SC + DeltaTime * DSC, OF + DeltaTime * DOF)
		end
	end;

	UDim2 = RobloxLerp;
	Vector2 = RobloxLerp;
	Vector3 = RobloxLerp;
	Rect = function(V0, V1)
		return function(DeltaTime)
			return Rect.new(
				V0.Min.X + DeltaTime * (V1.Min.X - V0.Min.X), V0.Min.Y + DeltaTime * (V1.Min.Y - V0.Min.Y),
				V0.Max.X + DeltaTime * (V1.Max.X - V0.Max.X), V0.Max.Y + DeltaTime * (V1.Max.Y - V0.Max.Y)
			)
		end
	end;

	Region3 = function(V0, V1)
		return function(DeltaTime)
			local imin = Lerp(V0.CFrame * (-V0.Size / 2), V1.CFrame * (-V1.Size / 2), DeltaTime)
			local imax = Lerp(V0.CFrame * (V0.Size / 2), V1.CFrame * (V1.Size / 2), DeltaTime)

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
		return function(DeltaTime)
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

				local interValue = (bValue - ap.Value) * DeltaTime + ap.Value
				local interEnvelope = (bEnvelope - ap.Envelope) * DeltaTime + ap.Envelope
				local interp = NumberSequenceKeypoint.new(ap.Time, interValue, interEnvelope)

				keylength = keylength + 1
				keypoints[keylength] = interp
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

					local interValue = (bp.Value - aValue) * DeltaTime + aValue
					local interEnvelope = (bp.Envelope - aEnvelope) * DeltaTime + aEnvelope
					local interp = NumberSequenceKeypoint.new(bp.Time, interValue, interEnvelope)

					keylength = keylength + 1
					keypoints[keylength] = interp
				end
			end

			table.sort(keypoints, SortByTime)
			return NumberSequence.new(keypoints)
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
