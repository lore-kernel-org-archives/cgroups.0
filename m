From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] mm: memcg: provide accurate stats for userspace reads
Date: Wed, 9 Aug 2023 14:58:41 +0200
Message-ID: <ZNONgeoytpkchHga@dhcp22.suse.cz>
References: <20230809045810.1659356-1-yosryahmed@google.com>
 <ZNNTgZVPZipTL/UM@dhcp22.suse.cz>
 <CAJD7tkYhxbd2e+4HMZVKUfD4cx6oDauna3vLmttNPLCmFNtpgA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1691585922; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QVWr8XXVikYCh9tW7i2JMcKFQHyA2Ul51zZ7VG7gDMk=;
        b=qQ/BYlEykYjWP3ve2rOyS1R2CVAD0zcH+XiaHYHXrTSyZBaOWu5MEx9YCNGQLo34CDGhiq
        TlsnFjOvhVaRV6Y75dFlwrNBeMiX9QtdlVT24EHYvyYM2ig/6Y8uxc/G9h4IscJRDSrIhb
        kQn1NeGt9IJHsLituqZTT0ZUKdtS8Fs=
Content-Disposition: inline
In-Reply-To: <CAJD7tkYhxbd2e+4HMZVKUfD4cx6oDauna3vLmttNPLCmFNtpgA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed 09-08-23 05:31:04, Yosry Ahmed wrote:
> On Wed, Aug 9, 2023 at 1:51=E2=80=AFAM Michal Hocko <mhocko-IBi9RG/b67k@p=
ublic.gmane.org> wrote:
> >
> > On Wed 09-08-23 04:58:10, Yosry Ahmed wrote:
> > > Over time, the memcg code added multiple optimizations to the stats
> > > flushing path that introduce a tradeoff between accuracy and
> > > performance. In some contexts (e.g. dirty throttling, refaults, etc),=
 a
> > > full rstat flush of the stats in the tree can be too expensive. Such
> > > optimizations include [1]:
> > > (a) Introducing a periodic background flusher to keep the size of the
> > > update tree from growing unbounded.
> > > (b) Allowing only one thread to flush at a time, and other concurrent
> > > flushers just skip the flush. This avoids a thundering herd problem
> > > when multiple reclaim/refault threads attempt to flush the stats at
> > > once.
> > > (c) Only executing a flush if the magnitude of the stats updates exce=
eds
> > > a certain threshold.
> > >
> > > These optimizations were necessary to make flushing feasible in
> > > performance-critical paths, and they come at the cost of some accuracy
> > > that we choose to live without. On the other hand, for flushes invoked
> > > when userspace is reading the stats, the tradeoff is less appealing
> > > This code path is not performance-critical, and the inaccuracies can
> > > affect userspace behavior. For example, skipping flushing when there =
is
> > > another ongoing flush is essentially a coin flip. We don't know if the
> > > ongoing flush is done with the subtree of interest or not.
> >
> > I am not convinced by this much TBH. What kind of precision do you
> > really need and how much off is what we provide?
> >
> > More expensive read of stats from userspace is quite easy to notice
> > and usually reported as a regression. So you should have a convincing
> > argument that an extra time spent is really worth it. AFAIK there are
> > many monitoring (top like) tools which simply read those files regularly
> > just to show numbers and they certainly do not need a high level of
> > precision.
>=20
> We used to spend this time before commit fd25a9e0e23b ("memcg: unify
> memcg stat flushing") which generalized the "skip if ongoing flush"
> for all stat flushing. As far I know, the problem was contention on
> the flushing lock which also affected critical paths like refault.
>=20
> The problem is that the current behavior is indeterministic, if cpu A
> tries to flush stats and cpu B is already doing that, cpu A will just
> skip. At that point, the cgroup(s) that cpu A cares about may have
> been fully flushed, partially flushed (in terms of cpus), or not
> flushed at all. We have no idea. We just know that someone else is
> flushing something. IOW, in some cases the flush request will be
> completely ignored and userspace will read stale stats (up to 2s + the
> periodic flusher runtime).

Yes, that is certainly true but why does that matter? Stats are always a
snapshot of the past. Do we get an inconsistent image that would be
actively harmful.

> Some workloads need to read up-to-date stats as feedback to actions
> (e.g. after proactive reclaim, or for userspace OOM killing purposes),
> and reading such stale stats causes regressions or misbehavior by
> userspace.

Please tell us more about those and why should all others that do not
require such a precision should page that price as well.

> > [...]
> > > @@ -639,17 +639,24 @@ static inline void memcg_rstat_updated(struct m=
em_cgroup *memcg, int val)
> > >       }
> > >  }
> > >
> > > -static void do_flush_stats(void)
> > > +static void do_flush_stats(bool full)
> > >  {
> > > +     if (!atomic_read(&stats_flush_ongoing) &&
> > > +         !atomic_xchg(&stats_flush_ongoing, 1))
> > > +             goto flush;
> > > +
> > >       /*
> > > -      * We always flush the entire tree, so concurrent flushers can =
just
> > > -      * skip. This avoids a thundering herd problem on the rstat glo=
bal lock
> > > -      * from memcg flushers (e.g. reclaim, refault, etc).
> > > +      * We always flush the entire tree, so concurrent flushers can =
choose to
> > > +      * skip if accuracy is not critical. Otherwise, wait for the on=
going
> > > +      * flush to complete. This avoids a thundering herd problem on =
the rstat
> > > +      * global lock from memcg flushers (e.g. reclaim, refault, etc).
> > >        */
> > > -     if (atomic_read(&stats_flush_ongoing) ||
> > > -         atomic_xchg(&stats_flush_ongoing, 1))
> > > -             return;
> > > -
> > > +     while (full && atomic_read(&stats_flush_ongoing) =3D=3D 1) {
> > > +             if (!cond_resched())
> > > +                     cpu_relax();
> >
> > You are reinveting a mutex with spinning waiter. Why don't you simply
> > make stats_flush_ongoing a real mutex and make use try_lock for !full
> > flush and normal lock otherwise?
>=20
> So that was actually a spinlock at one point, when we used to skip if
> try_lock failed.

AFAICS cgroup_rstat_flush is allowed to sleep so spinlocks are not
really possible.

> We opted for an atomic because the lock was only used
> in a try_lock fashion. The problem here is that the atomic is used to
> ensure that only one thread actually attempts to flush at a time (and
> others skip/wait), to avoid a thundering herd problem on
> cgroup_rstat_lock.
>=20
> Here, what I am trying to do is essentially equivalent to "wait until
> the lock is available but don't grab it". If we make
> stats_flush_ongoing a mutex, I am afraid the thundering herd problem
> will be reintroduced for stats_flush_ongoing this time.

You will have potentially many spinners for something that might take
quite a lot of time (sleep) if there is nothing else to schedule. I do
not think this is a proper behavior. Really, you shouldn't be busy
waiting for a sleeper.

> I am not sure if there's a cleaner way of doing this, but I am
> certainly open for suggestions. I also don't like how the spinning
> loop looks as of now.

mutex_try_lock for non-critical flushers and mutex_lock of syncing ones.
We can talk a custom locking scheme if that proves insufficient or
problematic.
--=20
Michal Hocko
SUSE Labs
