
addpath(genpath('/ceph/mri.meduniwien.ac.at/departments/physics/fmrilab/lab/presurfer'))
addpath(genpath('/ceph/mri.meduniwien.ac.at/departments/physics/fmrilab/lab/NORDIC_Raw'))

baseP = '/ceph/mri.meduniwien.ac.at/projects/physics/fmri/data/bcblvie22/BIDS';
subs = {'t001'}; %{'bt001','bt002'};
sess = {'002'};

for subI=1:length(subs)
    sub = ['sub-',subs{subI}];
    for sesI=1:length(sess)
        ses = ['ses-',sess{sesI}];
        sesP = fullfile(baseP, sub, ses);

        %% perform nordic on all the funtional files
        mags = dir(fullfile(sesP, 'func', '*_magnitude.nii.gz'));
        f_mags = mags(1).folder

        for magI=1:length(mags)
            % define file names
            fn_magn_in  = strrep(fullfile(f_mags, mags(magI).name), '.gz', '');
            fn_phase_in = strrep(strrep(fn_magn_in, 'magnitude', 'phase'), '.gz', '');
            fn_out      = strrep(strrep(fn_magn_in, 'magnitude', 'bold'), '.gz', '');

            if ~exist([fn_out,'.gz'], 'file')
                info = niftiinfo([fn_magn_in,'.gz']);
                system(['fslroi ', [fn_magn_in,'.gz'], ' ', fn_magn_in, ' 0 -1 0 -1 0 -1 0 ', num2str(info.ImageSize(end)-4)]);
                system(['fslroi ', [fn_phase_in,'.gz'], ' ', fn_phase_in, ' 0 -1 0 -1 0 -1 0 ', num2str(info.ImageSize(end)-4)]);
                system(['fslmaths ', fn_magn_in,  ' ', fn_magn_in,  ' -odt float']);
                system(['fslmaths ', fn_phase_in, ' ', fn_phase_in, ' -odt float']);

                ARG.temporal_phase = 1;
                ARG.phase_filter_width = 10;
                ARG.noise_volume_last = 1;
                [ARG.DIROUT,fn_out_name,~] = fileparts(fn_out);
                ARG.DIROUT = [ARG.DIROUT, '/'];
                NIFTI_NORDIC(fn_magn_in,fn_phase_in,fn_out_name,ARG)

                % clean up
                system(['fslroi ', fn_out, ' ', fn_out, ' 0 -1 0 -1 0 -1 0 ', num2str(info.ImageSize(end)-5)]);
                gzip(fn_out);
                system(['rm ', fn_magn_in, ' ', fn_phase_in, ' ', fn_out]);

                % copy the events.tsv
                system(['cp ', strrep(fn_magn_in, 'magnitude.nii', 'magnitude.json'), ' ', ...
                               strrep(fn_magn_in, 'magnitude.nii', 'bold.json')]);
            end
        end

        % rename sbref
        sbref_mags = dir(fullfile(sesP, 'func', '*_part-mag_sbref.nii.gz'));
        f_sbref_mags = sbref_mags(1).folder
        for sbref_magI = 1:length(sbref_mags)
            sbref_mag = fullfile(f_sbref_mags, sbref_mags(sbref_magI).name);
            system(['cp ', sbref_mag, ' ', strrep(sbref_mag, '_part-mag', '')]);
            system(['cp ', strrep(sbref_mag, '.nii.gz', '.json'), ' ', ...
                          strrep(sbref_mag, '_part-mag_sbref.nii.gz', '_sbref.json')]);
        end
    end
end
