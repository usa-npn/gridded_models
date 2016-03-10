si_data_dir='../data/'; %Default data directory
mds_verification_data_dir='../data/mds_verification_data/'; %Path to
                    %MDS output from Fortran calculations of SI for the
                    %"select 6" stations
display_message={'SUCCESS!!! ml_si should be ready to run. The following options were tested:'};
select6_stn_ids=[114442 118740 213290 234705 315771 405187]; %IDs for 
               %select 6 stations.
      
si_func_dir='../si_funcs/';%Location of SI functions
m_plot_dir='/Users/tra38/Matlab/m_map/m-map/';%Path to m_map
               
addpath(si_func_dir)
addpath(m_plot_dir)

load([si_data_dir 'select6.mat'])
    [SI_xdata,header]=xlsread([mds_verification_data_dir 'SI-x_select6_optimized_output.xls']);
    display_message={display_message{:}, ['(x) Successfully checked to make sure MDS verification data is available.']};
    
    for i =1:length(select6_stn_ids);
        stn_id=num2str(select6_stn_ids(i));
        eval(['tmin(:,:,i)=convert_temp(USC00' stn_id '.TMIN.data,' char(39) 'C' char(39) ',' char(39) 'F' char(39) ');']);
        eval(['tmax(:,:,i)=convert_temp(USC00' stn_id '.TMAX.data,' char(39) 'C' char(39) ',' char(39) 'F' char(39) ');']);
        eval(['lat(i)=USC00' stn_id '.lat;']);

        if i ==1
            eval(['stn_time=USC00' stn_id '.time;']);
        end

    end
    
    csvwrite('C:\Users\Jeff\Documents\MATLAB\ML_SI\data\tmin.csv', tmin);
    csvwrite('C:\Users\Jeff\Documents\MATLAB\ML_SI\data\tmax.csv', tmax);
    csvwrite('C:\Users\Jeff\Documents\MATLAB\ML_SI\data\lat.csv', lat);