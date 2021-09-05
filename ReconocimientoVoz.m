fprintf("Retrieving Data... \n");
ref1 = readmatrix("A01028822.txt");
ref2 = readmatrix("A01274880.txt");
fprintf("Data Retreived \n");

% extract arrays from first reference
tRef1 = ref1(:,1);
rRef1 = ref1(:,2);

% extract arrays from second reference
tRef2 = ref2(:,1);
rRef2 = ref2(:,2);



% Record audio sample (for voice comparison):

q=3;
% Record your voice for q seconds.
recObj = audiorecorder;
disp('Start speaking.')
recordblocking(recObj, q);
disp('End of Recording.');

% Play back the recording.
play(recObj);

% Store data in double-precision array.
audioSample = getaudiodata(recObj);
% Time axis
qa=recObj.TotalSamples;
t=(0:q/qa:q-q/qa)';




% Plot the waveforms in time domain.
figure()
subplot(1,3,1)
plot(tRef1,rRef1);
xlabel('time (secs)')
ylabel('amplitude (V)')
title("A01028822")

subplot(1,3,2)
plot(tRef2,rRef2);
xlabel('time (secs)')
ylabel('amplitude (V)')
title("A01274880")

subplot(1,3,3)
plot(t,audioSample);
xlabel('time (secs)')
ylabel('amplitude (V)')
title("Audio sample (recognition)")


