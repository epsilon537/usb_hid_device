/* FPGA Toplevel

 */

//`define ENABLE_DDR2LP
//`define ENABLE_HSMC_XCVR
//`define ENABLE_SMA
//`define ENABLE_REFCLK
//`define ENABLE_GPIO

`default_nettype none

module top_usb_device #(
    parameter J1_ROM_INIT_FILE = "j1_keyboard.hex"
) (
    input  wire       clk,
    input  wire       usb_clk,
    input  wire       reset_in_n,
    input  wire       dm_i,
    input  wire       dp_i,
    output wire       dm_o,
    output wire       dp_o,
    output wire       usb_oe,
    output wire [7:0] ledg,
    output wire [9:0] ledr
);

  import types::*;

  logic dm_out_reg, dp_out_reg;

  /* USB */
  d_port_t usb_d_i;  // USB port D+, D- (input)
  d_port_t usb_d_o;  // USB port D+, D- (output)
  wire     usb_d_en;  // USB port D+, D- (enable)

  wire     reset;  // reset
  /* external ports */
  assign dm_o   = dm_out_reg;
  assign dp_o   = dp_out_reg;
  assign usb_oe = usb_d_en;

  always_comb begin
    usb_d_i                  = d_port_t'({dp_i, dm_i});
    {dp_out_reg, dm_out_reg} = (usb_d_en) ? usb_d_o : 2'bz;
  end

  if_wb wbm (
      .rst(reset),
      .clk
  );
  if_wb wbs1 (
      .rst(reset),
      .clk
  );
  if_wb wbs2 (
      .rst(reset),
      .clk
  );
  if_wb wbs3 (
      .rst(reset),
      .clk
  );
  if_wb wbs4 (
      .rst(reset),
      .clk
  );

  sync_reset sync_reset (
      .clk(clk),
      .reset_in_n(reset_in_n),
      .reset(reset)
  );

  j1_wb cpu (
      .wb(wbm),
      .*
  );

  wb_intercon wb_intercon (.*);

  wb_rom #(.INIT_FILE(J1_ROM_INIT_FILE)) wb_rom (.wb(wbs1));

  wb_spram wb_spram (.wb(wbs2));

  board_io board_io (
      .reset,
      .key (4'b0),
      .sw  (10'b0),
      .hex (),
      .ledg(ledg),
      .ledr(ledr),
      .wb  (wbs3)
  );

  usb_device_controller usb_device_controller (
      .reset,
      .clk  (usb_clk),
      .usb_full_speed(1'b0),
      .d_i  (usb_d_i),
      .d_o  (usb_d_o),
      .d_en (usb_d_en),
      .wb   (wbs4)
  );
endmodule

`resetall
