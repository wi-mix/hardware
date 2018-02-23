-- averager_tb.vhd

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity averager_tb is
end entity averager_tb;

architecture test_bench of averager_tb is
    component averager is
    	port (
    		clk		: in	std_logic := '0';
    		a     	: in	unsigned(15 downto 0) := x"0000";
            a_ready : in    std_logic := '0';
            b     	: in	unsigned(15 downto 0) := x"0000";
            b_ready : in    std_logic := '0';
            o       : out   unsigned(15 downto 0);
    		o_ready : out	std_logic
    	);
    end component averager;

    signal clk		: std_logic := '0';
    signal a        : unsigned(15 downto 0);
    signal a_ready  : std_logic := '0';
    signal b        : unsigned(15 downto 0);
    signal b_ready  : std_logic := '0';
    signal o        : unsigned(15 downto 0);
    signal o_ready  : std_logic;

begin
	clk <= not clk after 1ns;

	stimulus : process
	begin
        wait for 0.5 ns;
        a_ready <= '0';
        b_ready <= '0';
		a <= x"001"
        b <= x"001"
        wait for 2 ns;
        a_ready <= '1';
        b_ready <= '1';
        wait for 2 ns;
        a_ready <= '0';
        b_ready <= '0';
		wait for 2 ns;
		wait;
	end process stimulus;


	FD0: freq_divider port map (clk => clk, target => target, output => output);
end architecture test_bench; -- of averager_tb
