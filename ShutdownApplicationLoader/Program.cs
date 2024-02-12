using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Diagnostics;

using McDToolsLib;

namespace ShutdownApplicationLoader
{
    internal class Program
    {
        static Logger Log;
        static void Main(string[] args)
        {
            Log = new Logger();
            Log.StartNewLog("ShutdownApplication_Loader_" + DateTime.Now.ToString("yyyyMMdd-HHmmss") + ".log", false);
            Log.WriteTitle("ShutdownApplication_Loader started");
            string currentUser = Environment.UserName;
            string name_of_shutdownApplicaton = "ShutdownApplicationV4.5.exe";
            bool bNeedDownToNewpos = false;
            Log.WriteInfoMessage("current user is:" + currentUser);

            if (currentUser.ToUpper().Contains("NEWPOS"))
            {
                Log.WriteInfoMessage("running as newpos user already:" + currentUser);
                bNeedDownToNewpos = false;
            }
            else
            {
                Log.WriteInfoMessage("running not as newpos user:" + currentUser);
                bNeedDownToNewpos = true;
            }
            Log.WriteInfoMessage("bNeedDownToNewpos:" + bNeedDownToNewpos);
            if (bNeedDownToNewpos)
            {
                Log.WriteInfoMessage("about to start the shutdownApplicaton with local user");
                ProcessExtensions.StartProcessAsCurrentUser(".\\" + name_of_shutdownApplicaton);
                Log.WriteInfoMessage("the shutdownApplicaton finished normally with local user");
            }
            else
            {
                try
                {
                    Log.WriteInfoMessage("about to start the shutdownApplicaton normally");
                    var process = new Process
                    {
                        StartInfo = new ProcessStartInfo
                        {
                            FileName = ".\\" + name_of_shutdownApplicaton,
                            Arguments = "",
                            UseShellExecute = false,
                            RedirectStandardOutput = true,
                            CreateNoWindow = true
                        }
                    };

                    process.Start();
                    Log.WriteInfoMessage("the shutdownApplicaton started normally");

                    while (!process.StandardOutput.EndOfStream)
                    {
                        var line = process.StandardOutput.ReadLine();
                        Log.WriteInfoMessage(line);
                    }

                    process.WaitForExit();
                    Log.WriteInfoMessage("the shutdownApplicaton finished normally");
                }
                catch (Exception e)
                {
                    Log.WriteWarningMessage(e.Message);
                }
            }

        }
    }
}
