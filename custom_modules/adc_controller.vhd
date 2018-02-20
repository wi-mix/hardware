-- adc_controller.vhd

-- This file was auto-generated as a prototype implementation of a module
-- created in component editor.  It ties off all outputs to ground and
-- ignores all inputs.  It needs to be edited to make it do something
-- useful.
-- 
-- This file will not be automatically regenerated.  You should check it in
-- to your version control system if you want to keep it.

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity adc_controller is
	port (
		clk                       : in  std_logic                      := '0';             --                 clock.clk
		reset_n                   : in  std_logic                      := '0';             --                 reset.reset
		adc_data_read_n           : in  std_logic                      := '0';             --              adc_data.read
		adc_data_readdata         : out std_logic_vector(127 downto 0);                    --                      .readdata
		adc_control_read_n        : in  std_logic                      := '0';             --           adc_control.read
		adc_control_readdata      : out std_logic_vector(31 downto 0);                     --                      .readdata
		adc_control_write_n       : in  std_logic                      := '0';             --                      .write
		adc_control_writedata     : in  std_logic_vector(31 downto 0)  := (others => '0'); --                      .writedata
		conduit_adc_clk           : out std_logic;                                         --           conduit_adc.export_clk
		conduit_adc_convst        : out std_logic;                                         --                      .export_convst
		conduit_adc_sdo           : out std_logic;                                         --                      .export_sdo
		conduit_adc_sdi           : in  std_logic                      := '0';             --                      .export_sdi
		data_ready_irq            : out std_logic;                                         --            data_ready.irq
		invalid_configuration_irq : out std_logic                                          -- invalid_configuration.irq
	);
end entity adc_controller;

architecture rtl of adc_controller is
begin

	-- TODO: Auto-generated HDL template

	adc_data_readdata <= "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";

	adc_control_readdata <= "00000000000000000000000000000000";

	conduit_adc_clk <= '0';

	conduit_adc_convst <= '0';

	conduit_adc_sdo <= '0';

	data_ready_irq <= '0';

	invalid_configuration_irq <= '0';

end architecture rtl; -- of adc_controller
