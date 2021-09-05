fprintf("Retrieving Data... \n");
ref1 = readmatrix("dataexport.txt");
fprintf("Data Retreived \n");

tRef1 = ref1(:,1);
rRef1 = ref1(:,2);



% Record the second Voice










% Plot the waveform.
figure()
plot(tRef1,rRef1);
xlabel('time (secs)')
ylabel('amplitude (V)')





