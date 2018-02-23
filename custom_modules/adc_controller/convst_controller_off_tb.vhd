-- convst_controller_off_tb.vhd

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity convst_controller_off_tb is
end entity convst_controller_off_tb;

architecture test_bench of convst_controller_off_tb is
	component convst_controller is
	port (
		clk		: in	std_logic;
		set		: in	std_logic;
		reset	: in	std_logic;
		mode	: in	std_logic_vector(1 downto 0);
		target	: in 	unsigned(31 downto 0);
		convst	: out 	std_logic;
		done	: out	std_logic
	);
	end component convst_controller;

	signal clk		: std_logic := '0';
	signal set		: std_logic := '0';
	signal reset	: std_logic := '0';
	signal mode		: std_logic_vector(1 downto 0) := "00";
	signal target	: unsigned(31 downto 0) := x"00000000";
	signal convst	: std_logic;
	signal done		: std_logic;

	-- Modes
	constant OFF 	: std_logic_vector(1 downto 0) := "00";
	constant SLEEP 	: std_logic_vector(1 downto 0) := "01";
	constant NAP 	: std_logic_vector(1 downto 0) := "10";
	constant ONM	: std_logic_vector(1 downto 0) := "11";
begin
	clk <= not clk after 1ns;

	stimulus : process
	begin
		wait for 0.5 ns;
		mode <= OFF;
        target <= x"00000000";
        wait for 2 ns;
        set <= '1';
        wait for 2 ns;
        set <= '0';
        wait for 10 ns;
        reset <= '1';
        wait for 2 ns;
        reset <= '0';
        wait for 20 ns;
        reset <= '1';
        wait for 2 ns;
        reset <= '0';
        wait for 200 ns;
        reset <= '1';
        wait for 2 ns;
        reset <= '0';
        wait for 1100 ns;
        reset <= '1';
        wait for 2 ns;
        reset <= '0';
        wait for 500 ns;
        reset <= '1';
        wait for 2 ns;
        reset <= '0';
        wait for 20 ns;
        target <= x"00001000";
        wait for 2 ns;
        set <= '1';
        wait for 2 ns;
        set <= '0';
        wait for 10 ns;
        reset <= '1';
        wait for 2 ns;
        reset <= '0';
        wait for 20 ns;
        reset <= '1';
        wait for 2 ns;
        reset <= '0';
        wait for 200 ns;
        reset <= '1';
        wait for 2 ns;
        reset <= '0';
        wait for 1100 ns;
        reset <= '1';
        wait for 2 ns;
        reset <= '0';
        wait for 350 ns;
        reset <= '1';
        wait for 2 ns;
        reset <= '0';
		wait;
	end process stimulus;


	CC: convst_controller port map (clk => clk, set => set, reset => reset,
		mode => mode, target => target, convst => convst, done => done);

end architecture test_bench; -- of convst_controller_off_tb
