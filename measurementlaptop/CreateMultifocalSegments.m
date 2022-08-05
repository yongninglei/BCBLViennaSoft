function [ window ] = CreateMultifocalSegments(BlinkingSegments,m,n,bk)
%CREATESTIMULI Summary of this function goes here
%   Detailed explanation goes here



%m=1024;
%n=1024;

outerRad=10.2049;
%outerRad=10;

[x,y]=meshgrid(linspace(-outerRad,outerRad,n),linspace(outerRad,-outerRad,m));

% r = eccentricity; theta = polar angle
r = sqrt (x.^2  + y.^2);
theta = atan2 (y, x);					% atan2 returns values between -pi and pi
theta(theta<0) = theta(theta<0)+2*pi;	% correct range to be between 0 and 2*pi


%Angle
xmin=0;
%xmax=8;
xmax=12;

%Eccentricity
ymin=0;
%ymax=10.2049;
ymax=10;

%Segments(1,:)=round(xmin+rand(1,NSegments)*(xmax-xmin));
%Segments(2,:)=round(ymin+rand(1,NSegments)*(ymax-ymin));


%No same segments allowed

%                 for g=1:NSegments
%
%                     while sum(Segments(1,:)==Segments(1,g) & Segments(2,:)==Segments(2,g)) > 2
%
%                         x=round(xmin+rand(1,NSegments)*(xmax-xmin));
%                         y=round(ymin+rand(1,NSegments)*(ymax-ymin));
%
%                     end
%
%
%

Segmentsxstart=0;
Segmentsystart=0;
SegmentCircle=1;

for i=1:60 %12 * 5 Segments
    
    
    
    %ANGLE
    
    %loAngle=Segments(1,:)*pi/6;
    %loAngle=Segmentsx*pi/6;
    %hiAngle = loAngle + pi/6 ;
    
    %12 Moegliche Startpunkte! - aber zyklisch
    
    
    Segment(1,i) = Segmentsxstart*pi/6;
    
    if Segment(1,i) > 8*pi
        
        Segment(1,i)=Segment(1,i)-8*pi;
        
    elseif Segment(1,i) > 6*pi
        
        Segment(1,i)=Segment(1,i)-6*pi;
        
    elseif Segment(1,i) > 4*pi
        
        Segment(1,i)=Segment(1,i)-4*pi;
        
    elseif Segment(1,i) > 2*pi
        
        Segment(1,i)=Segment(1,i)-2*pi;
        
    end
    
    Segment(2,i) = Segment(1,i) + pi/6 ;
    
    Segmentsxstart=Segmentsxstart+1;
    
    %ECCENTRICITY
    
    
    %loEcc = Segments(2,:)*1.5708;
    %hiEcc = loEcc + 1.5708;
    %loEcc = Segments(2,:)*2;
    %loEcc = Segmentsy*2;
    %hiEcc = loEcc + 2;
    
    if Segmentsxstart == 12*SegmentCircle+1;
        
        Segmentsystart=Segmentsystart+1;
        SegmentCircle=SegmentCircle+1;
        
    end
    
    Segment(3,i) = Segmentsystart*2;
    Segment(4,i) = Segment(3,i) + 2;
    
    
    
end
%Segment(:,BlinkingSegments(1))
if ~isempty(BlinkingSegments)
    
    window = ( ((theta>=Segment(1,BlinkingSegments(1)) & theta<Segment(2,BlinkingSegments(1))) | (Segment(2,BlinkingSegments(1))>2*pi & theta<mod(Segment(2,BlinkingSegments(1)),2*pi))) & ((r>=Segment(3,BlinkingSegments(1)) & r<=Segment(4,BlinkingSegments(1)))) & r<outerRad);
    
    
    for j=2:size(BlinkingSegments,2)
        
        
        %Segment(:,BlinkingSegments(j))
        
        window = window + ( ((theta>=Segment(1,BlinkingSegments(j)) & theta<Segment(2,BlinkingSegments(j))) | (Segment(2,BlinkingSegments(j))>2*pi & theta<mod(Segment(2,BlinkingSegments(j)),2*pi))) & ((r>=Segment(3,BlinkingSegments(j)) & r<=Segment(4,BlinkingSegments(j)))) & r<outerRad);
        
        
    end
    
else
    window=ones(m,n)*bk;
end
    



end

