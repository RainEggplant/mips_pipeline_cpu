import argparse
import random


def main():
    parser = argparse.ArgumentParser(
        description="This tool will generate 100 random 4-byte unsigned integers as well as an SSD table.")
    parser.add_argument("filename")
    args = parser.parse_args()
    txt_out = open(args.filename + ".txt", "w")
    bin_out = open(args.filename + ".bin", "wb")
    serial_out = open(args.filename + "_serial.txt", "w")
    hex_txt_out = open(args.filename + ".hex", "w")
    ssd_code = [
        0b0111111, 0b0000110, 0b1011011, 0b1001111, 0b1100110, 0b1101101, 0b1111101, 0b0000111,
        0b1111111, 0b1101111, 0b1110111, 0b1111100, 0b0111001, 0b1011110, 0b1111011, 0b1110001
    ]

    bin_out.write((100).to_bytes(4, byteorder="little", signed=False))

    for i in range(100):
        num = random.getrandbits(32)
        num_in_hex = "{:08x}".format(num)
        txt_out.write(f"{num}\n")
        bin_out.write(num.to_bytes(4, byteorder="little", signed=False))
        serial_out.write(
            f"{num_in_hex[6:8]} {num_in_hex[4:6]} {num_in_hex[2:4]} {num_in_hex[0:2]} ")
        hex_txt_out.write(f"{num_in_hex}\n")

    txt_out.close()
    bin_out.close()

    for i in range(16):
        num_in_hex = "{:08x}".format(ssd_code[i])
        serial_out.write(
            f"{num_in_hex[6:8]} {num_in_hex[4:6]} {num_in_hex[2:4]} {num_in_hex[0:2]} ")
        hex_txt_out.write(f"{num_in_hex}\n")

    serial_out.close()
    hex_txt_out.close()


if __name__ == "__main__":
    main()
