using System;
using System.Linq;
using System.Collections.Generic;
using System.Windows.Forms;
using Connection;

namespace CycleCount
{
    static class Program
    {
        /// <summary>
        /// The main entry point for the application.
        /// </summary>
        [MTAThread]
        static void Main(string[] args)
        {
            FXRFGlobals.GetFXMESGlobals();

#if PocketPC
            SymbolRFGun.SymbolRFGun myRFGun = new SymbolRFGun.SymbolRFGun();
            FXRFGlobals.MyRFGun = myRFGun;
#endif


            if (args.Any())
            {
                string opCode = args[0];
                string opName = args[1];
                Controller con = new Controller(opCode, opName);
            }
            else
            {
                Controller con = new Controller("", "");
            }


#if PocketPC
            FXRFGlobals.MyRFGun.StopRead();
            if (myRFGun != null) myRFGun.Close();
#endif
        }

    }
}