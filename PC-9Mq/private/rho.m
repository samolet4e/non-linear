% https://gist.github.com/sgonzalez/b03cde0a006812b3188181f8b37e0183
function y1 = rho(h)

    g = 9.80665; % meters per second^2
    R = 8.3144598; % Joules per mole per Kelvin
    dryAirMolarMass = 0.0289644; % kilograms per mole
    dryAirSpecificGasConstant = 287.058; % Joules per kilogram per Kelvin

    L0 = 0.; % meters
    L1 = 11000.; % meters
    L2 = 20000.; % meters
    L3 = 32000.; % meters

    T0 = 288.15; % Kelvin
    T1 = 216.65; % Kelvin
    T2 = 216.65; % Kelvin
    T3 = 228.65; % Kelvin

    B0 = -0.0065; % Kelvin per meter
    B1 = 0.; % Kelvin per meter
    B2 = 0.001; % Kelvin per meter
    B3 = 0.0028; % Kelvin per meter

    rho0 = 1.2250; % kilograms per cubic meter
    rho1 = 0.36391; % kilograms per cubic meter
    rho2 = 0.08803; % kilograms per cubic meter
    rho3 = 0.01322; % kilograms per cubic meter

    _t = 0.;
    if (h < L1)
        pow = 1. + g * dryAirMolarMass / (R * B0);
        _t = rho0 * (T0 / (T0 + B0 * (h - L0)))^pow;
    elseif (h < L2)
        _t = rho1 * exp(-g * dryAirMolarMass * (h - L1) / (R * T1));
    elseif (h < L3)
        pow = 1. + g * dryAirMolarMass / (R * B2);
        _t = rho2 * (T2 / (T2 + B2 * (h - L2)))^pow;
    else
        pow = 1. + g * dryAirMolarMass / (R * B3);
        _t = rho3 * pow(T3 / (T3 + B3 * (h - L3)), pow);
    end

    y1 = _t;

endfunction
