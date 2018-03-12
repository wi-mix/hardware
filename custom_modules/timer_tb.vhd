library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity timer_tb is
end entity timer_tb;

architecture test_bench of timer_tb is
	component timer is
	port (
		clk		: in	std_logic;
		enable	: in	std_logic;
		target	: in	unsigned(31 downto 0);
		done	: out	std_logic
	);
	end component timer;
	
	signal clk 		: std_logic := '0';
	signal enable	: std_logic := '0';
	signal target 	: unsigned(31 downto 0);
	signal done 	: std_logic;
begin
	clk <= not clk after 1ns;
	
	stimulus : process
	begin
		wait for 0.5 ns;
		target <= to_unsigned(2, 32);
		wait for 1 ns;
		enable <= '1';
		wait for 10 ns;
		enable <= '0';
		wait for 1 ns;
		target <= to_unsigned(4, 32);
		wait for 1 ns;
		enable <= '1';
		wait for 20 ns;
		enable <= '0';
		wait;
	end process stimulus;

	
	T0: timer port map (clk => clk, target => target, done => done, enable => enable);
end architecture test_bench;