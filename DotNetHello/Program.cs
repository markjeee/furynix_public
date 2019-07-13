using System;

namespace DotNetHello
{
    class Program
    {
        static void Main(string[] args)
        {
            DotNetWorld.World world = new DotNetWorld.World();

            Console.WriteLine("Hello " + world.world());
        }
    }
}
