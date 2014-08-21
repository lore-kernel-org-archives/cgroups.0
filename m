From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] cgroup: add tracepoints to track cgroup events
Date: Thu, 21 Aug 2014 19:45:14 -0400
Message-ID: <20140821194514.0e97b26a@gandalf.local.home>
References: <1408592785-6700-1-git-send-email-andrea@betterlinux.com>
	<20140821141330.GA1766@mtj.dyndns.org>
	<20140821153541.GA7625@Dell>
	<20140821170002.GB7625@Dell>
	<20140821170701.GA3940@mtj.dyndns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140821170701.GA3940@mtj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: Andrea Righi <andrea@betterlinux.com>, Li Zefan <lizefan@huawei.com>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Matt Heaton <matt@betterlinux.com>

On Thu, 21 Aug 2014 12:07:01 -0500
Tejun Heo <tj@kernel.org> wrote:

> Hello, Anrea.
> 
> On Thu, Aug 21, 2014 at 11:00:02AM -0600, Andrea Righi wrote:
> > hmm... am I missing something or we already support directory events?
> 
> Ah, right, those mkdir/rmdir and writes automatically generate those
> events.
> 
> > root@Dell:~# grep cgroups /proc/mounts
> > none /cgroups cgroup rw,relatime,cpuset,cpu,cpuacct,memory,devices,freezer,perf_event,hugetlb 0 0
> > root@Dell:~# inotifywait -m -r -e modify -e move -e create -e delete /cgroups
> > Setting up watches.  Beware: since -r was given, this may take a while!
> > Watches established.
> > /cgroups/ CREATE,ISDIR test
> > /cgroups/test/ MODIFY cgroup.procs
> > /cgroups/test/ MODIFY cgroup.procs
> > /cgroups/test/ MODIFY cgroup.populated
> > /cgroups/ MODIFY cgroup.procs
> > /cgroups/ MODIFY cgroup.procs
> > /cgroups/test/ MODIFY cgroup.populated
> > /cgroups/ DELETE,ISDIR test
> > 
> > I still need to figure out a smart way to track which PIDs are
> > added/removed to/from cgroup.procs from userland (inotifywait + git? :)),
> > but all the other informations provided by my tracepoint patch seem to
> > be already available via [di]notify.
> 
> Hmmm... yeah, determining exactly which pids got added / removed can
> be cumbersome from just MODIFY events.  That said, what are you trying
> to do with such information?
> 

OK, is this patch not being pushed then? I have a lot of comments to
make about it, but if this patch is being dropped for another way of
doing things I wont waste my time on it.

Thanks,

-- Steve
