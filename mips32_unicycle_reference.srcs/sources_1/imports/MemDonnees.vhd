---------------------------------------------------------------------------------------------
--
--	Université de Sherbrooke 
--  Département de génie électrique et génie informatique
--
--	S4i - APP4 
--	
--
--	Auteur: 		Marc-André Tétrault
--					Daniel Dalle
--					Sébastien Roy
-- 
---------------------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all; -- requis pour la fonction "to_integer"
use work.MIPS32_package.all;

entity MemDonnees is
Port ( 
	clk 		: in std_logic;
	reset 		: in std_logic;
	i_MemRead 	: in std_logic;
	i_MemWrite 	: in std_logic;
	i_SIMD      : in std_logic;
    i_Addresse 	: in std_logic_vector (31 downto 0);
	i_WriteData : in std_logic_vector (31 downto 0);
	i_WriteData2 : in std_logic_vector (31 downto 0);
	i_WriteData3 : in std_logic_vector (31 downto 0);
	i_WriteData4 : in std_logic_vector (31 downto 0);
    o_ReadData 	: out std_logic_vector (31 downto 0);
    o_ReadData2 	: out std_logic_vector (31 downto 0);
    o_ReadData3 	: out std_logic_vector (31 downto 0);
    o_ReadData4 	: out std_logic_vector (31 downto 0)
);
end MemDonnees;

architecture Behavioral of MemDonnees is
    signal ram_DataMemory : RAM(0 to 255) := ( -- type défini dans le package
------------------------
-- Insérez vos donnees ici
------------------------
--  TestMirroir_data
X"12345678",
X"87654321",
X"bad0face",
X"00000001",
X"00000002",
X"00000003",
X"00000004",
X"00000005",
X"00000006",
X"5555cccc",
------------------------
-- Fin de votre code
------------------------
    others => X"00000000");

    signal s_MemoryIndex 	: integer range 0 to 255; -- 0-127
	signal s_MemoryRangeValid 	: std_logic;
	signal s_MemoryRangeValidSIMD : std_logic;

begin
    -- Transformation de l'adresse en entier à interval fixés
    s_MemoryIndex 	<= to_integer(unsigned(i_Addresse(9 downto 2)));
	s_MemoryRangeValid <= '1' when i_Addresse(31 downto 10) = (X"10010" & "00") else '0';
	s_MemoryRangeValidSIMD <= '1' when (s_MemoryRangeValid = '1' and s_MemoryIndex < 253) else '0';
	
	-- Partie pour l'écriture
	process( clk )
    begin
        if clk='1' and clk'event then
            if reset = '0' and s_MemoryRangeValid = '1' and i_MemWrite = '1' then
                ram_DataMemory(s_MemoryIndex) <= i_WriteData;
                if i_SIMD = '1' then
                    ram_DataMemory(s_MemoryIndex+1) <= i_WriteData2;
                    ram_DataMemory(s_MemoryIndex+2) <= i_WriteData3;
                    ram_DataMemory(s_MemoryIndex+3) <= i_WriteData4;
                end if;
            end if;
        end if;
    end process;

    -- Valider que nous sommes dans le segment de mémoire, avec 256 addresses valides
    o_ReadData <= ram_DataMemory(s_MemoryIndex) when (s_MemoryRangeValid = '1' and i_MemRead = '1')
                    else (others => '0');

    o_ReadData2 <= ram_DataMemory(s_MemoryIndex+1) when (s_MemoryRangeValidSIMD = '1' and i_MemRead = '1' and i_SIMD = '1')
                    else (others => '0');

    o_ReadData3 <= ram_DataMemory(s_MemoryIndex+2) when (s_MemoryRangeValidSIMD = '1' and i_MemRead = '1' and i_SIMD = '1')
                    else (others => '0');

    o_ReadData4 <= ram_DataMemory(s_MemoryIndex+3) when (s_MemoryRangeValidSIMD = '1' and i_MemRead = '1' and i_SIMD = '1')
                    else (others => '0');

end Behavioral;

