-- freq_divider.vhd

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity freq_divider is
	port (
		clk		: in	std_logic                      := '0';             --                 clock.clk
		target	: in	unsigned(31 downto 0);
		output	: out	std_logic
	);
end entity freq_divider;

architecture rtl of freq_divider is
	signal count 	: unsigned(31 downto 0) := x"00000000";
	signal oo 		: std_logic := '0';
begin
	main_proc : process (clk)
	begin
		if(rising_edge(clk)) then
			if (count < target) then
				count <= count + 1;
			else
				count <= x"00000000";
				oo <= not oo;
			end if;
		end if;
	end process main_proc;
	
	output <= oo;
end architecture rtl; -- of timer