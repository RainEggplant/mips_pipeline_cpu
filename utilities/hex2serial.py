import argparse
import os


def main():
    parser = argparse.ArgumentParser(
        description="This tool will reorder MIPS machine code (hex text) for serial port to use.")
    parser.add_argument("filename")
    args = parser.parse_args()
    tmp = list(os.path.splitext(args.filename))
    tmp[-1] = "_serial.txt"
    filename_out = str().join(tmp)
    file_in = open(args.filename, "r")
    file_out = open(filename_out, "w")

    for line in file_in:
        file_out.write(f"{line[6:8]} {line[4:6]} {line[2:4]} {line[0:2]} ")

    file_in.close()
    file_out.close()


if __name__ == "__main__":
    main()
