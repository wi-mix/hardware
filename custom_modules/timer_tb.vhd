library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity timer_tb is
end entity timer_tb;

architecture test_bench of timer_tb is
	component freq_divider is
	port (
		clk		: in	std_logic;
		target	: in	unsigned(31 downto 0);
		done	: out	std_logic);
	end component freq_divider;
	
	signal clk 		: std_logic := '0';
	signal target 	: unsigned(31 downto 0);
	signal done 	: std_logic;
begin
	clk <= not clk after 2ns;
	
	stimulus : process
	begin
		target <= to_unsigned(2, 32);
		wait for 10 ns;
		target <= to_unsigned(4, 32);
		wait;
	end process stimulus;

	
	T0: freq_divider port map (clk => clk, target => target, done => done);
end architecture test_bench;