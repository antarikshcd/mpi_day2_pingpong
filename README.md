# mpi_day2_pingpong
Ping pong exercise from MPI day2

Additional comments:
1) Ping-pong is to be executed between 2 processes.
2) Place a ping-pong counter to count the back and forth.
   Each ping-pong shot(aka messge transfer) will add 1 to the counter.
3) MPI_Send and MPI_Recv performs blocking operations. This means that the code
   after these statements won't execute until the operations are completed and 
   a receipt is sent back.
4) Use MPI_Wtime() to get the times and then subtract them.
