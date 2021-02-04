From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH 6/7] mm: memcontrol: switch to rstat
Date: Thu, 4 Feb 2021 15:28:36 -0500
Message-ID: <YBxY9C8R/iiMNRk+@cmpxchg.org>
References: <20210202184746.119084-1-hannes@cmpxchg.org>
 <20210202184746.119084-7-hannes@cmpxchg.org>
 <YBwCZYWsQOFAGUar@dhcp22.suse.cz>
 <YBwdiu2Fj4JHgqhQ@cmpxchg.org>
 <YBwkVoNa77Nn5TE9@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yEvjhfE3B2Kd/et2YVJ5Ze7JfgA4snxVhFv0VxIo/SQ=;
        b=Ef7g7l18hq99xrkcC+S5rDk+Sp9Ldd0vt7jDuvrHK+Le50wfK90SOFztyYrf29ifLe
         biWfx67fF91Fo4nuJXl2iOm7tcA5jlLMrrnX0D+3B9Ndg3icZNqZOICzMoJMwChxhotz
         ySXUYjeFoyjJFXTjFmRy3AantGbnhjZfjnqNpAOPW7uqhIer8dTEpVZI6xP+NJj8ifhj
         dQwk76TLSuj9GGbU0nKkHxEBfRChrDAOVoKePjDl+pEWX/l7t+2k2sl9PhMwJtWH84Pw
         KnlHlf90OKa1gmp1WYk/YCl5MQ4QBIGmt1ubhQioYN5H51o23sks0+4aCN9r9Y8WK8Hs
         v3Og==
Content-Disposition: inline
In-Reply-To: <YBwkVoNa77Nn5TE9-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Thu, Feb 04, 2021 at 05:44:06PM +0100, Michal Hocko wrote:
> On Thu 04-02-21 11:15:06, Johannes Weiner wrote:
> > Hello Michal,
> > 
> > On Thu, Feb 04, 2021 at 03:19:17PM +0100, Michal Hocko wrote:
> > > On Tue 02-02-21 13:47:45, Johannes Weiner wrote:
> > > > Replace the memory controller's custom hierarchical stats code with
> > > > the generic rstat infrastructure provided by the cgroup core.
> > > > 
> > > > The current implementation does batched upward propagation from the
> > > > write side (i.e. as stats change). The per-cpu batches introduce an
> > > > error, which is multiplied by the number of subgroups in a tree. In
> > > > systems with many CPUs and sizable cgroup trees, the error can be
> > > > large enough to confuse users (e.g. 32 batch pages * 32 CPUs * 32
> > > > subgroups results in an error of up to 128M per stat item). This can
> > > > entirely swallow allocation bursts inside a workload that the user is
> > > > expecting to see reflected in the statistics.
> > > > 
> > > > In the past, we've done read-side aggregation, where a memory.stat
> > > > read would have to walk the entire subtree and add up per-cpu
> > > > counts. This became problematic with lazily-freed cgroups: we could
> > > > have large subtrees where most cgroups were entirely idle. Hence the
> > > > switch to change-driven upward propagation. Unfortunately, it needed
> > > > to trade accuracy for speed due to the write side being so hot.
> > > > 
> > > > Rstat combines the best of both worlds: from the write side, it
> > > > cheaply maintains a queue of cgroups that have pending changes, so
> > > > that the read side can do selective tree aggregation. This way the
> > > > reported stats will always be precise and recent as can be, while the
> > > > aggregation can skip over potentially large numbers of idle cgroups.
> > > > 
> > > > This adds a second vmstats to struct mem_cgroup (MEMCG_NR_STAT +
> > > > NR_VM_EVENT_ITEMS) to track pending subtree deltas during upward
> > > > aggregation. It removes 3 words from the per-cpu data. It eliminates
> > > > memcg_exact_page_state(), since memcg_page_state() is now exact.
> > > 
> > > I am still digesting details and need to look deeper into how rstat
> > > works but removing our own stats is definitely a good plan. Especially
> > > when there are existing limitations and problems that would need fixing.
> > > 
> > > Just to check that my high level understanding is correct. The
> > > transition is effectivelly removing a need to manually sync counters up
> > > the hierarchy and partially outsources that decision to rstat core. The
> > > controller is responsible just to tell the core how that syncing is done
> > > (e.g. which specific counters etc).
> > 
> > Yes, exactly.
> > 
> > rstat implements a tree of cgroups that have local changes pending,
> > and a flush walk on that tree. But it's all driven by the controller.
> > 
> > memcg needs to tell rstat 1) when stats in a local cgroup change
> > e.g. when we do mod_memcg_state() (cgroup_rstat_updated), 2) when to
> > flush, e.g. before a memory.stat read (cgroup_rstat_flush), and 3) how
> > to flush one cgroup's per-cpu state and propagate it upward to the
> > parent during rstat's flush walk (.css_rstat_flush).
> 
> Can we have this short summary in a changelog please?

Sure thing, I'll include that v2.

> > > Excplicit flushes are needed when you want an exact value (e.g. when
> > > values are presented to the userspace). I do not see any flushes to
> > > be done by the core pro-actively except for clean up on a release.
> > > 
> > > Is the above correct understanding?
> > 
> > Yes, that's correct.
> 
> OK, thanks for the confirmation. I will have a closer look tomorrow but
> I do not see any problems now.

Thanks
