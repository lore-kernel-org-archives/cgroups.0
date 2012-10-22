From: Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: process hangs on do_exit when oom happens
Date: Mon, 22 Oct 2012 11:08:40 +0530
Message-ID: <CAKTCnzmDhSd-POHSC0wx-ziVPUg9wFverK33Q1_SvCx3Gzuugg@mail.gmail.com>
References: <op.wmbi5kbrn27o5l@gaoqiang-d1.corp.qihoo.net>
	<20121019160425.GA10175@dhcp22.suse.cz>
	<CAKWKT+Z-SZb1=3rwLm+urs3fghQ3M6pdOR_rzXKCevoad11a5g@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=LsYoRbOGi+ZWYur2JGn1597fe2lywvh0rX/dItEWNTc=;
        b=Xur4ydDDz13EtoJgEaRfm5Yylh3ALc/j9m8sgzq/VijWHQfm3ioBKmybTBdeMp3F24
         5w9QJ1dhvqXuGsOumBm+64NIKkmu+a6fA9NTP83y2lRFR4VjkY0tBHkEiypjxRpXEkky
         RZx7XPNvEmbXGwyYSYdm7oJkHTbMD7hmF9ASokCvfk7tZgrBjk3bcwQAVTF0ZZ2RnRTc
         09eVABNTB5d1iOlnc1pgHfj1j3IPGAG4b1HVypXn/q6WkkHOIDUbhj1tPeNRBM0rWfWY
         qmkHuhGIc9JLCM+MNvZGplj/KUkeIaURf069BBxdOC6ScMZ5Ot/PUxfDlNZDrv05wxmW
         dEPw==
In-Reply-To: <CAKWKT+Z-SZb1=3rwLm+urs3fghQ3M6pdOR_rzXKCevoad11a5g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Qiang Gao <gaoqiangscut-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mmc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-mmc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Mon, Oct 22, 2012 at 7:46 AM, Qiang Gao <gaoqiangscut-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> I don't know whether  the process will exit finally, bug this stack lasts
> for hours, which is obviously unnormal.
> The situation:  we use a command calld "cglimit" to fork-and-exec the worker
> process,and the "cglimit" will
> set some limitation on the worker with cgroup. for now,we limit the
> memory,and we also use cpu cgroup,but with
> no limiation,so when the worker is running, the cgroup directory looks like
> following:
>
> /cgroup/memory/worker : this directory limit the memory
> /cgroup/cpu/worker :with no limit,but worker process is in.
>
> for some reason(some other process we didn't consider),  the worker process
> invoke global oom-killer,
> not cgroup-oom-killer.  then the worker process hangs there.
>
> Actually, if we didn't set the worker process into the cpu cgroup, this will
> never happens.
>

You said you don't use CPU limits right? can you also send in the
output of /proc/sched_debug. Can you also send in your
/etc/cgconfig.conf? If the OOM is not caused by cgroup memory limit
and the global system is under pressure in 2.6.32, it can trigger an
OOM.

Also

1. Have you turned off swapping (seems like it) right?
2. Do you have a NUMA policy setup for this task?

Can you also share the .config (not sure if any special patches are
being used) in the version you've mentioned.

Balbir
