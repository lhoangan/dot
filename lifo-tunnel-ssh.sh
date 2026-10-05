#!/bin/bash
#
# -------------------------------------------
# SSH tunnel creation on sully
# -------------------------------------------
# Rali - LIFO
#

# Switch to default (english)
export LC_ALL=C

PORT1=2200
PORT2=""
PORT2_L=0
SRV_DEST=""
SULLY=193.49.80.141
LIFO_USER=""
SSH_PID=0
LIFO_TUNNEL_STATUS=/tmp/.$USER-lifo-tunnel-status

# Get the SSH process id
# ---------------------------------------------------------
function get_service_pid()
{
	SSH_PID=$(lsof -i -P | grep LISTEN | grep ":$1" | grep -i ipv4 | awk '{print $2}')
}

# Check if client's local port (parameter) is free
# ---------------------------------------------------------
function is_free()
{
	local PORT_L
	PORT_L=$(lsof -i -P | grep LISTEN | grep ":$1" | grep -i ipv4 | awk '{print $9}' | cut -d: -f2)

	if [ "$PORT_L" == "" ]; then
		return 0
	else
		return 1
	fi
}

# Check if wired/Wifi connection (local/outside the campus)
# ---------------------------------------------------------
function is_local()
{
        user_location=$(ping -c1 -W1 192.168.80.1 | grep transmitted | awk '{print $4}')

        if [ "$user_location" == "1" ]; then
                # From Office/Uni.
                is_eduspot=$(ping -c1 -W1 8.8.8.8 | grep transmitted | awk '{print $4}')


                if [ "$is_eduspot" == "0" ]; then
                        # From EDUSPOT
                         return 1
                else
                # From EDUROAM or Ethernet
                        is_eduroam=$(ping -c1 -W1  pews | grep transmitted | awk '{print $4}')
                        [ "$is_eduroam" == "0" ]  && return 1 || return 0
                fi

        else
                # From outside Uni.
                return 1
        fi
}

# Set sully address depending on client's location
# ---------------------------------------------------------
function set_sully()
{
        if  is_local ; then
                 SULLY=192.168.80.237
        else
                SULLY="sully.univ-orleans.fr"
        fi
}


# check if a variable is a IP address
# ---------------------------------------------------------
function is_ip()
{
	local test
	test='([1-9]?[0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])'
	[[ $1 =~ ^$test\.$test\.$test\.$test$ ]] && return 0 || return 1
}


# checks if a host exists on LIFO/UO's LAN
# ---------------------------------------------------------
function server_is_valid()
{
        local CHECK_HOST
	local IS_ALIVE
        CHECK_HOST=$(ssh $LIFO_USER@$SULLY getent hosts $1 | awk '{ print $1 }')

	if [ "$CHECK_HOST" != "" ] ; then
		return 0
	else
		if is_ip $1 ; then
			IS_ALIVE=$(ssh $LIFO_USER@$SULLY ping -c1 -W1 $1 | grep transmitted | awk '{print $4}')
			[ "$IS_ALIVE" == "1" ] && return 0 || return 1
		else
			return 1
		fi
	fi
}

# choose a local port to forward to
# ---------------------------------------------------------
function set_local_port2()
{
	if [ ! "$1" -gt 1024 ]; then
		PORT2_L=$(expr 100 '*' "$1")
	else
		PORT2_L=$1
	fi
}

# lifo-tunnel-ssh.sh usage
# ---------------------------------------------------------
function _usage()
{
	echo -e "SSH tunnel creation/destruction and port forwarding".
        echo -e "usage:\t forward-lifo-port.sh [ -u | --user ] LIFO_LOGIN [ -s | --server ] LIFO_SERVER ] [ -p | --port ] LIFO_SERVER_PORT"
        echo -e "\t [ -d | --destroy ]"
        echo -e "\t [ -h | --help ]"
        echo -e "\t --status"

	echo -e "Examples:"
         echo -e "\t lifo-tunnel-ssh.sh -u smith -s gaiavm"
	 echo -e "\t lifo-tunnel-ssh.sh -u smith -s mirevserver -p 80"
         echo -e "\t lifo-tunnel-ssh.sh --status"
}

# Kill all local processes related to SSH
# ---------------------------------------------------------
function kill_proc()
{
	local i

	if [ -f $LIFO_TUNNEL_STATUS  ] ; then
		echo "Destroying the SSH tunnel..."
		for i in $PORT1 $PORT2_L
		do
			if ! is_free $i ; then
				get_service_pid $i
				[ $SSH_PID -gt 0 ] && kill -9 $SSH_PID > /dev/null 2>&1
			fi
		done
		rm $LIFO_TUNNEL_STATUS
		echo -e "SSH tunnel destroyed."
	else
		echo -e "Pas de tunnel SSH !"
	fi
}

# Show the Tunnel status
# ---------------------------------------------------------
function show_status()
{
	local port_l
	local srv_l
        local port_d
	local other_port=""
	[ "$LIFO_USER" == "" ] && LIFO_USER="<login>"

	if [ -f $LIFO_TUNNEL_STATUS  ]; then
		echo -e "-------------------------------------------------------"
		echo -e "LIFO SSH tunnel status\t\t\t\t[OK]"
		echo -e "-------------------------------------------------------"
		for i in $(cat  $LIFO_TUNNEL_STATUS)
		do
			port_l=$(echo $i | cut -d";" -f1)
			srv_l=$(echo $i | cut -d";" -f2)
			port_d=$(echo $i | cut -d";" -f3)
			[ "$port_l" != "2200" ] && other_port=$port_l
			echo -e "localhost:$port_l ---(forwarded to)---> $srv_l:$port_d"
		done
		echo -e "-------------------------------------------------------"
		echo -e " - SSH Connection to $srv_l : "
		echo -e "    ssh $LIFO_USER@localhost -p $PORT1"
                echo -e "-------------------------------------------------------"
		echo -e " - Copy file(s) to/from $srv_l : "
		echo -e "    sftp -P $PORT1 $LIFO_USER@localhost"
		echo -e "    scp -P $PORT1 src_file $LIFO_USER@localhost:"
		echo -e "    scp -P $PORT1 $LIFO_USER@localhost:src_file dest_dir"
		if [ "$other_port" != "" ] ; then
			echo -e "-------------------------------------------------------"
			echo -e " - HTTP connection to $srv_l : "
			echo -e "    http://localhost:$other_port"
		fi
		echo
	else
		echo "No SSH tunnel !"
	fi
}

# Check if variable in parameter is a number
# ---------------------------------------------------------
is_number()
{
        local re
        re='^[0-9]+$'
        [[ $1 =~ $re ]] && return 0 || return 1
}

# Check if user (-u username) parameter is entered
# ---------------------------------------------------------
function user_exists()
{
        [ "$LIFO_USER" != "" ] && return 0 || return 1
}

# Check if server (-s server_name/IP) parameter is entered
# ---------------------------------------------------------
function server_exists()
{
        [ "$SRV_DEST" != "" ] && return 0 || return 1
}

# Check if port (-p port_number) parameter is entered
# ---------------------------------------------------------
function port_exists()
{
        [ "$PORT2" != ""  ] && return 0 || return 1
}

# Create an SSH tunnel between localhost and remote server
# ---------------------------------------------------------
function create_tunnel()
{
	echo -e "Creating the tunnel ..."
	if [ $PORT2_L -gt 0 ]; then
		if is_free $PORT2_L ; then
			ssh -fNT  -L $PORT1:$SRV_DEST:22 -L $PORT2_L:$SRV_DEST:$PORT2 $LIFO_USER@$SULLY > /dev/null 2>&1
			if is_free $PORT1 ; then
				echo -e "Problem encountered !"
			else
				echo "$PORT1;$SRV_DEST;22" >>  $LIFO_TUNNEL_STATUS
				echo "$PORT2_L;$SRV_DEST;$PORT2" >> $LIFO_TUNNEL_STATUS
				show_status
			fi
		else
			echo "Port $PORT2_L is already used !"
			exit 0
		fi
	else
		ssh -fNT  -L 2200:$SRV_DEST:22 $LIFO_USER@$SULLY > /dev/null 2>&1
		if is_free $PORT1 ; then
			echo -e "Problem encountered !"
		else
			echo "$PORT1;$SRV_DEST;22" >>  $LIFO_TUNNEL_STATUS
			show_status
		fi
	fi
}


# ---------------------------------------------------------
# MAIN()

# Load the user defined parameters
while [[ $# > 0 ]]
do
        case "$1" in

		# Destroy the SSH tunnel
		-d|--destroy)
			kill_proc
			exit 0
  			;;

		--status)
			show_status
			exit 0
			;;

                -u|--user)
                	LIFO_USER="$2"
                	shift
                	;;

                -s|--server)
                	SRV_DEST="$2"
                	shift
                	;;

                -p|--port)
                	PORT2="$2"
                	shift
                	;;

                -h|--help|*)
			_usage
                	exit 0
                	;;
        esac
        shift
done

if user_exists ; then
	if server_exists ; then
		# Check local port 2200
		if is_free $PORT1 ; then
			# Check PORT2
			if port_exists ; then
				if is_number $PORT2 ; then
					# Set PORT2_L
					set_local_port2 $PORT2
				else
					echo "Port must be a number !"
					exit 0
				fi
			fi

			set_sully
			if server_is_valid $SRV_DEST ; then
				create_tunnel
			else
				echo "Invalid server $SRV_DEST !"
			fi
		# Port 2200 is not free
		else
			echo "Port $PORT1 unavailable or tunnel already created !"
		fi

	# SRV_DEST does not exist
	else
		_usage
		exit 0
	fi
else
	_usage
	exit 0
fi
