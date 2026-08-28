# ---- Clock definition ----
create_clock -name CLK -period 20.000 [get_ports CLK]

# ---- Reset ----
set_false_path -from [get_ports RST]

# ---- Input delays ----
set_input_delay -clock CLK -max 3.000 [get_ports {P_INPUT[*]}]
set_input_delay -clock CLK -min 0.500 [get_ports {P_INPUT[*]}]
set_input_delay -clock CLK -max 3.000 [get_ports V_INPUT]
set_input_delay -clock CLK -min 0.500 [get_ports V_INPUT]
set_input_delay -clock CLK -max 3.000 [get_ports {P_EN P_BIT}]
set_input_delay -clock CLK -min 0.500 [get_ports {P_EN P_BIT}]

# ---- Output delays ----
set_output_delay -clock CLK -max 2.000 [get_ports TX_OUTPUT]
set_output_delay -clock CLK -min 0.500 [get_ports TX_OUTPUT]
set_output_delay -clock CLK -max 2.000 [get_ports BUSY]
set_output_delay -clock CLK -min 0.500 [get_ports BUSY]
