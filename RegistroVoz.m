clear
clc

p1 = "Enter you university id: A######## \n";
pe = "User is not registered. Enter another one: \n";

mat = input(p1,'s')
% user validation pending


q=3;
% Record your voice for q seconds.
recObj = audiorecorder;
disp('Start speaking.')
recordblocking(recObj, q);
disp('End of Recording.');

% Play back the recording.
play(recObj);

% Store data in double-precision array.
myRecording = getaudiodata(recObj);
% Time axis
qa=recObj.TotalSamples;
t=(0:q/qa:q-q/qa)';
tab = [t myRecording];

if strcmp(mat,"A01028822") == 1
    dlmwrite('A01028822.txt',tab,'delimiter','\t','newline','pc')
    fprintf("Data written in A01028822.txt \n")
else
    dlmwrite('A01274880.txt',tab,'delimiter','\t','newline','pc')
    fprintf("Data written in A01274880.txt \n")
end


