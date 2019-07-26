library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use work.Common.all;

entity Leros_top is
    Port (
        led : out std_logic_vector(15 downto 0);
        clk : in std_logic
    );
end Leros_top;

architecture Behavioral of Leros_top is

    signal im_data_in : std_logic_vector(INSTR_WIDTH - 1 downto 0);
    signal im_addr : unsigned(REG_WIDTH - 1 downto 0);
    signal acc : std_logic_vector(REG_WIDTH - 1 downto 0);

    signal dm_data_rd : std_logic_vector(REG_WIDTH - 1 downto 0);
    signal dm_data_wr : std_logic_vector(REG_WIDTH - 1 downto 0);
    signal dm_addr : unsigned(REG_WIDTH - 1 downto 0);
    signal dm_wr_en : std_logic;

begin

    led <= acc(15 downto 0);

    Core_ent :  entity work.Leros_core
    port map (
        im_addr => im_addr,
        im_data_in_valid => '1',
        dm_addr => dm_addr,
        dm_data_in_valid => '0',
        reg_data_in => (others => '0'),
        dm_data_in => dm_data_rd,
        dm_data_out => dm_data_wr,
        dm_wr_en => dm_wr_en,
        clk => clk,
        rst => '0',
        im_data_in => im_data_in,
        acc_sig => acc
    );

    Data_mem : entity work.RAM
    generic map (
        data_width => REG_WIDTH,
        addr_width => 8
    )
    port map (
        clk => clk,
        data_in => dm_data_wr,
        data_out => dm_data_rd,
        addr => dm_addr(7 downto 0),
        wr_en => dm_wr_en
    );

    Instr_mem : entity work.ROM
    generic map (
        data_width => INSTR_WIDTH,
        addr_width => 4
    )
    port map (
        addr => im_addr(3 downto 0),
        data_out => im_data_in
    );

end Behavioral;
