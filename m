From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [patch] mm, memcg: add oom killer delay
Date: Fri, 31 May 2013 13:21:16 +0200
Message-ID: <20130531112116.GC32491@dhcp22.suse.cz>
References: <alpine.DEB.2.02.1305291817280.520@chino.kir.corp.google.com>
 <20130530150539.GA18155@dhcp22.suse.cz>
 <alpine.DEB.2.02.1305301338430.20389@chino.kir.corp.google.com>
 <20130531081052.GA32491@dhcp22.suse.cz>
 <alpine.DEB.2.02.1305310316210.27716@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1305310316210.27716-X6Q0R45D7oAcqpCFd4KODRPsWskHk0ljAL8bYrjMMd8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri 31-05-13 03:22:59, David Rientjes wrote:
> On Fri, 31 May 2013, Michal Hocko wrote:
> 
> > I have always discouraged people from running oom handler in the same
> > memcg (or even in the same hierarchy).
> > 
> 
> We allow users to control their own memcgs by chowning them, so they must 
> be run in the same hierarchy if they want to run their own userspace oom 
> handler.  There's nothing in the kernel that prevents that and the user 
> has no other option but to run in a parent cgroup.

If the access to the oom_control file is controlled by the file
permissions then the oom handler can live inside root cgroup. Why do you
need "must be in the same hierarchy" requirement?

> > Yes, mmap_sem is tricky. Nothing in the proc code should take it for
> > writing and charges are done with mmap_sem held for reading but that
> > doesn't prevent from non-oom thread to try to get it for writing which
> > would block also all future readers. We have also seen i_mutex being
> > held during charge so you have to be careful about that one as well but
> > I am not aware of other locks that could be a problem.
> > 
> > The question is, do you really need to open any /proc/<pid>/ files which
> > depend on mmap_sem (e.g. maps, smaps). /proc/<pid>/status should tell you
> > about used memory. Or put it another way around. What kind of data you
> > need for your OOM handler?
> > 
> 
> It's too easy to simply do even a "ps ax" in an oom memcg and make that 
> thread completely unresponsive because it allocates memory.

Yes, but we are talking about oom handler and that one has to be really
careful about what it does. So doing something that simply allocates is
dangerous.

> > I might be thinking about different use cases but user space OOM
> > handlers I have seen so far had quite a good idea what is going on
> > in the group and who to kill.
> 
> Then perhaps I'm raising constraints that you've never worked with, I 
> don't know.  We choose to have a priority-based approach that is inherited 
> by children; this priority is kept in userspace and and the oom handler 
> would naturally need to know the set of tasks in the oom memcg at the time 
> of oom and their parent-child relationship.  These priorities are 
> completely independent of memory usage.

OK, but both reading tasks file and readdir should be doable without
userspace (aka charged) allocations. Moreover if you run those oom
handlers under the root cgroup then it should be even easier.
-- 
Michal Hocko
SUSE Labs
