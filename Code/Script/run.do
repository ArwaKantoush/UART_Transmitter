vlib work
vlog Parity_Calculator.v Serializer.v FSM.v MUX.v UART_TX.v UART_TX_tb.v
vsim -voptargs=+acc work.UART_TX_tb
add wave *
run -all
#quit -sim
