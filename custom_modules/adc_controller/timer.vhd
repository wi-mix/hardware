-- timer.vhd

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity timer is
	port (
		clk		: in	std_logic                      := '0';             --                 clock.clk
		enable	: in	std_logic                      := '0';             --                 reset.reset
		target	: in	unsigned(31 downto 0);
		done	: out	std_logic
	);
end entity timer;

architecture rtl of timer is
	signal trg 		: unsigned(31 downto 0) := x"00000000";
	signal count 	: unsigned(31 downto 0) := x"00000001";
begin
	main_proc : process (enable, clk)
	begin
		if(enable = '0') then
			count <= x"00000001";
			trg <= target;
			done <= '0';
		elsif(enable = '1' and rising_edge(clk)) then
			if (count < trg) then
				done <= '0';
				count <= count + 1;
			else
				done <= '1';
			end if;
		end if;
	end process main_proc;
end architecture rtl; -- of timer
