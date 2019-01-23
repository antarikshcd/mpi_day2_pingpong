! Program for the ping-pong exercise from MPI:Day2

program main
    implicit none
	include 'mpif.h'
	integer, parameter :: mk = kind(1.0D0)
	integer(mk), parameter :: count = 2**18
	integer(mk) :: ierror, rank, size, ilen, i, tag, &
               status(MPI_STATUS_SIZE),src,dest, ping_pong_cnt, &
               ping_pong_limit
    character(len=256) :: name
    integer(mk), dimension(count) :: msg
    real(mk) :: t1, t2 

    ! initialize MPI
    call MPI_Init(ierror)
    !print*, 'MPI initializion error signal: ',ierror
    
    ! print the rnak of MPI_COMM_WORLD
    call MPI_Comm_RANK(MPI_COMM_WORLD, rank, ierror)
    !print*, 'MPI rank: ', rank, 'error status: ',ierror

    ! print the total number of sizes in the communicator
    call MPI_Comm_Size(MPI_COMM_WORLD, size, ierror)
    !print*, 'MPI size: ', size, 'error status: ',ierror

    ! print the processor name
    call MPI_Get_Processor_Name(name, ilen, ierror) 
    !print*,'MPI processor name', name(1:ilen), 'error status: ',ierror
    
    ! set the ping pong ping_pong_limit
    ping_pong_limit = 10

    ! set the message
    msg = 1
    ! intitalize the ping pong counter
    ping_pong_cnt = 0
    ! start the sending and receiving
    
    if (mod(size,2) .eq. 0) then

        
        do while (ping_pong_cnt < ping_pong_limit/2)
        if (mod(rank,2) .eq. 0) then
        ! first send and then receive
           !rank of the destination process
           dest = rank + 1 ! send to the right
           src =  rank + 1
           
           
           ! update the ping-pong counter before send operation
           ping_pong_cnt = ping_pong_cnt + 1
           ! time the code using MPI_Wtime
           t1 = MPI_Wtime()

           call MPI_Send(msg, count, MPI_DOUBLE_PRECISION, dest, tag,&
                          MPI_COMM_WORLD, ierror) 

           ! time the code using MPI_Wtime
           ! this code executes only when receipt of message is conformed
           t2 = MPI_Wtime()
           ! time for sending the message
           print*,'Time to send message = ', (t2-t1),'[s] from rank ',rank,&
                  'to rank ', dest
            
           ! now receive the messgae sent back by the receiver
           call MPI_Recv(msg, count, MPI_DOUBLE_PRECISION, src, tag,&
                          MPI_COMM_WORLD, status, ierror)

            
            print*,'PONG: Rank ',rank, 'received msg from source ',src
            
        else
            ! first receive and then send
            src = rank - 1
            dest = rank - 1 ! send to the right

            call MPI_Recv(msg, count, MPI_DOUBLE_PRECISION, src, tag,&
                          MPI_COMM_WORLD, status, ierror)
            print*,'PING: Rank ',rank, 'received msg from source ',src
     
            ! now send the message back to the sender
           ! update the ping-pong counter before send operation
           ping_pong_cnt = ping_pong_cnt + 1
           
           ! time the code using MPI_Wtime
           t1 = MPI_Wtime()
           call MPI_Send(msg, count, MPI_DOUBLE_PRECISION, dest, tag,&
                          MPI_COMM_WORLD, ierror) 
           t2 = MPI_Wtime()
           ! time for sending the message
           print*,'Time to send message = ', (t2-t1),'[s] from rank ',rank,&
                  'to rank ', dest


        endif   
        enddo
    else
        if (rank .eq. 0) then
            print*,'Rank: ',rank
            print*, 'Ping pong not executed! Needs even number of processes!'
        endif

    endif

    !call MPI_Barrier(MPI_COMM_WORLD,ierror) ! do i need a barrier?

    if (rank .eq. 0) then
        print*, 'Ping-pong limit of ', ping_pong_limit, 'reached.'
    endif
    ! terminate MPI
    call MPI_Finalize(ierror)   

 end program main
    