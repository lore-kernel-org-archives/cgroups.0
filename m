From: Andrea Righi <andrea@betterlinux.com>
Subject: Re: [PATCH] cgroup: add tracepoints to track cgroup events
Date: Thu, 21 Aug 2014 11:00:02 -0600
Message-ID: <20140821170002.GB7625@Dell>
References: <1408592785-6700-1-git-send-email-andrea@betterlinux.com>
 <20140821141330.GA1766@mtj.dyndns.org>
 <20140821153541.GA7625@Dell>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=betterlinux.com;
	s=default; t=1408640404;
	bh=VbYC/vDKOvmHSxk7cQyF8FLV7DxLTwiMU+vDTTskwiU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:In-Reply-To;
	b=XVCneQSepdgHaTtrwxyspiLg7uXA93QetP/1gp0GPjYKXbgZIMuJ+Q+Z2Mc+CT0gB
	 c5TdA2y/p+YZi6bvT++vjQNOAZW5buulh6lzpnHOC7Cs6FkyH5ShGB+vRmGMZam9xd
	 nzduwW+O9tCOJciE6Zg0nHvCu/sYneIb95/PbUcU=
Content-Disposition: inline
In-Reply-To: <20140821153541.GA7625@Dell>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Matt Heaton <matt@betterlinux.com>

On Thu, Aug 21, 2014 at 09:35:41AM -0600, Andrea Righi wrote:
> On Thu, Aug 21, 2014 at 09:13:30AM -0500, Tejun Heo wrote:
> > Hello,
> > 
> > On Wed, Aug 20, 2014 at 09:46:25PM -0600, Andrea Righi wrote:
> > > This patch adds the following tracepoints:
> > >  o trace_cgroup_create       when a new cgroup is created
> > >  o trace_cgroup_destroy      when a cgroup is removed
> > >  o trace_cgroup_task_migrate when a task/thread is moved from a cgroup to another
> > > 
> > > The purpose of these tracepoints is to identify and help cgroup "managers" to
> > > diagnose problems and detect when they are doing an excessive amount of work.
> > 
> > Using TPs for this looks like a really roundabout way of doing this
> > when the whole interface is based on filesystem.  Extending
> > kernfs_notity to support directory events seems like a better way to
> > do this.
> > 
> > Thanks.
> > 
> > -- 
> > tejun
> 
> Agreed. Thanks for the suggestion, Tejun.
> 
> -Andrea

hmm... am I missing something or we already support directory events?

Example:

root@Dell:~# grep cgroups /proc/mounts
none /cgroups cgroup rw,relatime,cpuset,cpu,cpuacct,memory,devices,freezer,perf_event,hugetlb 0 0
root@Dell:~# inotifywait -m -r -e modify -e move -e create -e delete /cgroups
Setting up watches.  Beware: since -r was given, this may take a while!
Watches established.
/cgroups/ CREATE,ISDIR test
/cgroups/test/ MODIFY cgroup.procs
/cgroups/test/ MODIFY cgroup.procs
/cgroups/test/ MODIFY cgroup.populated
/cgroups/ MODIFY cgroup.procs
/cgroups/ MODIFY cgroup.procs
/cgroups/test/ MODIFY cgroup.populated
/cgroups/ DELETE,ISDIR test

I still need to figure out a smart way to track which PIDs are
added/removed to/from cgroup.procs from userland (inotifywait + git? :)),
but all the other informations provided by my tracepoint patch seem to
be already available via [di]notify.

Thanks,
-Andrea
