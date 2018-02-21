-- adc_controller.vhd

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
	-- Internal Control Register
	signal adc_control : std_logic_vector(31 downto 0);


	-- Data port aliases
	alias adc_data0 : std_logic_vector is adc_data_readdata(15 downto 0);
	alias adc_data1 : std_logic_vector is adc_data_readdata(31 downto 16);
	alias adc_data2 : std_logic_vector is adc_data_readdata(47 downto 32);
	alias adc_data3 : std_logic_vector is adc_data_readdata(63 downto 48);
	alias adc_data4 : std_logic_vector is adc_data_readdata(79 downto 64);
	alias adc_data5 : std_logic_vector is adc_data_readdata(95 downto 80);
	alias adc_data6 : std_logic_vector is adc_data_readdata(111 downto 96);
	alias adc_data7 : std_logic_vector is adc_data_readdata(127 downto 112);

	-- Control Port Aliases
	
	-- IRQ Controls
	alias adc_ctrl_data_ready   : std_logic is adc_control(31);
	alias adc_ctrl_invalid      : std_logic is adc_control(30);
	
	-- Power Mode
	alias adc_ctrl_mode         : std_logic_vector is adc_control(29 downto 28);
	
	-- Averaging Controls
	alias adc_ctrl_average      : std_logic_vector is adc_control(27 downto 26);
	
	-- Duplex Controls
	alias adc_ctrl_sign         : std_logic is adc_control(25);
	alias adc_ctrl_polarity		: std_logic is adc_control(24);
	alias adc_ctrl_duplexity	: std_logic_vector is adc_control(23 downto 20);

	-- Enabled Channels
	alias adc_ctrl_chan_enable	: std_logic_vector is adc_control(15 downto 8);

	alias adc_ctrl_freq_div	: std_logic_vector is adc_control(7 downto 0);
	
	-- Serial Shifter Signals
	-- Serial Shifter Clock
	signal ass_clk 		: std_logic;
	signal ass_clk_div 	: unsigned(31 downto 0) := x"00000007";
	signal ass_ready	: std_logic;
	signal ass_half		: std_logic;
	signal ass_data		: std_logic_vector(11 downto 0);
	signal ass_cmd		: std_logic_vector(5 downto 0);

	-- Components
	component freq_divider is
	port (
		clk		: in	std_logic;
		target	: in	unsigned(31 downto 0);
		output	: out	std_logic
	);
	end component freq_divider;
	
	component adc_serial_shifter is
	port (
		clk		: in	std_logic;
		start	: in	std_logic;
		cmd		: in	std_logic_vector(5 downto 0);
		half	: out 	std_logic;
		ready	: out	std_logic;
		data	: out 	std_logic_vector(11 downto 0);
		-- Serial Port
		serial_in	: in	std_logic;
		serial_clk	: out	std_logic;
		serial_out	: out	std_logic
	);
	end component adc_serial_shifter;

begin

	write_control_register	: process(clk, reset_n, adc_control_write_n)
		variable invalid : std_logic := '0';
	begin
		if (reset_n = '0') then
			adc_control <= x"00000000";
		elsif (rising_edge(clk)) then
			if (adc_control_write_n = '1') then
				-- Store Settings
				adc_control(31) <= adc_control_writedata(31);
				adc_control(29 downto 0) <= adc_control_writedata(29 downto 0);
				
				-- Validate Input
				-- Duplex Channel 3 Validation
				-- Channel 7 must be disabled when in duplex
				if (adc_control_writedata(23) = '1' and adc_control_writedata(15) = '1') then
					invalid := '1';
				-- Duplex Channel 2 Validation
				-- Channel 5 must be disabled when in duplex
				elsif (adc_control_writedata(22) = '1' and adc_control_writedata(13) = '1') then
					invalid := '1';
				-- Duplex Channel 1 Validation
				-- Channel 3 must be disabled when in duplex
				elsif (adc_control_writedata(21) = '1' and adc_control_writedata(11) = '1') then
					invalid := '1';
				-- Duplex Channel 0 Validation
				-- Channel 1 must be disabled when in duplex
				elsif (adc_control_writedata(20) = '1' and adc_control_writedata(19) = '1') then
					invalid := '1';					
				end if;
				adc_ctrl_invalid <= invalid; 
			end if;
		end if;
	end process write_control_register;

	read_control_register : process(clk, adc_control_read_n)
	begin
		if (rising_edge(clk)) then
			if (adc_control_read_n = '1') then
				adc_control_readdata <= adc_control;
			end if;
		end if;
	end process read_control_register;

	interrupt_control : process(clk)
	begin
		if (rising_edge(clk)) then
			data_ready_irq <= adc_ctrl_data_ready;
			invalid_configuration_irq <= adc_ctrl_invalid;
		end if;
	end process interrupt_control;
	
	-- Generate Clock for ADC Serial Coms
	-- Max frequency 40 MHz
	-- Assuming 500 MHz input clock ~ 2ns
	-- 7 rising edges per half period
	-- 1/(7 * 2 * 2ns) = 35.71 MHz
	FD0: freq_divider port map (clk => clk, target => serial_clk_div, output => serial_clk);
	
	ASS: adc_serial_shifter port map (
		clk 	=> ass_clk,
		start 	=> ass_start,
		cmd 	=> ass_cmd,
		half 	=> ass_half,
		ready 	=> ass_ready,
		data 	=> ass_data,
		-- Serial Port
		serial_in 	=> conduit_adc_sdi,
		serial_clk 	=> conduit_adc_clk,
		serial_out 	=> conduit_adc_sdo);

	conduit_adc_convst <= '0';

end architecture rtl; -- of adc_controller
