From: Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH v2 8/9] vmscan: memcg: sleep when flushing stats during
 reclaim
Date: Thu, 30 Mar 2023 09:52:47 +0200
Message-ID: <ZCU/zzgWSZb/ux6J@dhcp22.suse.cz>
References: <20230328221644.803272-1-yosryahmed@google.com>
 <20230328221644.803272-9-yosryahmed@google.com>
 <ZCU9ByZybEi5G5sl@dhcp22.suse.cz>
 <CAJD7tkZODvLZOfGaO3gjC2udKNg_G0mA2CT57djjJXrrHNEbbg@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1680162768; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dh199jsuIkw67icwSCJmEAMOM1galF76gLuMPyO52BY=;
        b=mcaDKMiPqsMKSTSx2WP2qVHm5miTytkBZzWk5JU3bD7xHGqkrdBk9x1NvJOXI7BFXxeSZL
        ro/YJTfRWvZXZHW1a18Rmf7nhQRTSL8u01c1CTU8nlltVrDzsS+LWiOA0FVCVTMKGfaAxS
        ZEPEb0eUcZtK+ygv3nBfEKPB/BAeTAM=
Content-Disposition: inline
In-Reply-To: <CAJD7tkZODvLZOfGaO3gjC2udKNg_G0mA2CT57djjJXrrHNEbbg@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Yosry Ahmed <yosryahmed@google.com>
Cc: Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Jens Axboe <axboe@kernel.dk>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>, Vasily Averin <vasily.averin@linux.dev>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org

On Thu 30-03-23 00:44:10, Yosry Ahmed wrote:
> On Thu, Mar 30, 2023 at 12:40=E2=80=AFAM Michal Hocko <mhocko@suse.com> w=
rote:
> >
> > On Tue 28-03-23 22:16:43, Yosry Ahmed wrote:
> > > Memory reclaim is a sleepable context. Allow sleeping when flushing
> > > memcg stats to avoid unnecessarily performing a lot of work without
> > > sleeping. This can slow down reclaim code if flushing stats is taking
> > > too long, but there is already multiple cond_resched()'s in reclaim
> > > code.
> >
> > Why is this preferred? Memory reclaim is surely a slow path but what is
> > the advantage of calling mem_cgroup_flush_stats here?
>=20
> The purpose of this series is to limit calls to atomic flushing as
> much as possible, as flushing can become really expensive on systems
> with high cpu counts and a lot of cgroups, and performing such an
> expensive operation atomically causes problems -- so we'd rather avoid
> doing it atomically where possible.

Please add that to the changelog. While the intention might be obvious
now (although cover is not explicit about it either) it can cause some
head scratching in the future when somebody looks at this commit without
a broader context (e.g. previous ML discussions).

with that
Acked-by: Michal Hocko <mhocko@suse.com>
Thanks

> > > Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
> > > Acked-by: Shakeel Butt <shakeelb@google.com>
> > > Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> > > ---
> > >  mm/vmscan.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > > index a9511ccb936f..9c1c5e8b24b8 100644
> > > --- a/mm/vmscan.c
> > > +++ b/mm/vmscan.c
> > > @@ -2845,7 +2845,7 @@ static void prepare_scan_count(pg_data_t *pgdat=
, struct scan_control *sc)
> > >        * Flush the memory cgroup stats, so that we read accurate per-=
memcg
> > >        * lruvec stats for heuristics.
> > >        */
> > > -     mem_cgroup_flush_stats_atomic();
> > > +     mem_cgroup_flush_stats();
> > >
> > >       /*
> > >        * Determine the scan balance between anon and file LRUs.
> > > --
> > > 2.40.0.348.gf938b09366-goog
> >
> > --
> > Michal Hocko
> > SUSE Labs

--=20
Michal Hocko
SUSE Labs
