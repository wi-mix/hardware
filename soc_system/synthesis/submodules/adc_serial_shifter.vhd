-- freq_divider.vhd

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity adc_serial_shifter is
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
end entity adc_serial_shifter;

architecture rtl of adc_serial_shifter is
	signal state : unsigned(3 downto 0) := x"0";
	signal next_state : unsigned(3 downto 0) := x"0";
	
	-- shift registers
	signal shift_in : std_logic_vector(11 downto 0) := x"000";
	signal shift_out : std_logic_vector(5 downto 0) := "000000";

	-- Important States
	constant W8T : unsigned(3 downto 0) := x"0";
	constant MSS : unsigned(3 downto 0) := x"1";
	constant HSS : unsigned(3 downto 0) := x"7";
	constant LSS : unsigned(3 downto 0) := x"D";

begin
	rising_proc : process (clk)
	begin
		if(rising_edge(clk)) then
			if (state = W8T) then
				if (start = '1') then
					next_state <= MSS;
				else
					next_state <= W8T;
				end if;
			else
				shift_in(0) <= serial_in;
				
				-- Get Next State
				if (state = LSS) then
					next_state <= W8T;
				else
					next_state <= state + 1;
				end if;	
			end if;
		end if;
	end process rising_proc;
	
	falling_proc : process (clk)
	begin
		if(falling_edge(clk)) then
			-- Shift register
			if(state /= W8T) then
				shift_in(11 downto 1) <= shift_in(10 downto 0);
				shift_out <= shift_out(4 DOWNTO 0) & '0';
			end if;
			
			state <= next_state;			
		end if;
	end process falling_proc;
	
	-- Outputs
	serial_clk 	<= '0' when state = W8T else clk;
  	ready 		<= '0' when state = W8T else '1';
	half		<= '0' when state < HSS else '1';
	data <= shift_in;
	serial_out <= shift_out(5);
	
end architecture rtl; -- of timer