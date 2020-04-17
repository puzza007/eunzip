% Zip archive read chunk size
-define(zip_chunk_size, 65000).
-define(file_chunk_size, 1024 * 1024).          % 1 MB
-define(z_buffer_size, 5 * 1024 * 1024).        % 5 MB

% Compression methods
-define(M_STORE, 0).
-define(M_DEFLATE, 8).

% EOCD specific
-define(eocd_search_limit, 5 * 1024 * 1024).    % 5 MB
-define(eocd_header_size, 22).

% Zip64 specific
-define(zip64_eocd_locator_size, 20).
-define(zip64_eocd_size, 56).
-define(zip64_extra_field_id, 16#0001).

% Local header
-define(local_header_size, 30).

% Auxiliary structure to seek and read data from Zip archives
-record(file_buffer, {
    file :: file:fd(),
    size :: non_neg_integer(),
    limit :: non_neg_integer(),
    buffer :: binary(),
    buffer_size :: non_neg_integer(),
    buffer_position :: non_neg_integer(),
    direction :: eunzip_types:direction()
}).

% Central directory basic information
-record(cd_info, {
    total_entries :: non_neg_integer(),
    cd_size :: non_neg_integer(),
    cd_offset :: non_neg_integer()
}).

% File / directory entry within central directory
-record(cd_entry, {
    bit_flag :: non_neg_integer(),
    compression_method :: non_neg_integer(),
    last_modified_datetime :: calendar:datetime(),
    crc :: non_neg_integer(),
    compressed_size :: non_neg_integer(),
    uncompressed_size :: non_neg_integer(),
    local_header_offset :: non_neg_integer(),
    file_name :: file:filename_all()  % TODO: we should treat binary as "IBM Code Page 437" encoded string if GP flag 11 is not set
}).

% Unzip state holds file descriptor and central directory
-record(unzip_state, {
    zip_handle :: file:fd(),
    central_dir :: maps:map(),
    file_size :: non_neg_integer()
}).