import re

def extract_value(line):
    """
    Extracts the binary value from a line using regex.
    Assumes a format like: "Time: ... - (Sent|Received) Value: <binary_value>"
    """
    match = re.search(r'Value:\s*([01]+)', line)
    if match:
        return match.group(1)
    else:
        raise ValueError(f"Could not extract a binary value from line: {line}")

def read_first_line(filename):
    """
    Reads the first non-empty line from the given file.
    """
    with open(filename, 'r') as f:
        # Read lines and return the first non-empty one.
        for line in f:
            if line.strip():
                return line.strip()
    raise ValueError(f"No non-empty lines found in {filename}")

def main():
    # Filenames
    send_file = "send_values.txt"
    recv_data_file = "recv_data.txt"
    recv_filter_row_file = "recv_filter_row.txt"
    recv_timestep_file = "recv_timestep.txt"
    # Note: The 'recv_ifmapb_filter.txt' file is not used in the concatenation check.

    # Read the first valid line from each file
    send_line = read_first_line(send_file)
    data_line = read_first_line(recv_data_file)
    filter_row_line = read_first_line(recv_filter_row_file)
    timestep_line = read_first_line(recv_timestep_file)

    # Extract binary values from each line
    send_value = extract_value(send_line)
    data_value = extract_value(data_line)
    filter_row_value = extract_value(filter_row_line)
    timestep_value = extract_value(timestep_line)

    # Build the expected sent value by concatenating:
    # {recv_data, recv_filter_row, recv_timestep, recv_timestep}
    expected_value = data_value + filter_row_value + timestep_value + timestep_value

    # Display the values for comparison
    print("Sent Value      :", send_value)
    print("Expected Value  :", expected_value)
    if send_value == expected_value:
        print("MATCH: The sent value matches the expected concatenation.")
    else:
        print("NO MATCH: The sent value does not match the expected concatenation.")

if __name__ == "__main__":
    main()
