function OptimalFlipAngle = ErnstAngle(TRinms,FieldStrengthinTesla)
%ERNSTANGLE Summary of this function goes here
%   Detailed explanation goes here

if FieldStrengthinTesla==7
    T1=1900;
elseif FieldStrengthinTesla==3
   display('T1 not known!')
else
    display('T1 not known!')
end

OptimalFlipAngle=acosd(exp(-TRinms/T1));

end

