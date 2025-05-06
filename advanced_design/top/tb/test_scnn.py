import numpy as np
import torch
import torch.nn.functional as F
import os

def save_to_file(filename, data, original_shape):
    """Save tensor data to a text file, one element per line, followed by metadata."""
    with open(filename, 'w') as f:
        reshaped_data = data.reshape(-1, 1)
        np.savetxt(f, reshaped_data.cpu().numpy(), fmt='%d')
        f.write(f"// Original shape: {original_shape}\n")
        f.write("/* Original data:\n")
        f.write(str(data))
        f.write("*/\n")

def read_txt(path):
    """Read values from a text file until metadata comment, return list of strings."""
    vals = []
    with open(path) as f:
        for line in f:
            stripped = line.strip()
            if not stripped or stripped.startswith("//"):
                break
            vals.append(stripped)
    return vals

def generate_packet(filter_file, ifmap1_file, ifmap2_file, filtersize, ifmapsize):
    """Read text files and assemble SystemVerilog concatenation packets with width specifiers."""
    filter_vals = read_txt(filter_file)
    ifmap1_vals = read_txt(ifmap1_file)
    ifmap2_vals = read_txt(ifmap2_file)
    
    assert 2 <= filtersize <= 5, "filtersize must be between 2 and 5 to fit in 2-bit"
    fsize_bin = f"{filtersize - 2:02b}"     # 00~11 encoding for 2~5
    ifmapsize_bin = f"{ifmapsize:06b}"      # 6-bit binary string
    
    packets = []

    # Filter rows
    for i in range(filtersize):
        v = [f"{int(filter_vals[filtersize * i + j]):08b}" for j in range(filtersize)]
        v_bits = ''.join(v)
        v_padded = v_bits.rjust(40, '0')  
        packets.append([v_padded, fsize_bin, '011', '000', '000', '11'])


    # Ifmap windows (assume already flattened)
    window1_bits = [int(x) for x in ifmap1_vals[:ifmapsize*ifmapsize]]
    window2_bits = [int(x) for x in ifmap2_vals[:ifmapsize*ifmapsize]]



    packets += [
        [chunk, ifmapsize_bin, '001', '000', '000', '11']
        for chunk in split_ifmap_bits(window1_bits)
    ]
    packets += [
        [chunk, ifmapsize_bin, '101', '000', '000', '11']
        for chunk in split_ifmap_bits(window2_bits)
    ]


    packets_str = [''.join(p) for p in packets]
    output_dir = "scnn_script"
    os.makedirs(output_dir, exist_ok=True)
    output_path = os.path.join(output_dir, "send_values_bin.txt")
    with open(output_path, "w") as f:
        for line in packets_str:
            f.write(line + "\n")


def split_ifmap_bits(window_bits):
    # Reverse: LSB to MSB
    bit_str = ''.join(str(b) for b in window_bits[::-1])
    chunks = []
    i = len(bit_str)
    while i > 0:
        start = max(0, i - 36)
        chunk = bit_str[start:i]
        if len(chunk) < 36:
            chunk = chunk.rjust(36, '0')  # pad on the left (MSB side)
        chunks.insert(0, chunk)  # insert at front to maintain correct order
        i -= 36
    chunks.reverse()
    return chunks

def test():
    filtersize, ifmapsize = 4, 10
    threshold = 16

    # Generate random tensors
    filter_L1 = torch.randint(6, (1,1,filtersize,filtersize)).float()
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

    generate_packet(
        "scnn_script/L1_filter.txt",
        "scnn_script/ifmap_t1.txt",
        "scnn_script/ifmap_t2.txt",
        filtersize,
        ifmapsize,
    )
    # write_binary_packets(
    #     "scnn_script/L1_filter.txt",
    #     "scnn_script/ifmap_t1.txt",
    #     "scnn_script/ifmap_t2.txt",
    #     "scnn_script/send_values_bin.txt"
    # )

if __name__ == '__main__':
    test()
