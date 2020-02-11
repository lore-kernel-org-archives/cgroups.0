From: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
Subject: Re: [RFC] why can't dynamic isolation just like the static way
Date: Tue, 11 Feb 2020 08:54:43 -0500
Message-ID: <20200211085443.2a112c03@gandalf.local.home>
References: <fed10a26-7423-23b5-316c-c74d354870dd@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <fed10a26-7423-23b5-316c-c74d354870dd-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: =?UTF-8?B?546L6LSH?= <yun.wang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, "open list:SCHEDULER" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


You forgot to include the cgroup maintainers.

-- Steve


On Tue, 11 Feb 2020 16:17:34 +0800
王贇 <yun.wang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org> wrote:

> Hi, folks
> 
> We are dealing with isolcpus these days and try to do the isolation
> dynamically.
> 
> The kernel doc lead us into the cpuset.sched_load_balance, it's fine
> to achieve the dynamic isolation with it, however we got problem with
> the systemd stuff.
> 
> It's keeping create cgroup with sched_load_balance enabled on default,
> while the cpus are overlapped with the isolated ones, which lead into
> sched domain rebuild and these cpus become non-isolated.
> 
> We're just looking forward an easy way to dynamic isolate some cpus,
> just like the isolation parameter, but sched_load_balance forcing us
> to dealing with the management of cgroups, we really don't get the
> point in here...
> 
> Why do we have to mix the isolation with cgroups? Why not just provide
> a proc entry to read cpumask and rebuild the domains?
> 
> Please let us know if there is any good reason to make the dynamic
> isolation in that way, appreciated in advance :-)
> 
> Regards,
> Michael Wang

