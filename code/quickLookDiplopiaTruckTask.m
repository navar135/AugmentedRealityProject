figure; plot(alltimes-alltimes(1),allcontrasts);


ntrials = length(alltrials);
ttimes = zeros(1,ntrials);
tlevels =  zeros(1,ntrials);
nbuts =  zeros(1,ntrials);

for i = 1:ntrials
    if ~isempty(alltrials(i).allConts)
    ttimes(i) = alltrials(i).trialEnd;
    tlevels(i) =  alltrials(i).allConts(end);
    nbuts(i) =  length(alltrials(i).allConts);
    end
end
ttimes = ttimes-alltrials(1).trialStart;

figure;
plot(ttimes,tlevels);