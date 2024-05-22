% Define the sampling time here:
h = 0.05; %s
T = 120;
t = 0:h:(T-h);


% Define the PRBS input singal for identification:
rng(1);
prbs_steptime = 1;
prbs_amplitude = 0.2;
prbs_offset = 0;
prbs_order = 8;
u_PRBS_raw = prbs(prbs_order, 2^prbs_order - 1);
%u_PRBS_raw = u_PRBS_raw .* (rand(1,length(u_PRBS_raw))*2 - 1);
u_PRBS_ext = repelem(u_PRBS_raw, prbs_steptime/h);
u_PRBS = u_PRBS_ext(1:T/h)*prbs_amplitude + prbs_offset;
u_PRBS = u_PRBS';

% Chirp
chrip_amplitude = 0.2;
u_chirp = chirp(t, 0.1, t(end), 5)' * chrip_amplitude;

% Make input timetable
time = seconds(t');
u_in = timeseries(u_PRBS, t');
