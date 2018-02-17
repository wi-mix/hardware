-- seven_seg.vhd
-- Taken from tutorial 2

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity seven_seg is
    port (
        conduit_end_hex : out std_logic_vector(6 downto 0);
        avalon_slave_write_n : in  std_logic := '0';
        avalon_slave_writedata : in  std_logic_vector(31 downto 0) := (others => '0');
        clk : in  std_logic := '0';
        reset_n : in  std_logic := '0'
    );
end entity seven_seg;

architecture rtl of seven_seg is
procedure convert_hex_to_sev_seg (
    nibble : in std_logic_vector (3 downto 0);

    constant sev_seg_0 : std_logic_vector(6 downto 0) := not b"0111111"; -- ~0x3f
    constant sev_seg_1 : std_logic_vector(6 downto 0) := not b"0000110"; -- ~0x06
    constant sev_seg_2 : std_logic_vector(6 downto 0) := not b"1011011"; -- ~0x5b
    constant sev_seg_3 : std_logic_vector(6 downto 0) := not b"1001111"; -- ~0x4f
    constant sev_seg_4 : std_logic_vector(6 downto 0) := not b"1100110"; -- ~0x66
    constant sev_seg_5 : std_logic_vector(6 downto 0) := not b"1101101"; -- ~0x6d
    constant sev_seg_6 : std_logic_vector(6 downto 0) := not b"1111101"; -- ~0x7D
    constant sev_seg_7 : std_logic_vector(6 downto 0) := not b"0000111"; -- ~0x07
    constant sev_seg_8 : std_logic_vector(6 downto 0) := not b"1111111"; -- ~0x7f
    constant sev_seg_9 : std_logic_vector(6 downto 0) := not b"1101111"; -- ~0x6f
    constant sev_seg_a : std_logic_vector(6 downto 0) := not b"1110111"; -- ~0x7
    constant sev_seg_b : std_logic_vector(6 downto 0) := not b"1111100"; -- ~0x7c
    constant sev_seg_c : std_logic_vector(6 downto 0) := not b"0111001"; -- ~0x39
    constant sev_seg_d : std_logic_vector(6 downto 0) := not b"1011110"; -- ~0x5e
    constant sev_seg_e : std_logic_vector(6 downto 0) := not b"1111001"; -- ~0x79
    constant sev_seg_f : std_logic_vector(6 downto 0) := not b"1110001"; -- ~0x7112

    signal sev_seg : out std_logic_vector (6 downto 0) ) is
    begin
        case nibble is
            when x"0" => sev_seg <= sev_seg_0;
            when x"1" => sev_seg <= sev_seg_1;
            when x"2" => sev_seg <= sev_seg_2;
            when x"3" => sev_seg <= sev_seg_3;
            when x"4" => sev_seg <= sev_seg_4;
            when x"5" => sev_seg <= sev_seg_5;
            when x"6" => sev_seg <= sev_seg_6;
            when x"7" => sev_seg <= sev_seg_7;
            when x"8" => sev_seg <= sev_seg_8;
            when x"9" => sev_seg <= sev_seg_9;
            when x"a" => sev_seg <= sev_seg_a;
            when x"b" => sev_seg <= sev_seg_b;
            when x"c" => sev_seg <= sev_seg_c;
            when x"d" => sev_seg <= sev_seg_d;
            when x"e" => sev_seg <= sev_seg_e;
            when x"f" => sev_seg <= sev_seg_f;
        end case;
    end convert_hex_to_sev_seg;
    signal hex : std_logic_vector ( 6 downto 0);
begin
    write_to_seg : process( reset_n, avalon_slave_write_n ) is
    -- Declaration(s)
    begin
        if ( reset_n = '0' ) then
            convert_hex_to_sev_seg(nibble => x"0", sev_seg => hex);
        elsif (avalon_slave_write_n = '0') then
            convert_hex_to_sev_seg(nibble => avalon_slave_writedata(3 downto 0) , sev_seg => hex);
        end if;
    end process;
    conduit_end_hex <= hex;
end architecture rtl; --of seven_seg
