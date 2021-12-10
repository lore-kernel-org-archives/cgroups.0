From: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: [PATCH-next v2] mm/memcg: Properly handle memcg_stock access for
 PREEMPT_RT
Date: Fri, 10 Dec 2021 17:34:33 +0100
Message-ID: <YbOBmYrInQVI+VOR@linutronix.de>
References: <20211210025228.158196-1-longman@redhat.com>
 <YbNPrGEjtKjzEjQa@linutronix.de>
 <80ee87bb-f36c-4a16-9095-43ea84818375@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1639154074;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1optRwnSrbeTPq5hBXQ3ouIMBUA6Hs3VoxqW7Qdr5pQ=;
        b=cnZTbXRHb2RdvBl953YymNVlA/R/XwIkNnZFSBQV7xPgJQJi3k+Ts4wU56zs4hB6gN9Zx9
        zkt/xK85on0ihLpz4acHhJ9xGDUBdYiugnCJEdkk6QsZOj4pG4+ilNS2U9+alljTlyrisS
        /F3LnJ6esbiYZPRMfzrY8Oj/jVgrjByGEsEAFQzC7+K5o/s6JlEgNnvzpdu1+NJtiCQyu/
        kUAB6hG9mSPsbsymczRl189WujmmAsog42aw5+L1RWAx9TlF3JwXJ/Jc/ccjMJr2gWX7x6
        NO0xIYJPypme254pSw/MVWnzfDx9GTXCG/uFfFvZOKvmO+2FU1IqjpgqRTuy+A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1639154074;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1optRwnSrbeTPq5hBXQ3ouIMBUA6Hs3VoxqW7Qdr5pQ=;
        b=F1qbHzysXR9EGrBloIho2z2ExfYszOTiOtQNVU/EQ3u+tFM7ZODd5S9xeyggKtrxBYYpZP
        9AMc1tMvD1ujHmDw==
Content-Disposition: inline
In-Reply-To: <80ee87bb-f36c-4a16-9095-43ea84818375-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

On 2021-12-10 11:29:31 [-0500], Waiman Long wrote:
>=20
> On 12/10/21 08:01, Sebastian Andrzej Siewior wrote:
> > On 2021-12-09 21:52:28 [-0500], Waiman Long wrote:
> > =E2=80=A6
> > > --- a/mm/memcontrol.c
> > > +++ b/mm/memcontrol.c
> > =E2=80=A6
> > > @@ -2210,7 +2211,7 @@ static void refill_stock(struct mem_cgroup *mem=
cg, unsigned int nr_pages)
> > >   	struct memcg_stock_pcp *stock;
> > >   	unsigned long flags;
> > > -	local_irq_save(flags);
> > > +	local_lock_irqsave(&memcg_stock.lock, flags);
> > Why is this one using the lock? It isn't accessing irq_obj, right?
> Well, the lock isn't just for irq_obj. It protects the whole memcg_stock
> structure which include irq_obj. Sometimes, data in irq_obj (or task_obj)
> will get transfer to nr_pages and vice versa. So it is easier to use one
> single lock for the whole thing.

This needs way better documentation what protects what any why.
I don't like the quick slapping for RT only usage without any kind of
explanation. Once you think you know it is irq_obj only you end up here
where you have the lock again for no obvious reason.

>=20
> Cheers,
> Longman

Sebastian
