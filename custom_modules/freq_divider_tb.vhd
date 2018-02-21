library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity freq_divider_tb is
end entity freq_divider_tb;

architecture test_bench of freq_divider_tb is
	component freq_divider is
	port (
		clk		: in	std_logic;
		target	: in	unsigned(31 downto 0);
		output	: out	std_logic);
	end component freq_divider;
	
	signal clk 		: std_logic := '0';
	signal target 	: unsigned(31 downto 0);
	signal output 	: std_logic;
begin
	clk <= not clk after 2ns;
	
	stimulus : process
	begin
		target <= to_unsigned(2, 32);
		wait for 10 ns;
		target <= to_unsigned(4, 32);
		wait;
	end process stimulus;

	
	FD0: freq_divider port map (clk => clk, target => target, output => output);
end architecture test_bench;