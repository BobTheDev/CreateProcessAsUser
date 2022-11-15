using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Diagnostics;

using McDToolsLib;

namespace MySplashPagePre
{
    internal class Program
    {
        static Logger Log;
        static void Main(string[] args)
        {
            Log = new Logger();
            Log.StartNewLog("POS_Splash_page_Pre_" + DateTime.Now.ToString("yyyyMMdd-HHmmss") + ".log", false);
            Log.WriteTitle("MySplashPagePre started");
            string currentUser = Environment.UserName;
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
                Log.WriteInfoMessage("about to start the PosSplashRun with local user");
                ProcessExtensions.StartProcessAsCurrentUser(".\\PosSplashRun.exe");
                Log.WriteInfoMessage("the PosSplashRun finished normally with local user");
            }
            else
            {
                try
                {
                    Log.WriteInfoMessage("about to start the PosSplashRun normally");
                    var process = new Process
                    {
                        StartInfo = new ProcessStartInfo
                        {
                            FileName = ".\\PosSplashRun.exe",
                            Arguments = "",
                            UseShellExecute = false,
                            RedirectStandardOutput = true,
                            CreateNoWindow = true
                        }
                    };

                    process.Start();
                    Log.WriteInfoMessage("the PosSplashRun started normally");

                    while (!process.StandardOutput.EndOfStream)
                    {
                        var line = process.StandardOutput.ReadLine();
                        Log.WriteInfoMessage(line);
                    }

                    process.WaitForExit();
                    Log.WriteInfoMessage("the PosSplashRun finished normally");
                }
                catch (Exception e)
                {
                    Log.WriteWarningMessage(e.Message);
                }
            }
            
        }
    }
}
