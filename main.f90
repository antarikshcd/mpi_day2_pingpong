! Program for the ping-pong exercise from MPI:Day2

program main
    implicit none
	include 'mpif.h'
	integer, parameter :: mk = kind(1.0D0)
	integer :: count = 1
	integer :: ierror, rank, size, ilen, i, tag, status(MPI_STATUS_SIZE),src,dest
    character(len=256) :: name
    real(mk) :: msg

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

    ! set the message
    msg = 1.0_mk

    
    ! start the sending and receiving
    
    if (mod(size,2) .eq. 0) then

        if (mod(rank,2) .eq. 0) then
        ! first send and then receive
           !rank of the destination process
           dest = rank + 1 ! send to the right
           call MPI_Send(msg, count, MPI_DOUBLE_PRECISION, dest, tag,&
                          MPI_COMM_WORLD, ierror) 

           
           src =  rank + 1 
           ! now receive the messgae sent back by the receiver
           call MPI_Recv(msg, count, MPI_DOUBLE_PRECISION, src, tag,&
                          MPI_COMM_WORLD, status, ierror)

            print*,'PONG: Rank ',rank, 'received msg= ',msg, 'from source ',src
            
        else
            ! first receive and then send
            src = rank - 1
            call MPI_Recv(msg, count, MPI_DOUBLE_PRECISION, src, tag,&
                          MPI_COMM_WORLD, status, ierror)
            print*,'PING: Rank ',rank, 'received msg= ',msg, 'from source ',src
     
            ! now send the message back to the sender
           dest = rank - 1 ! send to the right
           call MPI_Send(msg, count, MPI_DOUBLE_PRECISION, dest, tag,&
                          MPI_COMM_WORLD, ierror) 


        endif   
    
    else
        if (rank .eq. 0) then
            print*,'Rank: ',rank
            print*, 'Ping pong not executed! Needs even number of processes!'
        endif

    endif

    ! terminate MPI
    call MPI_Finalize(ierror)   

 end program main
    