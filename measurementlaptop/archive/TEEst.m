Resolution=11;
BlankVectorThickness=3;

DiagVektor=ones(Resolution,1);

DiagVektor(1+BlankVectorThickness:end-BlankVectorThickness)=0;

DiagMatrix=diag(DiagVektor,0);

Thickness=3;

%Thickniss upwards
for i=1:Thickness/2

    DiagMatrix=DiagMatrix+diag(DiagVektor(1:end-i),i);

end

%Thickness downwards

for k=1:Thickness/2

    DiagMatrix=DiagMatrix+diag(DiagVektor(1:end-k),-k);

end

DiagMatrix=DiagMatrix+fliplr(DiagMatrix)