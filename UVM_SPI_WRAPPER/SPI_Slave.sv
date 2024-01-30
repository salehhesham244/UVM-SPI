typedef enum reg [2:0] {IDLE,CHK_CMD,WRITE,READ_ADD,READ_DATA} states;

module SPI_Slave(SPI_wrapper_if.Slave slave_intf);
	states cs, ns;
	//po parallel output
	reg [9:0] PO;
	//so->serial output
	reg SO, flag_rd = 0;
	bit[3:0] state_count = 0, final_count = 0;

	assign slave_intf.MISO = SO;
	assign slave_intf.rx_data=PO;
 	//cs logic:
	always @(posedge slave_intf.clk or negedge slave_intf.rst_n) begin
		if (!slave_intf.rst_n)
		    cs <= IDLE;
		else
		    cs <= ns;
	end
	// always @(cs) begin
	// 	case (cs)
	// 	      IDLE: slave_intf.rx_valid = 0;
	// 	      WRITE: slave_intf.rx_valid = 1;
	// 	      READ_ADD: slave_intf.rx_valid = 1;
	// 	      READ_DATA: slave_intf.rx_valid = 1;
	// 	      default: slave_intf.rx_valid = 0;
	// 	endcase
	// end
 //adding if statment to cover when the reset occures and removing ssn from the sensetivity list
	always @(posedge slave_intf.clk,negedge slave_intf.rst_n) begin
		if(~slave_intf.rst_n)begin
			flag_rd<=0;
			PO<=0;
			state_count<=0;
			SO<=0;
			final_count<=0;
			slave_intf.SS_n<=1;
		end
		else begin
		if(ns==CHK_CMD)begin
			state_count<=0;
			final_count<=0;
		end
		else if ((cs == WRITE) || (cs == READ_ADD)||((cs == READ_DATA) && (!slave_intf.tx_valid))) begin
		    if (state_count != 10) begin
				PO <= {PO[8:0], slave_intf.MOSI};
				state_count <= state_count + 1;
				slave_intf.rx_valid<=0;
				end
			else begin
			slave_intf.rx_valid<=1;
			end
		end
		else if ((cs==READ_DATA) && slave_intf.tx_valid) begin
		    SO <= slave_intf.tx_data[7-final_count];
		    final_count <= final_count + 1;
		end
	end

	end
//////////////////////////////////////////////////////////////////////////////////////
	
	//ns logic
	//corrections on the flow for rd_flag
	always @(slave_intf.MOSI, slave_intf.SS_n, cs) begin
		case (cs)
		      IDLE:begin
			
			if (slave_intf.SS_n)
			    ns = IDLE;
			else
			    ns = CHK_CMD;
			  end
		      CHK_CMD:
			if (slave_intf.SS_n)
			    ns = IDLE;
			else begin
			    if (!slave_intf.MOSI)
				ns = WRITE;
			    else begin
				if (!flag_rd)begin
				    ns = READ_ADD;
					end
				else begin
				    ns = READ_DATA;
					end
			    end
			end

		      WRITE:begin
			if (slave_intf.SS_n)
			    ns = IDLE;
			else
			    ns = WRITE;
			  end

		      READ_ADD:
			if (slave_intf.SS_n)
			    ns = IDLE;
			else begin
			    ns = READ_ADD;
   				flag_rd=1;
			end


		      READ_DATA:
			if (slave_intf.SS_n)
			    ns = IDLE;
			else begin
			    ns = READ_DATA;
				flag_rd=0;
			end
		      default: ns = IDLE;
		endcase
	end

	`ifdef SIM_PARAM
 
  //sequential
  property p1;
  @(posedge slave_intf.clk) disable iff (!slave_intf.rst_n) (state_count==10) |=> slave_intf.rx_valid ;
  endproperty

  property p2;
  @(posedge slave_intf.clk) disable iff (!slave_intf.rst_n) (slave_intf.rx_valid) |=> slave_intf.rx_data==PO ;
  endproperty

  property p3;
  @(posedge slave_intf.clk) disable iff (!slave_intf.rst_n) ((cs==READ_DATA) && slave_intf.tx_valid)  |=> slave_intf.MISO===$past(slave_intf.tx_data[7-final_count]);
  endproperty

  property p4;
  @(posedge slave_intf.clk) disable iff (!slave_intf.rst_n) (slave_intf.SS_n)  |=> (cs==IDLE);
  endproperty
	property slave_intf_tx_valid_still_high;
		@(posedge slave_intf.clk)disable iff(!slave_intf.rst_n || slave_intf.SS_n)  $rose(slave_intf.tx_valid) |=> $stable(slave_intf.tx_valid)[->7]; //
	endproperty
	always_comb begin : proc
		if(!slave_intf.rst_n)
			assert final (cs==IDLE);
	end
	
	//slave_intf.tx_valid_still_high_label:
	assert property(slave_intf_tx_valid_still_high);
	//slave_intf.tx_data_still_high_label:
	assert property(slave_intf_tx_data_still_high);

	//slave_intf.tx_valid_still_high_label_cover:
	cover property(slave_intf_tx_valid_still_high);
	//slave_intf.tx_data_still_high_label_cover:
	cover property(slave_intf_tx_data_still_high);


  // Assertion for rx_valid
  assert property (p1);
  cover property (p1);

  // Assertion for rx_data
  assert property (p2);
  cover property (p2);

  // Assertion for MiSO
  assert property (p3);
  cover property (p3);

  // Assertion for MiSO
  assert property (p4);
  cover property (p4);

`endif

endmodule
