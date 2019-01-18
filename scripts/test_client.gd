extends StreamPeerTCP

const MESSAGE_RECEIVED = "msg_received"
const BINARY_RECEIVED = "binary_received"

var host = '127.0.0.1'
var host_only = host
var path = null
var port = 80
var TIMEOUT = 30
var error = ''
var messages = []
var receiver = null
var receiver_f = null
var receiver_binary = null
var receiver_binary_f = null
var received_header = false

var close_listener = Node.new()
var dispatcher = Reference.new()

func run():
	var tm = 0.0
	var data = ''
	var is_reading_frame = false
	var size = 0
	var byte = 0
	var fin = 0
	var opcode = 0
	if get_status()==STATUS_CONNECTED:
		if get_available_bytes()>0:
			if not is_reading_frame:
				# frame
				byte = get_8()
				fin = byte & 0x80
				opcode = byte & 0x0F
				byte = get_8()
				var mskd = byte & 0x80
				var payload = byte & 0x7F
				#printt('length', get_available_bytes())
				#printt(fin,mskd,opcode,payload)
				if payload<126:
					# size of data = payload
					data += get_string(payload)
					if fin:
						if receiver:
							dispatcher.emit_signal(MESSAGE_RECEIVED, data)
						data = ''
				else:
					size = 0
					if payload==126:
						# 16-bit size
						size = get_u16()
						#printt(size,'of data')
					if get_available_bytes()<size:
						is_reading_frame = true
						size -= get_available_bytes()
						data += get_string(get_available_bytes())
					else:
						size = 0
						data += get_string(get_available_bytes())
						if fin:
							if receiver:
								dispatcher.emit_signal(MESSAGE_RECEIVED, data)
							data = ''
			else:
				if size<=get_available_bytes():
					size = 0
					data += get_string(get_available_bytes())
					is_reading_frame = false
					if fin:
						if receiver:
							dispatcher.emit_signal(MESSAGE_RECEIVED, data)
						data = ''
				else:
					size -= get_available_bytes()
					data += get_string(get_available_bytes())



func send(msg):
	var byte = 0x80 # fin
	byte = byte | 0x01 # text frame
	put_8(byte)
	byte = 0x00 | msg.length() # mask flag and payload size  **max of 125 bytes
	put_u8(byte)
	byte = randi() # mask 32 bit int
#	put_32(byte)
#	var masked = _mask(byte,msg)
#	for i in range(masked.size()):
#		put_u8(masked[i])
	# Convert to int array, stream 1 char at a time
	var utf8msg = msg.to_utf8()
	for i in range(utf8msg.size()):
		put_u8(utf8msg[i])
	print(msg+" sent")



func start(host,port,path=null):
	self.host_only = host
	if path == null:
		self.host = host
		path = ''
	else:
		self.host = host+"/"+path
	self.path = path
	self.port = port

	# Attempt connection to server
	if OK == connect_to_host(IP.resolve_hostname(host),port):
		# Wait for connection to be established
		var tm = 0.0
		while true:
			if get_status()==STATUS_ERROR:
				error = 'Connection fail'
				return
			if get_status()==STATUS_CONNECTED:
				break
			tm += 0.01
			if tm>TIMEOUT:
				error = 'Connection timeout'
				return
			OS.delay_msec(10)

		# Prepare header
		var header  = "GET / HTTP/1.1\r\n"
		header += "Host: " + host + "\r\n"
		header += "Upgrade: websocket\r\n"
		header += "Connection: Upgrade\r\n"
		header += "Sec-WebSocket-Key: 6Aw8vTgcG5EvXdQywVvbh_3fMxvd4Q7dcL2caAHAFjV\r\n"
		header += "Sec-WebSocket-Version: 13\r\n"
		header += "\r\n"

		# Send header
		if OK != put_data(header.to_ascii()):
			print('error sending handshake headers')
			return

	else:
		print('no')

	# Received header information is parsed differently
	var data = ''
	var tm = 0.0
	while !received_header:
		if get_available_bytes() > 0:
			data += get_string(get_available_bytes())
			received_header = true
			#print(data)
			return

		OS.delay_msec(100)
		tm += 0.1
		if tm>TIMEOUT:
			print('timeout')
			return

func set_receiver(o,f):
	if receiver:
		unset_receiver()
	receiver = o
	receiver_f = f
	dispatcher.connect( MESSAGE_RECEIVED, receiver, receiver_f)

func set_binary_receiver(o,f):
	if receiver_binary:
		unset_binary_receiver()
	receiver_binary = o
	receiver_binary_f = f
	dispatcher.connect( MESSAGE_RECEIVED, receiver_binary, receiver_binary_f)

func unset_receiver():
	dispatcher.disconnect( MESSAGE_RECEIVED, receiver, receiver_f)
	receiver = null
	receiver_f = null

func unset_binary_receiver():
	dispatcher.disconnect( MESSAGE_RECEIVED, receiver_binary, receiver_binary_f)
	receiver_binary = null
	receiver_binary_f = null

func _init(reference).():
	dispatcher.add_user_signal(MESSAGE_RECEIVED)
	dispatcher.add_user_signal(BINARY_RECEIVED)

func _mask(_m, _d):
	_m = int_to_hex(_m)
	_d=_d.to_utf8()
	var ret = []
	for i in range(_d.size()):
		ret.append(_d[i] ^ _m[i % 4])
	return ret

func int_to_hex(n):
	n = var2bytes(n)
	n.invert()
	n.resize(n.size()-4)
	return n