-- convst_controller.vhd

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity convst_controller is
	port (
		clk		: in	std_logic := '0';
		set		: in	std_logic := '0';
		reset	: in	std_logic := '0';
		mode	: in	std_logic_vector(1 downto 0);
		target	: in 	unsigned(31 downto 0);
		convst	: out 	std_logic;
		done	: out	std_logic
	);
end entity convst_controller;

architecture rtl of convst_controller is

	signal imode	: std_logic_vector(1 downto 0) := "00";

	-- Convst Signals
	signal iconvst	: std_logic := '0';

	-- Done Signals
	signal idone	: std_logic := '0';


    -- Maximum Conversion Time (Minimum Required) 1.6us -> 1600ns
    -- Assuming 500 mHz Clock (Period 2 ns)
    -- Minimum Conversion timer 800
    constant CT         : unsigned(31 downto 0) := x"00000320";

    -- Conversion Time Signals
    signal ct_set       : std_logic := '0';
    signal ct_reset     : std_logic := '0';
    signal ct_sro       : std_logic := '0';
    signal ct_enable    : std_logic := '0';
    signal ct_target    : unsigned(31 downto 0) := CT;
    signal ct_done      : std_logic := '0';

    -- Minimum Convst Pulse Width 20ns
	-- Assuming 500 mHz Clock (Period 2 ns)
	-- Minimum pulse target 10
	constant CPW        : unsigned(31 downto 0) := x"0000000A";

    -- Conversion Pulse Width Signals
    signal cpw_set      : std_logic := '0';
    signal cpw_reset    : std_logic := '0';
    signal cpw_sro      : std_logic := '0';
    signal cpw_enable   : std_logic := '0';
    signal cpw_target   : unsigned(31 downto 0) := CPW;
    signal cpw_done     : std_logic := '0';

	component timer is
	port (
		clk		: in	std_logic;
		enable	: in	std_logic;
		target	: in	unsigned(31 downto 0);
		done	: out	std_logic
	);
	end component timer;

	component sr_ff is
	port (
		clk		: in	std_logic := '0';
		set		: in	std_logic := '0';
		reset	: in	std_logic := '0';
		output	: out	std_logic := '0'
	);
	end component sr_ff;

	-- Modes
	constant OFF 	: std_logic_vector(1 downto 0) := "00";
	constant SLEEP 	: std_logic_vector(1 downto 0) := "01";
	constant NAP 	: std_logic_vector(1 downto 0) := "10";
	constant ONM	: std_logic_vector(1 downto 0) := "11";

begin
	main_proc : process (clk)
	begin
		if(rising_edge(clk)) then
			if(set = '1') then
				imode <= mode;
			elsif(reset = '1') then
				idone <= '0';
			end if;
		end if;
	end process main_proc;

    -- DONE HANDLING
    ct_proc : process (clk)
    begin
        if(rising_edge(clk)) then
            if(set = '1') then
                -- Set the Conversion Time Timer
                -- If Off or Sleeping Set Conversion Time to Minimum
                if(mode = OFF or mode = SLEEP) then
                    ct_target <= CT;
                else
                    -- The Conversion Time is the Max(Tartget, CT)
                    if(target < CT) then
                        ct_target <= CT;
                    else
                        ct_target <= target;
                    end if;
                end if;
            end if;
            if (ct_done = '1') then
                if(reset = '1') then
                    ct_reset <= '1';
                else
                    ct_reset <= '0';
                end if;
            else
                ct_reset <= '0';
            end if;
        end if;
    end process ct_proc;

    ct_enable <= ct_sro;
    ct_set <= set;
    CT_SRFF	: sr_ff port map(clk => clk, set => ct_set, reset => ct_reset, output => ct_sro);
    CT_TM	: timer port map(clk => clk, enable => ct_enable, target => ct_target, done => ct_done);

    done <= ct_done;

    -- CONVST HANDLING
    cpw_proc : process (clk)
    begin
        if(rising_edge(clk)) then
            if(set = '1') then
                iconvst <= '1';

                -- Setup Pulse Width Timer
                if(mode = NAP) then
                    if(target < CT) then
                        cpw_target <= CT;
                    else
                        cpw_target <= target;
                    end if;
                else
                    cpw_target <= CPW;
                end if;
            end if;
            if (cpw_done = '1') then
                if(iconvst = '1') then
                    if(imode = ONM) then
                        iconvst <= '0';
                    else
                        iconvst <= '1';
                    end if;
                else
                    iconvst <= '0';
                end if;
            end if;
            if (ct_done = '1') then
                if(imode = NAP) then
                    iconvst <= '0';
                end if;
                if(reset = '1') then
                    cpw_reset <= '1';
                    iconvst <= '0';
                else
                    cpw_reset <= '0';
                end if;
            else
                cpw_reset <= '0';
            end if;
		end if;
    end process cpw_proc;

    cpw_set <= set;
    cpw_enable <= cpw_sro;
	CPW_SRFF	: sr_ff port map(clk => clk, set => cpw_set, reset => cpw_reset, output => cpw_sro);
	CPW_TM		: timer port map(clk => clk, enable => cpw_enable, target => cpw_target, done => cpw_done);

	convst <= iconvst;
end architecture rtl; -- of convst_controller
