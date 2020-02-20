From: Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: asynchronous reclaim for memory.high
Date: Thu, 20 Feb 2020 10:45:24 -0500
Message-ID: <20200220154524.dql3i5brnjjwecft@ca-dmjordan1.us.oracle.com>
References: <20200219181219.54356-1-hannes@cmpxchg.org>
 <20200219183731.GC11847@dhcp22.suse.cz>
 <20200219191618.GB54486@cmpxchg.org>
 <20200219195332.GE11847@dhcp22.suse.cz>
 <20200219214112.4kt573kyzbvmbvn3@ca-dmjordan1.us.oracle.com>
 <20200219220859.GF54486@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=Y/mFiU18EBtEaH5OMEwxs9bxgqWYfXtQzQK0tFNuMzw=;
 b=XprjFRSGHt9YYCnNDTczDtIfli1Y+O0kphL/RPJ7I/vvYbyoTdaA1k7XDRwMMwTP/Ep1
 hbkicNFvU3h3mL1nxqwsStgwBHHm7xKuv8BRKCjsKk+/shspPr7QLuFwEga05GMILil/
 lpmK0g3v68WyUD6IVAGWlNImDuBofRSqpfwWBSRGnKDCDKSIpZPmC0qftkTCdsqfLEAo
 TTpib+H965bQ77e7+qK1sTetoeqCydFYn9Azer0fHM66/tQASZ+b18g7ApOtSYIhbNWx
 mD1DK+7ka2X3aQXR0sRZBnAEtPzBjuEAkon+WWWtdBYiTr7m9rxkevDzDEHyreVlaHn6 lQ== 
Content-Disposition: inline
In-Reply-To: <20200219220859.GF54486-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

+Peter

On Wed, Feb 19, 2020 at 05:08:59PM -0500, Johannes Weiner wrote:
> On Wed, Feb 19, 2020 at 04:41:12PM -0500, Daniel Jordan wrote:
> > On Wed, Feb 19, 2020 at 08:53:32PM +0100, Michal Hocko wrote:
> > > On Wed 19-02-20 14:16:18, Johannes Weiner wrote:
> > > > On Wed, Feb 19, 2020 at 07:37:31PM +0100, Michal Hocko wrote:
> > > > > On Wed 19-02-20 13:12:19, Johannes Weiner wrote:
> > > > > > This patch adds asynchronous reclaim to the memory.high cgroup limit
> > > > > > while keeping direct reclaim as a fallback. In our testing, this
> > > > > > eliminated all direct reclaim from the affected workload.
> > > > > 
> > > > > Who is accounted for all the work? Unless I am missing something this
> > > > > just gets hidden in the system activity and that might hurt the
> > > > > isolation. I do see how moving the work to a different context is
> > > > > desirable but this work has to be accounted properly when it is going to
> > > > > become a normal mode of operation (rather than a rare exception like the
> > > > > existing irq context handling).
> > > > 
> > > > Yes, the plan is to account it to the cgroup on whose behalf we're
> > > > doing the work.
> > 
> > How are you planning to do that?
> > 
> > I've been thinking about how to account a kernel thread's CPU usage to a cgroup
> > on and off while working on the parallelizing Michal mentions below.  A few
> > approaches are described here:
> > 
> > https://lore.kernel.org/linux-mm/20200212224731.kmss6o6agekkg3mw-S51bK0XF4qpuJJETbFA3a0B3C2bhBk7L0E9HWUfgJXw@public.gmane.org/
> 
> What we do for the IO controller is execute the work unthrottled but
> charge the cgroup on whose behalf we are executing with whatever cost
> or time or bandwith that was incurred. The cgroup will pay off this
> debt when it requests more of that resource.
>
[snip code pointers]

Thanks!  Figuring out how the io controllers dealt with remote charging was on
my list, this makes it easier.

> The plan for the CPU controller is similar. When a remote execution
> begins, flush the current runtime accumulated (update_curr) and
> associate the current thread with another cgroup (similar to
> current->active_memcg); when remote execution is done, flush the
> runtime delta to that cgroup and unset the remote context.

Ok, consistency with io and memory is one advantage to doing it that way.
Creating kthreads in cgroups also seems viable so far, and it's unclear whether
either approach is significantly simpler or more maintainable than the other,
at least to me.

Is someone on your side working on remote charging right now?  I was planning
to post an RFD comparing these soon and it would make sense to include them.
