From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 0/3] memcg: Slow down swap allocation as the available
 space gets depleted
Date: Fri, 17 Apr 2020 18:59:41 -0400
Message-ID: <20200417225941.GE43469@mtj.thefacebook.com>
References: <20200417010617.927266-1-kuba@kernel.org>
 <CALvZod78ZUhU+yr2x1h_gv+VgVGTPnSSGKh_+fd+MeiAKreJvg@mail.gmail.com>
 <20200417162355.GA43469@mtj.thefacebook.com>
 <CALvZod4ftvXCu8SbQUXwTGVvx5K2+at9h30r28chZLXEB1JdfQ@mail.gmail.com>
 <20200417173615.GB43469@mtj.thefacebook.com>
 <CALvZod7-r0OrJ+-_uCy_p3BU3348ve2+YatiSdLvFaVqcqCs=w@mail.gmail.com>
 <20200417193539.GC43469@mtj.thefacebook.com>
 <CALvZod6LT25t9aAA1KHmf1U4-L8zSjUXQ4VQvX4cMT1A+R_g+w@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8801jFN/GrsE8fa3Pk4djhRzV1N+Kj/xtd4sR7cPIJY=;
        b=eFx3mF2izmyuuy+NlcXaQ6JuMj3oh7WJ8XZtMr9WOfL9uZpAeVCnutroEyWtEhpxUG
         U+Hrb7r0k5y1Y1a3TZLKgW0LdmTMLqNwjfheoRsTPzNngA+n/0YfYLqRI2d/YcKjpbDD
         sOjVhwed3Tx26v86MOWCVyBbbatyaT6ZJHSZXRsF4YbYX2rwoBAh5ziMxjuLEbJrNB3O
         So9pKpViuYklaBJrkN7tffQvA6QefQ6fFMzGx8Cpb6zn5RUvRLz9xbmN/e1EVVasq23O
         HFfbTKrzrbEDqdD7FNeQf2ml/i+sd7rJwYXe/+1OdhvSEgGV5PPe/B+G1KxPFMYwMhp1
         +iCw==
Content-Disposition: inline
In-Reply-To: <CALvZod6LT25t9aAA1KHmf1U4-L8zSjUXQ4VQvX4cMT1A+R_g+w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Kernel Team <kernel-team-b10kYP2dOMg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello, Shakeel.

On Fri, Apr 17, 2020 at 02:51:09PM -0700, Shakeel Butt wrote:
> > > In this example does 'B' have memory.high and memory.max set and by A
> >
> > B doesn't have anything set.
> >
> > > having no other restrictions, I am assuming you meant unlimited high
> > > and max for A? Can 'A' use memory.min?
> >
> > Sure, it can but 1. the purpose of the example is illustrating the
> > imcompleteness of the existing mechanism
> 
> I understand but is this a real world configuration people use and do
> we want to support the scenario where without setting high/max, the
> kernel still guarantees the isolation.

Yes, that's the configuration we're deploying fleet-wide and at least the
direction I'm gonna be pushing towards for reasons of generality and ease of
use.

Here's an example to illustrate the point - consider distros or upstream
desktop environments wanting to provide basic resource configuration to
protect user sessions and critical system services needed for user
interaction by default. That is something which is clearly and immediately
useful but also is extremely challenging to achieve with limits.

There are no universally good enough upper limits. Any one number is gonna
be both too high to guarantee protection and too low for use cases which
legitimately need that much memory. That's because the upper limits aren't
work-conserving and have a high chance of doing harm when misconfigured
making figuring out the correct configuration almost impossible with
per-use-case manual tuning.

The whole idea behind memory.low and related efforts is resolving that
problem by making memory control more work-conserving and forgiving, so that
users can say something like "I want the user session to have at least 25%
memory protected if needed and possible" and get most of the benefits of
carefully crafted configuration. We're already deploying such configuration
and it works well enough for a wide variety of workloads.

> > 2. there's a big difference between
> > letting the machine hit the wall and waiting for the kernel OOM to trigger
> > and being able to monitor the situation as it gradually develops and respond
> > to it, which is the whole point of the low/high mechanisms.
> 
> I am not really against the proposed solution. What I am trying to see
> is if this problem is more general than an anon/swap-full problem and
> if a more general solution is possible. To me it seems like, whenever
> a large portion of reclaimable memory (anon, file or kmem) becomes
> non-reclaimable abruptly, the memory isolation can be broken. You gave
> the anon/swap-full example, let me see if I can come up with file and
> kmem examples (with similar A & B).
> 
> 1) B has a lot of page cache but temporarily gets pinned for rdma or
> something and the system gets low on memory. B can attack A's low
> protected memory as B's page cache is not reclaimable temporarily.
> 
> 2) B has a lot of dentries/inodes but someone has taken a write lock
> on shrinker_rwsem and got stuck in allocation/reclaim or CPU
> preempted. B can attack A's low protected memory as B's slabs are not
> reclaimable temporarily.
> 
> I think the aim is to slow down B enough to give the PSI monitor a
> chance to act before either B targets A's protected memory or the
> kernel triggers oom-kill.
> 
> My question is do we really want to solve the issue without limiting B
> through high/max? Also isn't fine grained PSI monitoring along with
> limiting B through memory.[high|max] general enough to solve all three
> example scenarios?

Yes, we definitely want to solve the issue without involving high and max. I
hope that part is clear now. As for whether we want to cover niche cases
such as RDMA pinning a large swath of page cache, I don't know, maybe? But I
don't think that's a problem with a comparable importance especially given
that in both cases you listed the problem is temporary and the workload
wouldn't have the ability to keep expanding undeterred.

Thanks.

-- 
tejun
