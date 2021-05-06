module queue (input wire clk, reset, rw, input wire [3:0] din, output wire empty1, full1, output wire [3:0] dout);
	/*
	components used:
	2 alu's
	2 comparators
	2 3-bit registers(front & rear)
	1 1-bit register(empty)
	4 inverters
	4 and gates
	3 2:1 mux
	2 3-bit 2:1 mux
	1 memory unit(8 locations and 4-bit word length)
	*/

	// state variables
	reg [2:0] front, rear;
	reg empty;

	// temp wires
	wire emptyStar, full, ignoreCarry, frontEqualsRear, fullBar, w_def, emptyBar, select0, frontEqualsRearBar, select1, muxOut0, select2, muxOut1, rwBar;
	wire [2:0] frontPlusOne, rearPlusOne, w_addr, frontStar;

	// initialisation
	initial begin
		front = 0;
		rear = 0;
		empty = 1;
	end
	
	// memory unit
	xst_ram_1r1w_synch_8_4_0 ram0(clk, reset, w_def, din, w_addr, front, dout);
	
	// combination logic
	alu a0(2'b00, front, 3'b001, frontPlusOne, ignoreCarry);
	alu a1(2'b00,  rear, 3'b001,  rearPlusOne, ignoreCarry);
	
	compare c0(front, rearPlusOne, full);
	compare c1(front, rear, frontEqualsRear);
		
	invert i0(full, fullBar);
	invert i1(empty, emptyBar);
	invert i2(frontEqualsRear, frontEqualsRearBar);
	invert i3(rw, rwBar);
	
	and2 and0(fullBar, rw, w_def);
	and2 and1(w_def, emptyBar, select0);
	and2 and3(frontEqualsRearBar, emptyBar, select1);
	and2 and4(frontEqualsRear, muxOut0, select2);

	mux2 m0(emptyBar, empty, rw, muxOut0);
	mux2 m1(1'b1, 1'b0, rw, muxOut1);
	mux2 m2(empty, muxOut1, select2, emptyStar);
	
	threeBit21Mux tbm0(rear, rearPlusOne, select0, w_addr);
	threeBit21Mux tbm1(front, frontPlusOne, select1, frontStar);	
	
	// empty & full output
	assign empty1 = empty;
	assign full1 = full;
	
	// next state's state variables
	always @(posedge clk) begin
		if (rwBar) front <= frontStar;
		rear <= w_addr;
		empty <= emptyStar;
	end
endmodule

