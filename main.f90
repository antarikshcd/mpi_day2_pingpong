! Program for the ping-pong exercise from MPI:Day2

program main
    implicit none
	include 'mpif.h'
	integer, parameter :: mk = kind(1.0D0)
	integer(mk) :: count 
	integer(mk) :: ierror, rank, size, ilen, i, tag, &
               status(MPI_STATUS_SIZE),src,dest, ping_pong_cnt, &
               ping_pong_limit
    character(len=256) :: name
    character(len=256) :: filename, countchar
    integer(mk), dimension(:), allocatable :: msg
    real(mk) :: t1, t2, tick 

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

    ! allocate the integer array msg
    !First, make sure the right number of inputs have been provided
    if(command_argument_count().ne.1) then
       write(*,*)'ERROR, ONE COMMAND-LINE ARGUMENT REQUIRED: ENTER MESSAGE SIZE, STOPPING'
       stop
    endif

    call get_command_argument(1,countchar)   !first, read in the two values

    ! convert it into integer of type double
    READ(countchar,*)count
    
    ! allocate message
    allocate(msg(count))    
    
    ! set the ping pong ping_pong_limit
    ping_pong_limit = 10

    ! set the message
    msg = 1
    ! intitalize the ping pong counter
    ping_pong_cnt = 0
    ! start the sending and receiving

    !get resolution of time
    tick = MPI_Wtick()
    if (rank .eq. 0) then

         print*, 'Wall time scale= ', tick, '[s]'

    endif
    ! generate the save file name
    write(filename, '(A,I1.1,A)') '3_output_rank', rank,'.dat'     
    
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

           !call sleep(0.0000001)
           open(10, file=filename, position='append')
           write(10, *) count, (t2-t1)
           close(10)
           call flush(10)       
            
           ! now receive the messgae sent back by the receiver
           call MPI_Recv(msg, count, MPI_DOUBLE_PRECISION, src, tag,&
                          MPI_COMM_WORLD, status, ierror)

            
            print*,'PONG: Rank ',rank, 'received msg of size ',count,'from source ',src
            
        else
            ! first receive and then send
            src = rank - 1
            dest = rank - 1 ! send to the right

            call MPI_Recv(msg, count, MPI_DOUBLE_PRECISION, src, tag,&
                          MPI_COMM_WORLD, status, ierror)
            print*,'PING: Rank ',rank, 'received msg of size ',count ,'from source ',src
     
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
           open(10, file=filename, position='append')
           write(10, *) count, (t2-t1)
           close(10)
           call flush(10)       


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
    