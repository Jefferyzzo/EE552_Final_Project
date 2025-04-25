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
    filter_width = 8
    
    # File paths
    send_timestep_file = "send_timestep.txt"
    send_outspike_file = "send_outspike.txt"
    send_residue_file  = "send_residue.txt"
    recv_file          = "recv_packet.txt"
    
    # Read all lines from each file
    timestep_lines    = read_file_lines(send_timestep_file)
    outputspike_lines = read_file_lines(send_outspike_file)
    residue_lines     = read_file_lines(send_residue_file)
    recv_lines        = read_file_lines(recv_file)

    # Compare up to the shortest file length
    num_lines = min(len(timestep_lines), len(outputspike_lines), len(residue_lines), len(recv_lines))
    print(f"Comparing {num_lines} lines...\n")

    match_count = 0  # Counter for matching lines

    for i in range(num_lines):
        try:
            timestep_value    = extract_value(timestep_lines[i])
            outputspike_value = extract_value(outputspike_lines[i])
            residue_value     = extract_value(residue_lines[i])
            recv_value        = extract_value(recv_lines[i])
        except ValueError as e:
            print(f"Line {i+1}: ERROR - {e}")
            continue

        # Concatenate to form expected value in the order:
        # Expected = recv_data + recv_filter_row + recv_ifmapb_filter + recv_timestep
        expected_value = residue_value + '0' * (2 * filter_width - 3) + '00' + outputspike_value + '000' + timestep_value + '00000'
        match = (recv_value == expected_value)
        if match:
            match_count += 1

        # Print verbose comparison for the current line
        print(f"Line {i+1}:")
        print(f"  Sent Timestep          : {timestep_value}")
        print(f"  Sent Outputspike       : {outputspike_value}")
        print(f"  Sent Residue           : {residue_value}")
        print(f"  Concatenated Expected  : {expected_value}")
        print(f"  Received Value         : {recv_value}")
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
