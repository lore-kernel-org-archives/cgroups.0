From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC] memory reserve for userspace oom-killer
Date: Wed, 21 Apr 2021 06:57:43 -0700
Message-ID: <CALvZod4kRWDQuZZQ5F+z6WMcUWLwgYd-Kb0mY8UAEK4MbSOZaA@mail.gmail.com>
References: <CALvZod7vtDxJZtNhn81V=oE-EPOf=4KZB2Bv6Giz+u3bFFyOLg@mail.gmail.com>
 <YH54pyRWSi1zLMw4@dhcp22.suse.cz> <CALvZod4kjdgMU=8T_bx6zFufA1cGtt2p1Jg8jOgi=+g=bs-Evw@mail.gmail.com>
 <YH/RPydqhwXdyG80@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SzUt8X/WzmqyiQTQOb09ZoIGFmeYojo8TKKWXg5zRNc=;
        b=mjoh/M3C5zXaRixBaiMGh8FW3jbxldonTsAzJ77oVizAjeOQHKGQiC3i75Wu1umZhX
         RchEyUx3ji5vKetnRRp26j8o1NQ2RDmlT0MDgmHTFqrnIHTNRA2hOPGLJSlBZ96jGVKf
         571gU2R/TArQpNfCLUqywHzxY8P+cvMHYJLT1l3UwzGQBXFPMDEgJCSCblnavYn8A5bO
         JXVBkSCY3RsQl8DJcCt2LB/rX6BfDfUMqitdJacy+e9UK6xr1L491vhp2P7k43GWQnVa
         XgkwX1mnEErizRWbJD2VriTjvK5e1upblqP8QOGLtZ4cRNo9253JqHD+ovek+QYElz8G
         tJ7w==
In-Reply-To: <YH/RPydqhwXdyG80-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Dragos Sbirlea <dragoss-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Priya Duraisamy <padmapriyad-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Wed, Apr 21, 2021 at 12:16 AM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
>
[...]
> > To decide when to kill, the oom-killer has to read a lot of metrics.
> > It has to open a lot of files to read them and there will definitely
> > be new allocations involved in those operations. For example reading
> > memory.stat does a page size allocation. Similarly, to perform action
> > the oom-killer may have to read cgroup.procs file which again has
> > allocation inside it.
>
> True but many of those can be avoided by opening the file early. At
> least seq_file based ones will not allocate later if the output size
> doesn't increase. Which should be the case for many. I think it is a
> general improvement to push those who allocate during read to an open
> time allocation.
>

I agree that this would be a general improvement but it is not always
possible (see below).

> > Regarding sophisticated oom policy, I can give one example of our
> > cluster level policy. For robustness, many user facing jobs run a lot
> > of instances in a cluster to handle failures. Such jobs are tolerant
> > to some amount of failures but they still have requirements to not let
> > the number of running instances below some threshold. Normally killing
> > such jobs is fine but we do want to make sure that we do not violate
> > their cluster level agreement. So, the userspace oom-killer may
> > dynamically need to confirm if such a job can be killed.
>
> What kind of data do you need to examine to make those decisions?
>

Most of the time the cluster level scheduler pushes the information to
the node controller which transfers that information to the
oom-killer. However based on the freshness of the information the
oom-killer might request to pull the latest information (IPC and RPC).

[...]
> >
> > I was thinking of simply prctl(SET_MEMPOOL, bytes) to assign mempool
> > to a thread (not shared between threads) and prctl(RESET_MEMPOOL) to
> > free the mempool.
>
> I am not a great fan of prctl. It has become a dumping ground for all
> mix of unrelated functionality. But let's say this is a minor detail at
> this stage.

I agree this does not have to be prctl().

> So you are proposing to have a per mm mem pool that would be

I was thinking of per-task_struct instead of per-mm_struct just for simplicity.

> used as a fallback for an allocation which cannot make a forward
> progress, right?

Correct

> Would that pool be preallocated and sitting idle?

Correct

> What kind of allocations would be allowed to use the pool?

I was thinking of any type of allocation from the oom-killer (or
specific threads). Please note that the mempool is the backup and only
used in the slowpath.

> What if the pool is depleted?

This would mean that either the estimate of mempool size is bad or
oom-killer is buggy and leaking memory.

I am open to any design directions for mempool or some other way where
we can provide a notion of memory guarantee to oom-killer.

thanks,
Shakeel
