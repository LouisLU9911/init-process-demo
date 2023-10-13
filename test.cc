#include <iostream>
#include <fstream>
#include <chrono>
#include <thread>
#include <csignal>

bool finished_writing = false;

void signal_handler(int signal)
{
    std::cout << "Received signal " << signal << ", cleaning up" << std::endl;
    if(!finished_writing)
    {
        std::cout << "Deleting file" << std::endl;
        std::remove("example.txt");
    }
    exit(signal);
}

int main()
{
    std::remove("example.txt");
    std::ofstream outfile("example.txt", std::ios::app);

    // Set up signal handler for SIGTERM
    std::signal(SIGTERM, signal_handler);

    if(outfile.is_open())
    {
        outfile << "hello" << std::endl;
        outfile.flush(); // Flush the output buffer
        std::cout << "File written successfully" << std::endl;

        // Sleep for 3 minutes
        std::this_thread::sleep_for(std::chrono::minutes(3));

        outfile << "world" << std::endl;
        outfile.flush(); // Flush the output buffer
        outfile.close();
        std::cout << "File written successfully" << std::endl;
        finished_writing = true;
    }
    else
    {
        std::cerr << "Error opening file" << std::endl;
    }

    return 0;
}
