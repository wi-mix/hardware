-- pwm.vhd

-- This file was auto-generated as a prototype implementation of a module
-- created in component editor.  It ties off all outputs to ground and
-- ignores all inputs.  It needs to be edited to make it do something
-- useful.
-- 
-- This file will not be automatically regenerated.  You should check it in
-- to your version control system if you want to keep it.

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity pwm is
	port (
		avalon_slave_write_n   : in  std_logic                     := '0';             -- avalon_slave.write_n
		avalon_slave_writedata : in  std_logic_vector(31 downto 0) := (others => '0'); --             .writedata
		conduit_end_pulse      : out std_logic;                                        --  conduit_end.export
		clk                    : in  std_logic                     := '0';             --        clock.clk
		reset_sink_reset       : in  std_logic                     := '0'              --        reset.reset
	);
end entity pwm;

architecture rtl of pwm is
component timer is
	port (
		clk		: in	std_logic;
		enable	: in	std_logic;
		target	: in	unsigned(31 downto 0);
		done	: out	std_logic
	);
end component timer;

type state is (OFF, UP, DOWN);

signal pulseEnable	: std_logic:='0';
signal pulseTarget	: unsigned(31 downto 0);
signal done			: std_logic:='0';

signal periodEnable	: std_logic:='0';
signal periodTarget	: unsigned(31 downto 0);
signal done			: std_logic:='0';

signal reg			: std_logic_vector(31 downto 0); 
signal enable		: std_logic:= '0';

signal state		: state := OFF;
signal next_state	: state := OFF;

begin
	main_proc: process ()
		if(rising_edge(clk)) then
			if(avalon_slave_write_n = '1') then
				reg <= avalon_slave_writedata;
			end if;
			if(reg != x"00000000")
				count <= count + 1;
			end if;
		end if;
	end process main_proc;
end architecture rtl; -- of pwm
