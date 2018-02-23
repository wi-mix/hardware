-- starter.vhd

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity sr_ff is
	port (
		clk		: in	std_logic := '0';
		set		: in	std_logic := '0';
		reset	: in	std_logic := '0';
		output	: out	std_logic
	);
end entity sr_ff;

architecture rtl of sr_ff is
    signal iq : std_logic := '0';
begin
	main_proc : process (clk)
	begin
		if(rising_edge(clk)) then
			if(set = '1') then
				iq <= '1';
			elsif(reset = '1') then
				iq <= '0';
			end if;
		end if;
	end process main_proc;

    output <= iq;
end architecture rtl; -- of sr_ff
