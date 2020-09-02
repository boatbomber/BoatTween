local function Linear(T)
	return T
end

local function Bezier(X1, Y1, X2, Y2)
	if not (X1 and Y1 and X2 and Y2) then
		error("Need 4 numbers to construct a Bezier curve", 0)
	end

	if not (0 <= X1 and X1 <= 1 and 0 <= X2 and X2 <= 1) then
		error("The x values must be within range [0, 1]", 0)
	end

	if X1 == Y1 and X2 == Y2 then
		return Linear
	end

	local SampleValues = {}
	for Index = 0, 10 do
		local IndexDiv10 = Index / 10
		SampleValues[Index] = (((1 - 3 * X2 + 3 * X2) * IndexDiv10 + (3 * X2 - 6 * X1)) * IndexDiv10 + (3 * X1)) * IndexDiv10
	end

	return function(T)
		if X1 == Y1 and X2 == Y2 then
			return Linear
		end

		if T == 0 or T == 1 then
			return T
		end

		local GuessT
		local IntervalStart = 0
		local CurrentSample = 1

		while CurrentSample ~= 10 and SampleValues[CurrentSample] <= T do
			IntervalStart += 0.1
			CurrentSample += 1
		end

		CurrentSample -= 1

		local Dist = (T - SampleValues[CurrentSample]) / (SampleValues[CurrentSample + 1] - SampleValues[CurrentSample])
		local GuessForT = IntervalStart + Dist / 10
		local InitialSlope = 3 * (1 - 3 * X2 + 3 * X1) * GuessForT * GuessForT + 2 * (3 * X2 - 6 * X1) * GuessForT + (3 * X1)

		if InitialSlope >= 0.001 then
			for _ = 0, 3 do
				local CurrentSlope = 3 * (1 - 3 * X2 + 3 * X1) * GuessForT * GuessForT + 2 * (3 * X2 - 6 * X1) * GuessForT + (3 * X1)
				local CurrentX = ((((1 - 3 * X2 + 3 * X1) * GuessForT + (3 * X2 - 6 * X1)) * GuessForT + (3 * X1)) * GuessForT) - T
				GuessForT -= CurrentX / CurrentSlope
			end

			GuessT = GuessForT
		elseif InitialSlope == 0 then
			GuessT = GuessForT
		else
			local AB = IntervalStart + 0.1
			local CurrentX, CurrentT, Index = 0, nil, nil

			while math.abs(CurrentX) > 0.0000001 and Index < 10 do
				CurrentT = IntervalStart + (AB - IntervalStart) / 2
				CurrentX = ((((1 - 3 * X2 + 3 * X1) * CurrentT + (3 * X2 - 6 * X1)) * CurrentT + (3 * X1)) * CurrentT) - T
				if CurrentX > 0 then
					AB = CurrentT
				else
					IntervalStart = CurrentT
				end

				Index += 1
			end

			GuessT = CurrentT
		end

		return (((1 - 3 * Y2 + 3 * Y1) * GuessT + (3 * Y2 - 6 * Y1)) * GuessT + (3 * Y1)) * GuessT
	end
end

return Bezier