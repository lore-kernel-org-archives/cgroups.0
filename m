From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [RFC PATCH 4/7] memcg: sleep during flushing stats in safe
 contexts
Date: Thu, 23 Mar 2023 13:27:32 -0400
Message-ID: <20230323172732.GE739026@cmpxchg.org>
References: <20230323040037.2389095-1-yosryahmed@google.com>
 <20230323040037.2389095-5-yosryahmed@google.com>
 <20230323155613.GC739026@cmpxchg.org>
 <CAJD7tkZ7Dz9myftc9bg7jhiaOYcn7qJ+V4sxZ_2kfnb+k=zhJQ@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112; t=1679592453;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=z/h2YRuqxkbq2WVy9rSukgPkz7MffMXHVCaEQ8JsfSI=;
        b=0b1sytAcRxnizGxvw+p+lkYnbDhWMhQxrXGPJPm5sHacyMrIEdNLQJWaWguMuI6iRT
         gIob4qZ61pz7VHAvob8ln+eERCrG8SD695iKZx3xXdVhxJf2AK68WpjLNHTbfR1+mL/h
         W7T8K7/p+oIhtsGd2HUyWvFwIy6iY8DRoXXxq5zUNE26HtDLdvCeI65VKxv5w/6Cz/WF
         fEPo60DJZK/R6TZ+NZeMzWnHn7sJXOyNF2qPFslVrcEcKc1n5cSCHU1BEimYAOU8AJaR
         A2BbTJLzfny7Nv4w5tfJ4xLxwqSSQOmSgthksXW6BG1tzizPpqODzSDd5+8QtbLdZvtY
         p2Tw==
Content-Disposition: inline
In-Reply-To: <CAJD7tkZ7Dz9myftc9bg7jhiaOYcn7qJ+V4sxZ_2kfnb+k=zhJQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Vasily Averin <vasily.averin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Mar 23, 2023 at 09:01:12AM -0700, Yosry Ahmed wrote:
> On Thu, Mar 23, 2023 at 8:56=E2=80=AFAM Johannes Weiner <hannes-druUgvl0L=
CNAfugRpC6u6w@public.gmane.org> wrote:
> >
> > On Thu, Mar 23, 2023 at 04:00:34AM +0000, Yosry Ahmed wrote:
> > > @@ -644,26 +644,26 @@ static void __mem_cgroup_flush_stats(void)
> > >               return;
> > >
> > >       flush_next_time =3D jiffies_64 + 2*FLUSH_TIME;
> > > -     cgroup_rstat_flush(root_mem_cgroup->css.cgroup, false);
> > > +     cgroup_rstat_flush(root_mem_cgroup->css.cgroup, may_sleep);
> >
> > How is it safe to call this with may_sleep=3Dtrue when it's holding the
> > stats_flush_lock?
>=20
> stats_flush_lock is always called with trylock, it is only used today
> so that we can skip flushing if another cpu is already doing a flush
> (which is not 100% correct as they may have not finished flushing yet,
> but that's orthogonal here). So I think it should be safe to sleep as
> no one can be blocked waiting for this spinlock.

I see. It still cannot sleep while the lock is held, though, because
preemption is disabled. Make sure you have all lock debugging on while
testing this.

> Perhaps it would be better semantically to replace the spinlock with
> an atomic test and set, instead of having a lock that can only be used
> with trylock?

It could be helpful to clarify what stats_flush_lock is protecting
first. Keep in mind that locks should protect data, not code paths.

Right now it's doing multiple things:

1. It protects updates to stats_flush_threshold
2. It protects updates to flush_next_time
3. It serializes calls to cgroup_rstat_flush() based on those ratelimits

However,

1. stats_flush_threshold is already an atomic

2. flush_next_time is not atomic. The writer is locked, but the reader
   is lockless. If the reader races with a flush, you could see this:

					if (time_after(jiffies, flush_next_time))
	spin_trylock()
        flush_next_time =3D now + delay
        flush()
        spin_unlock()
					spin_trylock()
					flush_next_time =3D now + delay
					flush()
					spin_unlock()

   which means we already can get flushes at a higher frequency than
   FLUSH_TIME during races. But it isn't really a problem.

   The reader could also see garbled partial updates, so it needs at
   least READ_ONCE and WRITE_ONCE protection.

3. Serializing cgroup_rstat_flush() calls against the ratelimit
   factors is currently broken because of the race in 2. But the race
   is actually harmless, all we might get is the occasional earlier
   flush. If there is no delta, the flush won't do much. And if there
   is, the flush is justified.

In summary, it seems to me the lock can be ditched altogether. All the
code needs is READ_ONCE/WRITE_ONCE around flush_next_time.
