function [const,Trialevents,eye,text,gaze]=runSingleTrial(scr,const,Trialevents,my_key,text,sounds,eye,i,gaze)
% ----------------------------------------------------------------------
% [Trialevents]=runSingleTrial(scr,const,Trialevents,my_key,text,i)
% ----------------------------------------------------------------------
% Goal of the function :
% Draw stimuli of each indivual trial and collect inputs
% ----------------------------------------------------------------------
% Input(s) :
% scr : struct containing screen configurations
% const : struct containing constant configurations
% my_key : structure containing keyboard configurations
% Trialevents: structure containing trial events
% text: structure containing text config.
% sounds: structure containing sounds.
% eye: Eye-tracking info.
% i: the trial number
% ----------------------------------------------------------------------
% Output(s):
% Trialevents : struct containing all the variable design configurations
% with data appended.
% ----------------------------------------------------------------------
% Function created by Nick Hedger
% Project :     priming


% Trial-level variables;
trial.trialnum=num2str(Trialevents.trialmat(i,1));  
trial.stimtype=Trialevents.trialmat(i,2);
trial.scramtype=Trialevents.trialmat(i,3);
trial.duration=Trialevents.trialmat(i,4)/1000; 
trial.Model=Trialevents.trialmat(i,5);

% Print the condition details to the external file.

log_txt=sprintf(text.formatSpecTrial,trial.trialnum,text.stimlabel{trial.stimtype},text.scramlabel{trial.scramtype},num2str(trial.duration),num2str(trial.Model));
fprintf(const.log_text_fid,'%s\n',log_txt);

if const.debug
fprintf(strcat(log_txt,'\n'));
end

const.trialsdone=trial.trialnum;

%% Drawings
    HideCursor;
    % Fixation dot;
    Screen('DrawDots',scr.main,scr.mid,const.bigfixsize,const.bigfixcol,[],1);
    Screen('DrawDots',scr.main,scr.mid,const.smallfixsize,const.blue,[],1);
    Screen('DrawDots',scr.main,scr.mid,const.smallerfixsize,const.blue,[],1);
    sound(sounds.begin,sounds.beginf);
    
    Fixonset=Screen('Flip',scr.main,[1]);
    
    % If there is an eyetracker detected, start recording gaze
    if isa(eye.eyetracker,'EyeTracker')
    gaze_data = eye.eyetracker.get_gaze_data();
    log_txt=sprintf(text.gazestart,num2str(clock));
    fprintf(const.log_text_fid,'%s\n',log_txt);
    end
    
    pause(const.fixdur);
    
    % Frames
    Screen('DrawTexture',scr.main,const.tex.Frametex,[],[const.framerectl]); 
    Screen('DrawTexture',scr.main,const.tex.Frametex,[],[const.framerectr]); 
    
    if trial.stimtype==1 && trial.scramtype==1
    Screen('DrawTexture',scr.main,const.tex.stim{1,trial.Model},[],[const.stimrectl]);
    Screen('DrawTexture',scr.main,const.tex.stim{2,trial.Model},[],[const.stimrectr]);
    elseif trial.stimtype==2 && trial.scramtype==1
    Screen('DrawTexture',scr.main,const.tex.stim{2,trial.Model},[],[const.stimrectl]);
    Screen('DrawTexture',scr.main,const.tex.stim{1,trial.Model},[],[const.stimrectr]);
    elseif trial.stimtype==1 && trial.scramtype==2
    Screen('DrawTexture',scr.main,const.tex.stimsc{1,trial.Model},[],[const.stimrectl]);
    Screen('DrawTexture',scr.main,const.tex.stimsc{2,trial.Model},[],[const.stimrectr]);
    elseif trial.stimtype==2 && trial.scramtype==2
    Screen('DrawTexture',scr.main,const.tex.stimsc{2,trial.Model},[],[const.stimrectl]);
    Screen('DrawTexture',scr.main,const.tex.stimsc{1,trial.Model},[],[const.stimrectr]); 
    end
    
    
    
    Stimonset=Screen('Flip', scr.main);
    log_txt=sprintf(text.formatSpecFlip1,num2str(clock));
    fprintf(const.log_text_fid,'%s\n',log_txt);
    
    t1=GetSecs;
    [KeyIsDown,secs,keyCode]=KbCheck(max(GetKeyboardIndices));
    while keyCode(my_key.left)==0 && keyCode(my_key.right)==0
        [KeyisDown,secs,keyCode]=KbCheck(max(GetKeyboardIndices));
    end
    
    if keyCode(my_key.left)==1;
        Trialevents.resp{i}=1;
    elseif keyCode(my_key.right)==1;
        Trialevents.resp{i}=2;
    end
    t2=GetSecs;
    Trialevents.elapsed{i}=t2-t1;
    
    
    
    if isa(eye.eyetracker,'EyeTracker')
        collected_gaze_data=eye.eyetracker.get_gaze_data();
        eye.eyetracker.stop_gaze_data();
        log_txt=sprintf(text.gazestop,num2str(clock));
        fprintf(const.log_text_fid,'%s\n',log_txt);
        plottrial(const,scr,collected_gaze_data)
    else
        collected_gaze_data=i;
    end
    
    if Trialevents.resp{i}==1;
    Screen('DrawTexture',scr.main,const.tex.Selecttex,[],[const.framerectl]); 
    Screen('DrawTexture',scr.main,const.tex.Frametex,[],[const.framerectr]); 
    elseif Trialevents.resp{i}==2;
    Screen('DrawTexture',scr.main,const.tex.Selecttex,[],[const.framerectr]); 
    Screen('DrawTexture',scr.main,const.tex.Frametex,[],[const.framerectl]);
    end
    
    if trial.stimtype==1 && trial.scramtype==1
    Screen('DrawTexture',scr.main,const.tex.stim{1,trial.Model},[],[const.stimrectl]);
    Screen('DrawTexture',scr.main,const.tex.stim{2,trial.Model},[],[const.stimrectr]);
    elseif trial.stimtype==2 && trial.scramtype==1
    Screen('DrawTexture',scr.main,const.tex.stim{2,trial.Model},[],[const.stimrectl]);
    Screen('DrawTexture',scr.main,const.tex.stim{1,trial.Model},[],[const.stimrectr]);
    elseif trial.stimtype==1 && trial.scramtype==2
    Screen('DrawTexture',scr.main,const.tex.stimsc{1,trial.Model},[],[const.stimrectl]);
    Screen('DrawTexture',scr.main,const.tex.stimsc{2,trial.Model},[],[const.stimrectr]);
    elseif trial.stimtype==2 && trial.scramtype==2
    Screen('DrawTexture',scr.main,const.tex.stimsc{2,trial.Model},[],[const.stimrectl]);
    Screen('DrawTexture',scr.main,const.tex.stimsc{1,trial.Model},[],[const.stimrectr]); 
    end
    
    Selectoffset=Screen('Flip',scr.main,[]);
    WaitSecs(0.5)
    
%     ShowCursor;
%     SetMouse(const.awrect(1), const.awrect(2), scr.main);
%     
%     %     Define response range and rescale this to the 1-4 range.
%     
%     range=const.awrect(3)-const.awrect(1);
%     rescaled=linspace(1,4,range);
%     
%     
%  
%     while 1
%         %         Draw tickmarks
%         vect=round(linspace(const.awrect(1),const.awrect(3),4));
%         for tick=vect
%             tick_offset = OffsetRect(const.tick, tick, const.awrect(2)-2);
%             Screen('FillRect', scr.main, const.rectColor, tick_offset);
%         end
%         
%         %     Draw PAS labels and numbers.
%         Screen('TextSize', scr.main, [40]);
%         DrawFormattedText(scr.main, text.choice,vect(1)+((vect(2)-vect(1))/2), const.awrect(2)-400, WhiteIndex(scr.main),[],[]);
%         
%         for txt=1:4
%         Screen('TextSize', scr.main, [20]);
%         DrawFormattedText(scr.main, text.choice_desc{txt},vect(txt)-(0.2*(vect(2)-vect(1))), const.awrect(2)-100, WhiteIndex(scr.main),[],[]);
%         %DrawFormattedText(scr.main, num2str(txt),vect(txt), const.awrect(2)+40, WhiteIndex(scr.main),[],[]);
%         end
%         
%         %    Draw the response bar
%         Screen('FillRect', scr.main, const.rectColor, const.awrect);
%         
%         %     Get mouse position and determine whether or not it is in the bar.
%         [mx, my, buttons] = GetMouse(scr.main);
%         inside_bar = IsInRect(mx, my+1, const.awrect);
%         resprect = CenterRectOnPointd(const.selectRect, mx, const.awrect(2)+1);
%         
%         %    Draw slider at new location
%         Screen('FillRect', scr.main, const.blue, resprect);
%         
%         %    Mouse must be clicked, spacebar must be pressed and slider must be
%         %    within response bar range.
%         if ismember(round(mx),const.awrect(1):const.awrect(3)) && sum(buttons) > 0
%             Trialevents.awResp(i) = rescaled(round(mx)-const.awrect(1));
%             break;
%             WaitSecs(1)
%             
%         end
%         
%         Screen('Flip', scr.main);
%         
%         if sum(buttons) <= 0
%             offsetSet = 0;
%         end
%     end
%     HideCursor;
%     
    
    Screen('Flip', scr.main);
    
    %  Offset
    
    Screen('DrawDots',scr.main,scr.mid,const.bigfixsize,const.bigfixcol,[],1);
    Screen('DrawDots',scr.main,scr.mid,const.smallfixsize,const.smallfixcol,[],1);
    Screen('DrawDots',scr.main,scr.mid,const.smallerfixsize,const.smallerfixcol,[],1);
    Stimoffset=Screen('Flip',scr.main,[]);
    log_txt=sprintf(text.formatSpecFlip1,num2str(clock));
    fprintf(const.log_text_fid,'%s\n',log_txt);
    
    
    %  Update progress bar.
    progvec=round(linspace(1,const.stimright,length(Trialevents.trialmat)));
    progbar=[0 7 progvec(str2num(const.trialsdone)) 17];
    %  Draw slider at new location
    Screen('FillRect', scr.main, const.blue, progbar);
    
    t1=GetSecs;
    [KeyIsDown,secs,keyCode]=KbCheck(max(GetKeyboardIndices));
    while keyCode(my_key.space)==0 && keyCode(my_key.escape)==0
        [KeyisDown,secs,keyCode]=KbCheck(max(GetKeyboardIndices));
    end
    
    if keyCode(my_key.space)==1;
    close
    const.trialsdone=trial.trialnum;
    config.scr = scr; config.const = rmfield(const,'tex'); config.Trialevents = Trialevents; config.my_key = my_key;config.text = text;config.sounds = sounds;config.eye = eye;
    log_txt=sprintf(text.save,num2str(clock));
    fprintf(const.log_text_fid,'%s\n',log_txt);
    save(const.filename,'config');
    save(strcat(const.gazefilename,'_trial',num2str(i),'_gaze.mat'),'collected_gaze_data')
    
    Screen('DrawDots',scr.main,scr.mid,const.bigfixsize,const.bigfixcol,[],1);
    Screen('DrawDots',scr.main,scr.mid,const.smallfixsize,const.smallfixcol,[],1);
    Screen('DrawDots',scr.main,scr.mid,const.smallerfixsize,const.smallerfixcol,[],1);
    
    Screen('Flip', scr.main);
    elseif keyCode(my_key.escape)==1
        const.trialsdone=trial.trialnum;
        config.scr = scr; config.const = rmfield(const,'tex'); config.Trialevents = Trialevents; config.my_key = my_key;config.text = text;config.sounds = sounds;config.eye = eye;
        log_txt=sprintf(text.formatSpecQuit,num2str(clock));
        fprintf(const.log_text_fid,'%s\n',log_txt);
        save(const.filename,'config');
        save(strcat(const.gazefilename,'_trial',num2str(i),'_gaze.mat'),'gaze')
        log_txt=sprintf(text.save,num2str(clock));
        fprintf(const.log_text_fid,'%s\n',log_txt);
        ShowCursor(1);
        Screen('CloseAll')
    end
    

    
end