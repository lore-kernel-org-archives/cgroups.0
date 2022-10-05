From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC] memcg rstat flushing optimization
Date: Wed, 5 Oct 2022 06:30:06 -1000
Message-ID: <Yz2xDq0jo1WZNblz@slm.duckdns.org>
References: <CAJD7tkZQ+L5N7FmuBAXcg_2Lgyky7m=fkkBaUChr7ufVMHss=A@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DIgSyoN94ADqU20gRcmOmyh9FdirVR3/a/n9qkAKtZM=;
        b=pJ841aP9R3YYjlZHcaKL4JqVDmnW1R6uCt2rV3ba70kepXv9mH8Oyq3he8OA52pVIc
         AKoD0jCdja0PT3R8DuX3PLkQ5yJ3Wbw+fQM1eOztB9+2PS6HhGG7Rok0CIaPbOxtqFoy
         qs+eHZMrAPb0R7SuoK5wD7yEPhMW7c/c5Wo3KMATlnL0jcxCVwezL1eN/JgacZud926T
         vN3bmZUfBdgYXOH+5ASAaa7nhO4k2oOTEnbtcu5YqhyKnWSJQnLJXdv3CdV978h69iyF
         T8EC84w1Vu7YLVN1BpDrhhHEcfR9xL+SMTNfASMjk7TCyz4psKsKYFOeFpgtn294FIkJ
         RCBg==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJD7tkZQ+L5N7FmuBAXcg_2Lgyky7m=fkkBaUChr7ufVMHss=A@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux-MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Hello,

On Tue, Oct 04, 2022 at 06:17:40PM -0700, Yosry Ahmed wrote:
> We have recently ran into a hard lockup on a machine with hundreds of
> CPUs and thousands of memcgs during an rstat flush. There have also
> been some discussions during LPC between myself, Michal Koutn=FD, and
> Shakeel about memcg rstat flushing optimization. This email is a
> follow up on that, discussing possible ideas to optimize memcg rstat
> flushing.
>=20
> Currently, mem_cgroup_flush_stats() is the main interface to flush
> memcg stats. It has some internal optimizations that can skip a flush
> if there hasn't been significant updates in general. It always flushes
> the entire memcg hierarchy, and always invokes flushing using
> cgroup_rstat_flush_irqsafe(), which has interrupts disabled and does
> not sleep. As you can imagine, with a sufficiently large number of
> memcgs and cpus, a call to mem_cgroup_flush_stats() might be slow, or
> in an extreme case like the one we ran into, cause a hard lockup
> (despite periodically flushing every 4 seconds).

How long were the stalls? Given that rstats are usually flushed by its
consumers, flushing taking some time might be acceptable but what's really
problematic is that the whole thing is done with irq disabled. We can think
about other optimizations later too but I think the first thing to do is
making the flush code able to pause and resume. ie. flush in batches and
re-enable irq / resched between batches. We'd have to pay attention to
guaranteeing forward progress. It'd be ideal if we can structure iteration
in such a way that resuming doesn't end up nodes which got added after it
started flushing.

Thanks.

--=20
tejun
