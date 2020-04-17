From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 0/3] memcg: Slow down swap allocation as the available
 space gets depleted
Date: Fri, 17 Apr 2020 13:36:15 -0400
Message-ID: <20200417173615.GB43469@mtj.thefacebook.com>
References: <20200417010617.927266-1-kuba@kernel.org>
 <CALvZod78ZUhU+yr2x1h_gv+VgVGTPnSSGKh_+fd+MeiAKreJvg@mail.gmail.com>
 <20200417162355.GA43469@mtj.thefacebook.com>
 <CALvZod4ftvXCu8SbQUXwTGVvx5K2+at9h30r28chZLXEB1JdfQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=F+HgM45oFlXbwupYfko4Yr92PXppTYIX/jM7xHjwT0U=;
        b=TiLFh5ajMpb02YUYYwgGkQ0XhhZQEV+TBGxC+xQc3+dlMsyhZIaiuXTuOE434f7iy0
         iBhpQpKLim2K9grkhWBnI2xw9MaXHiSsUNeNask+Dpb2SuecIn1YI3kZ4pvvl7fhPFZX
         JzhmT252wqxAw1h1u6+3OIExrRKHTEhlm1o6Jn9aTlSDIdYk1GAEgVtejsHyqIuJY3pa
         C6ghblGdWFUWyBWkNA/mSnIv9AxI9ET5ZTr0gqqqJUw/7/uGX5c+2ocP/RkfH1T7qZBV
         4lkpuiDmL37+pFz2W+R4SRfb/jN+BaJHHZdhaUuN/0jbSFXEjXGDGrWy2tBnnkhiDqmZ
         fl+w==
Content-Disposition: inline
In-Reply-To: <CALvZod4ftvXCu8SbQUXwTGVvx5K2+at9h30r28chZLXEB1JdfQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Kernel Team <kernel-team-b10kYP2dOMg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello,

On Fri, Apr 17, 2020 at 10:18:15AM -0700, Shakeel Butt wrote:
> > There currently are issues with anonymous memory management which makes them
> > different / worse than page cache but I don't follow why swapping
> > necessarily means that isolation is broken. Page refaults don't indicate
> > that memory isolation is broken after all.
> 
> Sorry, I meant the performance isolation. Direct reclaim does not
> really differentiate who to stall and whose CPU to use.

Can you please elaborate concrete scenarios? I'm having a hard time seeing
differences from page cache.

> > > memcg limit reclaim and memcg limits are overcommitted. Shouldn't
> > > running out of swap will trigger the OOM earlier which should be
> > > better than impacting the whole system.
> >
> > The primary scenario which was being considered was undercommitted
> > protections but I don't think that makes any relevant differences.
> >
> 
> What is undercommitted protections? Does it mean there is still swap
> available on the system but the memcg is hitting its swap limit?

Hahaha, I assumed you were talking about memory.high/max and was saying that
the primary scenarios that were being considered was usage of memory.low
interacting with swap. Again, can you please give an concrete example so
that we don't misunderstand each other?

> > This is exactly similar to delay injection for memory.high. What's desired
> > is slowing down the workload as the available resource is depleted so that
> > the resource shortage presents as gradual degradation of performance and
> > matching increase in resource PSI. This allows the situation to be detected
> > and handled from userland while avoiding sudden and unpredictable behavior
> > changes.
> >
> 
> Let me try to understand this with an example. Memcg 'A' has

Ah, you already went there. Great.

> memory.high = 100 MiB, memory.max = 150 MiB and memory.swap.max = 50
> MiB. When A's usage goes over 100 MiB, it will reclaim the anon, file
> and kmem. The anon will go to swap and increase its swap usage until
> it hits the limit. Now the 'A' reclaim_high has fewer things (file &
> kmem) to reclaim but the mem_cgroup_handle_over_high() will keep A's
> increase in usage in check.
> 
> So, my question is: should the slowdown by memory.high depends on the
> reclaimable memory? If there is no reclaimable memory and the job hits
> memory.high, should the kernel slow it down to crawl until the PSI
> monitor comes and decides what to do. If I understand correctly, the
> problem is the kernel slow down is not successful when reclaimable
> memory is very low. Please correct me if I am wrong.

In combination with memory.high, swap slowdown may not be necessary because
memory.high's slow down mechanism is already there to handle "can't swap"
scenario whether that's because swap is disabled wholesale, limited or
depleted. However, please consider the following scenario.

cgroup A has memory.low protection and no other restrictions. cgroup B has
no protection and has access to swap. When B's memory starts bloating and
gets the system under memory contention, it'll start consuming swap until it
can't. When swap becomes depleted for B, there's nothing holding it back and
B will start eating into A's protection.

The proposed mechanism just plugs another vector for the same condition
where anonymous memory management breaks down because they can no longer be
reclaimed due to swap unavailability.

Thanks.

-- 
tejun
