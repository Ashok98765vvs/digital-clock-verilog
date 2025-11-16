==========================
 SIMPLE QUESTA RUN GUIDE
==========================

1. Create a new folder for your project.
   Put your design file and testbench file inside it.

2. Open QuestaSim terminal and create the work library:
   vlib work
   vmap work work

3. Compile your design and testbench files:
   vlog design.sv
   vlog testbench.sv
   (use vcom if you are using VHDL)

4. Run the testbench:
   vsim work.testbench

5. Add all signals to the waveform window:
   add wave *

6. Run the simulation:
   run -all

7. Zoom waveforms using the Wave window buttons:
   - Zoom In
   - Zoom Out
   - Zoom Full

8. Optional: Force a clock or input triggers:
   force -deposit clk 0 0ns, 1 5ns -repeat 10ns
   force -deposit reset 1 0ns, 0 20ns

==========================
 END OF FILE
==
