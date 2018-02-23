library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity adc_serial_shifter_tb is
end entity adc_serial_shifter_tb;

architecture test_bench of adc_serial_shifter_tb is
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
	
	signal clk 		: std_logic := '0';
	signal start	: std_logic := '0';
	signal cmd		: std_logic_vector(5 downto 0) := "010101";
	signal half		: std_logic; -- output
	signal ready	: std_logic; -- output
	signal data		: std_logic_vector(11 downto 0); -- output
	-- Serial Port
	signal serial_in	: std_logic := '0';
	signal serial_clk	: std_logic; -- output
	signal serial_out	: std_logic; -- output
begin
	clk <= not clk after 14ns;
	
	stimulus : process
	begin
		wait for 35 ns;
		start <= '1';
		wait for 10 ns;
		start <= '0';
		wait for 10 ns;
		serial_in <= '1';
		wait for 20 ns;
		serial_in <= '0';
		wait for 40 ns;
		serial_in <= '1';
		wait for 20 ns;
		serial_in <= '0';
		wait for 40 ns;
		serial_in <= '1';
		wait for 20 ns;
		serial_in <= '0';
		wait for 40 ns;
		serial_in <= '1';
		wait for 80 ns;
		serial_in <= '0';
		wait for 40 ns;
		serial_in <= '1';
		wait for 20 ns;
		serial_in <= '0';
		wait;
	end process stimulus;

	
	ASS: adc_serial_shifter port map (clk => clk, start => start, cmd => cmd,
		half => half, ready => ready, data => data, 
		serial_in => serial_in, serial_clk => serial_clk, serial_out => serial_out);
		
end architecture test_bench; -- of adc_serial_shifter_tb