From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC] memcg rstat flushing optimization
Date: Wed, 5 Oct 2022 10:20:54 -0700
Message-ID: <CAJD7tkawcrpmacguvyWVK952KtD-tP+wc2peHEjyMHesdM1o0Q@mail.gmail.com>
References: <CAJD7tkZQ+L5N7FmuBAXcg_2Lgyky7m=fkkBaUChr7ufVMHss=A@mail.gmail.com>
 <Yz2xDq0jo1WZNblz@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date;
        bh=pSbHEWZPAlqGXv5FT+k2l6EJrddPS9d76u3iLY1UjMg=;
        b=nVP2RDD+po/mEoQ18TDe3da6XMJYLJ3G/86Z+g1/BnYSydgCF/IHS5V3aRKLcx2zOf
         hLdheL7NOkvibYxUvkWeMSiIoQorEvAvFsWt63HM3oqIt4LA3rE0H5PCoQuT0UgvESMm
         ioMWWD0Pct6I5vhv/ENxTQdKMQHa6ebYj2f5cJcT9fi8WYkN6y4yWxZ5h8qTEAH36yJ4
         46wV6mmCl3CN/1ysRRGXW/rOwntLOlIRHeLcKem8rd5Ht8i0Wwa/HCqI+y411/l7w+BQ
         HVq3sEMXw1rkQPsNM7cGFjapzN8ABJeCJtjnDscNQlb1k1Pz2YENhe27h+LDmvXwgzk3
         Rvow==
In-Reply-To: <Yz2xDq0jo1WZNblz-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-9"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux-MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Wed, Oct 5, 2022 at 9:30 AM Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> Hello,
>
> On Tue, Oct 04, 2022 at 06:17:40PM -0700, Yosry Ahmed wrote:
> > We have recently ran into a hard lockup on a machine with hundreds of
> > CPUs and thousands of memcgs during an rstat flush. There have also
> > been some discussions during LPC between myself, Michal Koutn=C3=BD, an=
d
> > Shakeel about memcg rstat flushing optimization. This email is a
> > follow up on that, discussing possible ideas to optimize memcg rstat
> > flushing.
> >
> > Currently, mem_cgroup_flush_stats() is the main interface to flush
> > memcg stats. It has some internal optimizations that can skip a flush
> > if there hasn't been significant updates in general. It always flushes
> > the entire memcg hierarchy, and always invokes flushing using
> > cgroup_rstat_flush_irqsafe(), which has interrupts disabled and does
> > not sleep. As you can imagine, with a sufficiently large number of
> > memcgs and cpus, a call to mem_cgroup_flush_stats() might be slow, or
> > in an extreme case like the one we ran into, cause a hard lockup
> > (despite periodically flushing every 4 seconds).
>
> How long were the stalls? Given that rstats are usually flushed by its

I think 10 seconds while interrupts are disabled is what we need for a
hard lockup, right?

> consumers, flushing taking some time might be acceptable but what's reall=
y
> problematic is that the whole thing is done with irq disabled. We can thi=
nk
> about other optimizations later too but I think the first thing to do is
> making the flush code able to pause and resume. ie. flush in batches and
> re-enable irq / resched between batches. We'd have to pay attention to
> guaranteeing forward progress. It'd be ideal if we can structure iteratio=
n
> in such a way that resuming doesn't end up nodes which got added after it
> started flushing.

IIUC you mean that the caller of cgroup_rstat_flush() can call a
different variant that only flushes a part of the rstat tree then
returns, and the caller makes several calls interleaved by re-enabling
irq, right? Because the flushing code seems to already do this
internally if the non irqsafe version is used.

I think this might be tricky. In this case the path that caused the
lockup was memcg_check_events()->mem_cgroup_threshold()->__mem_cgroup_thres=
hold()->mem_cgroup_usage()->mem_cgroup_flush_stats().
Interrupts are disabled by callers of memcg_check_events(), but the
rstat flush call is made much deeper in the call stack. Whoever is
disabling interrupts doesn't have access to pause/resume flushing.

There are also other code paths that used to use
cgroup_rstat_flush_irqsafe() directly before mem_cgroup_flush_stats()
was introduced like mem_cgroup_wb_stats() [1].

This is why I suggested a selective flushing variant of
cgroup_rstat_flush_irqsafe(), so that flushers that need irq disabled
have the ability to only flush a subset of the stats to avoid long
stalls if possible.

[1] https://lore.kernel.org/lkml/20211001190040.48086-2-shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org=
/

>
> Thanks.
>
> --
> tejun
