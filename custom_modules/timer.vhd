-- timer.vhd

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity timer is
	port (
		clk		: in	std_logic                      := '0';             --                 clock.clk
		reset	: in	std_logic                      := '0';             --                 reset.reset
		target	: in	unsigned(31 downto 0);
		done	: out	std_logic
	);
end entity timer;

architecture rtl of timer is
	signal trg 		: unsigned(31 downto 0) := "00000000";
	signal count 	: unsigned(31 downto 0) := "00000000";
begin
	main_proc : process (clk)
	begin
		if(reset = '1') then
			count <= "0";
			trg <= target;
			done <= '0';
		elsif(rising_edge(clk)) then
			if (count < trg) then
				done <= '0';
				count <= count + 1;
			else
				done <= '1';
			end if;
		end if;
	end process main_proc;
end architecture rtl; -- of timer
