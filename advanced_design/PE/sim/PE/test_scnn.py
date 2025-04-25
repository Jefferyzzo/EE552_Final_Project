import numpy as np
import torch
import torch.nn.functional as F
import os

def save_to_file(filename, data, original_shape):
    """Save tensor data to a text file, one element per line."""
    with open(filename, 'w') as f:
        reshaped_data = data.reshape(-1, 1)
        np.savetxt(f, reshaped_data.cpu().numpy(), fmt='%d')
        f.write(f"// Original shape: {original_shape}\n")
        f.write("/* Original data:\n")
        f.write(str(data))
        f.write("*/\n")
        
def generate_filter_packets(filter_tensor, FILTER_WIDTH, output_path):
    """
    Generate row-wise filter packets from a NxN square filter tensor (2x2 to 5x5 supported).
    Packet format per row:
    LSB → timestep (1) | flag (1) | row_index (3)
          | D[N-1] ... D[0] | 0-padding ← MSB

    Args:
        filter_tensor (torch.Tensor): Shape (1, 1, N, N)
        FILTER_WIDTH (int): Bit-width of each value
        output_path (str): File path to write binary packets
    """
    _, _, H, W = filter_tensor.shape
    assert H == W and 2 <= H <= 5, "Filter must be square and 2x2–5x5"

    total_data_bits = 5 * FILTER_WIDTH
    meta_bits = 5  # timestep (1) + flag (1) + row_index (3)
    total_bits = total_data_bits + meta_bits

    with open(output_path, 'w') as f:
        for row in range(H):
            packet = 0
            bit_pos = 0

            # LSB fields
            packet |= 0 << bit_pos         # timestep
            bit_pos += 1

            packet |= 1 << bit_pos         # flag (1 = filter)
            bit_pos += 1

            packet |= ((row+1) & 0b111) << bit_pos  # 3-bit row
            bit_pos += 3

            # Add N filter values: D[N-1] (LSB) to D[0] (MSB of data)
            for i in reversed(range(W)):
                val = int(filter_tensor[0, 0, row, i].item())
                packet |= (val & ((1 << FILTER_WIDTH) - 1)) << bit_pos
                bit_pos += FILTER_WIDTH

            # Pad with (5 - N) dummy values = 0
            pad_count = 5 - W
            bit_pos += pad_count * FILTER_WIDTH

            # Convert to binary string with LSB left, MSB right
            binary_string = f"{packet:0{total_bits}b}"
            f.write(binary_string + '\n')

def generate_ifmap_packets(ifmap_tensor, FILTER_WIDTH, output_path, conv_loc=0, timestep=0):
    """
    Generate a single ifmap packet from a binary NxN ifmap tensor (values are 0 or 1).

    Total packet width = 5*FILTER_WIDTH + 5 bits
    LSB → timestep (1)
          flag (0 for ifmap)
          filter_row (3'b000)
          size (2 bits)
          conv_loc (5*FILTER_WIDTH + 5 - 27 bits)
          ifmap_data (25 bits: flattened binary values, LSB = last bit) ← MSB

    Args:
        ifmap_tensor (torch.Tensor): Shape (1,1,N,N), values must be 0 or 1
        FILTER_WIDTH (int): Determines total packet width
        output_path (str): File to write the single packet
        conv_loc (int): Location field (width = 5*FILTER_WIDTH + 5 - 27)
        timestep (int): LSB field set by user (0 or 1)
    """
    _, _, H, W = ifmap_tensor.shape
    assert H == W and 2 <= H <= 5, "ifmap must be square NxN (2 ≤ N ≤ 5)"

    size_map = {2: 0b00, 3: 0b01, 4: 0b10, 5: 0b11}
    size_val = size_map[H]

    total_bits = 5 * FILTER_WIDTH + 5
    conv_loc_bits = total_bits - 25 - 2 - 3 - 1 - 1

    packet = 0
    bit_pos = 0

    # LSB fields
    packet |= (timestep & 0b1) << bit_pos
    bit_pos += 1

    packet |= 0 << bit_pos  # flag = 0 (ifmap)
    bit_pos += 1

    packet |= 0 << bit_pos  # filter_row = 3'b000 (since one packet)
    bit_pos += 3

    packet |= (size_val & 0b11) << bit_pos
    bit_pos += 2

    packet |= (conv_loc & ((1 << conv_loc_bits) - 1)) << bit_pos
    bit_pos += conv_loc_bits

    # Flatten ifmap_tensor into 25-bit binary block (0/1 values)
    flat = ifmap_tensor.view(-1).tolist()
    flat = [int(x) & 1 for x in flat]  # make sure values are 0 or 1
    assert len(flat) <= 25, "Ifmap data must be 25 bits or fewer"

    data = 0
    for i, bit in enumerate(reversed(flat)):  # LSB = last value
        data |= (bit & 1) << i

    packet |= data << bit_pos
    bit_pos += 25

    assert bit_pos == total_bits, f"Packet size mismatch: got {bit_pos} bits, expected {total_bits}"

    with open(output_path, 'w') as f:
        binary_string = f"{packet:0{total_bits}b}"
        f.write(binary_string + '\n')
        
def combine_packet_files(filter_path, ifmap_t1_path, ifmap_t2_path, output_path):
    """
    Combine packets from 3 text files (filter, ifmap_t1, ifmap_t2) into one file.
    
    Order:
    - All filter packets
    - Then ifmap_t1 packet
    - Then ifmap_t2 packet

    Args:
        filter_path (str): Path to filter_packets.txt
        ifmap_t1_path (str): Path to ifmap_t1_packets.txt
        ifmap_t2_path (str): Path to ifmap_t2_packets.txt
        output_path (str): Combined output file
    """
    def read_lines(path):
        with open(path, 'r') as f:
            return [line.strip() for line in f if line.strip()]

    all_packets = (
        read_lines(filter_path) +
        read_lines(ifmap_t1_path) +
        read_lines(ifmap_t2_path)
    )

    with open(output_path, 'w') as f:
        for packet in all_packets:
            f.write(packet + '\n')


def test():
    filterwidth = 8
    filtersize  = 5
    ifmapsize   = 5
    threshold   = 64

    # Generate random tensors
    filter_L1 = torch.randint(256, (1,1,filtersize,filtersize)).float() #(batch_size, channels, height, width)
    ifmap_t1 = torch.randint(2, (1,1,ifmapsize,ifmapsize)).float()
    ifmap_t2 = torch.randint(2, (1,1,ifmapsize,ifmapsize)).float()

    # Print random data and compute spikes/residues
    print("filter_L1:\n", filter_L1)
    print("ifmap_t1:\n", ifmap_t1)
    print("ifmap_t2:\n", ifmap_t2)

    L1_conv_out_t1 = F.conv2d(ifmap_t1, filter_L1)
    L1_out_spike_t1 = (L1_conv_out_t1 > threshold).int()
    L1_residue_t1   = L1_conv_out_t1 - L1_out_spike_t1 * threshold
    print("Timestep 1:")
    print("L1_out_spike_t1:")
    print(L1_out_spike_t1)
    print("L1_residue_t1:")
    print(L1_residue_t1)

    L1_conv_out_t2 = F.conv2d(ifmap_t2, filter_L1) + L1_residue_t1
    L1_out_spike_t2 = (L1_conv_out_t2 > threshold).int()
    L1_residue_t2   = L1_conv_out_t2 - L1_out_spike_t2 * threshold
    print("Timestep 2:")
    print("L1_out_spike_t2:")
    print(L1_out_spike_t2)
    print("L1_residue_t2:")
    print(L1_residue_t2) 

    os.makedirs("scnn_script", exist_ok=True)
    save_to_file("scnn_script/L1_filter.txt", filter_L1, filter_L1.shape)
    save_to_file("scnn_script/ifmap_t1.txt", ifmap_t1, ifmap_t1.shape)
    save_to_file("scnn_script/ifmap_t2.txt", ifmap_t2, ifmap_t2.shape)
    save_to_file("scnn_script/L1_out_spike_t1.txt", L1_out_spike_t1, L1_out_spike_t1.shape)
    save_to_file("scnn_script/L1_out_spike_t2.txt", L1_out_spike_t2, L1_out_spike_t2.shape)
    save_to_file("scnn_script/L1_residue_t1.txt", L1_residue_t1, L1_residue_t1.shape)
    save_to_file("scnn_script/L1_residue_t2.txt", L1_residue_t2, L1_residue_t2.shape)
    
    generate_filter_packets(
        filter_tensor=filter_L1,
        FILTER_WIDTH=filterwidth,
        output_path="scnn_script/filter_packets.txt"
    )
    
    generate_ifmap_packets(
        ifmap_tensor=ifmap_t1,
        FILTER_WIDTH=filterwidth,
        output_path="scnn_script/ifmap_t1_packets.txt",
        conv_loc=0,
        timestep=0
    )
    
    generate_ifmap_packets(
        ifmap_tensor=ifmap_t2,
        FILTER_WIDTH=filterwidth,
        output_path="scnn_script/ifmap_t2_packets.txt",
        conv_loc=0,
        timestep=1
    )
    
    combine_packet_files(
        filter_path="scnn_script/filter_packets.txt",
        ifmap_t1_path="scnn_script/ifmap_t1_packets.txt",
        ifmap_t2_path="scnn_script/ifmap_t2_packets.txt",
        output_path="scnn_script/combined_packets.txt"
    )

if __name__ == '__main__':
    test()
