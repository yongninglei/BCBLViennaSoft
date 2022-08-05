function [ BlinkingSegments ] = DefineBlinkingSegments(ImageNumber,ImageDuration)
%Defines a Struct of size (ImageNumber/ImageDuration) x NSegments 
%   Detailed explanation goes here
    
    
  
    
    %---------------------------------------
    
    NSegmentshelp=4;
    NBlocks=(ImageNumber/ImageDuration);
    BlinkingSegmentshelp=zeros(NBlocks,NSegmentshelp);
    
    TimeCourseSegment1=[ones(1,3), zeros(1,17), ones(1,3), zeros(1,17), ones(1,3), zeros(1,17), ones(1,3), zeros(1,17)]';
    
    BlinkingSegmentshelp(:,1)=TimeCourseSegment1;
    
    for i=2:size(BlinkingSegmentshelp,2)
        
        BlinkingSegmentshelp(:,i)=circshift(BlinkingSegmentshelp(:,1),[5*(i-1) 0]);
        
        BlinkingSegmentshelp(BlinkingSegmentshelp(:,i)==1,i)=i;
        
    end
    
    Segment1subsegments=[1:3,10:12,13:15,22:24,25:27,34:36];
    Segment2subsegments=[40:45,52:57];
    Segment3subsegments=[37:39,46:48,49:51,58:60];
    Segment4subsegments=[4:9,16:21,28:33];
    
    NSegments=60;
    
    BlinkingSegments=zeros(NBlocks,NSegments);
    
    for i=1:size(BlinkingSegments,2)
        
        if ismember(i,Segment1subsegments)
            
            BlinkingSegments(:,i)=BlinkingSegmentshelp(:,1);
            BlinkingSegments(BlinkingSegments(:,i)==1,i)=i;
        
        elseif ismember(i,Segment2subsegments)
            
            BlinkingSegments(:,i)=BlinkingSegmentshelp(:,2);
            BlinkingSegments(BlinkingSegments(:,i)==2,i)=i;
                
        elseif ismember(i,Segment3subsegments)
            
            BlinkingSegments(:,i)=BlinkingSegmentshelp(:,3);
            BlinkingSegments(BlinkingSegments(:,i)==3,i)=i;
            
        elseif ismember(i,Segment4subsegments)
            
            BlinkingSegments(:,i)=BlinkingSegmentshelp(:,4);
            BlinkingSegments(BlinkingSegments(:,i)==4,i)=i;
                
        end
        
    end
    
    
    
    
    
    
    
    
    %---------------------------------------
    
    %?KLASSISCHES PARADIGMA
%     
%     NSegments=60;
%     
%     NBlocks=(ImageNumber/ImageDuration);
%     
%     %NBlocks=68;
%     
%     BlinkingSegments=zeros(NBlocks-1,NSegments);
%     
%     TimeCourseSegment1=unique(mod([1:NBlocks-1].^2,NBlocks-1))+1;
% 
%     BlinkingSegments(TimeCourseSegment1,:)=1;
%     
%     
%     for i=2:size(BlinkingSegments,2)
%         
%         BlinkingSegments(:,i)=circshift(BlinkingSegments(:,i),[17*(i-1) 0]);
%         
%         BlinkingSegments(BlinkingSegments(:,i)==1,i)=i;
%         
%     end
%     
%     BlinkingSegments(end+1,:)=0;
%     
%     
% % %     % Artificial Errors
% % %     
% %      for k=[1 4 7 10]
% %          
% %          BlinkingSegments(:,k)=zeros(NBlocks,1);
% %          
% %      end

end