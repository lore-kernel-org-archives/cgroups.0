From: Andrea Righi <andrea-oIIqvOZpAevzfdHfmsDf5w@public.gmane.org>
Subject: Re: [PATCH] cgroup: add tracepoints to track cgroup events
Date: Thu, 21 Aug 2014 22:05:35 -0600
Message-ID: <20140822040535.GA2298@Dell>
References: <1408592785-6700-1-git-send-email-andrea@betterlinux.com>
 <20140821141330.GA1766@mtj.dyndns.org>
 <20140821153541.GA7625@Dell>
 <20140821170002.GB7625@Dell>
 <20140821170701.GA3940@mtj.dyndns.org>
 <20140821194514.0e97b26a@gandalf.local.home>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=betterlinux.com;
	s=default; t=1408680336;
	bh=J65e9FNzi0SpV7LxesZfaV8RuMyGcYYCuIFbfZB/5p4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:In-Reply-To;
	b=OKbLXcaoxVuy7bHPSf/SvxwfdIXmJCu4zxeTq+vVuVsWNCGgffLF0MRHVIsakI5gA
	 Vczm3DSy7MfajBVATUjBGLFSoMktDF+LCLolvyJbDsBKgnhXT1lmqzBJQAxqg/MW83
	 phOI4wQJQgiOb/2eJVjh9IgnBuwto3LFRhlxO178=
Content-Disposition: inline
In-Reply-To: <20140821194514.0e97b26a-f9ZlEuEWxVcJvu8Pb33WZ0EMvNT87kid@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Heaton <matt-oIIqvOZpAevzfdHfmsDf5w@public.gmane.org>

On Thu, Aug 21, 2014 at 07:45:14PM -0400, Steven Rostedt wrote:
> On Thu, 21 Aug 2014 12:07:01 -0500
> Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> 
> > Hello, Anrea.
> > 
> > On Thu, Aug 21, 2014 at 11:00:02AM -0600, Andrea Righi wrote:
> > > hmm... am I missing something or we already support directory events?
> > 
> > Ah, right, those mkdir/rmdir and writes automatically generate those
> > events.
> > 
> > > root@Dell:~# grep cgroups /proc/mounts
> > > none /cgroups cgroup rw,relatime,cpuset,cpu,cpuacct,memory,devices,freezer,perf_event,hugetlb 0 0
> > > root@Dell:~# inotifywait -m -r -e modify -e move -e create -e delete /cgroups
> > > Setting up watches.  Beware: since -r was given, this may take a while!
> > > Watches established.
> > > /cgroups/ CREATE,ISDIR test
> > > /cgroups/test/ MODIFY cgroup.procs
> > > /cgroups/test/ MODIFY cgroup.procs
> > > /cgroups/test/ MODIFY cgroup.populated
> > > /cgroups/ MODIFY cgroup.procs
> > > /cgroups/ MODIFY cgroup.procs
> > > /cgroups/test/ MODIFY cgroup.populated
> > > /cgroups/ DELETE,ISDIR test
> > > 
> > > I still need to figure out a smart way to track which PIDs are
> > > added/removed to/from cgroup.procs from userland (inotifywait + git? :)),
> > > but all the other informations provided by my tracepoint patch seem to
> > > be already available via [di]notify.
> > 
> > Hmmm... yeah, determining exactly which pids got added / removed can
> > be cumbersome from just MODIFY events.  That said, what are you trying
> > to do with such information?
> > 
> 
> OK, is this patch not being pushed then? I have a lot of comments to
> make about it, but if this patch is being dropped for another way of
> doing things I wont waste my time on it.
> 
> Thanks,
> 
> -- Steve

Comments are always welcome, but at this point I'd say we can drop this
patch, so don't waste your time on it. I can find an alternative way to
get the same informations from user-space.

Thanks,
-Andrea
