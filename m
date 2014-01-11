From: Marian Marinov <mm-108MBtLGafw@public.gmane.org>
Subject: cgroups aware /proc/loadavg
Date: Sat, 11 Jan 2014 20:16:49 +0200
Message-ID: <52D18A91.9060000@1h.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

I'm working on making /proc/loadavg cgroup aware.

I have already done so with cpuinfo, sched, interrupts and partially meminfo:
   https://github.com/1HLtd/linux/tree/cgroup-aware-proc

However patching the loadavg is not a trivial task and I need some assistance.

After much reading I'm wondering, if it would be easier to patch the cpu or cpuacct cgroups to include an array in which 
we can hold a per cgroup avenrun array and use that information in the /proc/loadavg when it is displayed to a process 
that is not in the base cgroup.

Best regards,
Marian

-- 
Marian Marinov
Founder & CEO of 1H Ltd.
Jabber/GTalk: hackman-/eSpBmjxGS4dnm+yROfE0A@public.gmane.org
ICQ: 7556201
Mobile: +359 886 660 270
