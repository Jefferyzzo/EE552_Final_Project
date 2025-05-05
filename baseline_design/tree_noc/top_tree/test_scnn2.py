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

def generate_packet(filter_file, ifmap1_file, ifmap2_file, sv_filename):
    """Generate SystemVerilog packets without xhop, yhop, direction."""
    filter_vals = read_txt(filter_file)
    ifmap1_vals = read_txt(ifmap1_file)
    ifmap2_vals = read_txt(ifmap2_file)

    packets = []
    opcodes = ['0110', '1010', '1110']

    # Filter rows
    for i in range(3):
        v = [int(filter_vals[3*i + j]) for j in range(3)]
        packets.append(v + [opcodes[i], '0'])  # keep opcode and ts only

    # Ifmap windows
    packets.append([int(x) for x in ifmap1_vals[:9]] + ['0000', '0'])  # ifmap t1
    packets.append([int(x) for x in ifmap2_vals[:9]] + ['0001', '0'])  # ifmap t2

    os.makedirs(os.path.dirname(sv_filename), exist_ok=True)
    with open(sv_filename, 'w') as f:
        for idx, comps in enumerate(packets):
            if idx < 3:
                f.write(
                    f"send_values[{idx}] = {{8'd{comps[0]},8'd{comps[1]},8'd{comps[2]},4'b{comps[3]},1'b{comps[4]}}}; // filter row {idx+1}\n"
                )
            else:
                bits = ",".join([f"1'b{b}" for b in comps[:9]])
                f.write(
                    f"send_values[{idx}] = {{{bits},4'b{comps[9]},1'b{comps[10]}}}; // ifmap t{idx-2}\n"
                )

def write_binary_packets(filter_file, ifmap1_file, ifmap2_file, output_file):
    """Generate binary packets without xhop, yhop, direction."""
    filter_vals = [int(v) for v in read_txt(filter_file)]
    ifmap1_all = [int(v) for v in read_txt(ifmap1_file)]
    ifmap2_all = [int(v) for v in read_txt(ifmap2_file)]
    size = int(len(ifmap1_all) ** 0.5)

    filter_hops = [('10','0'), ('11','0'), ('00','1'), ('10','1')]
    conv_offsets = [(0,0),(1,0),(0,1),(1,1)]

    lines = []

    # FILTER PACKETS
    for row in range(3):
        data_bytes = filter_vals[3*row : 3*row+3]
        data_content = ''.join(f"{b:08b}" for b in data_bytes)
        filter_row = f"{row+1:02b}"
        ifmapb = '1'
        ts = '0'
        for x_hop, y_hop in filter_hops:
            line = f"{data_content}_{filter_row}_{ifmapb}_{ts}"
            lines.append(line)

    # IFMAP PACKETS
    for idx, ifmap_all in enumerate([ifmap1_all, ifmap2_all], start=1):
        ts = '0' if idx == 1 else '1'
        filter_row = '00'
        ifmapb = '0'
        for (x_off, y_off), (x_hop, y_hop) in zip(conv_offsets, filter_hops):
            window_bits = []
            for dy in range(3):
                for dx in range(3):
                    ix = (y_off + dy) * size + (x_off + dx)
                    window_bits.append(str(ifmap_all[ix]))
            data_bits = ''.join(window_bits)
            data_content = data_bits.rjust(24, '0')
            line = f"{data_content}_{filter_row}_{ifmapb}_{ts}"
            lines.append(line)

    os.makedirs(os.path.dirname(output_file), exist_ok=True)
    with open(output_file, 'w') as f:
        for l in lines:
            f.write(l + "\n")

def test():
    filtersize, ifmapsize = 3, 4
    threshold = 16

    # Generate random tensors
    filter_L1 = torch.randint(6, (1,1,filtersize,filtersize)).float()
    ifmap_t1 = torch.randint(2, (1,1,ifmapsize,ifmapsize)).float()
    ifmap_t2 = torch.randint(2, (1,1,ifmapsize,ifmapsize)).float()

    print("filter_L1:\n", filter_L1)
    print("ifmap_t1:\n", ifmap_t1)
    print("ifmap_t2:\n", ifmap_t2)

    # Timestep 1 conv
    L1_conv_out_t1 = F.conv2d(ifmap_t1, filter_L1)
    L1_out_spike_t1 = (L1_conv_out_t1 > threshold).int()
    L1_residue_t1 = L1_conv_out_t1 - L1_out_spike_t1 * threshold
    print("Timestep 1 spikes:\n", L1_out_spike_t1)
    print("Timestep 1 residue:\n", L1_residue_t1)

    # Timestep 2 conv
    L1_conv_out_t2 = F.conv2d(ifmap_t2, filter_L1) + L1_residue_t1
    L1_out_spike_t2 = (L1_conv_out_t2 > threshold).int()
    L1_residue_t2 = L1_conv_out_t2 - L1_out_spike_t2 * threshold
    print("Timestep 2 spikes:\n", L1_out_spike_t2)
    print("Timestep 2 residue:\n", L1_residue_t2)

    # Save all data
    os.makedirs("scnn_script", exist_ok=True)
    save_to_file("scnn_script/L1_filter.txt", filter_L1, filter_L1.shape)
    save_to_file("scnn_script/ifmap_t1.txt", ifmap_t1, ifmap_t1.shape)
    save_to_file("scnn_script/ifmap_t2.txt", ifmap_t2, ifmap_t2.shape)
    save_to_file("scnn_script/L1_out_spike_t1.txt", L1_out_spike_t1, L1_out_spike_t1.shape)
    save_to_file("scnn_script/L1_out_spike_t2.txt", L1_out_spike_t2, L1_out_spike_t2.shape)
    save_to_file("scnn_script/L1_residue_t1.txt", L1_residue_t1, L1_residue_t1.shape)
    save_to_file("scnn_script/L1_residue_t2.txt", L1_residue_t2, L1_residue_t2.shape)

    # Generate packets
    generate_packet(
        "scnn_script/L1_filter.txt",
        "scnn_script/ifmap_t1.txt",
        "scnn_script/ifmap_t2.txt",
        "scnn_script/send_values.sv"
    )
    write_binary_packets(
        "scnn_script/L1_filter.txt",
        "scnn_script/ifmap_t1.txt",
        "scnn_script/ifmap_t2.txt",
        "scnn_script/send_values_bin.txt"
    )

if __name__ == '__main__':
    print("SCNN test starts")
    test()
