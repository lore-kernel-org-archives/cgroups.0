From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH 3/3] mm: memcontrol: deprecate charge moving
Date: Wed, 7 Dec 2022 13:51:08 -0800
Message-ID: <20221207135108.fe1d51f7581f6ff86dbf9bc8@linux-foundation.org>
References: <20221206171340.139790-1-hannes@cmpxchg.org>
        <20221206171340.139790-4-hannes@cmpxchg.org>
        <CALvZod6WcBifeWJYG_QLr9Uy5aSbpLoCVyOp+FVx0ca1gzq4fA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670449869;
        bh=lOzePfG+gfzij5YGhbjycoi2p2PKhj4xCr9a0XLkW7U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qAeunG95UWOW53nZ4bn+0tSSku08KCUXDW0eYgErfMITVSEM0r0BgPOUJEwHKCEsw
         Qk1Ug0XI/fjFr1Dr4jnFNUIUdbJpkvdtrW1s/VhUqfkyXF/grfKFD0z/YPBFUy2kCE
         sSQZHlM4fu8tYRGxpXTtq06S1jSnpS2fpOmaaB8g=
In-Reply-To: <CALvZod6WcBifeWJYG_QLr9Uy5aSbpLoCVyOp+FVx0ca1gzq4fA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, 6 Dec 2022 16:03:54 -0800 Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:

> On Tue, Dec 6, 2022 at 9:14 AM Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
> >
> > Charge moving mode in cgroup1 allows memory to follow tasks as they
> > migrate between cgroups. This is, and always has been, a questionable
> > thing to do - for several reasons.
> >
> > First, it's expensive. Pages need to be identified, locked and
> > isolated from various MM operations, and reassigned, one by one.
> >
> > Second, it's unreliable. Once pages are charged to a cgroup, there
> > isn't always a clear owner task anymore. Cache isn't moved at all, for
> > example. Mapped memory is moved - but if trylocking or isolating a
> > page fails, it's arbitrarily left behind. Frequent moving between
> > domains may leave a task's memory scattered all over the place.
> >
> > Third, it isn't really needed. Launcher tasks can kick off workload
> > tasks directly in their target cgroup. Using dedicated per-workload
> > groups allows fine-grained policy adjustments - no need to move tasks
> > and their physical pages between control domains. The feature was
> > never forward-ported to cgroup2, and it hasn't been missed.
> >
> > Despite it being a niche usecase, the maintenance overhead of
> > supporting it is enormous. Because pages are moved while they are live
> > and subject to various MM operations, the synchronization rules are
> > complicated. There are lock_page_memcg() in MM and FS code, which
> > non-cgroup people don't understand. In some cases we've been able to
> > shift code and cgroup API calls around such that we can rely on native
> > locking as much as possible. But that's fragile, and sometimes we need
> > to hold MM locks for longer than we otherwise would (pte lock e.g.).
> >
> > Mark the feature deprecated. Hopefully we can remove it soon.
> >
> > Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> 
> Acked-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> 
> I would request this patch to be backported to stable kernels as well
> for early warnings to users which update to newer kernels very late.

Sounds reasonable, but the changelog should have a few words in it
explaining why we're requesting the backport.  I guess I can type those
in.

We're at -rc8 and I'm not planning on merging these up until after
6.2-rc1 is out.  Please feel free to argue with me on that score.
