#!/bin/bash
#
# -------------------------------------------
# Port forwarding through SSH tunnel on sully
# -------------------------------------------
# Rali - LIFO
#

# Switch to default (english)
export LC_ALL=C

PORT2=""
PORT2_L=0
SRV_DEST=""
SULLY="sully.univ-orleans.fr"
LIFO_USER=""
SVC_PID=0
USER_P_FWD_STATUS=/tmp/.$USER-port-fwd-status

# Check if a port is currently forwarded to localhost
# param : port
# ---------------------------------------------------------
function port_forwarded()
{
	local port_l
	local i

        if [ -f $USER_P_FWD_STATUS  ]; then
        	for i in $(cat  $USER_P_FWD_STATUS)
		do
			port_l=$(echo $i | cut -d";" -f1)
			if [ "$port_l" == "$1" ]; then
				return 0
				exit 0
			fi
		done
		return 1
	fi
}

# Get the SSH process id 
# param : port
# ---------------------------------------------------------
function get_service_pid()
{
	SVC_PID=$(lsof -i -P | grep LISTEN | grep ":\b${1}\b" | grep -i ipv4 | awk '{print $2}')
}

# Check if client's local port is free
# param : port
# ---------------------------------------------------------
function is_free()
{
	local PORT_L
	PORT_L=$(lsof -i -P | grep LISTEN | grep ":\b${1}\b" | grep -i ipv4 | awk '{print $9}' | cut -d: -f2)

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

# Check if a variable is an IP address
# param : IP address
# ---------------------------------------------------------
function is_ip()
{
	local test
	test='([1-9]?[0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])'
	[[ $1 =~ ^$test\.$test\.$test\.$test$ ]] && return 0 || return 1
}

# Check if a host exists on LIFO/UO's LAN
# param : hostname/IP address
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

# Set a local port to forward to : if $1 < 1024 $1=$1*100
# param : port
# ---------------------------------------------------------
function set_local_port2()
{
	if [ ! "$1" -gt 1024 ]; then
		PORT2_L=$(expr 100 '*' "$1")
	else
		PORT2_L=$1
	fi
}

# forward-lifo-port.sh usage/help
# ---------------------------------------------------------
function _usage()
{
	echo -e "Forward a distant host's port to localhost."
	echo -e "usage:\t forward-lifo-port.sh [ -u | --user ] LIFO_LOGIN [ -s | --server ] LIFO_SERVER ] [ -p | --port ] LIFO_SERVER_PORT"
	echo -e "\t [ -r | --remove LOCAL_PORT_TO_REMOVE ]"
	echo -e "\t [ -d | --destroy ]"
        echo -e "\t [ -h | --help ]"
	echo -e "\t --status"
	echo -e "Examples:"
         echo -e "\t forward-lifo-port.sh -u smith -s hpetg -p 9100"
         echo -e "\t forward-lifo-port.sh -u smith -s photocop -p 9100"
	 echo -e "\t forward-lifo-port.sh -u smith -s mirevserver -p 80"
	 echo -e "\t forward-lifo-port.sh -r 8000"
         echo -e "\t forward-lifo-port.sh --status"
}

# Kill all local processes related to SSH
# param : PID (optional)
# ---------------------------------------------------------
function kill_proc()
{
	local i
	local port_l

	if [ "$1" == "" ]; then

		if [ -f $USER_P_FWD_STATUS  ] ; then
			echo "Disabling port forwarding ..."
			echo

			for i in $(cat $USER_P_FWD_STATUS )
			do
				port_l=$(echo $i | cut -d";" -f1)
				if [ "$i" != "" ]; then
					get_service_pid $port_l
					[ $SVC_PID -gt 0 ] &&  kill -9 $SVC_PID > /dev/null 2>&1
				fi
			done
			rm $USER_P_FWD_STATUS
			echo -e "Port Forwarding disabled."
		else
			echo -e "Port forwarding is NOT enabled !"
		fi

	else
		[ $SVC_PID -gt 0 ] &&  kill -9 $SVC_PID > /dev/null 2>&1
		sed -n '/'$PORT2'/!p' -i $USER_P_FWD_STATUS
		if [ ! -s $USER_P_FWD_STATUS ]; then 
			rm $USER_P_FWD_STATUS
			echo -e "Port Forwarding disabled."
		else 
			show_status
		fi
	fi

}

# Show port forwarding status
# ---------------------------------------------------------
function show_status()
{
	local port_l
	local srv_l
        local port_d
	local other_port=""
	[ "$LIFO_USER" == "" ] && LIFO_USER="<login>"

	if [ -f $USER_P_FWD_STATUS  ]; then
		echo -e "-------------------------------------------------------"
		echo -e "Port forwarding status\t\t\t\t[OK]"
		echo -e "-------------------------------------------------------"
		for i in $(cat  $USER_P_FWD_STATUS)
		do
			port_l=$(echo $i | cut -d";" -f1)
			srv_l=$(echo $i | cut -d";" -f2)
			port_d=$(echo $i | cut -d";" -f3)
			echo -e "localhost:$port_l ---(forwarded to)---> $srv_l:$port_d"
		done

		echo
	else
		echo "No port forwarding !"
	fi
}

# Check if variable in parameter is a number
# param : any
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

# Forward port
# ---------------------------------------------------------
function forward_port()
{
	local LIBRE
	local tmp
	LIBRE="N"

	while [ $LIBRE == "N" ]; do
		if  is_free $PORT2_L ; then
			LIBRE="Y"
		else
			tmp=$(expr "$PORT2_L" '+' 1)
			PORT2_L=$tmp
			if  is_free $PORT2_L ; then 
				LIBRE="Y"
			fi
		fi
	done

	set_sully
	echo -e "Enabling port forwarding ..."
	ssh -fNT -L $PORT2_L:$SRV_DEST:$PORT2 $LIFO_USER@$SULLY > /dev/null 2>&1
	echo "$PORT2_L;$SRV_DEST;$PORT2" >>  $USER_P_FWD_STATUS
	show_status
}

# remove local port forwarding by killing the ssh tunnel PID
# param : port
# ---------------------------------------------------------
function remove_port()
{
	if is_number $1 ; then
		echo -e "Removing local port $1 ..."
		if port_forwarded $1 ; then
			get_service_pid $1
			kill_proc $SVC_PID
			exit 0
		else
			echo "Port $1 is not forwarded on localhost !"
			exit 0
		fi
	else
		echo -e "-r must be followed by an integer !"
		exit 0
	fi
}

# ---------------------------------------------------------
# MAIN()

# Load the user defined parameters
while [[ $# > 0 ]]
do
        case "$1" in

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

                -r|--remove)
                        PORT2="$2"
			if [ "$PORT2" != "" ]; then
				remove_port $PORT2
			else
				 _usage
				exit 0
			fi
			#shift
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
		if port_exists ; then
			if is_number $PORT2 ; then
				# Set PORT2_L value
				set_local_port2 $PORT2
				if server_is_valid $SRV_DEST ; then
					forward_port
				else
					echo "Invalid server $SRV_DEST !"
				fi
			else
				echo "Port must be a number !"
				exit 0
			fi
      		else
			_usage
			exit 0
      		fi

	else
		_usage
		exit 0
	fi
else
	_usage
	exit 0
fi
