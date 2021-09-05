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

% compute kurtosis for the waveforms
kRef1 = kurtosis(rRef1);
kRef2 = kurtosis(rRef2);
kSamp = kurtosis(audioSample);

% Compute correlation matrix:
samples = [rRef1 rRef2 audioSample];
r2 = corrcoef(samples);
cors = r2(1:2,3); % [ref2, red1]



% Compute PDF & CDF probabilistic distributions for sample and references
xDist = linspace(-0.1,0.1,length(t));

% normal distributions with adjusted mean and standard deviation
pd1 = makedist("Normal",mean(rRef1),std(rRef1));
pd2 = makedist("Normal",mean(rRef2),std(rRef2));
pds = makedist("Normal",mean(audioSample),std(audioSample));

% Probabily density distributions
pdf1 = pdf(pd1,xDist);
pdf2 = pdf(pd2,xDist);
pdfs = pdf(pds,xDist);

% Cumulative probability Distributions
cdf1 = cdf(pd1,xDist);
cdf2 = cdf(pd2,xDist);
cdfs = cdf(pds,xDist);

% Mean squared error between the probabilistic distribtutions

%PDF combinations

mse1sp = RMSE(pdf1,pdfs);
mse2sp = RMSE(pdf2,pdfs);

%CDF combinations
mse1sc = RMSE(cdf1,cdfs);
mse2sc = RMSE(cdf2,cdfs);


% Results
closer(mse1sp,mse2sp);
pDist = normalize(cors);
moreProbable(pDist);

% Voice recognition summary
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

% plot probability distributions
figure()
subplot(3,2,1)
createPlot(xDist,cdf1,"CDF Reference: A01028822","values","probability",'b')
subplot(3,2,2)
createPlot(xDist,pdf1,"PDF Reference: A01028822","values","probability",'r')
subplot(3,2,3)
createPlot(xDist,cdf2,"CDF Reference: A01274880","values","probability",'b')
subplot(3,2,4)
createPlot(xDist,pdf2,"PDF Reference: A01274880","values","probability",'r')
subplot(3,2,5)
createPlot(xDist,cdfs,"CDF Sample Objective","values","probability",'b')
subplot(3,2,6)
createPlot(xDist,pdfs,"PDF Sample Objective","values","probability",'r')



% root mean squared error function
function rmse = RMSE(ref,samp)
    err = (ref-samp).^2;
    rmse = sqrt(mean(err));
end


function createPlot(x,y,t,xl,yl,c)
    plot(x,y,c)
    title(t)
    xlabel(xl)
    ylabel(yl)
    grid on
end

% Use on pdf
function closer(rms1,rms2)
    if(rms1 < rms2)
        fprintf("The audio sample is closer to reference: A01028822 \n")
    else
        fprintf("The audio sample is closer to reference: A01274880 \n")
    end
end



% Normalize correlation coeficients to a single probabilistic distribution
function pDist = normalize(cors)
    t = exp(cors);
    pDist = t./sum(t);
end

function moreProbable(pDist)
    if pDist(2) < pDist(1)
        fprintf("It is more probable that the voice belongs to A01028822 \n")
    else
        fprintf("It is more probable that the voice belongs to A01274880 \n")
    end
end
