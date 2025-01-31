function RandomizedRuns=randomized_stimuli()

RandomizedIndex=randperm(8);

Runs={'eightbars_lr','eightbars_lr','wedgesrings_lr','wedgesrings_lr','eightbars_hr','eightbars_hr','wedgesrings_hr','wedgesrings_hr'};

RandomizedRuns=Runs(RandomizedIndex)';

end