import strutils
import  nim_cwpack/cwpack

proc msg_pack_str(pack_context: ptr cw_pack_context; v: cstring): void =
    var l = uint32 v.len.toU32() + 1
    cw_pack_str(pack_context, v, l)

var cw: cw_pack_context
var buffer = newSeq[char](20)
# echo cw_pack_context_init(addr cw, addr buffer, 20, 0)
var pack_overflow_handler: pack_overflow_handler
echo cw_pack_context_init(addr cw, addr buffer, 20, pack_overflow_handler)
var map_size: uint32
map_size = 2
cw_pack_map_size(addr cw, map_size)
# var src_data: cstring
# src_data = "compact"
msg_pack_str(addr cw, "compact")
cw_pack_boolean(addr cw, true);
msg_pack_str(addr cw, "schema")
cw_pack_unsigned(addr cw, 0);
# var encode_data = cast[ptr char](buffer)
# var msg_len = cw.current - cw.start
# var cw_start = cast[ptr char](cw.start)
var cw_start = cast[int8](cw.start)
var cw_current = cast[int8](cw.current)
echo "msg len:", cw_current - cw_start, ", sizeof:", sizeof(cw)

echo "unpack"
var item_root : seq[char] = newSeq[char]()
# unpack
proc msgpack_unpack(unpack_context: ptr cw_unpack_context): void =
    cw_unpack_next(unpack_context)
    echo "unpack_type:", unpack_context.item.type
    case unpack_context.item.type
        of CWP_ITEM_ARRAY:
            echo "array_size:", unpack_context.item.as.array.size
            var dim = unpack_context.item.as.array.size
            for i in 0..dim:
                echo "array:", i
                msgpack_unpack(unpack_context)
        of CWP_ITEM_MAP:
            echo "map_size:", unpack_context.item.as.map.size
            # var dim = uint32(2) * unpack_context.item.as.map.size
            # var dim = 2 * int32(unpack_context.item.as.map.size)
            var dim = 1 * int32(unpack_context.item.as.map.size)
            echo "dim:", dim, [int(0)..int(dim)]
            var result_buffer: array[20, string]
            # var result_buffer = array[dim, string]
            # var result_buffer : seq[string]
            # result_buffer = @[]
            # var result_buffer = openArray[string]
            # result_buffer[1] = "a"
            # for i in 0..dim:
            for i in 1..dim:
                echo "map:", i
                # echo unpack_context.item.as.var
                # result_buffer[i] = msgpack_unpack(unpack_context)
                msgpack_unpack(unpack_context)
            # echo "result_buffer:", result_buffer
            # var result = result_buffer
        of CWP_ITEM_NEGATIVE_INTEGER:
            echo "pass CWP_ITEM_NEGATIVE_INTEGER"
            var result = unpack_context.item.as.u64
        of CWP_ITEM_POSITIVE_INTEGER:
            echo "pass CWP_ITEM_POSITIVE_INTEGER"
            item_root.add char(unpack_context.item.as.u64)
        of CWP_ITEM_BOOLEAN:
            item_root.add char(unpack_context.item.as.boolean)
        of CWP_ITEM_STR:
            var encode_data_str = unpack_context.item.as.str.start
            # var encode_data_ca = cast[cstringArray](encode_data_str)
            # var encode_s = cstringArrayToSeq(encode_data_ca)
            # # echo encode_data_ca
            # echo encode_s
            # var encode_data = cast[ptr char](encode_data_str)
            var str_len = unpack_context.item.as.str.length
            var encode_data = cast[ptr array[2000, char]](encode_data_str)
            echo "CWP_ITEM_STR LEN:", unpack_context.item.as.str.length
            # echo "CWP_ITEM_STR:", encode_data
            echo "CWP_ITEM_STR:" , join(encode_data[0..str_len - 1])
            # echo join(encode_data[0..str_len - 1])
            # item_root.add(encode_data)
        else:
            echo "other"

var cw_unpack: cw_unpack_context
var unpack_underflow_handler: unpack_underflow_handler
echo cw_unpack_context_init(addr cw_unpack, cw.start, 20, unpack_underflow_handler)

# echo cw_unpack_context_init(addr cw_unpack, addr msg_encode_data, 2000, unpack_underflow_handler)
msgpack_unpack(addr cw_unpack)
# while cw_unpack.return_code == CWP_RC_OK:
    # msgpack_unpack(addr cw_unpack)
echo item_root
# for i in 0..20:
    # echo i
    # msgpack_unpack(addr cw_unpack)

# cw_unpack_next(addr cw_unpack)
# echo cw_unpack.item.type
# var encode_data_str = cw_unpack.item.as.str.start
# var encode_data = cast[ptr char](encode_data_str)
# echo cw_unpack.item.as.str.length
# echo encode_data

# cw_unpack_next(addr cw_unpack)
# echo cw_unpack.item.type
