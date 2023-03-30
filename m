From: Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH v2 8/9] vmscan: memcg: sleep when flushing stats during reclaim
Date: Thu, 30 Mar 2023 00:44:10 -0700
Message-ID: <CAJD7tkZODvLZOfGaO3gjC2udKNg_G0mA2CT57djjJXrrHNEbbg@mail.gmail.com>
References: <20230328221644.803272-1-yosryahmed@google.com>
 <20230328221644.803272-9-yosryahmed@google.com> <ZCU9ByZybEi5G5sl@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680162287;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=28SBvYRFwm/SwjBANXWTAMmx79zC2hxmQLZYCOkhW7w=;
        b=XC/JQkgUrkQzY6HHF2NhZnpoRWT+0wS9HXMuIuwQTp9rKch4Ytd7OHq7B6ZlYzmoIN
         Xe41PjKT72i8B3/cXTSXEg1IQnDraLRQMJMHYetoWWGjFqE2CxvPrvXHNDWgl87bYMsh
         WdwVVICevoPuzBNIHuJDvQJT1mrphxjAYc2j6LK0KPxJhcnJrlmseiUrxuyv1lwNRTJp
         +FSGoMUedD4yHquuhjfw7Y6nZWzvHcf/ctNL4xVIvIW4rnVlbcVv+Of3qtdTGXL9EZos
         GIk26f60XOLEveR9GlABACeWhYk6kSbAGJ2+4SHw417+h1IQRhKDpuqZ5Zdtzx5YFgxE
         fTzQ==
In-Reply-To: <ZCU9ByZybEi5G5sl@dhcp22.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Michal Hocko <mhocko@suse.com>
Cc: Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Jens Axboe <axboe@kernel.dk>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, Vasily Averin <vasily.averin@linux.dev>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org

On Thu, Mar 30, 2023 at 12:40=E2=80=AFAM Michal Hocko <mhocko@suse.com> wro=
te:
>
> On Tue 28-03-23 22:16:43, Yosry Ahmed wrote:
> > Memory reclaim is a sleepable context. Allow sleeping when flushing
> > memcg stats to avoid unnecessarily performing a lot of work without
> > sleeping. This can slow down reclaim code if flushing stats is taking
> > too long, but there is already multiple cond_resched()'s in reclaim
> > code.
>
> Why is this preferred? Memory reclaim is surely a slow path but what is
> the advantage of calling mem_cgroup_flush_stats here?

The purpose of this series is to limit calls to atomic flushing as
much as possible, as flushing can become really expensive on systems
with high cpu counts and a lot of cgroups, and performing such an
expensive operation atomically causes problems -- so we'd rather avoid
doing it atomically where possible.

>
> > Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
> > Acked-by: Shakeel Butt <shakeelb@google.com>
> > Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> > ---
> >  mm/vmscan.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index a9511ccb936f..9c1c5e8b24b8 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -2845,7 +2845,7 @@ static void prepare_scan_count(pg_data_t *pgdat, =
struct scan_control *sc)
> >        * Flush the memory cgroup stats, so that we read accurate per-me=
mcg
> >        * lruvec stats for heuristics.
> >        */
> > -     mem_cgroup_flush_stats_atomic();
> > +     mem_cgroup_flush_stats();
> >
> >       /*
> >        * Determine the scan balance between anon and file LRUs.
> > --
> > 2.40.0.348.gf938b09366-goog
>
> --
> Michal Hocko
> SUSE Labs
