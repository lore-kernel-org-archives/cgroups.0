From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/3] mm: memcontrol: deprecate charge moving
Date: Wed, 7 Dec 2022 14:15:17 -0800
Message-ID: <CALvZod63UBrAGXpzs0ukdazvjmBfb61t9PCzUhjrbnDWTaP59Q@mail.gmail.com>
References: <20221206171340.139790-1-hannes@cmpxchg.org> <20221206171340.139790-4-hannes@cmpxchg.org>
 <CALvZod6WcBifeWJYG_QLr9Uy5aSbpLoCVyOp+FVx0ca1gzq4fA@mail.gmail.com> <20221207135108.fe1d51f7581f6ff86dbf9bc8@linux-foundation.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=6md11XMzi0tM9VfuttVehehretVvYJGzXswfjHRw2Yk=;
        b=FVhyDC1j451hmgMkwi1V7ZI4X8jOVWr/eIXmSC2wvcstj2nqmH63mzvSgwTtApATU7
         c5BKCleqCvOmWqkJMjNflr+8QXYBnxcOe+vMskQUHOYE6kLQMtsWp1TscflaWmBvVchW
         1+T44q440TMM6kpmml1fH/7sz02N0B0oPTP/arw7d+LG2oYA1h3b83NbFIbbTJASfxrL
         hvFcOa6aCxls9HxIdBn80Leq+fJS4b/Qu4JUpuIbAuBsk7hlWLhuzXiizfLeCfikD0Vu
         kPIHF7EbCCpHToNq47vCM2gtuZGqmzjfqNe3Itbh8AzNvl7j1zF04iWA4a0LZgTg/mUY
         hIwQ==
In-Reply-To: <20221207135108.fe1d51f7581f6ff86dbf9bc8-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Dec 7, 2022 at 1:51 PM Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
>
> On Tue, 6 Dec 2022 16:03:54 -0800 Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>
> > On Tue, Dec 6, 2022 at 9:14 AM Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
> > >
> > > Charge moving mode in cgroup1 allows memory to follow tasks as they
> > > migrate between cgroups. This is, and always has been, a questionable
> > > thing to do - for several reasons.
> > >
> > > First, it's expensive. Pages need to be identified, locked and
> > > isolated from various MM operations, and reassigned, one by one.
> > >
> > > Second, it's unreliable. Once pages are charged to a cgroup, there
> > > isn't always a clear owner task anymore. Cache isn't moved at all, for
> > > example. Mapped memory is moved - but if trylocking or isolating a
> > > page fails, it's arbitrarily left behind. Frequent moving between
> > > domains may leave a task's memory scattered all over the place.
> > >
> > > Third, it isn't really needed. Launcher tasks can kick off workload
> > > tasks directly in their target cgroup. Using dedicated per-workload
> > > groups allows fine-grained policy adjustments - no need to move tasks
> > > and their physical pages between control domains. The feature was
> > > never forward-ported to cgroup2, and it hasn't been missed.
> > >
> > > Despite it being a niche usecase, the maintenance overhead of
> > > supporting it is enormous. Because pages are moved while they are live
> > > and subject to various MM operations, the synchronization rules are
> > > complicated. There are lock_page_memcg() in MM and FS code, which
> > > non-cgroup people don't understand. In some cases we've been able to
> > > shift code and cgroup API calls around such that we can rely on native
> > > locking as much as possible. But that's fragile, and sometimes we need
> > > to hold MM locks for longer than we otherwise would (pte lock e.g.).
> > >
> > > Mark the feature deprecated. Hopefully we can remove it soon.
> > >
> > > Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> >
> > Acked-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> >
> > I would request this patch to be backported to stable kernels as well
> > for early warnings to users which update to newer kernels very late.
>
> Sounds reasonable, but the changelog should have a few words in it
> explaining why we're requesting the backport.  I guess I can type those
> in.

Thanks a lot.

>
> We're at -rc8 and I'm not planning on merging these up until after
> 6.2-rc1 is out.  Please feel free to argue with me on that score.

No, I totally agree with you. There is no such urgency in merging
these and a couple of weeks delay is totally fine.
