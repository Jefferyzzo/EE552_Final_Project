import re

def extract_value(line):
    """
    Extracts the binary string after 'Value:' from a line.
    """
    match = re.search(r'Value:\s*([01]+)', line)
    if match:
        return match.group(1)
    else:
        raise ValueError(f"Could not extract binary value from line: {line}")

def read_file_lines(filename):
    """
    Returns all non-empty lines from a file.
    """
    with open(filename, 'r') as f:
        return [line.strip() for line in f if line.strip()]

def main():
    # File paths
    send_file               = "send_values.txt"
    recv_timestep_file      = "recv_timestep.txt"
    recv_ifmapb_filter_file = "recv_ifmapb_filter.txt"
    recv_filter_row_file    = "recv_filter_row.txt"
    recv_data_file          = "recv_data.txt"
    
    # Read all lines from each file
    send_lines          = read_file_lines(send_file)
    timestep_lines      = read_file_lines(recv_timestep_file)
    ifmapb_filter_lines = read_file_lines(recv_ifmapb_filter_file)
    filter_row_lines    = read_file_lines(recv_filter_row_file)
    data_lines          = read_file_lines(recv_data_file)

    # Compare up to the shortest file length
    num_lines = min(len(send_lines), len(timestep_lines), len(ifmapb_filter_lines), len(filter_row_lines), len(data_lines))
    print(f"Comparing {num_lines} lines...\n")

    match_count = 0  # Counter for matching lines

    for i in range(num_lines):
        try:
            send_value          = extract_value(send_lines[i])
            timestep_value      = extract_value(timestep_lines[i])
            ifmapb_filter_value = extract_value(ifmapb_filter_lines[i])
            filter_row_value    = extract_value(filter_row_lines[i])
            data_value          = extract_value(data_lines[i])
        except ValueError as e:
            print(f"Line {i+1}: ERROR - {e}")
            continue

        # Concatenate to form expected value in the order:
        # Expected = recv_data + recv_filter_row + recv_ifmapb_filter + recv_timestep
        expected_value = data_value + filter_row_value + ifmapb_filter_value + timestep_value
        match = (send_value == expected_value)
        if match:
            match_count += 1

        # Print verbose comparison for the current line
        print(f"Line {i+1}:")
        print(f"  Received Timestep      : {timestep_value}")
        print(f"  Received Ifmapb_filter : {ifmapb_filter_value}")
        print(f"  Received Filter Row    : {filter_row_value}")
        print(f"  Received Data          : {data_value}")
        print(f"  Concatenated Expected  : {expected_value}")
        print(f"  Sent Value             : {send_value}")
        print(f"  MATCH?                 : {'✅ YES' if match else '❌ NO'}\n")

    # Summary output
    print("Summary:")
    print(f"  Total lines compared   : {num_lines}")
    print(f"  Matching lines         : {match_count}")
    if match_count == num_lines:
        print("  Overall Result         : ✅ All lines match!")
    else:
        print("  Overall Result         : ❌ Some lines did not match.")

if __name__ == "__main__":
    main()
