From: "Robert Gierzinger" <robert.gierzinger-RbZlAiThDcE@public.gmane.org>
Subject: Process Limit cgroups
Date: Thu, 7 Nov 2013 12:31:58 +0100 (CET)
Message-ID: <trinity-a0dd51e0-7bb0-487f-a76b-aa2ba86877da-1383823917957@3capp-gmx-bs50>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

Will there be a limitation of the number of processes per cgroup (task counter subsystem from Frederic Weisbecker)? I guess this would be interesting for many users especially in connection with LXC. As long as this is not implemented our security policy prevents us from using LXC. I could isolate resources quite well, however, I am still able to bomb the host system once I become root in LXC-guests. I tried to circumvent this problem with apparmor, rlimits etc. but was not successful, see http://sourceforge.net/mailarchive/forum.php?thread_name=CAJ75kXYapfC_ihVyshWyGQqBL_jJbLJitgOscaCt1ciNyoyokg%40mail.gmail.com&forum_name=lxc-devel
Is there any plan for such an implementation?

bye,
Robert
