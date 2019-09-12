def main():
    print("This tool can read 4-byte integer in hex format. Input data below:")
    data = input()
    num_byte = data.split()
    for i in range(int((len(num_byte) + 3) / 4)):
        n = i * 4
        print(
            int(f"{num_byte[n + 3]}{num_byte[n + 2]}{num_byte[n + 1]}{num_byte[n]}", 16))


if __name__ == "__main__":
    main()
