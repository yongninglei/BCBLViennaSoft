function [ BlinkingSegments ] = oldDefineBlinkingSegments(ImageNumber,ImageDuration)
%Defines a Struct of size (ImageNumber/ImageDuration) x NSegments 
%   Detailed explanation goes here
    
    
    NSegments=60;
    
    NBlocks=ImageNumber/ImageDuration;
    
    BlinkingSegments=zeros(NBlocks,NSegments);
    
    TimeCourseSegment1=unique(mod([1:NBlocks].^2,NBlocks-1))+1;

    BlinkingSegments(TimeCourseSegment1,:)=1;
    
    for i=2:size(BlinkingSegments,2)
        
        BlinkingSegments(:,i)=circshift(BlinkingSegments(:,i),[-17*(i-1) 0]);
        
        BlinkingSegments(BlinkingSegments(:,i)==1,i)=i;
        
    end
    
    % Artificial Errors
    
    %for k=[1 4 7 10]
        
    %    BlinkingSegments(:,k)=zeros(NBlocks,1);
        
    %end
    
    


end