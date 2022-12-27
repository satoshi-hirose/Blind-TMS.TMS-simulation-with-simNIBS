%% Extract results
load ../Results/Parameters
load ../Results/IndividualResults

%% define region of interest
ALL_ROIs={{'lh.V1','rh.V1','lh.V2','rh.V2'}};

% If you want to see the summary for multiple regions, list them as follows.
% ALL_ROIs={{'V1','V2'}
% {'lh.V3','lh.V3A','lh.V3CD', 'rh.V3','rh.V3A','rh.V3CD'}
% {'lh.V4','rh.V4','lh.V4t','rh.V4t'}};


%% brain region includes the peak
for sub=1:length(subnames)
    for sim = 1:length(RESULTS{sub})
        [peakval,i_tmp]=max(RESULTS{sub}(sim).indiv.value);
        group_RESULTS.peak_region{sub,sim} = RESULTS{sub}(sim).param.arealist{RESULTS{sub}(sim).indiv.anat(i_tmp)};
    end
end

%% ROI size
for rid = 1:length(ALL_ROIs)
    for sub=1:length(subnames)
        region_ind = find(sum(strcmpi(repmat(RESULTS{sub}(sim).param.arealist,length(ALL_ROIs{rid}),1),repmat(ALL_ROIs{rid}',1,length(RESULTS{sub}(sim).param.arealist)))));
        group_RESULTS.Whole_ROI_area(rid,sub) = sum(any(RESULTS{sub}(1).indiv.anat==region_ind,2).*RESULTS{sub}(1).indiv.areas);
    end
end


%% above threshold (e.g. V/m for normE) area
threshold = 10;
for sub=1:length(subnames)
    for sim = 1:length(RESULTS{sub})
        above_threshold.ind     = (RESULTS{sub}(sim).indiv.value>threshold);
        above_threshold.area    = RESULTS{sub}(sim).indiv.areas(above_threshold.ind);
        above_threshold.value   = RESULTS{sub}(sim).indiv.value(above_threshold.ind);
        above_threshold.xyz     = RESULTS{sub}(sim).indiv.xyz(above_threshold.ind,:);
        above_threshold.anat    = RESULTS{sub}(sim).indiv.anat(above_threshold.ind);
        nanat = length(RESULTS{sub}(sim).param.arealist);
        nnode = length(above_threshold.value);
        group_RESULTS.above_t_area_region{sub}(sim,:) = sum((repmat(1:nanat,nnode,1)==repmat(above_threshold.anat,1,nanat)).*repmat(above_threshold.area,1,nanat));
        for rid = 1:length(ALL_ROIs)
            region_ind = find(sum(strcmpi(repmat(RESULTS{sub}(sim).param.arealist,length(ALL_ROIs{rid}),1),repmat(ALL_ROIs{rid}',1,length(RESULTS{sub}(sim).param.arealist)))));
            group_RESULTS.above_t_area_ROI(sub,sim,rid) = sum(group_RESULTS.above_t_area_region{sub}(sim,region_ind));
            group_RESULTS.above_t_prop_ROI(sub,sim,rid) = group_RESULTS.above_t_area_ROI(sub,sim,rid)/group_RESULTS.Whole_ROI_area(rid,sub);
        end
    end
end

save ../Results/GroupResults group_RESULTS
writetable(table(subnames,group_RESULTS.peak_region,mean(group_RESULTS.above_t_prop_ROI,2),'VariableNames',{'SubjectName', 'PeakLocation', 'PropOfStimulatedRegionInV1V2'})...
    ,'../Results/Table.txt')