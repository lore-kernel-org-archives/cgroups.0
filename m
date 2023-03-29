From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH 1/7] cgroup: rstat: only disable interrupts for the
 percpu lock
Date: Wed, 29 Mar 2023 10:00:50 -1000
Message-ID: <ZCSY8l/jVwszF6iA@slm.duckdns.org>
References: <ZBz/V5a7/6PZeM7S@slm.duckdns.org>
 <CAJD7tkYNZeEytm_Px9_73Y-AYJfHAxaoTmmnO71HW5hd1B5tPg@mail.gmail.com>
 <ZB5UalkjGngcBDEJ@slm.duckdns.org>
 <CAJD7tkYhyMkD8SFf8b8L1W9QUrLOdw-HJ2NUbENjw5dgFnH3Aw@mail.gmail.com>
 <CALvZod6rF0D21hcV7xnqD+oRkn=x5NLi5GOkPpyaPa859uDH+Q@mail.gmail.com>
 <CAJD7tkY_ESpMYMw72bsATpp6tPphv8qS6VbfEUjpKZW6vUqQSQ@mail.gmail.com>
 <CALvZod41ecuCKmuFBNtAjoKJjQgWYzoe4_B8zRK37HYk-rYDkA@mail.gmail.com>
 <CAJD7tkZrp=4zWvjE9_010TAG1T_crCbf9P64UzJABspgcrGPKg@mail.gmail.com>
 <ZCSJDpPPOVvBYfOy@slm.duckdns.org>
 <f9b6410-ee17-635f-a35d-559fa0191dc3@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680120052;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lwysfnQkAd80wlNyJ6XzThTPiLtn2B/tyA3fjQAFkXU=;
        b=VhGF9AnSesD95PbIw4HKQtmtguZMl7HEDnjXJr5VTDVRIevs+1HBUeQ5jfnJOor6Uk
         VGnu7EvlPqhvNxv8RZkHktwn+oBeH+Pnnf1g3tb+S0UFbD5H/EVLQ7WSVvtpCJlJD4qF
         7WQdVImaam9FqrqmDuRw2Sq3cKQbxxS8w6lkd/SzoMxPwFfREAwPn8bPp7a3XoFqAWFt
         Hd9WBZMtBQzMHWAZlCrnKrd5hwd48+xbCLXjnP7LePyuuo/yjboiAxWuCKIOggXKhNC+
         AAs/7O15Dtlcb5z865sBl3TbnMRLyLavIcjyeMqUHVcD8RPDq2PxXPvBzBprp/8JgpoG
         Fulw==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <f9b6410-ee17-635f-a35d-559fa0191dc3-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Vasily Averin <vasily.averin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Hugh. How have you been?

On Wed, Mar 29, 2023 at 12:22:24PM -0700, Hugh Dickins wrote:
> Hi Tejun,
> Butting in here, I'm fascinated.  This is certainly not my area, I know
> nothing about rstat, but this is the first time I ever heard someone
> arguing for more disabling of interrupts rather than less.
> 
> An interrupt coming in while holding a contended resource can certainly
> add to latencies, that I accept of course.  But until now, I thought it
> was agreed best practice to disable irqs only regretfully, when strictly
> necessary.
> 
> If that has changed, I for one want to know about it.  How should we
> now judge which spinlocks should disable interrupts and which should not?
> Page table locks are currently my main interest - should those be changed?

For rstat, it's a simple case because the global lock here wraps around
per-cpu locks which have to be irq-safe, so the only difference we get
between making the global irq-unsafe and keeping it so but releasing
inbetween is:

 Global lock held: G
 IRQ disabled: I
 Percpu lock held: P
 
1. IRQ unsafe

 GGGGGGGGGGGGGGG~~GGGGG
 IIII IIII IIII ~~ IIII
 PPPP PPPP PPPP ~~ PPPP

2. IRQ safe released inbetween cpus

 GGGG GGGG GGGG ~~ GGGG
 IIII IIII IIII ~~ IIII
 PPPP PPPP PPPP ~~ PPPP

#2 seems like the obvious thing to do here given how the lock is used and
each P section may take a bit of time.

So, in the rstat case, the choice is, at least to me, obvious, but even for
more generic cases where the bulk of actual work isn't done w/ irq disabled,
I don't think the picture is as simple as "use the least protected variant
possible" anymore because the underlying hardware changed.

For an SMP kernel running on an UP system, "the least protected variant" is
the obvious choice to make because you don't lose anything by holding a
spinlock longer than necessary. However, as you increase the number of CPUs,
there rises a tradeoff between local irq servicing latency and global lock
contention.

Imagine a, say, 128 cpu system with a few cores servicing relatively high
frequency interrupts. Let's say there's a mildly hot lock. Usually, it shows
up in the system profile but only just. Let's say something happens and the
irq rate on those cores went up for some reason to the point where it
becomes a rather common occurrence when the lock is held on one of those
cpus, irqs are likely to intervene lengthening how long the lock is held,
sometimes, signficantly. Now because the lock is on average held for much
longer, it become a lot hotter as more CPUs would stall on it and depending
on luck or lack thereof these stalls can span many CPUs on the system for
quite a while. This is actually something we saw in production.

So, in general, there's a trade off between local irq service latency and
inducing global lock contention when using unprotected locks. With more and
more CPUs, the balance keeps shifting. The balance still very much depends
on the specifics of a given lock but yeah I think it's something we need to
be a lot more careful about now.

Thanks.

-- 
tejun
